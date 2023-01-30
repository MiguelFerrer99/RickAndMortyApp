//
//  UIViewController+Extension.swift
//  RickAndMorty
//
//  Created by Miguel Ferrer Fornali on 25/1/23.
//

import UIKit

final class BarButtonItem: UIBarButtonItem {
    override var menu: UIMenu? {
        set {}
        get { return super.menu }
    }
}

extension UIViewController: UIGestureRecognizerDelegate {
    func configureNavigationBar(with title: String) {
        self.title = title
        navigationItem.backBarButtonItem = nil
        navigationController?.setNavigationBarHidden(false, animated: true)
        navigationController?.interactivePopGestureRecognizer?.delegate = self
        navigationController?.interactivePopGestureRecognizer?.isEnabled = true
        navigationController?.navigationBar.layer.shadowOpacity = 0
    }
}
