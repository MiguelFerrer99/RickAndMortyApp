//
//  CharactersViewController.swift
//  RickAndMorty
//
//  Created by Miguel Ferrer Fornali on 22/1/23.
//

import UIKit
import Combine
import Foundation

final class CharactersViewController: UIViewController {
    @IBOutlet private weak var searchView: SearchView!
    @IBOutlet private weak var collectionView: CharactersCollectionView!
    @IBOutlet private weak var collectionViewToContainerViewTopConstraint: NSLayoutConstraint!
    @IBOutlet private weak var collectionViewToSearchViewTopConstraint: NSLayoutConstraint!
    private let viewModel: CharactersViewModel
    private let dependencies: CharactersDependenciesResolver
    private var subscriptions: Set<AnyCancellable> = []
    private let iPadDevice = UIDevice.current.userInterfaceIdiom == .pad

    init(dependencies: CharactersDependenciesResolver) {
        self.dependencies = dependencies
        self.viewModel = dependencies.resolve()
        super.init(nibName: "CharactersViewController", bundle: .main)
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

private extension CharactersViewController {
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
        searchView.configure(with: .characters.searchPlaceholder.localized)
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
                case .charactersReceived(let pager):
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.05) { [weak self] in
                        guard let self = self else { return }
                        self.collectionView.configure(with: pager, and: self.imageCacheManager)
                        if pager.currentPage == 1 { self.collectionView.scrollToTop() }
                    }
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
                    self.collectionView.showLoader()
                    self.viewModel.clearCharactersPager()
                    self.viewModel.characterNameFiltered = text
                    self.viewModel.loadCharaters()
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
                    self.viewModel.loadCharaters()
                }
            }.store(in: &subscriptions)
    }
    
    func configureNavigationBar() {
        configureNavigationBar(with: .characters.title.localized)
        setupNavigationBarShadow()
        updateRightNavigationBarButton()
        navigationItem.leftBarButtonItem = BarButtonItem(image: UIImage(systemName: "arrow.left"), style: .plain, target: self, action: #selector(didTapBackButton))
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
            guard let self = self else { return }
            self.searchView.isHidden.toggle()
            self.updateRightNavigationBarButton()
            if self.searchView.isHidden {
                self.viewModel.clearCharactersPager()
                self.viewModel.loadCharaters()
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
