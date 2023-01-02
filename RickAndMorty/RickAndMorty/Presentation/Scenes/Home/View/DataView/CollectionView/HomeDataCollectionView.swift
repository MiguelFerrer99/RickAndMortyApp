//
//  HomeDataCollectionView.swift
//  RickAndMorty
//
//  Created by Miguel Ferrer Fornali on 6/12/22.
//

import UIKit
import Combine

enum HomeDataCollectionViewState {
    // Define states
}

final class HomeDataCollectionView: UICollectionView {
    private var subscriptions = Set<AnyCancellable>()
    private var subject = PassthroughSubject<HomeDataCollectionViewState, Never>()
    var publisher: AnyPublisher<HomeDataCollectionViewState, Never> { subject.eraseToAnyPublisher() }
    
    init(frame: CGRect) {
        super.init(frame: frame, collectionViewLayout: .init())
        setupView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupView()
    }
}

private extension HomeDataCollectionView {
    var cellIdentifier: String {
        String(describing: type(of: HomeDataCollectionViewCell()))
    }
    
    var headerIdentifier: String {
        String(describing: type(of: HomeDataCollectionViewSectionHeaderView()))
    }
    
    func setupView() {
        delegate = self
        dataSource = self
        registerCell()
        registerHeader()
        configureLayout()
    }
    
    func registerCell() {
        let nib = UINib(nibName: cellIdentifier, bundle: .main)
        register(nib, forCellWithReuseIdentifier: cellIdentifier)
    }
    
    func registerHeader() {
        let nib = UINib(nibName: headerIdentifier, bundle: .main)
        register(nib, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: headerIdentifier)
    }
    
    func configureLayout() {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        let groupSize = NSCollectionLayoutSize(widthDimension: .absolute(160), heightDimension: .absolute(160))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
        let section = NSCollectionLayoutSection(group: group)
        section.orthogonalScrollingBehavior = .continuous
        section.contentInsets = .init(top: 0, leading: 20, bottom: 20, trailing: 20)
        section.interGroupSpacing = 20
        let headerSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .estimated(60))
        let header = NSCollectionLayoutBoundarySupplementaryItem(layoutSize: headerSize, elementKind: UICollectionView.elementKindSectionHeader, alignment: .top)
        section.boundarySupplementaryItems = [header]
        let compositionalLayout = UICollectionViewCompositionalLayout(section: section)
        collectionViewLayout = compositionalLayout
    }
    
    func bind(_ headerView: HomeDataCollectionViewSectionHeaderView) {
        headerView.publisher
            .filter { $0 == .didTapButton }
            .sink { [weak self] _ in
                guard let _ = self else { return }
                print("Header button tapped")
            }.store(in: &subscriptions)
    }
}

extension HomeDataCollectionView: UICollectionViewDelegate, UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        3
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        switch kind {
        case UICollectionView.elementKindSectionHeader:
            let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: headerIdentifier, for: indexPath) as! HomeDataCollectionViewSectionHeaderView
            headerView.configure(with: "Characters")
            bind(headerView)
            return headerView
        default:
            return UICollectionReusableView()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        10
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellIdentifier, for: indexPath) as! HomeDataCollectionViewCell
        return cell
    }
}
