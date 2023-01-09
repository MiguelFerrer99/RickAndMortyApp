//
//  HomeDataCollectionViewLoadingCell.swift
//  RickAndMorty
//
//  Created by Miguel Ferrer Fornali on 9/1/23.
//

import UIKit
import Lottie

final class HomeDataCollectionViewLoadingCell: UICollectionViewCell {
    @IBOutlet private weak var animationView: LottieAnimationView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupView()
    }
}

private extension HomeDataCollectionViewLoadingCell {
    func setupView() {
        configureLoader()
    }
    
    func configureLoader() {
        animationView.loopMode = .loop
        animationView.play()
    }
}
