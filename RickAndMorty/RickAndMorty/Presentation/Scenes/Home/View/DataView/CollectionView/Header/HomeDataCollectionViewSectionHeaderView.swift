//
//  HomeDataCollectionViewSectionHeaderView.swift
//  RickAndMorty
//
//  Created by Miguel Ferrer Fornali on 2/1/23.
//

import UIKit
import Combine

enum HomeDataCollectionViewSectionHeaderViewState {
    case didTapButton
}

final class HomeDataCollectionViewSectionHeaderView: UICollectionReusableView {
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var arrowImageContainerView: UIView!
    @IBOutlet private weak var arrowImageView: UIImageView!
    
    private var subscriptions = Set<AnyCancellable>()
    private var subject = PassthroughSubject<HomeDataCollectionViewSectionHeaderViewState, Never>()
    var publisher: AnyPublisher<HomeDataCollectionViewSectionHeaderViewState, Never> { subject.eraseToAnyPublisher() }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupView()
    }
    
    func configure(with title: String) {
        titleLabel.text = title
    }
}

private extension HomeDataCollectionViewSectionHeaderView {
    func setupView() {
        configureTitleLabel()
        configureArrowImageContainerView()
    }
    
    func configureTitleLabel() {
        titleLabel.font = .boldSystemFont(ofSize: 24)
    }
    
    func configureArrowImageContainerView() {
        let gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(didTapArrowImageContainerView))
        arrowImageContainerView.addGestureRecognizer(gestureRecognizer)
        arrowImageContainerView.isUserInteractionEnabled = true
    }
    
    @objc func didTapArrowImageContainerView() {
        subject.send(.didTapButton)
    }
}
