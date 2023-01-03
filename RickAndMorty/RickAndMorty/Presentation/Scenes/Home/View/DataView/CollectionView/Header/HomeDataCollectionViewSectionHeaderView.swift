//
//  HomeDataCollectionViewSectionHeaderView.swift
//  RickAndMorty
//
//  Created by Miguel Ferrer Fornali on 2/1/23.
//

import UIKit
import Combine

enum HomeDataCollectionViewSectionHeaderViewState {
    case didTapButton(HomeDataCategory)
}

final class HomeDataCollectionViewSectionHeaderView: UICollectionReusableView {
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var arrowImageView: UIImageView!
    private var subscriptions = Set<AnyCancellable>()
    private var subject = PassthroughSubject<HomeDataCollectionViewSectionHeaderViewState, Never>()
    var publisher: AnyPublisher<HomeDataCollectionViewSectionHeaderViewState, Never> { subject.eraseToAnyPublisher() }
    private var category: HomeDataCategory? = nil
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupView()
    }
    
    func configure(with category: HomeDataCategory) {
        self.category = category
        titleLabel.text = category.getTitle()
    }
}

private extension HomeDataCollectionViewSectionHeaderView {
    func setupView() {
        configureTitleLabel()
    }
    
    func configureTitleLabel() {
        let iPadDevice = UIDevice.current.userInterfaceIdiom == .pad
        titleLabel.font = .boldSystemFont(ofSize: iPadDevice ? 28 : 22)
    }
    
    @IBAction func didTapButton(_ sender: UIButton) {
        guard let category = category else { return }
        subject.send(.didTapButton(category))
    }
}
