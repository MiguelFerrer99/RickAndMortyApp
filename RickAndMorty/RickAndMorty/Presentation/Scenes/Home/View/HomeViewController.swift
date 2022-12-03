//
//  HomeViewController.swift
//  RickAndMorty
//
//  Created by Miguel Ferrer Fornali on 3/12/22.
//

import UIKit
import Combine

final class HomeViewController: UIViewController {
    private let viewModel: HomeViewModel
    private let dependencies: HomeDependenciesResolver
    private var subscriptions: Set<AnyCancellable> = []
    
    private lazy var titleView: HomeTitleView = {
        HomeTitleView()
    }()

    init(dependencies: HomeDependenciesResolver) {
        self.dependencies = dependencies
        self.viewModel = dependencies.resolve()
        super.init(nibName: "HomeViewController", bundle: .main)
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        bind()
        viewModel.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        configureNavigationBar()
    }
}

private extension HomeViewController {
    var sceneNavigationController: UINavigationController {
        dependencies.external.resolve()
    }
    
    func setupViews() {
        // Configure views
    }
    
    func bind() {
        bindViewModel()
        bindTitleView()
    }
    
    func bindViewModel() {
        // Bind ViewModel states
    }
    
    func bindTitleView() {
        titleView.publisher
            .filter { $0 == .didTapView }
            .sink { [weak self] _ in
                guard let self = self else { return }
                self.viewModel.openAuthorBottomSheet()
            }.store(in: &subscriptions)
    }
    
    func configureNavigationBar() {
        sceneNavigationController.setNavigationBarHidden(false, animated: true)
        self.navigationItem.titleView = titleView
    }
}
