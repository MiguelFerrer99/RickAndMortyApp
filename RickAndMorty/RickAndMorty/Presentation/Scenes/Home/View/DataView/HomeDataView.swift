//
//  HomeDataView.swift
//  RickAndMorty
//
//  Created by Miguel Ferrer Fornali on 5/12/22.
//

import UIKit
import Combine

enum HomeDataViewState {
    case didTapTitleImage
}

final class HomeDataView: XibView {
    @IBOutlet private weak var topImageView: UIImageView!
    @IBOutlet private weak var topImageViewHeightConstraint: NSLayoutConstraint!
    
    private var subscriptions = Set<AnyCancellable>()
    private var subject = PassthroughSubject<HomeDataViewState, Never>()
    var publisher: AnyPublisher<HomeDataViewState, Never> {
        subject.eraseToAnyPublisher()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
        bind()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupView()
        bind()
    }
}

private extension HomeDataView {
    func setupView() {
        moveImageToCenter()
        moveImageToTop()
    }
    
    func moveImageToCenter() {
        topImageViewHeightConstraint.constant = frame.height
        layoutIfNeeded()
    }
    
    func moveImageToTop() {
        UIView.animate(withDuration: 1.0) { [weak self] in
            guard let self = self else { return }
            self.topImageViewHeightConstraint.constant = 60
            self.layoutIfNeeded()
        } completion: { [weak self] finished in
            guard let self = self else { return }
            if finished { self.configureImage() }
        }
    }
    
    func bind() {
        // Bind collection view states
    }
    
    func configureImage() {
        topImageView.isUserInteractionEnabled = true
        let gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(didTapTopImage))
        topImageView.addGestureRecognizer(gestureRecognizer)
    }
    
    @objc func didTapTopImage() {
        subject.send(.didTapTitleImage)
    }
}
