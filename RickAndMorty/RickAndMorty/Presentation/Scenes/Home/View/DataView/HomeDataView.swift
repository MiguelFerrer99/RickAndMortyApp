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
    @IBOutlet private weak var titleView: UIView!
    @IBOutlet private weak var topImageView: UIImageView!
    @IBOutlet private weak var topImageViewDefaultHeightConstraint: NSLayoutConstraint!
    @IBOutlet private weak var topImageViewDefaultWidthConstraint: NSLayoutConstraint!
    @IBOutlet private weak var topImageViewReceivedDataHeightConstraint: NSLayoutConstraint!
    @IBOutlet private weak var topImageViewReceivedWidthConstraint: NSLayoutConstraint!
    @IBOutlet private weak var collectionView: HomeDataCollectionView!
    
    private var subscriptions = Set<AnyCancellable>()
    private var subject = PassthroughSubject<HomeDataViewState, Never>()
    var publisher: AnyPublisher<HomeDataViewState, Never> { subject.eraseToAnyPublisher() }
    
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
    
    func receivedData() {
        moveImageToTop()
    }
}

private extension HomeDataView {
    func setupView() {
        // Configure view
    }
    
    func bind() {
        // Bind states
    }
    
    func moveImageToTop() {
        UIView.animate(withDuration: 0.7, delay: 0, usingSpringWithDamping: 20, initialSpringVelocity: 5) { [weak self] in
            guard let self = self else { return }
            self.topImageViewDefaultHeightConstraint.priority = UILayoutPriority(999)
            self.topImageViewDefaultWidthConstraint.priority = UILayoutPriority(999)
            self.topImageViewReceivedDataHeightConstraint.priority = UILayoutPriority(1000)
            self.topImageViewReceivedWidthConstraint.priority = UILayoutPriority(1000)
            self.layoutIfNeeded()
        } completion: { [weak self] finished in
            guard let self = self else { return }
            if finished {
                self.configureTitleViewImage()
                self.showCollecionView()
            }
        }
    }
    
    func configureTitleViewImage() {
        topImageView.isUserInteractionEnabled = true
        let gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(didTapTopImage))
        topImageView.addGestureRecognizer(gestureRecognizer)
    }
    
    func showCollecionView() {
        UIView.animate(withDuration: 0.3, delay: 0) { [weak self] in
            guard let self = self else { return }
            self.collectionView.alpha = 1
        } completion: { [weak self] finished in
            guard let self = self else { return }
            self.collectionView.isUserInteractionEnabled = true
        }
    }
    
    @objc func didTapTopImage() {
        subject.send(.didTapTitleImage)
    }
}
