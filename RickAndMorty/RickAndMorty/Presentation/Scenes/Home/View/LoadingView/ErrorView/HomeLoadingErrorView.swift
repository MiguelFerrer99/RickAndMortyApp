//
//  HomeLoadingErrorView.swift
//  RickAndMorty
//
//  Created by Miguel Ferrer Fornali on 2/12/22.
//

import UIKit
import Combine

enum HomeLoadingErrorViewState {
    case didTapTryAgain
}

final class HomeLoadingErrorView: XibView {
    @IBOutlet private weak var stackView: UIStackView!
    @IBOutlet private weak var titleLabel: UILabel!
    
    private var subscriptions = Set<AnyCancellable>()
    private var subject = PassthroughSubject<HomeLoadingErrorViewState, Never>()
    var publisher: AnyPublisher<HomeLoadingErrorViewState, Never> {
        subject.eraseToAnyPublisher()
    }
    
    private lazy var tryAgainButtonView: TryAgainButtonView = {
        TryAgainButtonView()
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
        bind()
        setAppearance()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupView()
        bind()
        setAppearance()
    }
}

private extension HomeLoadingErrorView {
    func setupView() {
        configureTryAgainButtonView()
    }
    
    func configureTryAgainButtonView() {
        stackView.addArrangedSubview(tryAgainButtonView)
    }
    
    func bind() {
        bindTryAgainButtonView()
    }
    
    func bindTryAgainButtonView() {
        tryAgainButtonView.publisher
            .filter { $0 == .didTapButton }
            .sink { [weak self] _ in
                guard let self = self else { return }
                self.subject.send(.didTapTryAgain)
            }.store(in: &subscriptions)
    }
    
    func setAppearance() {
        configureTitleLabel()
    }
    
    func configureTitleLabel() {
        titleLabel.font = .systemFont(ofSize: 16, weight: .bold)
        titleLabel.text = .loading.errorTitle.localized
    }
}
