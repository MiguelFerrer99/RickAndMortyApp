//
//  HomeTitleView.swift
//  RickAndMorty
//
//  Created by Miguel Ferrer Fornali on 3/12/22.
//

import UIKit
import Combine

enum HomeTitleViewState {
    case didTapView
}

final class HomeTitleView: XibView {
    @IBOutlet weak var titleImageView: UIImageView!
    
    private var subscriptions = Set<AnyCancellable>()
    private var subject = PassthroughSubject<HomeTitleViewState, Never>()
    var publisher: AnyPublisher<HomeTitleViewState, Never> {
        subject.eraseToAnyPublisher()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupView()
    }
}

private extension HomeTitleView {    
    func setupView() {
        titleImageView.isUserInteractionEnabled = true
        titleImageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(didTapView)))
    }
    
    @objc func didTapView() {
        subject.send(.didTapView)
    }
}
