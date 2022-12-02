//
//  LoadingLoaderView.swift
//  RickAndMorty
//
//  Created by Miguel Ferrer Fornali on 2/12/22.
//

import UIKit
import Lottie

final class LoadingLoaderView: XibView {
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

private extension LoadingLoaderView {
    func setupView() {
        animationView.loopMode = .loop
        animationView.play()
    }
}
