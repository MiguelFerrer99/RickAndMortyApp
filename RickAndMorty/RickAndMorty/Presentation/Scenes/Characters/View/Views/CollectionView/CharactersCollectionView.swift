//
//  CharactersCollectionView.swift
//  RickAndMorty
//
//  Created by Miguel Ferrer Fornali on 25/1/23.
//

import UIKit
import Combine
import Foundation

enum CharactersCollectionViewState {
    case showNavigationBarShadow(Bool)
    case viewMore
}

final class CharactersCollectionView: UICollectionView {
    private var subject = PassthroughSubject<CharactersCollectionViewState, Never>()
    var publisher: AnyPublisher<CharactersCollectionViewState, Never> { subject.eraseToAnyPublisher() }
    private var charactersPager: Pagination<CharacterRepresentable>?
    private var imageCacheManager: ImageCacheManager?
    
    init(frame: CGRect) {
        super.init(frame: frame, collectionViewLayout: .init())
        setupView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupView()
    }
    
    func configure(with charactersPager: Pagination<CharacterRepresentable>, and imageCacheManager: ImageCacheManager) {
        self.charactersPager = charactersPager
        self.imageCacheManager = imageCacheManager
        reloadData()
    }
}

private extension CharactersCollectionView {
    var infoCellIdentifier: String {
        String(describing: type(of: CharactersCollectionViewInfoCell()))
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
        guard let charactersPager = charactersPager else { return false }
        let itemsLeftToLastItem = 6
        return (((numberOfItems(inSection: 0) - 1) - itemsLeftToLastItem) == index) && (!charactersPager.isLastPage)
    }
}

extension CharactersCollectionView: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        guard let charactersPager = charactersPager else { return 0 }
        return charactersPager.getItems().count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = dequeueReusableCell(withReuseIdentifier: infoCellIdentifier, for: indexPath) as? CharactersCollectionViewInfoCell,
              let character = charactersPager?.getItems()[indexPath.item],
              let imageCacheManager = imageCacheManager else { return UICollectionViewCell() }
        let representable = DefaultCharactersCollectionViewInfoCellRepresentable(title: character.name, urlImage: character.urlImage)
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
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        subject.send(.showNavigationBarShadow(scrollView.contentOffset.y > 0))
    }
}