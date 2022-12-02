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
        setAppearance()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setAppearance()
    }
}

private extension TryAgainButtonView {
    func setAppearance() {
        configureContainerView()
        configureTitleLabel()
    }
    
    func configureContainerView() {
        containerView.layer.borderWidth = 3.0
        containerView.layer.cornerRadius = 10
        containerView.layer.borderColor = UIColor.black.cgColor
        containerView.addGestureRecognizer(UILongPressGestureRecognizer(target: self, action: #selector(didLongPressButtonView)))
        containerView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(didTapButtonView)))
    }
    
    func configureTitleLabel() {
        titleLabel.font = .systemFont(ofSize: 16, weight: .bold)
        titleLabel.text = .tryAgainButtonView.title.localized
    }
    
    @objc func didLongPressButtonView(recognizer: UILongPressGestureRecognizer) {
        switch recognizer.state {
        case .began:
            titleLabel.alpha = 0.5
        case .ended:
            titleLabel.alpha = 1
        default:
            break
        }
    }
    
    @objc func didTapButtonView(recognizer: UITapGestureRecognizer) {
        switch recognizer.state {
        case .began:
            titleLabel.alpha = 0.5
        case .ended:
            titleLabel.alpha = 1
            subject.send(.didTapButton)
        default:
            break
        }
    }
}
