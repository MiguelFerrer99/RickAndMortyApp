//
//  LocationsCollectionViewInfoCell.swift
//  RickAndMorty
//
//  Created by Miguel Ferrer Fornali on 26/1/23.
//

import UIKit

final class LocationsCollectionViewInfoCell: UICollectionViewCell {
    @IBOutlet private weak var containerView: UIView!
    @IBOutlet private weak var imageView: UIImageView!
    @IBOutlet private weak var titleLabel: UILabel!
    
    private lazy var gradientLayer = CAGradientLayer()
    
    override func prepareForReuse() {
        super.prepareForReuse()
        setDefaultConfiguration()
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupView()
    }
    
    func configure(with representable: LocationsCollectionViewInfoCellRepresentable) {
        titleLabel.text = representable.title
        showTextAndImage(image: representable.image)
    }
}

private extension LocationsCollectionViewInfoCell {
    func setupView() {
        configureContainerView()
        configureImageView()
        configureTitleLabel()
    }
    
    func configureContainerView() {
        containerView.clipsToBounds = true
        containerView.layer.cornerRadius = 10
    }
    
    func configureImageView() {
        DispatchQueue.main.async { [weak self] in
            guard let self else { return }
            gradientLayer.frame = bounds
            gradientLayer.startPoint = CGPoint(x: 0, y: 1)
            gradientLayer.endPoint = CGPoint(x: 1, y: 0)
            gradientLayer.colors = [UIColor.black.withAlphaComponent(0.6).cgColor,
                                    UIColor.black.withAlphaComponent(0.2).cgColor,
                                    UIColor.clear.cgColor]
            imageView.layer.addSublayer(gradientLayer)
        }
    }
    
    func configureTitleLabel() {
        titleLabel.alpha = 0
        titleLabel.textColor = .white
        titleLabel.font = .systemFont(ofSize: UIDevice.isIpad ? 30 : 15, weight: .semibold)
    }
    
    func showTextAndImage(image: String) {
        if let image = UIImage(named: image) {
            imageView.image = image
            imageView.alpha = 1
            titleLabel.alpha = 1
        }
    }
    
    func setDefaultConfiguration() {
        imageView.image = nil
        titleLabel.alpha = 0
        configureImageView()
    }
}
