//
//  LocationDetailViewController.swift
//  RickAndMorty
//
//  Created by Miguel Ferrer Fornali on 29/1/23.
//

import UIKit
import Combine

final class LocationDetailViewController: UIViewController {
    @IBOutlet private weak var containerStackView: UIStackView!
    
    private let viewModel: LocationDetailViewModel
    private let dependencies: LocationDetailDependenciesResolver
    private let sceneNavigationController: UINavigationController
    private var subscriptions: Set<AnyCancellable> = []
    private lazy var typeInfoView = InfoView()
    private lazy var dimensionInfoView = InfoView()
    private lazy var numberOfResidentsInfoView = InfoView()
    private lazy var spacerView = UIView()

    init(dependencies: LocationDetailDependenciesResolver) {
        self.dependencies = dependencies
        self.viewModel = dependencies.resolve()
        self.sceneNavigationController = dependencies.external.resolve()
        super.init(nibName: String(describing: LocationDetailViewController.self), bundle: .main)
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

private extension LocationDetailViewController {
    func setupViews() {
        configureContainerStackView()
    }
    
    func configureContainerStackView() {
        containerStackView.addArrangedSubview(typeInfoView)
        containerStackView.addArrangedSubview(dimensionInfoView)
        containerStackView.addArrangedSubview(numberOfResidentsInfoView)
        containerStackView.addArrangedSubview(spacerView)
    }
    
    func bind() {
        bindViewModel()
    }
    
    func bindViewModel() {
        viewModel.state
            .sink { [weak self] state in
                guard let self else { return }
                switch state {
                case .locationReceived(let info): setInfo(info)
                case .idle: return
                }
            }.store(in: &subscriptions)
    }
    
    func setInfo(_ info: LocationDetailRepresentable) {
        configureNavigationBar(with: info.name)
        typeInfoView.configure(title: .locationDetail.type.localized, description: info.type)
        dimensionInfoView.configure(title: .locationDetail.dimension.localized, description: info.dimension)
        numberOfResidentsInfoView.configure(title: .locationDetail.numberOfResidents.localized, description: "\(info.numberOfResidents)")
    }
    
    func configureNavigationBar() {
        navigationItem.leftBarButtonItem = BarButtonItem(image: UIImage(systemName: "arrow.left"), style: .plain, target: self, action: #selector(didTapBackButton))
    }
    
    @objc func didTapBackButton() {
        viewModel.goBack()
    }
}
