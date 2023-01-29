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
    enum tryAgainButtonView: String, Localizable {
        case title = "tryAgainButtonView_title"
    }
    
    enum home: String, Localizable {
        case title = "home_title"
        case loadingErrorTitle = "home_loadingErrorTitle"
        case charactersSectionTitle = "home_charactersSectionTitle"
        case locationsSectionTitle = "home_locationsSectionTitle"
        case episodesSectionTitle = "home_episodesSectionTitle"
        case viewMore = "home_viewMore"
        case episodeSeason = "home_episodeSeason"
        case episodeEpisode = "home_episodeEpisode"
    }
    
    enum authorInfo: String, Localizable {
        case name = "authorInfo_name"
        case openingMediaError = "authorInfo_openingMediaError"
    }
    
    enum characters: String, Localizable {
        case title = "characters_title"
        case searchPlaceholder = "characters_searchPlaceholder"
        case empty = "characters_empty"
    }
    
    enum locations: String, Localizable {
        case title = "locations_title"
        case searchPlaceholder = "locations_searchPlaceholder"
        case empty = "locations_empty"
    }
    
    enum episodes: String, Localizable {
        case title = "episodes_title"
        case searchPlaceholder = "episodes_searchPlaceholder"
        case empty = "episodes_empty"
        case season = "episodes_season"
        case episode = "episodes_episode"
    }
}
