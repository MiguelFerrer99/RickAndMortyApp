//
//  CharacterDetailViewController.swift
//  RickAndMorty
//
//  Created by Miguel Ferrer Fornali on 30/1/23.
//

import UIKit
import Combine

final class CharacterDetailViewController: UIViewController {
    @IBOutlet private weak var scrollView: UIScrollView!
    @IBOutlet private weak var imageView: UIImageView!
    @IBOutlet private weak var infoStackView: UIStackView!
    @IBOutlet private weak var titleLabel: UILabel!
    
    private let viewModel: CharacterDetailViewModel
    private let dependencies: CharacterDetailDependenciesResolver
    private var subscriptions: Set<AnyCancellable> = []
    private let statusInfoView = InfoView()
    private let speciesInfoView = InfoView()
    private let genderInfoView = InfoView()
    private let originInfoView = InfoView()
    private let locationInfoView = InfoView()
    private let numberOfEpisodesInfoView = InfoView()
    private lazy var sceneNavigationController = dependencies.external.resolve()
    private lazy var imageCacheManager = dependencies.external.resolveImageCacheManager()

    init(dependencies: CharacterDetailDependenciesResolver) {
        self.dependencies = dependencies
        self.viewModel = dependencies.resolve()
        super.init(nibName: String(describing: CharacterDetailViewController.self), bundle: .main)
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

private extension CharacterDetailViewController {
    func setupViews() {
        configureScrollView()
        configureInfoStackView()
        configureTitleLabel()
    }
    
    func configureScrollView() {
        scrollView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 30, right: 0)
    }
    
    func configureInfoStackView() {
        infoStackView.addArrangedSubview(statusInfoView)
        infoStackView.addArrangedSubview(speciesInfoView)
        infoStackView.addArrangedSubview(genderInfoView)
        infoStackView.addArrangedSubview(originInfoView)
        infoStackView.addArrangedSubview(locationInfoView)
        infoStackView.addArrangedSubview(numberOfEpisodesInfoView)
    }
    
    func configureTitleLabel() {
        titleLabel.font = .systemFont(ofSize: UIDevice.isIpad ? 50 : 30, weight: .bold)
    }
    
    func bind() {
        bindViewModel()
    }
    
    func bindViewModel() {
        viewModel.state
            .sink { [weak self] state in
                guard let self else { return }
                switch state {
                case .characterReceived(let info): setInfo(info)
                case .idle: return
                }
            }.store(in: &subscriptions)
    }
    
    func configureNavigationBar() {
        configureNavigationBar(with: "", transparent: true)
        navigationItem.leftBarButtonItem = BarButtonItem(image: UIImage(systemName: "arrow.left"), style: .plain, target: self, action: #selector(didTapBackButton))
    }
    
    func setInfo(_ info: CharacterDetailRepresentable) {
        fillCharactersImageView(with: info.image)
        titleLabel.text = info.name
        statusInfoView.configure(title: .characterDetail.status.localized, description: info.status.getText())
        speciesInfoView.configure(title: .characterDetail.species.localized, description: info.species)
        genderInfoView.configure(title: .characterDetail.gender.localized, description: info.gender.getText())
        originInfoView.configure(title: .characterDetail.origin.localized, description: info.origin.name, style: .secondary)
        locationInfoView.configure(title: .characterDetail.location.localized, description: info.location.name, style: .secondary)
        numberOfEpisodesInfoView.configure(title: .characterDetail.numberOfEpisodes.localized, description: "\(info.numberOfEpisodes)", style: .secondary)
    }
    
    func fillCharactersImageView(with image: String) {
        if let uiImage = imageCacheManager.get(name: image) {
            imageView.image = uiImage
        } else if let url = URL(string: image) {
            imageView.load(url: url) { [weak self] in
                guard let self else { return }
                imageCacheManager.add(image: $0, name: image)
                imageView.image = $0
            }
        }
    }
    
    @objc func didTapBackButton() {
        viewModel.goBack()
    }
}
