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
    private let iPadDevice = UIDevice.current.userInterfaceIdiom == .pad
    
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
        backgroundView.isHidden = iPadDevice
    }
    
    func configureBottomSheetView() {
        topSpacerView.isHidden = !iPadDevice
        bottomSpacerView.isHidden = !iPadDevice
        bottomSheetView.layer.cornerRadius = iPadDevice ? 0 : 50
        bottomSheetView.layer.maskedCorners = iPadDevice ? [] : [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        bottomSheetBarView.layer.cornerRadius = bottomSheetBarView.frame.height / 2.0
        if !iPadDevice {
            let gestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(didMoveBottomSheetView))
            bottomSheetView.addGestureRecognizer(gestureRecognizer)
            bottomSheetView.topAnchor.constraint(greaterThanOrEqualTo: view.topAnchor).isActive = true
        } else {
            bottomSheetView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        }
        bottomSheetView.layoutIfNeeded()
    }
    
    func configureAvatarTitleLabel() {
        avatarTitleLabel.font = .systemFont(ofSize: iPadDevice ? 32 : 18, weight: .bold)
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
            guard let self = self else { return }
            self.backgroundView.alpha = 0.4
        }
    }
    
    func configureBackgroundViewForDisappear() {
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
                if !iPadDevice {
                    let conversionFactor = (bottomSheetView.frame.height - translation.y) / bottomSheetView.frame.height
                    backgroundView.alpha = 0.4 * conversionFactor
                }
            }
        case .ended:
            if translation.y > 200 || velocity.y > 1500 {
                configureBackgroundViewForDisappear()
            } else {
                UIView.animate(withDuration: 0.25) { [weak self] in
                    guard let self = self else { return }
                    self.backgroundView.alpha = 0.4
                    self.bottomSheetView.transform = .init(translationX: 0, y: 0)
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
