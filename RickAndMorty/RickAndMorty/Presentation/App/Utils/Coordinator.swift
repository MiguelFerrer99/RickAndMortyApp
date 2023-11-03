//
//  Coordinator.swift
//  MFFApp
//
//  Created by Miguel Ferrer on 9/7/23.
//

import UIKit

protocol Coordinator: AnyObject {
    var navigationController: UINavigationController { get set }
    func start()
    func dismiss()
}

extension Coordinator {
    func dismiss() {
        guard let viewController = navigationController.visibleViewController else { return }
        if viewController.isModal {
            navigationController.dismiss(animated: true)
        } else {
            navigationController.popViewController(animated: true)
        }
    }
}
