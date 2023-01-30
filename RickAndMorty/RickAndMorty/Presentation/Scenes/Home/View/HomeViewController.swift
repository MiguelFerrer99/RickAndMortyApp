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
    private let loadingView = HomeLoadingView()
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
    
    var imageCacheManager: ImageCacheManager {
        dependencies.external.resolveImageCacheManager()
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
        bindDataView()
    }
    
    func bindViewModel() {
        viewModel.state
            .sink { [weak self] state in
                guard let self = self else { return }
                switch state {
                case .loading:
                    self.loadingView.loadingData()
                case .error:
                    self.loadingView.receivedError()
                case .received(let categories):
                    self.showDataView(with: categories)
                case .idle: return
                }
            }.store(in: &subscriptions)
    }
    
    func bindLoadingView() {
        loadingView.publisher
            .sink { [weak self] state in
                guard let self = self else { return }
                switch state {
                case .tryAgain:
                    self.viewModel.viewDidLoad()
                }
            }.store(in: &subscriptions)
    }
    
    func bindDataView() {
        dataView.publisher
            .sink { [weak self] state in
                guard let self = self else { return }
                switch state {
                case .didTapTitleImage:
                    self.viewModel.openAuthorInfo()
                case .openLocation(let location):
                    self.viewModel.openLocation(location)
                case .openEpisode(let episode):
                    self.viewModel.openEpisode(episode)
                case .viewMore(let category):
                    self.viewModel.openCategoryDetail(category)
                }
            }.store(in: &subscriptions)
    }
    
    func configureNavigationBar() {
        sceneNavigationController.setNavigationBarHidden(true, animated: true)
    }
    
    func showDataView(with categories: [HomeDataCategory]) {
        loadingView.receivedData()
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) { [weak self] in
            guard let self = self else { return }
            self.loadingView.isHidden = true
            self.dataView.isHidden = false
            self.dataView.receivedData(categories, with: self.imageCacheManager)
        }
    }
}
