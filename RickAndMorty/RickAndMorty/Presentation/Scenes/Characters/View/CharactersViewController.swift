//
//  CharactersViewController.swift
//  RickAndMorty
//
//  Created by Miguel Ferrer Fornali on 22/1/23.
//

import UIKit
import Combine

final class CharactersViewController: UIViewController, UIGestureRecognizerDelegate {
    private let viewModel: CharactersViewModel
    private let dependencies: CharactersDependenciesResolver
    private var subscriptions: Set<AnyCancellable> = []

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
        let backItemImage = UIImage(systemName: "arrow.left")
        sceneNavigationController.navigationBar.backIndicatorImage = backItemImage
        sceneNavigationController.navigationBar.backIndicatorTransitionMaskImage = backItemImage
        sceneNavigationController.interactivePopGestureRecognizer?.delegate = self
        sceneNavigationController.interactivePopGestureRecognizer?.isEnabled = true
    }
}
