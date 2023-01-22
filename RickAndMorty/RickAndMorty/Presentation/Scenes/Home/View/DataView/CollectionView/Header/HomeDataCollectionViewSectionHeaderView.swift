//
//  HomeDataCollectionViewSectionHeaderView.swift
//  RickAndMorty
//
//  Created by Miguel Ferrer Fornali on 2/1/23.
//

import UIKit

protocol HomeDataCollectionViewSectionHeaderViewProtocol: AnyObject {
    func didTapButton(with category: HomeDataCategory)
}

final class HomeDataCollectionViewSectionHeaderView: UICollectionReusableView {
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var viewMoreLabel: UILabel!
    @IBOutlet private weak var arrowImageView: UIImageView!
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
    }
    
    func configureTitleLabel() {
        let iPadDevice = UIDevice.current.userInterfaceIdiom == .pad
        titleLabel.font = .boldSystemFont(ofSize: iPadDevice ? 28 : 20)
    }
    
    func configureViewMoreLabel() {
        let iPadDevice = UIDevice.current.userInterfaceIdiom == .pad
        viewMoreLabel.font = .boldSystemFont(ofSize: iPadDevice ? 28 : 20)
        viewMoreLabel.text = .home.viewMore.localized
    }
    
    @IBAction func didTapViewMoreButton(_ sender: UIButton) {
        guard let category = category else { return }
        delegate?.didTapButton(with: category)
    }
}
