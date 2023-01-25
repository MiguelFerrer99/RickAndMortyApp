//
//  EpisodesViewController.swift
//  RickAndMorty
//
//  Created by Miguel Ferrer Fornali on 23/1/23.
//

import UIKit
import Combine

final class EpisodesViewController: UIViewController {
    @IBOutlet private weak var containerView: UIView!
    private let viewModel: EpisodesViewModel
    private let dependencies: EpisodesDependenciesResolver
    private var subscriptions: Set<AnyCancellable> = []

    init(dependencies: EpisodesDependenciesResolver) {
        self.dependencies = dependencies
        self.viewModel = dependencies.resolve()
        super.init(nibName: "EpisodesViewController", bundle: .main)
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

private extension EpisodesViewController {
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
        configureNavigationBar(with: .episodes.title.localized)
    }
}
