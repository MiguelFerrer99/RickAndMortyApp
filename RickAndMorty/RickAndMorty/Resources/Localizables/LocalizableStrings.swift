//
//  LocalizableStrings.swift
//  NbaApp
//
//  Created by Miguel Ferrer Fornali on 24/9/22.
//

import UIKit
import SwiftUI

protocol Localizable: CustomStringConvertible {
    var rawValue: String { get }
}

extension Localizable {
    var localized: String {
        return NSLocalizedString(self.rawValue, comment: "")
    }

    var uppercased: String {
        return self.localized.uppercased()
    }

    var description: String {
        return self.localized
    }

    func localized(with: CVarArg...) -> String {
        let text = String(format: self.localized, arguments: with)
        return text
    }
}

extension String {
    enum loading: String, Localizable {
        case errorTitle = "loading_errorTitle"
        case errorButton = "loading_errorButton"
    }
    
    enum tryAgainButtonView: String, Localizable {
        case title = "tryAgainButtonView_title"
    }
}
