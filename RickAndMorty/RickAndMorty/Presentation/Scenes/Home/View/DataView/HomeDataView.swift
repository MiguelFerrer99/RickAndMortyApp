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
    case viewAll(HomeDataCategory)
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
    private let iPadDevice = UIDevice.current.userInterfaceIdiom == .pad
    
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
    
    func receivedData(_ categories: [HomeDataCategory]) {
        collectionView.configure(with: categories)
        moveImageToTop()
    }
}

private extension HomeDataView {
    func setupView() {
        configureTitleView()
    }
    
    func configureTitleView() {
        titleView.layer.masksToBounds = false
        titleView.layer.shadowRadius = iPadDevice ? 10 : 5
        titleView.layer.shadowOpacity = 0
        titleView.layer.shadowColor = UIColor.black.cgColor
        titleView.layer.shadowOffset = CGSize(width: 0, height: iPadDevice ? 5 : 2)
    }
    
    func bind() {
        bindCollectionView()
    }
    
    func bindCollectionView() {
        collectionView.publisher
            .sink { [weak self] state in
                guard let self = self else { return }
                switch state {
                case .viewAll(let category):
                    self.subject.send(.viewAll(category))
                case .showTitleViewShadow:
                    self.showTitleViewShadow()
                case .hideTitleViewShadow:
                    self.hideTitleViewShadow()
                }
            }.store(in: &subscriptions)
    }
    
    func showTitleViewShadow() {
        UIView.animate(withDuration: 0.2, delay: 0) { [weak self] in
            guard let self = self else { return }
            self.titleView.layer.shadowOpacity = 1
        }
    }
    
    func hideTitleViewShadow() {
        UIView.animate(withDuration: 0.2, delay: 0) { [weak self] in
            guard let self = self else { return }
            self.titleView.layer.shadowOpacity = 0
        }
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
