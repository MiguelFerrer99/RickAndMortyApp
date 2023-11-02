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
    @IBOutlet private weak var topSpacerView: UIView!
    @IBOutlet private weak var bottomSpacerView: UIView!
    
    private let viewModel: AuthorInfoViewModel
    private let dependencies: AuthorInfoDependenciesResolver
    private let sceneNavigationController: UINavigationController
    
    init(dependencies: AuthorInfoDependenciesResolver) {
        self.dependencies = dependencies
        self.viewModel = dependencies.resolve()
        self.sceneNavigationController = dependencies.external.resolve()
        super.init(nibName: String(describing: AuthorInfoViewController.self), bundle: .main)
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
        configureBackgroundViewForAppear()
    }
}

private extension AuthorInfoViewController {
    func setupView() {
        configureBackgroundView()
        configureBottomSheetView()
        configureAvatarTitleLabel()
        configureMediaImages()
    }
    
    func configureBackgroundView() {
        let gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(didTapBackgroundView))
        backgroundView.addGestureRecognizer(gestureRecognizer)
        backgroundView.isHidden = UIDevice.isIpad
    }
    
    func configureBottomSheetView() {
        topSpacerView.isHidden = !UIDevice.isIpad
        bottomSpacerView.isHidden = !UIDevice.isIpad
        bottomSheetView.layer.cornerRadius = UIDevice.isIpad ? 0 : 50
        bottomSheetView.layer.maskedCorners = UIDevice.isIpad ? [] : [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        bottomSheetBarView.layer.cornerRadius = bottomSheetBarView.frame.height / 2.0
        if !UIDevice.isIpad {
            let gestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(didMoveBottomSheetView))
            bottomSheetView.addGestureRecognizer(gestureRecognizer)
            bottomSheetView.topAnchor.constraint(greaterThanOrEqualTo: view.topAnchor).isActive = true
        } else {
            bottomSheetView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        }
        bottomSheetView.layoutIfNeeded()
    }
    
    func configureAvatarTitleLabel() {
        avatarTitleLabel.font = .systemFont(ofSize: UIDevice.isIpad ? 32 : 18, weight: .bold)
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
    
    func configureBackgroundViewForAppear() {
        UIView.animate(withDuration: 0.25) { [weak self] in
            guard let self else { return }
            backgroundView.alpha = 0.4
        }
    }
    
    func configureBackgroundViewForDisappear() {
        UIView.animate(withDuration: 0.25) { [weak self] in
            guard let self else { return }
            backgroundView.alpha = 0
            viewModel.dismiss()
        }
    }
    
    @objc func didMoveBottomSheetView(recognizer: UIPanGestureRecognizer) {
        let translation = recognizer.translation(in: view)
        let velocity = recognizer.velocity(in: view)
        switch recognizer.state {
        case .changed:
            if translation.y > 0 {
                bottomSheetView.transform = .init(translationX: 0, y: translation.y)
                if !UIDevice.isIpad {
                    let conversionFactor = (bottomSheetView.frame.height - translation.y) / bottomSheetView.frame.height
                    backgroundView.alpha = 0.4 * conversionFactor
                }
            }
        case .ended:
            if translation.y > 200 || velocity.y > 1500 {
                configureBackgroundViewForDisappear()
            } else {
                UIView.animate(withDuration: 0.25) { [weak self] in
                    guard let self else { return }
                    backgroundView.alpha = 0.4
                    bottomSheetView.transform = .init(translationX: 0, y: 0)
                }
            }
        default: break
        }
    }
    
    @objc func didTapBackgroundView() {
        configureBackgroundViewForDisappear()
    }
    
    @objc func didTapGithub() {
        viewModel.openGitHub()
    }
    
    @objc func didTapLinkedin() {
        viewModel.openLinkedIn()
    }
}
