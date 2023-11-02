//
//  EpisodesViewController.swift
//  RickAndMorty
//
//  Created by Miguel Ferrer Fornali on 23/1/23.
//

import UIKit
import Combine

final class EpisodesViewController: UIViewController {
    @IBOutlet private weak var searchView: SearchView!
    @IBOutlet private weak var containerView: UIView!
    @IBOutlet private weak var collectionView: EpisodesCollectionView!
    @IBOutlet private weak var collectionViewToContainerViewTopConstraint: NSLayoutConstraint!
    @IBOutlet private weak var collectionViewToSearchViewTopConstraint: NSLayoutConstraint!
    
    private let viewModel: EpisodesViewModel
    private let dependencies: EpisodesDependenciesResolver
    private let sceneNavigationController: UINavigationController
    private let imageCacheManager: ImageCacheManager
    private var subscriptions: Set<AnyCancellable> = []

    init(dependencies: EpisodesDependenciesResolver) {
        self.dependencies = dependencies
        self.viewModel = dependencies.resolve()
        self.sceneNavigationController = dependencies.external.resolve()
        self.imageCacheManager = dependencies.external.resolveImageCacheManager()
        super.init(nibName: String(describing: EpisodesViewController.self), bundle: .main)
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
    func setupView() {
        configureSearchView()
    }
    
    func configureSearchView() {
        searchView.configure(with: .episodes.searchPlaceholder.localized)
    }
    
    func bind() {
        bindViewModel()
        bindSearchView()
        bindCollectionView()
    }
    
    func bindViewModel() {
        viewModel.state
            .sink { state in
                switch state {
                case .episodesReceived(let pager):
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.05) { [weak self] in
                        guard let self else { return }
                        collectionView.configure(with: pager, and: imageCacheManager)
                        if pager.currentPage == 1 { collectionView.scrollToTop() }
                    }
                case .idle: return
                }
            }.store(in: &subscriptions)
    }
    
    func bindSearchView() {
        searchView.publisher
            .sink { [weak self] state in
                guard let self else { return }
                switch state {
                case .searched(let text):
                    collectionView.showLoader()
                    viewModel.clearEpisodesPager()
                    viewModel.episodeNameFiltered = text
                    viewModel.loadEpisodes()
                }
            }.store(in: &subscriptions)
    }
    
    func bindCollectionView() {
        collectionView.publisher
            .sink { [weak self] state in
                guard let self else { return }
                switch state {
                case .showNavigationBarShadow(let show):
                    searchView.isHidden ? showNavigationBarShadow(show) : searchView.showShadow(show)
                case .openEpisodeDetail(let episode):
                    viewModel.openEpisodeDetail(episode)
                case .viewMore:
                    viewModel.loadEpisodes()
                }
            }.store(in: &subscriptions)
    }
    
    func configureNavigationBar() {
        configureNavigationBar(with: .episodes.title.localized)
        setupNavigationBarShadow()
        updateRightNavigationBarButton()
        navigationItem.leftBarButtonItem = BarButtonItem(image: UIImage(systemName: "arrow.left"), style: .plain, target: self, action: #selector(didTapBackButton))
    }
    
    func setupNavigationBarShadow() {
        sceneNavigationController.navigationBar.clipsToBounds = false
        sceneNavigationController.navigationBar.layer.masksToBounds = false
        sceneNavigationController.navigationBar.layer.shadowRadius = UIDevice.isIpad ? 10 : 5
        sceneNavigationController.navigationBar.layer.shadowOpacity = 0
        sceneNavigationController.navigationBar.layer.shadowColor = UIColor.black.cgColor
        sceneNavigationController.navigationBar.layer.shadowOffset = CGSize(width: 0, height: UIDevice.isIpad ? 5 : 3)
        showNavigationBarShadow(collectionView.contentOffset.y > 0)
    }
    
    func showNavigationBarShadow(_ show: Bool) {
        UIView.animate(withDuration: 0.2, delay: 0) { [weak self] in
            guard let self else { return }
            sceneNavigationController.navigationBar.layer.shadowOpacity = show ? 1 : 0
        }
    }
    
    func updateRightNavigationBarButton() {
        if searchView.isHidden {
            searchView.close()
            navigationItem.rightBarButtonItem = BarButtonItem(image: UIImage(systemName: "magnifyingglass"), style: .plain, target: self, action: #selector(didTapRightNavigationBarButton))
        } else {
            navigationItem.rightBarButtonItem = BarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(didTapRightNavigationBarButton))
        }
    }
    
    @objc func didTapBackButton() {
        viewModel.goBack()
    }
    
    @objc func didTapRightNavigationBarButton() {
        UIView.animate(withDuration: 0.2, delay: 0, options: .curveLinear, animations: { [weak self] in
            guard let self else { return }
            searchView.isHidden.toggle()
            updateRightNavigationBarButton()
            if searchView.isHidden {
                viewModel.clearEpisodesPager()
                viewModel.loadEpisodes()
            }
            showNavigationBarShadow(searchView.isHidden && collectionView.contentOffset.y > 0)
            searchView.showShadow(!searchView.isHidden && collectionView.contentOffset.y > 0)
            collectionViewToContainerViewTopConstraint.priority = searchView.isHidden ? .required : .defaultHigh
            collectionViewToSearchViewTopConstraint.priority = searchView.isHidden ? .defaultHigh : .required
            view.layoutIfNeeded()
        }, completion: { [weak self] finished in
            guard let self else { return }
            if finished, !searchView.isHidden { searchView.showKeyboard() }
        })
    }
}
