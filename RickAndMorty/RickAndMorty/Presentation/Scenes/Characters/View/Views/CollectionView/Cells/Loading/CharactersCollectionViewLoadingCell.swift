//
//  CharactersCollectionViewLoadingCell.swift
//  RickAndMorty
//
//  Created by Miguel Ferrer Fornali on 29/1/23.
//

import UIKit
import Lottie

final class CharactersCollectionViewLoadingCell: UICollectionViewCell {
    @IBOutlet private weak var animationView: LottieAnimationView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupView()
    }
}

private extension CharactersCollectionViewLoadingCell {
    func setupView() {
        animationView.loopMode = .loop
        animationView.play()
    }
}
