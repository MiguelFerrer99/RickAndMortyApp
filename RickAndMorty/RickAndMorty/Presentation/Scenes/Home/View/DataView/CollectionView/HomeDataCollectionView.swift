//
//  HomeDataCollectionView.swift
//  RickAndMorty
//
//  Created by Miguel Ferrer Fornali on 6/12/22.
//

import UIKit
import Combine

enum HomeDataCollectionViewState {
    case showTitleViewShadow(Bool)
    case viewMore(HomeDataCategory)
}

final class HomeDataCollectionView: UICollectionView {
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
    var infoCellIdentifier: String {
        String(describing: type(of: HomeDataCollectionViewInfoCell()))
    }
    
    var headerIdentifier: String {
        String(describing: type(of: HomeDataCollectionViewSectionHeaderView()))
    }
    
    func setupView() {
        delegate = self
        dataSource = self
        registerCells()
        registerHeader()
        configureLayout()
    }
    
    func registerCells() {
        let infoCellNib = UINib(nibName: infoCellIdentifier, bundle: .main)
        register(infoCellNib, forCellWithReuseIdentifier: infoCellIdentifier)
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
        section.interGroupSpacing = iPadDevice ? 40 : 10
        let headerSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .estimated(60))
        let header = NSCollectionLayoutBoundarySupplementaryItem(layoutSize: headerSize, elementKind: UICollectionView.elementKindSectionHeader, alignment: .top)
        section.boundarySupplementaryItems = [header]
        let compositionalLayout = UICollectionViewCompositionalLayout(section: section)
        contentInset = .init(top: 0, left: 0, bottom: 20, right: 0)
        collectionViewLayout = compositionalLayout
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
            guard let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: headerIdentifier, for: indexPath) as? HomeDataCollectionViewSectionHeaderView else { return UICollectionReusableView() }
            guard let category = categories?[safe: indexPath.section] else { return UICollectionReusableView() }
            headerView.configure(with: category, delegate: self)
            return headerView
        default: return UICollectionReusableView()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        guard let category = categories?[section] else { return 0 }
        switch category {
        case .characters(let items): return items.count
        case .locations(let items): return items.count
        case .episodes(let items): return items.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let category = categories?[indexPath.section], let cell = collectionView.dequeueReusableCell(withReuseIdentifier: infoCellIdentifier, for: indexPath) as? HomeDataCollectionViewInfoCell else { return UICollectionViewCell() }
        var representable: HomeDataCollectionViewInfoCellRepresentable
        switch category {
        case .characters(let items):
            let character = items[indexPath.item]
            representable = DefaultHomeDataCollectionViewInfoCellRepresentable(style: .character(character.name, character.urlImage))
        case .locations(let items):
            let location = items[indexPath.item]
            representable = DefaultHomeDataCollectionViewInfoCellRepresentable(style: .location(location.name, "Location"))
        case .episodes(let items):
            let episode = items[indexPath.item]
            representable = DefaultHomeDataCollectionViewInfoCellRepresentable(style: .episode(episode.name, "Episode"))
        }
        cell.configure(with: representable)
        return cell
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        subject.send(.showTitleViewShadow(scrollView.contentOffset.y > 0))
    }
}

extension HomeDataCollectionView: HomeDataCollectionViewSectionHeaderViewProtocol {
    func didTapButton(with category: HomeDataCategory) {
        subject.send(.viewMore(category))
    }
}
