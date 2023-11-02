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
    var isModal: Bool {
        let presentingIsModal = presentingViewController != nil
        let presentingIsNavigation = navigationController?.presentingViewController?.presentedViewController == navigationController
        let presentingIsTabBar = tabBarController?.presentingViewController is UITabBarController
        return presentingIsModal || presentingIsNavigation || presentingIsTabBar
    }
    
    func configureNavigationBar(with title: String, hidden: Bool = false) {
        self.title = title
        navigationItem.backBarButtonItem = nil
        navigationController?.setNavigationBarHidden(hidden, animated: true)
        navigationController?.interactivePopGestureRecognizer?.delegate = self
        navigationController?.interactivePopGestureRecognizer?.isEnabled = true
        navigationController?.navigationBar.layer.shadowOpacity = 0
    }
}
