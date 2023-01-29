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
    case openLocation(LocationRepresentable)
    case viewMore(HomeDataCategory)
}

final class HomeDataView: XibView {
    @IBOutlet private weak var titleView: UIView!
    @IBOutlet private weak var topImageView: UIImageView!
    @IBOutlet private weak var titleViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet private weak var titleViewDefaultBottomConstraint: NSLayoutConstraint!
    @IBOutlet private weak var topImageViewDefaultWidthConstraint: NSLayoutConstraint!
    @IBOutlet private weak var topImageViewWidthConstraint: NSLayoutConstraint!
    @IBOutlet private weak var topImageViewWidthPadConstraint: NSLayoutConstraint!
    @IBOutlet private weak var collectionView: HomeDataCollectionView!
    private var subscriptions = Set<AnyCancellable>()
    private var subject = PassthroughSubject<HomeDataViewState, Never>()
    var publisher: AnyPublisher<HomeDataViewState, Never> { subject.eraseToAnyPublisher() }
    private let iPadDevice = UIDevice.current.userInterfaceIdiom == .pad
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        bind()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        bind()
    }
    
    func receivedData(_ categories: [HomeDataCategory], with imageCacheManager: ImageCacheManager) {
        collectionView.configure(with: categories, and: imageCacheManager)
        moveImageToTop()
    }
}

private extension HomeDataView {
    func bind() {
        bindCollectionView()
    }
    
    func bindCollectionView() {
        collectionView.publisher
            .sink { [weak self] state in
                guard let self = self else { return }
                switch state {
                case .showTitleViewShadow(let show):
                    self.showTitleViewShadow(show)
                case .openLocation(let location):
                    self.subject.send(.openLocation(location))
                case .viewMore(let category):
                    self.subject.send(.viewMore(category))
                }
            }.store(in: &subscriptions)
    }
    
    func showTitleViewShadow(_ show: Bool) {
        UIView.animate(withDuration: 0.2, delay: 0) { [weak self] in
            guard let self = self else { return }
            self.titleView.layer.shadowOpacity = show ? 1 : 0
        }
    }
    
    func moveImageToTop() {
        UIView.animate(withDuration: 0.7, delay: 0, usingSpringWithDamping: 20, initialSpringVelocity: 5) { [weak self] in
            guard let self = self else { return }
            self.titleViewDefaultBottomConstraint.priority = UILayoutPriority(999)
            self.titleViewHeightConstraint.priority = UILayoutPriority(1000)
            self.topImageViewDefaultWidthConstraint.priority = UILayoutPriority(999)
            self.topImageViewWidthConstraint.priority = UILayoutPriority(self.iPadDevice ? 999 : 1000)
            self.topImageViewWidthConstraint.priority = UILayoutPriority(self.iPadDevice ? 1000 : 999)
            self.layoutIfNeeded()
        } completion: { [weak self] finished in
            guard let self = self else { return }
            if finished {
                self.configureTitleView()
                self.configureTitleViewImage()
                self.showCollecionView()
            }
        }
    }
    
    func configureTitleView() {
        titleView.clipsToBounds = false
        titleView.layer.masksToBounds = false
        titleView.layer.shadowRadius = iPadDevice ? 10 : 5
        titleView.layer.shadowOpacity = 0
        titleView.layer.shadowColor = UIColor.black.cgColor
        titleView.layer.shadowOffset = CGSize(width: 0, height: iPadDevice ? 5 : 3)
        titleView.layer.shadowPath = UIBezierPath(rect: CGRect(x: 0,
                                                               y: titleView.bounds.maxY - titleView.layer.shadowRadius,
                                                               width: titleView.bounds.width,
                                                               height: titleView.layer.shadowRadius)).cgPath
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
