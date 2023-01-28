//
//  HomeLoadingView.swift
//  RickAndMorty
//
//  Created by Miguel Ferrer Fornali on 5/12/22.
//

import UIKit
import Combine

enum HomeLoadingViewState {
    case tryAgain
}

final class HomeLoadingView: XibView {
    @IBOutlet private weak var stackView: UIStackView!
    private var subscriptions = Set<AnyCancellable>()
    private var subject = PassthroughSubject<HomeLoadingViewState, Never>()
    var publisher: AnyPublisher<HomeLoadingViewState, Never> { subject.eraseToAnyPublisher() }
    private lazy var loaderView: HomeLoadingLoaderView = {
        let view = HomeLoadingLoaderView()
        view.isHidden = true
        return view
    }()
    private lazy var errorView: HomeLoadingErrorView = {
        let view = HomeLoadingErrorView()
        view.isHidden = true
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
        bind()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupView()
        bind()
    }
    
    func receivedData() {
        setReceivedDataAppearance()
    }
    
    func loadingData() {
        setLoadingAppearance()
    }
    
    func receivedError() {
        setErrorAppearance()
    }
}

private extension HomeLoadingView {
    func setupView() {
        configureLoaderView()
        configureErrorView()
    }
    
    func configureLoaderView() {
        stackView.addArrangedSubview(loaderView)
    }
    
    func configureErrorView() {
        stackView.addArrangedSubview(errorView)
    }
    
    func bind() {
        bindErrorView()
    }
    
    func bindErrorView() {
        errorView.publisher
            .filter { $0 == .didTapTryAgain }
            .sink { [weak self] _ in
                guard let self = self else { return }
                self.subject.send(.tryAgain)
            }.store(in: &subscriptions)
    }
    
    func setReceivedDataAppearance() {
        UIView.animate(withDuration: 0.2) { [weak self] in
            guard let self = self else { return }
            self.loaderView.alpha = 0
            self.errorView.alpha = 0
        } completion: { [weak self] ended in
            guard let self = self else { return }
            self.loaderView.isHidden = true
            self.errorView.isHidden = true
        }
    }
    
    func setLoadingAppearance() {
        UIView.animate(withDuration: 0.2) { [weak self] in
            guard let self = self else { return }
            self.loaderView.alpha = 1
            self.errorView.alpha = 0
        } completion: { [weak self] ended in
            guard let self = self else { return }
            self.loaderView.isHidden = false
            self.errorView.isHidden = true
        }
    }
    
    func setErrorAppearance() {
        UIView.animate(withDuration: 0.2) { [weak self] in
            guard let self = self else { return }
            self.loaderView.alpha = 0
            self.errorView.alpha = 1
        } completion: { [weak self] ended in
            guard let self = self else { return }
            self.loaderView.isHidden = true
            self.errorView.isHidden = false
        }
    }
}
