//
//  LoadingViewController.swift
//  iOSCleanArchitecture
//
//  Created by Miguel Ferrer Fornali on 19/11/22.
//

import UIKit
import Combine

final class LoadingViewController: UIViewController {
    @IBOutlet private weak var stackView: UIStackView!
    
    private let viewModel: LoadingViewModel
    private let dependencies: LoadingDependenciesResolver
    private var subscriptions: Set<AnyCancellable> = []
    
    private lazy var loaderView: LoadingLoaderView = {
        let view = LoadingLoaderView()
        view.isHidden = true
        return view
    }()
    private lazy var errorView: LoadingErrorView = {
        let view = LoadingErrorView()
        view.isHidden = true
        return view
    }()
    
    init(dependencies: LoadingDependenciesResolver) {
        self.dependencies = dependencies
        self.viewModel = dependencies.resolve()
        super.init(nibName: "LoadingViewController", bundle: .main)
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        bind()
        viewModel.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        configureNavigationBar()
    }
}

private extension LoadingViewController {
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
        bindViewModel()
        bindErrorView()
    }
    
    func bindViewModel() {
        viewModel.state
            .filter { $0 == .loading }
            .sink { [weak self] _ in
                guard let self = self else { return }
                self.setLoadingState()
            }.store(in: &subscriptions)
        
        viewModel.state
            .filter { $0 == .error }
            .sink { [weak self] _ in
                guard let self = self else { return }
                self.setErrorState()
            }.store(in: &subscriptions)
    }
    
    func bindErrorView() {
        errorView.publisher
            .filter { $0 == .didTapTryAgain }
            .sink { [weak self] _ in
                guard let self = self else { return }
                self.viewModel.getInfoAgain()
            }.store(in: &subscriptions)
    }
    
    func configureNavigationBar() {
        self.navigationController?.setNavigationBarHidden(true, animated: false)
    }
    
    func setLoadingState() {
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
    
    func setErrorState() {
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
