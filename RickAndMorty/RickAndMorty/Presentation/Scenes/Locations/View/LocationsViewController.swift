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
    private let iPadDevice = UIDevice.current.userInterfaceIdiom == .pad

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
    
    var imageCacheManager: ImageCacheManager {
        dependencies.external.resolveImageCacheManager()
    }
    
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
            .sink { [weak self] state in
                guard let self = self else { return }
                switch state {
                case .locationsReceived(let pager):
                    self.collectionView.configure(with: pager, and: self.imageCacheManager)
                    if pager.currentPage == 1 { self.collectionView.scrollToTop() }
                case .idle: return
                }
            }.store(in: &subscriptions)
    }
    
    func bindSearchView() {
        searchView.publisher
            .sink { [weak self] state in
                guard let self = self else { return }
                switch state {
                case .searched(let text):
                    self.viewModel.clearFilteredLocationsPager()
                    self.viewModel.locationNameFiltered = text
                    self.viewModel.loadLocations()
                }
            }.store(in: &subscriptions)
    }
    
    func bindCollectionView() {
        collectionView.publisher
            .sink { [weak self] state in
                guard let self = self else { return }
                switch state {
                case .showNavigationBarShadow(let show):
                    self.searchView.isHidden ? self.showNavigationBarShadow(show) : self.searchView.showShadow(show)
                case .viewMore:
                    self.viewModel.loadLocations()
                }
            }.store(in: &subscriptions)
    }
    
    func configureNavigationBar() {
        configureNavigationBar(with: .locations.title.localized)
        setupNavigationBarShadow()
        updateRightNavigationBarButton()
        navigationItem.leftBarButtonItem = BackBarButtonItem(image: UIImage(systemName: "arrow.left"), style: .plain, target: self, action: #selector(didTapBackButton))
    }
    
    func setupNavigationBarShadow() {
        sceneNavigationController.navigationBar.clipsToBounds = false
        sceneNavigationController.navigationBar.layer.masksToBounds = false
        sceneNavigationController.navigationBar.layer.shadowRadius = iPadDevice ? 10 : 5
        sceneNavigationController.navigationBar.layer.shadowOpacity = 0
        sceneNavigationController.navigationBar.layer.shadowColor = UIColor.black.cgColor
        sceneNavigationController.navigationBar.layer.shadowOffset = CGSize(width: 0, height: iPadDevice ? 5 : 3)
    }
    
    func showNavigationBarShadow(_ show: Bool) {
        UIView.animate(withDuration: 0.2, delay: 0) { [weak self] in
            guard let self = self else { return }
            self.sceneNavigationController.navigationBar.layer.shadowOpacity = show ? 1 : 0
        }
    }
    
    func updateRightNavigationBarButton() {
        if searchView.isHidden {
            searchView.close()
            navigationItem.rightBarButtonItem = BackBarButtonItem(image: UIImage(systemName: "magnifyingglass"), style: .plain, target: self, action: #selector(didTapRightNavigationBarButton))
        } else {
            navigationItem.rightBarButtonItem = BackBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(didTapRightNavigationBarButton))
        }
    }
    
    @objc func didTapBackButton() {
        viewModel.goBack()
    }
    
    @objc func didTapRightNavigationBarButton() {
        UIView.animate(withDuration: 0.2, delay: 0, options: .curveLinear, animations: { [weak self] in
            guard let self = self else { return }
            self.searchView.isHidden.toggle()
            self.updateRightNavigationBarButton()
            if self.searchView.isHidden {
                self.viewModel.clearFilteredLocationsPager()
                self.viewModel.loadLocations()
            }
            self.showNavigationBarShadow(self.searchView.isHidden && self.collectionView.contentOffset.y > 0)
            self.searchView.showShadow(!self.searchView.isHidden && self.collectionView.contentOffset.y > 0)
            self.collectionViewToContainerViewTopConstraint.priority = UILayoutPriority(self.searchView.isHidden ? 1000 : 999)
            self.collectionViewToSearchViewTopConstraint.priority = UILayoutPriority(self.searchView.isHidden ? 999 : 1000)
            self.view.layoutIfNeeded()
        }, completion: { [weak self] finished in
            guard let self = self else { return }
            if finished, !self.searchView.isHidden { self.searchView.showKeyboard() }
        })
    }
}
