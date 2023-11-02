//
//  Coordinator.swift
//  MFFApp
//
//  Created by Miguel Ferrer on 9/7/23.
//

import UIKit

// MARK: - PopType
enum PopType {
    case gesture, button
}

// MARK: - Coordinator
protocol Coordinator: AnyObject {
    var identifier: String { get }
    var onFinish: (() -> Void)? { get set }
    var childCoordinators: [Coordinator] { get set }
    var navigationController: UINavigationController { get set }
    func start()
    func dismiss(with type: PopType)
}

extension Coordinator {
    var identifier: String { String(describing: self) }
    
    func append(child coordinator: Coordinator) {
        childCoordinators.append(coordinator)
        coordinator.onFinish = { [weak self, weak coordinator] in
            guard let self, let coordinator else { return }
            childCoordinators.removeAll { coordinator.identifier == $0.identifier }
        }
    }
    
    func dismiss(with type: PopType) {
        guard let viewController = navigationController.visibleViewController else { return }
        if type == .button {
            if viewController.isModal {
                navigationController.dismiss(animated: true)
            } else {
                navigationController.popViewController(animated: true)
            }
        }
        onFinish?()
    }
}
