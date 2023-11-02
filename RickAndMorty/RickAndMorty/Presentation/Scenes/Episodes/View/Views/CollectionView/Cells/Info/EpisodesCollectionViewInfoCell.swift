//
//  EpisodesCollectionViewInfoCell.swift
//  RickAndMorty
//
//  Created by Miguel Ferrer Fornali on 26/1/23.
//

import UIKit

final class EpisodesCollectionViewInfoCell: UICollectionViewCell {
    @IBOutlet private weak var containerView: UIView!
    @IBOutlet private weak var imageView: UIImageView!
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var episodeLabel: UILabel!
    
    private lazy var gradientLayer = CAGradientLayer()
    
    override func prepareForReuse() {
        super.prepareForReuse()
        setDefaultConfiguration()
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupView()
    }
    
    func configure(with representable: EpisodesCollectionViewInfoCellRepresentable) {
        titleLabel.text = representable.title
        episodeLabel.text = .episodes.season.localized(with: representable.season) + "\n" + .episodes.episode.localized(with: representable.episode)
        showTextAndImage()
    }
}

private extension EpisodesCollectionViewInfoCell {
    func setupView() {
        configureContainerView()
        configureImageView()
        configureTitleLabel()
        configureEpisodeLabel()
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
    
    func configureEpisodeLabel() {
        episodeLabel.alpha = 0
        episodeLabel.textColor = .white
        episodeLabel.font = UIFont(name: "GetSchwifty-Regular", size: UIDevice.isIpad ? 70 : 20)
        episodeLabel.shadowColor = .black
        episodeLabel.shadowOffset = CGSize(width: 2, height: 3)
    }
    
    func showTextAndImage() {
        if let image = UIImage(named: "Episode") {
            imageView.image = image
            imageView.alpha = 1
            titleLabel.alpha = 1
            episodeLabel.alpha = 1
        }
    }
    
    func setDefaultConfiguration() {
        imageView.image = nil
        titleLabel.alpha = 0
        episodeLabel.alpha = 0
        configureImageView()
    }
}
