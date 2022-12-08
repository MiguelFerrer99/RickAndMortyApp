//
//  AuthorInfoViewController.swift
//  RickAndMorty
//
//  Created by Miguel Ferrer Fornali on 7/12/22.
//

import UIKit
import Combine

final class AuthorInfoViewController: UIViewController {
    @IBOutlet private weak var backgroundView: UIView!
    @IBOutlet private weak var bottomSheetView: UIView!
    @IBOutlet private weak var infoStackView: UIStackView!
    @IBOutlet private weak var bottomSheetBarView: UIView!
    @IBOutlet private weak var avatarTitleLabel: UILabel!
    @IBOutlet private weak var githubImageView: UIImageView!
    @IBOutlet private weak var linkedinImageView: UIImageView!
    
    private let viewModel: AuthorInfoViewModel
    private let dependencies: AuthorInfoDependenciesResolver
    private var subscriptions: Set<AnyCancellable> = []

    init(dependencies: AuthorInfoDependenciesResolver) {
        self.dependencies = dependencies
        self.viewModel = dependencies.resolve()
        super.init(nibName: "AuthorInfoViewController", bundle: .main)
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
        configureBackgroundViewForAppear()
    }
}

private extension AuthorInfoViewController {
    var sceneNavigationController: UINavigationController {
        dependencies.external.resolve()
    }
    
    func setupView() {
        configureBackgroundView()
        configureBottomSheetView()
        configureAvatarTitleLabel()
        configureMediaImages()
    }
    
    func configureBackgroundView() {
        let gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(didTapBackgroundView))
        backgroundView.addGestureRecognizer(gestureRecognizer)
    }
    
    func configureBottomSheetView() {
        bottomSheetView.clipsToBounds = true
        bottomSheetView.layer.cornerRadius = 50
        bottomSheetView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        let gestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(didMoveBottomSheetView))
        bottomSheetView.addGestureRecognizer(gestureRecognizer)
        bottomSheetBarView.layer.cornerRadius = bottomSheetBarView.frame.height / 2.0
    }
    
    func configureAvatarTitleLabel() {
        avatarTitleLabel.font = .systemFont(ofSize: 16, weight: .bold)
        avatarTitleLabel.text = .authorInfo.name.localized
    }
    
    func configureMediaImages() {
        configureGithubMediaImage()
        configureLinkedinMediaImage()
    }
    
    func configureGithubMediaImage() {
        githubImageView.isUserInteractionEnabled = true
        let githubGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(didTapGithub))
        githubImageView.addGestureRecognizer(githubGestureRecognizer)
    }
    
    func configureLinkedinMediaImage() {
        linkedinImageView.isUserInteractionEnabled = true
        let linkedinGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(didTapLinkedin))
        linkedinImageView.addGestureRecognizer(linkedinGestureRecognizer)
    }
    
    func bind() {
        bindViewModel()
    }
    
    func bindViewModel() {
        viewModel.state
            .sink { [weak self] state in
                guard let self = self else { return }
                switch state {
                case .receivedData(let representable):
                    self.configureViewControllerView(with: representable.iPad)
                default: break
                }
            }.store(in: &subscriptions)
    }
    
    func configureViewControllerView(with iPad: Bool) {
        if iPad {
            // Configure views to show only BottomSheetView
        }
    }
    
    
    func configureNavigationBar() {
        sceneNavigationController.setNavigationBarHidden(true, animated: false)
    }
    
    func configureBackgroundViewForAppear() {
        UIView.animate(withDuration: 0.25) { [weak self] in
            guard let self = self else { return }
            self.backgroundView.alpha = 0.4
        }
    }
    
    func dismiss() {
        UIView.animate(withDuration: 0.25) { [weak self] in
            guard let self = self else { return }
            self.backgroundView.alpha = 0
            self.viewModel.dismiss()
        }
    }
    
    @objc func didMoveBottomSheetView(recognizer: UIPanGestureRecognizer) {
        let translation = recognizer.translation(in: view)
        let velocity = recognizer.velocity(in: view)
        switch recognizer.state {
        case .changed:
            if translation.y > 0 {
                bottomSheetView.transform = .init(translationX: 0, y: translation.y)
            }
        case .ended:
            if translation.y > 100 || velocity.y > 1500 {
                dismiss()
            } else {
                UIView.animate(withDuration: 0.25) { [weak self] in
                    guard let self = self else { return }
                    self.bottomSheetView.transform = .init(translationX: 0, y: 0)
                }
            }
        default: break
        }
    }
    
    @objc func didTapBackgroundView() {
        dismiss()
    }
    
    @objc func didTapGithub() {
        viewModel.openGitHub()
    }
    
    @objc func didTapLinkedin() {
        viewModel.openLinkedIn()
    }
}
