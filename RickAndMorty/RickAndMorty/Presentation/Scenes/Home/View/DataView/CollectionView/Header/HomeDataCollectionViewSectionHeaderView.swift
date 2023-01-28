//
//  HomeDataCollectionViewSectionHeaderView.swift
//  RickAndMorty
//
//  Created by Miguel Ferrer Fornali on 2/1/23.
//

import UIKit

protocol HomeDataCollectionViewSectionHeaderViewProtocol: AnyObject {
    func didTapTitle(category: HomeDataCategory)
    func didTapViewMore(category: HomeDataCategory)
}

final class HomeDataCollectionViewSectionHeaderView: UICollectionReusableView {
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var viewMoreLabel: UILabel!
    @IBOutlet private weak var stackButtonView: UIStackView!
    private var category: HomeDataCategory? = nil
    private weak var delegate: HomeDataCollectionViewSectionHeaderViewProtocol?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupView()
    }
    
    func configure(with category: HomeDataCategory, delegate: HomeDataCollectionViewSectionHeaderViewProtocol) {
        self.category = category
        self.delegate = delegate
        titleLabel.text = category.getTitle()
    }
}

private extension HomeDataCollectionViewSectionHeaderView {
    func setupView() {
        configureTitleLabel()
        configureViewMoreLabel()
        configureStackButtonView()
    }
    
    func configureTitleLabel() {
        let iPadDevice = UIDevice.current.userInterfaceIdiom == .pad
        titleLabel.font = .boldSystemFont(ofSize: iPadDevice ? 28 : 18)
        let gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(didTapTitleLabel))
        titleLabel.addGestureRecognizer(gestureRecognizer)
        titleLabel.isUserInteractionEnabled = true
    }
    
    func configureViewMoreLabel() {
        let iPadDevice = UIDevice.current.userInterfaceIdiom == .pad
        viewMoreLabel.font = .boldSystemFont(ofSize: iPadDevice ? 28 : 18)
        viewMoreLabel.text = .home.viewMore.localized
    }
    
    func configureStackButtonView() {
        let gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(didTapStackButtonView))
        stackButtonView.addGestureRecognizer(gestureRecognizer)
        stackButtonView.isUserInteractionEnabled = true
    }
    
    @objc func didTapStackButtonView() {
        guard let category = category else { return }
        delegate?.didTapViewMore(category: category)
    }
    
    @objc func didTapTitleLabel() {
        guard let category = category else { return }
        delegate?.didTapTitle(category: category)
    }
}
