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
    @IBOutlet private weak var titleLabelLeadingConstraint: NSLayoutConstraint!
    @IBOutlet private weak var titleLabelBottomConstraint: NSLayoutConstraint!
    @IBOutlet private weak var titleLabelTopConstraint: NSLayoutConstraint!
    @IBOutlet private weak var titleLabelTrailingConstraint: NSLayoutConstraint!
    private let iPadDevice = UIDevice.current.userInterfaceIdiom == .pad
    private var imageCacheManager: ImageCacheManager?
    private let gradientLayer = CAGradientLayer()
    
    override func prepareForReuse() {
        super.prepareForReuse()
        imageView.image = nil
        titleLabel.alpha = 0
        configureImageView()
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupView()
    }
    
    func configure(with representable: CharactersCollectionViewInfoCellRepresentable, and imageCacheManager: ImageCacheManager) {
        self.imageCacheManager = imageCacheManager
        titleLabel.text = representable.title
        guard let url = URL(string: representable.urlImage) else { return }
        if let image = imageCacheManager.get(name: representable.urlImage) {
            showTextAndImage(image: image)
        } else {
            imageView.load(url: url) {
                imageCacheManager.add(image: $0, name: representable.urlImage)
                self.showTextAndImage(image: $0)
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
            self.imageView.alpha = 0
        }
    }
    
    func configureTitleLabel() {
        titleLabel.alpha = 0
        titleLabel.textColor = .white
        titleLabel.font = .systemFont(ofSize: iPadDevice ? 30 : 15, weight: .semibold)
        if iPadDevice {
            titleLabelLeadingConstraint.constant = 40
            titleLabelBottomConstraint.constant = 40
            titleLabelTopConstraint.constant = 40
            titleLabelTrailingConstraint.constant = 40
            containerView.layoutIfNeeded()
        }
    }
    
    func showTextAndImage(image: UIImage) {
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            self.imageView.image = image
            UIView.animate(withDuration: 0.5, delay: 0, options: .curveEaseOut, animations: { [weak self] in
                guard let self = self else { return }
                self.imageView.alpha = 1
                self.titleLabel.alpha = 1
            }, completion: nil)
        }
    }
}
