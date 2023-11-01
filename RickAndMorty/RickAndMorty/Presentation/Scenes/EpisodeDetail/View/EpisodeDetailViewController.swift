//
//  EpisodeDetailViewController.swift
//  RickAndMorty
//
//  Created by Miguel Ferrer Fornali on 30/1/23.
//

import UIKit
import Combine

final class EpisodeDetailViewController: UIViewController {
    @IBOutlet private weak var containerStackView: UIStackView!
    
    private let viewModel: EpisodeDetailViewModel
    private let dependencies: EpisodeDetailDependenciesResolver
    private var subscriptions: Set<AnyCancellable> = []
    private let airDateInfoView = InfoView()
    private let seasonInfoView = InfoView()
    private let episodeInfoView = InfoView()
    private let numberOfCharactersInfoView = InfoView()
    private let spacerView = UIView()
    private lazy var sceneNavigationController = dependencies.external.resolve()

    init(dependencies: EpisodeDetailDependenciesResolver) {
        self.dependencies = dependencies
        self.viewModel = dependencies.resolve()
        super.init(nibName: String(describing: EpisodeDetailViewController.self), bundle: .main)
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

private extension EpisodeDetailViewController {
    func setupViews() {
        configureContainerStackView()
    }
    
    func configureContainerStackView() {
        containerStackView.addArrangedSubview(airDateInfoView)
        containerStackView.addArrangedSubview(seasonInfoView)
        containerStackView.addArrangedSubview(episodeInfoView)
        containerStackView.addArrangedSubview(numberOfCharactersInfoView)
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
                case .episodeReceived(let info): setInfo(info)
                case .idle: return
                }
            }.store(in: &subscriptions)
    }
    
    func setInfo(_ info: EpisodeDetailRepresentable) {
        configureNavigationBar(with: info.name)
        airDateInfoView.configure(title: .episodeDetail.airDate.localized, description: info.airDate.toString(dateFormat: "EEEE, MMM d, yyyy"))
        seasonInfoView.configure(title: .episodeDetail.season.localized, description: "\(info.season)")
        episodeInfoView.configure(title: .episodeDetail.episode.localized, description: "\(info.episode)")
        numberOfCharactersInfoView.configure(title: .episodeDetail.numberOfCharacters.localized, description: "\(info.numberOfCharacters)")
        
    }
    
    func configureNavigationBar() {
        navigationItem.leftBarButtonItem = BarButtonItem(image: UIImage(systemName: "arrow.left"), style: .plain, target: self, action: #selector(didTapBackButton))
    }
    
    @objc func didTapBackButton() {
        viewModel.goBack()
    }
}
