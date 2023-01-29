//
//  EpisodesCollectionView.swift
//  RickAndMorty
//
//  Created by Miguel Ferrer Fornali on 26/1/23.
//

import UIKit
import Combine
import Foundation

enum EpisodesCollectionViewState {
    case showNavigationBarShadow(Bool)
    case viewMore
}

final class EpisodesCollectionView: UICollectionView {
    private var subject = PassthroughSubject<EpisodesCollectionViewState, Never>()
    var publisher: AnyPublisher<EpisodesCollectionViewState, Never> { subject.eraseToAnyPublisher() }
    private var episodesPager: Pagination<EpisodeRepresentable>?
    private var imageCacheManager: ImageCacheManager?
    private var isLoading = false { didSet { reload() } }
    
    init(frame: CGRect) {
        super.init(frame: frame, collectionViewLayout: .init())
        setupView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupView()
    }
    
    func configure(with episodesPager: Pagination<EpisodeRepresentable>, and imageCacheManager: ImageCacheManager) {
        self.episodesPager = episodesPager
        self.imageCacheManager = imageCacheManager
        isLoading = false
    }
    
    func scrollToTop() {
        if numberOfItems(inSection: 0) > 0 {
            scrollToItem(at: IndexPath(item: 0, section: 0), at: .top, animated: false)
        }
    }
    
    func showLoader() {
        isLoading = true
    }
}

private extension EpisodesCollectionView {
    var infoCellIdentifier: String {
        String(describing: type(of: EpisodesCollectionViewInfoCell()))
    }
    
    var emptyCellIdentifier: String {
        String(describing: type(of: EpisodesCollectionViewEmptyCell()))
    }
    
    var loadingCellIdentifier: String {
        String(describing: type(of: EpisodesCollectionViewLoadingCell()))
    }
    
    func setupView() {
        delegate = self
        dataSource = self
        contentInset = UIEdgeInsets(top: 20, left: 20, bottom: 20, right: 20)
        registerCells()
    }
    
    func registerCells() {
        let infoCellNib = UINib(nibName: infoCellIdentifier, bundle: .main)
        register(infoCellNib, forCellWithReuseIdentifier: infoCellIdentifier)
        let emptyCellNib = UINib(nibName: emptyCellIdentifier, bundle: .main)
        register(emptyCellNib, forCellWithReuseIdentifier: emptyCellIdentifier)
        let loadingCellNib = UINib(nibName: loadingCellIdentifier, bundle: .main)
        register(loadingCellNib, forCellWithReuseIdentifier: loadingCellIdentifier)
    }
    
    func shouldLoadMoreItems(index: Int) -> Bool {
        guard let episodesPager = episodesPager else { return false }
        let itemsLeftToLastItem = 4
        return (((numberOfItems(inSection: 0) - 1) - itemsLeftToLastItem) == index) && (!episodesPager.isLastPage)
    }
    
    func reload() {
        UIView.setAnimationsEnabled(false)
        reloadData()
        UIView.setAnimationsEnabled(true)
    }
}

extension EpisodesCollectionView: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        guard let episodesPager = episodesPager else { return 0 }
        return isLoading || episodesPager.getItems().isEmpty ? 1 : episodesPager.getItems().count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let episodesPager = episodesPager else { return UICollectionViewCell() }
        if isLoading {
            guard let cell = dequeueReusableCell(withReuseIdentifier: loadingCellIdentifier, for: indexPath) as? EpisodesCollectionViewLoadingCell else { return UICollectionViewCell() }
            return cell
        } else if episodesPager.getItems().isEmpty {
            guard let cell = dequeueReusableCell(withReuseIdentifier: emptyCellIdentifier, for: indexPath) as? EpisodesCollectionViewEmptyCell else { return UICollectionViewCell() }
            return cell
        } else {
            guard let cell = dequeueReusableCell(withReuseIdentifier: infoCellIdentifier, for: indexPath) as? EpisodesCollectionViewInfoCell,
                  let episode = episodesPager.getItems()[safe: indexPath.item] else { return UICollectionViewCell() }
            let representable = DefaultEpisodesCollectionViewInfoCellRepresentable(title: episode.name, season: episode.season, episode: episode.episode)
            cell.configure(with: representable)
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if shouldLoadMoreItems(index: indexPath.item) {
            subject.send(.viewMore)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let size = CGSize(width: frame.width - 40, height: frame.height - 100)
        guard let episodesPager = episodesPager else { return size }
        if episodesPager.getItems().isNotEmpty {
            let leftContentInset: CGFloat = 20
            let minSpacingColumns: CGFloat = 10
            let cellWidth = frame.width/2 - (leftContentInset + minSpacingColumns)
            return CGSize(width: cellWidth, height: cellWidth)
        } else { return size }
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        subject.send(.showNavigationBarShadow(scrollView.contentOffset.y > 0))
    }
}
