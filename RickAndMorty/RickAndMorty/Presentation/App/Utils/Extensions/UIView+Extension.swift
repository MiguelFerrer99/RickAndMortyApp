//
//  UIView+Extension.swift
//  iOSCleanArchitecture
//
//  Created by Miguel Ferrer Fornali on 19/11/22.
//

import UIKit

extension UIView {
    func fullFit(topMargin: CGFloat = 0, bottomMargin: CGFloat = 0, leftMargin: CGFloat = 0, rightMargin: CGFloat = 0) {
        guard let superview else { return }
        translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            leftAnchor.constraint(equalTo: superview.leftAnchor, constant: leftMargin),
            rightAnchor.constraint(equalTo: superview.rightAnchor, constant: -rightMargin),
            topAnchor.constraint(equalTo: superview.topAnchor, constant: topMargin),
            bottomAnchor.constraint(equalTo: superview.bottomAnchor, constant: -bottomMargin)
        ])
    }
}
