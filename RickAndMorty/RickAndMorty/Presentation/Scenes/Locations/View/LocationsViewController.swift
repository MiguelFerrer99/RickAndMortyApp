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
        setupView()
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
    
    func setupView() {
        // Configure views
    }
    
    func bind() {
        bindViewModel()
    }
    
    func bindViewModel() {
        // Bind ViewModel states
    }
    
    func configureNavigationBar() {
        configureNavigationBar(with: .locations.title.localized)
    }
}
