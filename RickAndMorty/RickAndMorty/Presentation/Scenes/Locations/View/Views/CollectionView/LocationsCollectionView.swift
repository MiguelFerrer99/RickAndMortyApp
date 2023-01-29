//
//  LocationsCollectionView.swift
//  RickAndMorty
//
//  Created by Miguel Ferrer Fornali on 26/1/23.
//

import UIKit
import Combine
import Foundation

enum LocationsCollectionViewState {
    case showNavigationBarShadow(Bool)
    case openLocationDetail(LocationRepresentable)
    case viewMore
}

final class LocationsCollectionView: UICollectionView {
    private var subject = PassthroughSubject<LocationsCollectionViewState, Never>()
    var publisher: AnyPublisher<LocationsCollectionViewState, Never> { subject.eraseToAnyPublisher() }
    private var locationsPager: Pagination<LocationRepresentable>?
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
    
    func configure(with locationsPager: Pagination<LocationRepresentable>, and imageCacheManager: ImageCacheManager) {
        self.locationsPager = locationsPager
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

private extension LocationsCollectionView {
    var infoCellIdentifier: String {
        String(describing: type(of: LocationsCollectionViewInfoCell()))
    }
    
    var emptyCellIdentifier: String {
        String(describing: type(of: LocationsCollectionViewEmptyCell()))
    }
    
    var loadingCellIdentifier: String {
        String(describing: type(of: LocationsCollectionViewLoadingCell()))
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
        guard let locationsPager = locationsPager else { return false }
        let itemsLeftToLastItem = 4
        return (((numberOfItems(inSection: 0) - 1) - itemsLeftToLastItem) == index) && (!locationsPager.isLastPage)
    }
    
    func reload() {
        UIView.setAnimationsEnabled(false)
        reloadData()
        UIView.setAnimationsEnabled(true)
    }
}

extension LocationsCollectionView: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        guard let locationsPager = locationsPager else { return 0 }
        return isLoading || locationsPager.getItems().isEmpty ? 1 : locationsPager.getItems().count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let locationsPager = locationsPager else { return UICollectionViewCell() }
        if isLoading {
            guard let cell = dequeueReusableCell(withReuseIdentifier: loadingCellIdentifier, for: indexPath) as? LocationsCollectionViewLoadingCell else { return UICollectionViewCell() }
            return cell
        } else if locationsPager.getItems().isEmpty {
            guard let cell = dequeueReusableCell(withReuseIdentifier: emptyCellIdentifier, for: indexPath) as? LocationsCollectionViewEmptyCell else { return UICollectionViewCell() }
            return cell
        } else {
            guard let cell = dequeueReusableCell(withReuseIdentifier: infoCellIdentifier, for: indexPath) as? LocationsCollectionViewInfoCell,
                  let location = locationsPager.getItems()[safe: indexPath.item] else { return UICollectionViewCell() }
            let representable = DefaultLocationsCollectionViewInfoCellRepresentable(title: location.name, image: location.image)
            cell.configure(with: representable)
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        deselectItem(at: indexPath, animated: true)
        guard let location = locationsPager?.getItems()[safe: indexPath.item] else { return }
        subject.send(.openLocationDetail(location))
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if shouldLoadMoreItems(index: indexPath.item) {
            subject.send(.viewMore)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let size = CGSize(width: frame.width - 40, height: frame.height - 100)
        guard let locationsPager = locationsPager else { return size }
        if locationsPager.getItems().isNotEmpty {
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
