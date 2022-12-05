//
//  HomeViewController.swift
//  iOSCleanArchitecture
//
//  Created by Miguel Ferrer Fornali on 19/11/22.
//

import UIKit
import Combine

final class HomeViewController: UIViewController {
    @IBOutlet private weak var containerView: UIView!
    
    private let viewModel: HomeViewModel
    private let dependencies: HomeDependenciesResolver
    private var subscriptions: Set<AnyCancellable> = []
    
    private lazy var loadingView: HomeLoadingView = {
        HomeLoadingView()
    }()
    private lazy var dataView: HomeDataView = {
        let dataView = HomeDataView()
        dataView.isHidden = true
        return dataView
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
        configureLoadingView()
        configureDataView()
    }
    
    func configureLoadingView() {
        containerView.addSubview(loadingView)
        loadingView.fullFit()
        containerView.layoutIfNeeded()
    }
    
    func configureDataView() {
        containerView.addSubview(dataView)
        dataView.fullFit()
        containerView.layoutIfNeeded()
    }
    
    func bind() {
        bindViewModel()
        bindLoadingView()
    }
    
    func bindViewModel() {
        viewModel.state
            .filter { $0 == .loading }
            .sink { [weak self] _ in
                guard let self = self else { return }
                self.loadingView.loadingData()
            }.store(in: &subscriptions)
        
        viewModel.state
            .filter { $0 == .error }
            .sink { [weak self] _ in
                guard let self = self else { return }
                self.loadingView.receivedError()
            }.store(in: &subscriptions)
        
        viewModel.state
            .filter { $0 == .received }
            .sink { [weak self] _ in
                guard let self = self else { return }
                self.showDataView()
            }.store(in: &subscriptions)
    }
    
    func bindLoadingView() {
        loadingView.publisher
            .filter { $0 == .tryAgain }
            .sink { [weak self] _ in
                guard let self = self else { return }
                self.viewModel.tryAgain()
            }.store(in: &subscriptions)
    }
    
    func configureNavigationBar() {
        configureNavigationBarCommons()
        sceneNavigationController.setNavigationBarHidden(true, animated: false)
    }
    
    func configureNavigationBarCommons() {
        let navBarAppearance = UINavigationBarAppearance()
        navBarAppearance.configureWithOpaqueBackground()
        navBarAppearance.shadowColor = .clear
        navBarAppearance.shadowImage = UIImage()
        sceneNavigationController.navigationBar.standardAppearance = navBarAppearance
        sceneNavigationController.navigationBar.scrollEdgeAppearance = navBarAppearance
    }
}

private extension HomeViewController {
    func showDataView() {
        loadingView.receivedData()
        loadingView.isHidden = true
        dataView.isHidden = false
    }
}
