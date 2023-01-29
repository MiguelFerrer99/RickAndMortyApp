//
//  InfoView.swift
//  RickAndMorty
//
//  Created by Miguel Ferrer Fornali on 30/1/23.
//

import UIKit

final class InfoView: XibView {
    @IBOutlet private weak var containerView: UIView!
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var descriptionLabel: UILabel!
    private let iPadDevice = UIDevice.current.userInterfaceIdiom == .pad
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupView()
    }
    
    func configure(title: String, description: String) {
        titleLabel.text = title
        descriptionLabel.text = description
    }
}

private extension InfoView {
    func setupView() {
        configureContainerView()
        configureTitleLabel()
        configureDescriptionLabel()
    }
    
    func configureContainerView() {
        containerView.layer.cornerRadius = 10
    }
    
    func configureTitleLabel() {
        titleLabel.font = .boldSystemFont(ofSize: iPadDevice ? 25 : 14)
    }
    
    func configureDescriptionLabel() {
        descriptionLabel.font = .systemFont(ofSize: iPadDevice ? 25 : 14)
    }
}
