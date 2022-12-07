//
//  AuthorInfoViewController.swift
//  RickAndMorty
//
//  Created by Miguel Ferrer Fornali on 7/12/22.
//

import UIKit

final class AuthorInfoViewController: UIViewController {
    @IBOutlet private weak var bottomSheetView: UIView!
    @IBOutlet private weak var infoStackView: UIStackView!
    @IBOutlet private weak var bottomSheetBarView: UIView!
    @IBOutlet private weak var avatarTitleLabel: UILabel!
    @IBOutlet private weak var githubImageView: UIImageView!
    @IBOutlet private weak var linkedinImageView: UIImageView!
    
    private let viewModel: AuthorInfoViewModel
    private let dependencies: AuthorInfoDependenciesResolver

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
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        configureNavigationBar()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        guard let screen = view.window?.windowScene?.screen else { return }
        self.view.frame = CGRect(x: 0, y: screen.bounds.height / 1.8, width: screen.bounds.width, height: screen.bounds.height / 2.2)
    }
}

private extension AuthorInfoViewController {
    var sceneNavigationController: UINavigationController {
        dependencies.external.resolve()
    }
    
    func setupView() {
        configureBottomSheetView()
        configureAvatarTitleLabel()
        configureMediaImages()
    }
    
    func configureBottomSheetView() {
        bottomSheetView.clipsToBounds = true
        bottomSheetView.layer.cornerRadius = 50
        bottomSheetView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        bottomSheetBarView.layer.cornerRadius = bottomSheetBarView.frame.height / 2.0
    }
    
    func configureAvatarTitleLabel() {
        avatarTitleLabel.font = .systemFont(ofSize: 18, weight: .bold)
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
    
    func configureNavigationBar() {
        sceneNavigationController.setNavigationBarHidden(true, animated: false)
    }
    
    @objc func didTapBackgroundView() {
        viewModel.dismiss()
    }
    
    @objc func didTapGithub() {
        viewModel.openGitHub()
    }
    
    @objc func didTapLinkedin() {
        viewModel.openLinkedIn()
    }
}
