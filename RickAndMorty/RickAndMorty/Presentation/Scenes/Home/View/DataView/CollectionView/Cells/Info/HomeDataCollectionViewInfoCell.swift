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
    @IBOutlet private weak var episodeLabel: UILabel!
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
    
    func configure(with representable: HomeDataCollectionViewInfoCellRepresentable, and imageCacheManager: ImageCacheManager) {
        switch representable.style {
        case .character(let title, let urlImage):
            titleLabel.text = title
            if let image = imageCacheManager.get(name: urlImage) {
                showTextAndImage(image: image)
            } else {
                if let url = URL(string: urlImage) {
                    imageView.load(url: url) {
                        imageCacheManager.add(image: $0, name: urlImage)
                        self.showTextAndImage(image: $0)
                    }
                }
            }
        case .location(let title, let imageName):
            titleLabel.text = title
            if let image = UIImage(named: imageName) {
                showTextAndImage(image: image)
            }
        case .episode(let title, let season, let episode):
            titleLabel.text = title
            episodeLabel.text = .home.episodeSeason.localized(with: season) + "\n" + .home.episodeEpisode.localized(with: episode)
            if let image = UIImage(named: "Episode") {
                showTextAndImage(image: image, isEpisode: true)
            }
        }
    }
}

private extension HomeDataCollectionViewInfoCell {
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
    
    func configureEpisodeLabel() {
        episodeLabel.textColor = .white
        episodeLabel.font = UIFont(name: "GetSchwifty-Regular", size: iPadDevice ? 50 : 20)
        episodeLabel.shadowColor = .black
        episodeLabel.shadowOffset = CGSize(width: 2, height: 3)
    }
    
    func setDefaultConfiguration() {
        imageView.image = nil
        titleLabel.alpha = 0
        episodeLabel.alpha = 0
        configureImageView()
    }
    
    func showTextAndImage(image: UIImage, isEpisode: Bool = false) {
        imageView.image = image
        imageView.alpha = 1
        titleLabel.alpha = 1
        episodeLabel.alpha = isEpisode ? 1 : 0
    }
}
