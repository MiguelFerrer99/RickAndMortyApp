//
//  UIViewController+Extension.swift
//  RickAndMorty
//
//  Created by Miguel Ferrer Fornali on 25/1/23.
//

import UIKit

fileprivate final class BackBarButtonItem: UIBarButtonItem {
    override var menu: UIMenu? {
        set {}
        get { return super.menu }
    }
}

extension UIViewController: UIGestureRecognizerDelegate {
    func configureNavigationBar(with title: String) {
        self.title = title
        let backItemImage = UIImage(systemName: "arrow.left")
        navigationItem.backBarButtonItem = nil
        navigationItem.leftBarButtonItem = BackBarButtonItem(image: backItemImage, style: .plain, target: self, action: #selector(didTapBackButton))
        navigationController?.setNavigationBarHidden(false, animated: true)
        navigationController?.interactivePopGestureRecognizer?.delegate = self
        navigationController?.interactivePopGestureRecognizer?.isEnabled = true
    }
    
    @objc private func didTapBackButton() {
        navigationController?.popViewController(animated: true)
    }
}
