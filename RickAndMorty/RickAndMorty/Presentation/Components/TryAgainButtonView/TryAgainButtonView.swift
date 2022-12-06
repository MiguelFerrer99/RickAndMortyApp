//
//  TryAgainButtonView.swift
//  RickAndMorty
//
//  Created by Miguel Ferrer Fornali on 2/12/22.
//

import UIKit
import Combine

enum TryAgainButtonViewState {
    case didTapButton
}

final class TryAgainButtonView: XibView {
    @IBOutlet private weak var containerView: UIView!
    @IBOutlet private weak var titleLabel: UILabel!
    
    private var subscriptions = Set<AnyCancellable>()
    private var subject = PassthroughSubject<TryAgainButtonViewState, Never>()
    var publisher: AnyPublisher<TryAgainButtonViewState, Never> {
        subject.eraseToAnyPublisher()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupView()
    }
}

private extension TryAgainButtonView {
    func setupView() {
        configureContainerView()
        configureTitleLabel()
    }
    
    func configureContainerView() {
        containerView.layer.borderWidth = 3.0
        containerView.layer.cornerRadius = 10
        containerView.layer.borderColor = UIColor.black.cgColor
        containerView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(didTapContainerView)))
    }
    
    func configureTitleLabel() {
        titleLabel.font = .systemFont(ofSize: 16, weight: .bold)
        titleLabel.text = .tryAgainButtonView.title.localized
    }
    
    @objc func didTapContainerView() {
        subject.send(.didTapButton)
    }
}
