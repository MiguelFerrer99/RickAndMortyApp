//
//  HomeLoadingLoaderView.swift
//  RickAndMorty
//
//  Created by Miguel Ferrer Fornali on 2/12/22.
//

import UIKit
import Lottie

final class HomeLoadingLoaderView: XibView {
    @IBOutlet private weak var animationView: LottieAnimationView!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupView()
    }
}

private extension HomeLoadingLoaderView {
    func setupView() {
        animationView.loopMode = .loop
        animationView.play()
    }
}
