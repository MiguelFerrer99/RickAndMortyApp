//
//  LocationsCollectionViewEmptyCell.swift
//  RickAndMorty
//
//  Created by Miguel Ferrer Fornali on 28/1/23.
//

import UIKit

final class LocationsCollectionViewEmptyCell: UICollectionViewCell {
    @IBOutlet private weak var titleLabel: UILabel!
    private let iPadDevice = UIDevice.current.userInterfaceIdiom == .pad
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupView()
    }
}

private extension LocationsCollectionViewEmptyCell {
    func setupView() {
        configureTitleLabel()
    }
    
    func configureTitleLabel() {
        titleLabel.font = .boldSystemFont(ofSize: iPadDevice ? 28 : 18)
        titleLabel.text = .characters.empty.localized
    }
}
