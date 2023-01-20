//
//  HomeDataCollectionViewInfoCell.swift
//  RickAndMorty
//
//  Created by Miguel Ferrer Fornali on 1/1/23.
//

import UIKit

final class HomeDataCollectionViewInfoCell: UICollectionViewCell {
    @IBOutlet private weak var containerView: UIView!
    @IBOutlet private weak var imageView: UIImageView!
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var titleLabelLeadingConstraint: NSLayoutConstraint!
    @IBOutlet private weak var titleLabelBottomConstraint: NSLayoutConstraint!
    @IBOutlet private weak var titleLabelTopConstraint: NSLayoutConstraint!
    @IBOutlet private weak var titleLabelTrailingConstraint: NSLayoutConstraint!
    private let iPadDevice = UIDevice.current.userInterfaceIdiom == .pad
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupView()
    }
    
    func configure(with representable: HomeDataCollectionViewInfoCellRepresentable) {
        titleLabel.text = representable.title
        if let urlImage = representable.urlImage { setUrlImage(with: urlImage) }
    }
}

private extension HomeDataCollectionViewInfoCell {
    func setupView() {
        configureContainerView()
        configureTitleLabel()
    }
    
    func configureContainerView() {
        containerView.clipsToBounds = true
        containerView.layer.cornerRadius = 10
    }
    
    func configureImageView(with uiImage: UIImage) {
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            let gradientLayer = CAGradientLayer()
            gradientLayer.frame = self.bounds
            gradientLayer.startPoint = CGPoint(x: 0, y: 1)
            gradientLayer.endPoint = CGPoint(x: 1, y: 0)
            gradientLayer.colors = [UIColor.black.withAlphaComponent(0.6).cgColor,
                                    UIColor.black.withAlphaComponent(0.2).cgColor,
                                    UIColor.clear.cgColor]
            self.imageView.layer.addSublayer(gradientLayer)
            self.imageView.image = uiImage
            self.titleLabel.alpha = 1
        }
    }
    
    func configureTitleLabel() {
        titleLabel.textColor = .white
        titleLabel.font = .systemFont(ofSize: iPadDevice ? 30 : 16, weight: .semibold)
        if iPadDevice {
            titleLabelLeadingConstraint.constant = 40
            titleLabelBottomConstraint.constant = 40
            titleLabelTopConstraint.constant = 40
            titleLabelTrailingConstraint.constant = 40
            containerView.layoutIfNeeded()
        }
    }
    
    func setUrlImage(with urlImage: String) {
        guard let url = URL(string: urlImage) else { return }
        URLSession.shared.dataTask(with: url) { [weak self] (data, response, error) in
            guard let self = self, let data = data, error.isNil, let uiImage = UIImage(data: data) else { return }
            self.configureImageView(with: uiImage)
        }
    }
}
