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
    @IBOutlet private weak var collectionView: EpisodesCollectionView!
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
                case .episodesReceived(let pager):
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
                    self.viewModel.viewMoreEpisodes()
                }
            }.store(in: &subscriptions)
    }
    
    func configureNavigationBar() {
        configureNavigationBar(with: .episodes.title.localized)
    }
}
