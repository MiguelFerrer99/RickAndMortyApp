//
//  UIDevice+Extension.swift
//  RickAndMorty
//
//  Created by Miguel Ferrer on 1/11/23.
//

import UIKit

extension UIDevice {
    static var isIpad: Bool { current.userInterfaceIdiom == .pad }
}
