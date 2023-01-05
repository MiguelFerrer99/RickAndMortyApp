//
//  HomeDataCollectionView.swift
//  RickAndMorty
//
//  Created by Miguel Ferrer Fornali on 6/12/22.
//

import UIKit
import Combine

enum HomeDataCollectionViewState {
    case viewAll(HomeDataCategory)
    case showTitleViewShadow
    case hideTitleViewShadow
}

final class HomeDataCollectionView: UICollectionView {
    private var subscriptions = Set<AnyCancellable>()
    private var subject = PassthroughSubject<HomeDataCollectionViewState, Never>()
    var publisher: AnyPublisher<HomeDataCollectionViewState, Never> { subject.eraseToAnyPublisher() }
    private let iPadDevice = UIDevice.current.userInterfaceIdiom == .pad
    private var categories: [HomeDataCategory]?
    
    init(frame: CGRect) {
        super.init(frame: frame, collectionViewLayout: .init())
        setupView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupView()
    }
    
    func configure(with categories: [HomeDataCategory]) {
        self.categories = categories
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
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1/3), heightDimension: .fractionalWidth(1/3))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
        let section = NSCollectionLayoutSection(group: group)
        section.orthogonalScrollingBehavior = .continuous
        section.contentInsets = .init(top: 0, leading: iPadDevice ? 40 : 20, bottom: iPadDevice ? 40 : 20, trailing: iPadDevice ? 40 : 20)
        section.interGroupSpacing = iPadDevice ? 40 : 20
        let headerSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .estimated(60))
        let header = NSCollectionLayoutBoundarySupplementaryItem(layoutSize: headerSize, elementKind: UICollectionView.elementKindSectionHeader, alignment: .top)
        section.boundarySupplementaryItems = [header]
        let compositionalLayout = UICollectionViewCompositionalLayout(section: section)
        contentInset = .init(top: 0, left: 0, bottom: 20, right: 0)
        collectionViewLayout = compositionalLayout
    }
    
    func bind(_ headerView: HomeDataCollectionViewSectionHeaderView) {
        headerView.publisher
            .sink { [weak self] state in
                guard let self = self else { return }
                switch state {
                case .didTapButton(let category):
                    self.subject.send(.viewAll(category))
                }
            }.store(in: &subscriptions)
    }
}

extension HomeDataCollectionView: UICollectionViewDelegate, UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        guard let categories = categories else { return 0 }
        return categories.count
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        switch kind {
        case UICollectionView.elementKindSectionHeader:
            let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: headerIdentifier, for: indexPath) as! HomeDataCollectionViewSectionHeaderView
            guard let category = categories?[safe: indexPath.section] else { return UICollectionReusableView() }
            headerView.configure(with: category)
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
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView.contentOffset.y > 0 {
            subject.send(.showTitleViewShadow)
        } else {
            subject.send(.hideTitleViewShadow)
        }
    }
}
