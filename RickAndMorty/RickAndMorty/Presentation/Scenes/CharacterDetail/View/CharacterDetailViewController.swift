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
    @IBOutlet private weak var characterImageView: UIImageView!
    @IBOutlet private weak var infoStackView: UIStackView!
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var dashedLineView1: DashedLineView!
    @IBOutlet private weak var statusInfoView: InfoView!
    @IBOutlet private weak var speciesInfoView: InfoView!
    @IBOutlet private weak var genderInfoView: InfoView!
    @IBOutlet private weak var dashedLineView2: DashedLineView!
    @IBOutlet private weak var originInfoView: InfoView!
    @IBOutlet private weak var locationInfoView: InfoView!
    @IBOutlet private weak var dashedLineView3: DashedLineView!
    @IBOutlet private weak var numberOfEpisodesInfoView: InfoView!
    private let viewModel: CharacterDetailViewModel
    private let dependencies: CharacterDetailDependenciesResolver
    private var subscriptions: Set<AnyCancellable> = []
    private let iPadDevice = UIDevice.current.userInterfaceIdiom == .pad

    init(dependencies: CharacterDetailDependenciesResolver) {
        self.dependencies = dependencies
        self.viewModel = dependencies.resolve()
        super.init(nibName: "CharacterDetailViewController", bundle: .main)
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
    var sceneNavigationController: UINavigationController {
        dependencies.external.resolve()
    }
    
    var imageCacheManager: ImageCacheManager {
        dependencies.external.resolveImageCacheManager()
    }
    
    func setupViews() {
        configureScrollView()
        configureTitleLabel()
    }
    
    func configureScrollView() {
        scrollView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 30, right: 0)
    }
    
    func configureTitleLabel() {
        titleLabel.font = .systemFont(ofSize: iPadDevice ? 50 : 30, weight: .bold)
    }
    
    func bind() {
        bindViewModel()
    }
    
    func bindViewModel() {
        viewModel.state
            .sink { [weak self] state in
                guard let self = self else { return }
                switch state {
                case .characterReceived(let info):
                    self.setInfo(info)
                case .idle: return
                }
            }.store(in: &subscriptions)
    }
    
    func configureNavigationBar() {
        configureNavigationBar(with: "")
        sceneNavigationController.setNavigationBarHidden(true, animated: true)
        navigationItem.leftBarButtonItem = BarButtonItem(image: UIImage(systemName: "arrow.left"), style: .plain, target: self, action: #selector(didTapBackButton))
    }
    
    func setInfo(_ info: CharacterDetailRepresentable) {
        configureNavigationBar(with: info.name)
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
            characterImageView.image = uiImage
        } else if let url = URL(string: image) {
            characterImageView.load(url: url) { [weak self] in
                guard let self = self else { return }
                self.imageCacheManager.add(image: $0, name: image)
                self.characterImageView.image = $0
            }
        }
    }
    
    @objc func didTapBackButton() {
        viewModel.goBack()
    }
}
