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
    public lazy var publisher: AnyPublisher<HomeDataCollectionViewState, Never> = {
        return subject.eraseToAnyPublisher()
    }()
    
    init(frame: CGRect) {
        super.init(frame: frame, collectionViewLayout: UICollectionViewLayout())
        setupView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupView()
    }
}

private extension HomeDataCollectionView {
    func setupView() {
        // Configure collection view
        backgroundColor = .red
    }
}
