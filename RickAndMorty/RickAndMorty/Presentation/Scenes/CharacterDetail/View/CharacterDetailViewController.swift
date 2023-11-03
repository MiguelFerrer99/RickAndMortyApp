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
    @IBOutlet private weak var closeImageView: UIImageView!
    
    private let viewModel: CharacterDetailViewModel
    private let dependencies: CharacterDetailDependenciesResolver
    private let sceneNavigationController: UINavigationController
    private let imageCacheManager: ImageCacheManager
    private var subscriptions: Set<AnyCancellable> = []
    private lazy var statusInfoView = InfoView()
    private lazy var speciesInfoView = InfoView()
    private lazy var genderInfoView = InfoView()
    private lazy var originInfoView = InfoView()
    private lazy var locationInfoView = InfoView()
    private lazy var numberOfEpisodesInfoView = InfoView()
    
    init(dependencies: CharacterDetailDependenciesResolver, info: CharacterDetailRepresentable) {
        self.dependencies = dependencies
        self.viewModel = dependencies.resolve(with: info)
        self.sceneNavigationController = dependencies.external.resolve()
        self.imageCacheManager = dependencies.external.resolve()
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
        configureCloseImageView()
        configureScrollView()
        configureInfoStackView()
        configureTitleLabel()
    }
    
    func configureCloseImageView() {
        let gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(didTapCloseImageView))
        closeImageView.addGestureRecognizer(gestureRecognizer)
        closeImageView.isUserInteractionEnabled = true
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
        configureNavigationBar(with: "", hidden: true)
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
    
    @objc func didTapCloseImageView() {
        viewModel.dismiss()
    }
}
