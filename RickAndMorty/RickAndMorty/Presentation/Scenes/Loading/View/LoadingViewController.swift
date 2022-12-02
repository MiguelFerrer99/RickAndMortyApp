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
        setAppearance()
        bind()
        viewModel.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        configureNavigationBar()
    }
}

private extension LoadingViewController {
    func setAppearance() {
        configureLoaderView()
    }
    
    func configureLoaderView() {
        stackView.addArrangedSubview(loaderView)
    }
    
    func bind() {
        bindViewModel()
    }
    
    func bindViewModel() {
        viewModel.state
            .filter { $0 == .loading }
            .sink { [weak self] _ in
                guard let self = self else { return }
                self.loaderView.isHidden = false
            }.store(in: &subscriptions)
    }
    
    func configureNavigationBar() {
        self.navigationController?.setNavigationBarHidden(true, animated: false)
    }
}
