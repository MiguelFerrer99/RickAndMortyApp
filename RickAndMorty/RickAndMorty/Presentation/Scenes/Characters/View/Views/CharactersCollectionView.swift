//
//  CharactersCollectionView.swift
//  RickAndMorty
//
//  Created by Miguel Ferrer Fornali on 25/1/23.
//

import UIKit

import UIKit
import Combine

enum CharactersCollectionViewState {
    // States
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
    }
}

private extension CharactersCollectionView {
    var infoCellIdentifier: String {
        String(describing: type(of: HomeDataCollectionViewInfoCell()))
    }
    
    func setupView() {
        delegate = self
        dataSource = self
        registerCell()
    }
    
    func registerCell() {
        let infoCellNib = UINib(nibName: infoCellIdentifier, bundle: .main)
        register(infoCellNib, forCellWithReuseIdentifier: infoCellIdentifier)
    }
}

extension CharactersCollectionView: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        UICollectionViewCell()
    }
}
