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
    case viewMore
}

final class LocationsCollectionView: UICollectionView {
    private var subject = PassthroughSubject<LocationsCollectionViewState, Never>()
    var publisher: AnyPublisher<LocationsCollectionViewState, Never> { subject.eraseToAnyPublisher() }
    private var locationsPager: Pagination<LocationRepresentable>?
    private var imageCacheManager: ImageCacheManager?
    
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
        reloadData()
    }
}

private extension LocationsCollectionView {
    var infoCellIdentifier: String {
        String(describing: type(of: LocationsCollectionViewInfoCell()))
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
    }
    
    func shouldLoadMoreItems(index: Int) -> Bool {
        guard let locationsPager = locationsPager else { return false }
        let itemsLeftToLastItem = 6
        return (((numberOfItems(inSection: 0) - 1) - itemsLeftToLastItem) == index) && (!locationsPager.isLastPage)
    }
}

extension LocationsCollectionView: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        guard let locationsPager = locationsPager else { return 0 }
        return locationsPager.getItems().count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = dequeueReusableCell(withReuseIdentifier: infoCellIdentifier, for: indexPath) as? LocationsCollectionViewInfoCell,
              let location = locationsPager?.getItems()[indexPath.item],
              let imageCacheManager = imageCacheManager else { return UICollectionViewCell() }
        let representable = DefaultLocationsCollectionViewInfoCellRepresentable(title: location.name)
        cell.configure(with: representable, and: imageCacheManager)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if shouldLoadMoreItems(index: indexPath.item) {
            subject.send(.viewMore)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let leftContentInset: CGFloat = 20
        let minSpacingColumns: CGFloat = 10
        let cellWidth = frame.width/2 - (leftContentInset + minSpacingColumns)
        return CGSize(width: cellWidth, height: cellWidth)
    }
}
