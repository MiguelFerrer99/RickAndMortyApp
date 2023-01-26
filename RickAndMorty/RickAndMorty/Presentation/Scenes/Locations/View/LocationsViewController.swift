//
//  LocationsViewController.swift
//  RickAndMorty
//
//  Created by Miguel Ferrer Fornali on 23/1/23.
//

import UIKit
import Combine

final class LocationsViewController: UIViewController {
    @IBOutlet private weak var containerView: UIView!
    @IBOutlet private weak var collectionView: LocationsCollectionView!
    private let viewModel: LocationsViewModel
    private let dependencies: LocationsDependenciesResolver
    private var subscriptions: Set<AnyCancellable> = []

    init(dependencies: LocationsDependenciesResolver) {
        self.dependencies = dependencies
        self.viewModel = dependencies.resolve()
        super.init(nibName: "LocationsViewController", bundle: .main)
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bind()
        viewModel.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        configureNavigationBar()
    }
}

private extension LocationsViewController {
    var sceneNavigationController: UINavigationController {
        dependencies.external.resolve()
    }
    
    var imageCacheManager: ImageCacheManager {
        dependencies.external.resolveImageCacheManager()
    }
    
    func bind() {
        bindViewModel()
        bindCollectionView()
    }
    
    func bindViewModel() {
        viewModel.state
            .sink { [weak self] state in
                guard let self = self else { return }
                switch state {
                case .locationsReceived(let pager):
                    self.collectionView.configure(with: pager, and: self.imageCacheManager)
                case .idle: return
                }
            }.store(in: &subscriptions)
    }
    
    func bindCollectionView() {
        collectionView.publisher
            .sink { [weak self] state in
                guard let self = self else { return }
                switch state {
                case .viewMore:
                    self.viewModel.viewMoreLocations()
                }
            }.store(in: &subscriptions)
    }
    
    func configureNavigationBar() {
        configureNavigationBar(with: .locations.title.localized)
    }
}
