//
//  LocationsViewController.swift
//  RickAndMorty
//
//  Created by Miguel Ferrer Fornali on 23/1/23.
//

import UIKit
import Combine

final class LocationsViewController: UIViewController {
    @IBOutlet private weak var searchView: SearchView!
    @IBOutlet private weak var containerView: UIView!
    @IBOutlet private weak var collectionView: LocationsCollectionView!
    @IBOutlet private weak var collectionViewToContainerViewTopConstraint: NSLayoutConstraint!
    @IBOutlet private weak var collectionViewToSearchViewTopConstraint: NSLayoutConstraint!
    
    private let viewModel: LocationsViewModel
    private let dependencies: LocationsDependenciesResolver
    private var subscriptions: Set<AnyCancellable> = []
    private lazy var sceneNavigationController = dependencies.external.resolve()
    private lazy var imageCacheManager = dependencies.external.resolveImageCacheManager()
    
    init(dependencies: LocationsDependenciesResolver) {
        self.dependencies = dependencies
        self.viewModel = dependencies.resolve()
        super.init(nibName: String(describing: LocationsViewController.self), bundle: .main)
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
    func setupView() {
        configureSearchView()
    }
    
    func configureSearchView() {
        searchView.configure(with: .locations.searchPlaceholder.localized)
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
                case .locationsReceived(let pager):
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
                    viewModel.clearLocationsPager()
                    viewModel.locationNameFiltered = text
                    viewModel.loadLocations()
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
                case .openLocationDetail(let location):
                    viewModel.openLocationDetail(location)
                case .viewMore:
                    viewModel.loadLocations()
                }
            }.store(in: &subscriptions)
    }
    
    func configureNavigationBar() {
        configureNavigationBar(with: .locations.title.localized)
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
                viewModel.clearLocationsPager()
                viewModel.loadLocations()
            }
            showNavigationBarShadow(searchView.isHidden && collectionView.contentOffset.y > 0)
            searchView.showShadow(!searchView.isHidden && collectionView.contentOffset.y > 0)
            collectionViewToContainerViewTopConstraint.priority = UILayoutPriority(searchView.isHidden ? 1000 : 999)
            collectionViewToSearchViewTopConstraint.priority = UILayoutPriority(searchView.isHidden ? 999 : 1000)
            view.layoutIfNeeded()
        }, completion: { [weak self] finished in
            guard let self else { return }
            if finished, !searchView.isHidden { searchView.showKeyboard() }
        })
    }
}
