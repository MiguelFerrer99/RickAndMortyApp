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
    case viewAll(HomeDataCategory)
    case viewMore(HomeDataCategory)
}

final class HomeDataCollectionView: UICollectionView {
    private var subject = PassthroughSubject<HomeDataCollectionViewState, Never>()
    var publisher: AnyPublisher<HomeDataCollectionViewState, Never> { subject.eraseToAnyPublisher() }
    private let iPadDevice = UIDevice.current.userInterfaceIdiom == .pad
    private var categories: [HomeDataCategory]?
    private var isLoadingCharacters = false { didSet { reloadSection(0, loadingEnabled: isLoadingCharacters) } }
    private var isLoadingLocations = false { didSet { reloadSection(1, loadingEnabled: isLoadingLocations) } }
    private var isLoadingEpisodes = false { didSet { reloadSection(2, loadingEnabled: isLoadingEpisodes) } }
    
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
    
    func update(with category: HomeDataCategory) {
        switch category {
        case .characters:
            categories?.remove(at: 0)
            categories?.insert(category, at: 0)
            isLoadingCharacters = false
        case .locations:
            categories?.remove(at: 1)
            categories?.insert(category, at: 1)
            isLoadingLocations = false
        case .episodes:
            categories?.remove(at: 2)
            categories?.insert(category, at: 2)
            isLoadingEpisodes = false
        }
    }
}

private extension HomeDataCollectionView {
    var infoCellIdentifier: String {
        String(describing: type(of: HomeDataCollectionViewInfoCell()))
    }
    
    var loadingCellIdentifier: String {
        String(describing: type(of: HomeDataCollectionViewLoadingCell()))
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
        let loadingCellNib = UINib(nibName: loadingCellIdentifier, bundle: .main)
        register(loadingCellNib, forCellWithReuseIdentifier: loadingCellIdentifier)
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
    
    func isLastItemAndHaveMore(of category: HomeDataCategory, index: Int, section: Int) -> Bool {
        let isLastPage: Bool
        switch category {
        case .characters(let pager): isLastPage = pager.isLastPage
        case .locations(let pager): isLastPage = pager.isLastPage
        case .episodes(let pager): isLastPage = pager.isLastPage
        }
        return (index == numberOfItems(inSection: section) - 1) && !isLastPage
    }
    
    func reloadSection(_ section: Int, loadingEnabled: Bool) {
        UIView.setAnimationsEnabled(false)
        reloadSections(IndexSet(integer: section))
        let currentNumberOfItems = numberOfItems(inSection: section)
        let indexPath = IndexPath(item: loadingEnabled ? currentNumberOfItems : (currentNumberOfItems - 20), section: section)
        scrollToItem(at: indexPath, at: .right, animated: true)
        UIView.setAnimationsEnabled(true)
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
        case .characters(let pager): return pager.getItems().count + (isLoadingCharacters ? 1 : 0)
        case .locations(let pager): return pager.getItems().count + (isLoadingLocations ? 1 : 0)
        case .episodes(let pager): return pager.getItems().count + (isLoadingEpisodes ? 1 : 0)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if (isLoadingCharacters || isLoadingLocations || isLoadingEpisodes), (indexPath.item == numberOfItems(inSection: indexPath.section) - 1) {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: loadingCellIdentifier, for: indexPath) as? HomeDataCollectionViewLoadingCell else { return UICollectionViewCell() }
            return cell
        } else {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: infoCellIdentifier, for: indexPath) as? HomeDataCollectionViewInfoCell else { return UICollectionViewCell() }
            cell.configure(with: DefaultHomeDataCollectionViewInfoCellRepresentable(title: "", urlImage: ""), and: indexPath.item)
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        guard let category = categories?[indexPath.section] else { return }
        if isLastItemAndHaveMore(of: category, index: indexPath.item, section: indexPath.section) {
            switch category {
            case .characters: isLoadingCharacters = true
            case .locations: isLoadingLocations = true
            case .episodes: isLoadingEpisodes = true
            }
            subject.send(.viewMore(category))
        }
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        subject.send(.showTitleViewShadow(scrollView.contentOffset.y > 0))
    }
}

extension HomeDataCollectionView: HomeDataCollectionViewSectionHeaderViewProtocol {
    func didTapButton(with category: HomeDataCategory) {
        subject.send(.viewAll(category))
    }
}
