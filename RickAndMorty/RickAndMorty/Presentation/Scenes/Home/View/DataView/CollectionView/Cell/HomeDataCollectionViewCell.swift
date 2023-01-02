//
//  HomeDataCollectionViewCell.swift
//  RickAndMorty
//
//  Created by Miguel Ferrer Fornali on 1/1/23.
//

import UIKit

final class HomeDataCollectionViewCell: UICollectionViewCell {
    @IBOutlet private weak var containerView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupView()
    }
}

private extension HomeDataCollectionViewCell {
    func setupView() {
        configureBackground()
    }
    
    func configureBackground() {
        containerView.layer.cornerRadius = 10
    }
}
