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
    case openCharacter(CharacterRepresentable)
    case openLocation(LocationRepresentable)
    case openEpisode(EpisodeRepresentable)
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
                guard let self else { return }
                switch state {
                case .showTitleViewShadow(let show): showTitleViewShadow(show)
                case .openCharacter(let character): subject.send(.openCharacter(character))
                case .openLocation(let location): subject.send(.openLocation(location))
                case .openEpisode(let episode): subject.send(.openEpisode(episode))
                case .viewMore(let category): subject.send(.viewMore(category))
                }
            }.store(in: &subscriptions)
    }
    
    func showTitleViewShadow(_ show: Bool) {
        UIView.animate(withDuration: 0.2, delay: 0) { [weak self] in
            guard let self else { return }
            titleView.layer.shadowOpacity = show ? 1 : 0
        }
    }
    
    func moveImageToTop() {
        UIView.animate(withDuration: 0.7, delay: 0, usingSpringWithDamping: 20, initialSpringVelocity: 5) { [weak self] in
            guard let self else { return }
            titleViewDefaultBottomConstraint.priority = UILayoutPriority(999)
            titleViewHeightConstraint.priority = UILayoutPriority(1000)
            topImageViewDefaultWidthConstraint.priority = UILayoutPriority(999)
            topImageViewWidthConstraint.priority = UILayoutPriority(UIDevice.isIpad ? 999 : 1000)
            topImageViewWidthConstraint.priority = UILayoutPriority(UIDevice.isIpad ? 1000 : 999)
            layoutIfNeeded()
        } completion: { [weak self] finished in
            guard let self else { return }
            if finished {
                configureTitleView()
                configureTitleViewImage()
                showCollecionView()
            }
        }
    }
    
    func configureTitleView() {
        titleView.clipsToBounds = false
        titleView.layer.masksToBounds = false
        titleView.layer.shadowRadius = UIDevice.isIpad ? 10 : 5
        titleView.layer.shadowOpacity = 0
        titleView.layer.shadowColor = UIColor.black.cgColor
        titleView.layer.shadowOffset = CGSize(width: 0, height: UIDevice.isIpad ? 5 : 3)
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
            guard let self else { return }
            collectionView.alpha = 1
        } completion: { [weak self] finished in
            guard let self else { return }
            collectionView.isUserInteractionEnabled = true
        }
    }
    
    @objc func didTapTopImage() {
        subject.send(.didTapTitleImage)
    }
}
