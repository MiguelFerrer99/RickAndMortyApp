//
//  EpisodesCollectionViewLoadingCell.swift
//  RickAndMorty
//
//  Created by Miguel Ferrer Fornali on 29/1/23.
//

import UIKit
import Lottie

final class EpisodesCollectionViewLoadingCell: UICollectionViewCell {
    @IBOutlet private weak var animationView: LottieAnimationView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupView()
    }
}

private extension EpisodesCollectionViewLoadingCell {
    func setupView() {
        animationView.loopMode = .loop
        animationView.play()
    }
}
