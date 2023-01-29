//
//  CharactersCollectionViewInfoCell.swift
//  RickAndMorty
//
//  Created by Miguel Ferrer Fornali on 25/1/23.
//

import UIKit

final class CharactersCollectionViewInfoCell: UICollectionViewCell {
    @IBOutlet private weak var containerView: UIView!
    @IBOutlet private weak var imageView: UIImageView!
    @IBOutlet private weak var titleLabel: UILabel!
    private let iPadDevice = UIDevice.current.userInterfaceIdiom == .pad
    private let gradientLayer = CAGradientLayer()
    
    override func prepareForReuse() {
        super.prepareForReuse()
        setDefaultConfiguration()
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupView()
    }
    
    func configure(with representable: CharactersCollectionViewInfoCellRepresentable, and imageCacheManager: ImageCacheManager) {
        titleLabel.text = representable.title
        if let image = imageCacheManager.get(name: representable.urlImage) {
            showTextAndImage(image: image)
        } else {
            if let url = URL(string: representable.urlImage) {
                imageView.load(url: url) {
                    imageCacheManager.add(image: $0, name: representable.urlImage)
                    self.showTextAndImage(image: $0)
                }
            }
        }
    }
}

private extension CharactersCollectionViewInfoCell {
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
            guard let self = self else { return }
            self.gradientLayer.frame = self.bounds
            self.gradientLayer.startPoint = CGPoint(x: 0, y: 1)
            self.gradientLayer.endPoint = CGPoint(x: 1, y: 0)
            self.gradientLayer.colors = [UIColor.black.withAlphaComponent(0.6).cgColor,
                                    UIColor.black.withAlphaComponent(0.2).cgColor,
                                    UIColor.clear.cgColor]
            self.imageView.layer.addSublayer(self.gradientLayer)
        }
    }
    
    func configureTitleLabel() {
        titleLabel.alpha = 0
        titleLabel.textColor = .white
        titleLabel.font = .systemFont(ofSize: iPadDevice ? 30 : 15, weight: .semibold)
    }
    
    func showTextAndImage(image: UIImage) {
        imageView.image = image
        imageView.alpha = 1
        titleLabel.alpha = 1
    }
    
    func setDefaultConfiguration() {
        imageView.image = nil
        titleLabel.alpha = 0
        configureImageView()
    }
}
