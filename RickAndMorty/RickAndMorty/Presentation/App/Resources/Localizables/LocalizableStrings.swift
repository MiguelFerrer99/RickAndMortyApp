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
    var localized: String { NSLocalizedString(rawValue, comment: "") }
    var uppercased: String { localized.uppercased() }
    var description: String { localized }

    func localized(with: CVarArg...) -> String {
        String(format: localized, arguments: with)
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
    
    enum characterDetail: String, Localizable {
        case status = "characterDetail_status"
        case species = "characterDetail_species"
        case gender = "characterDetail_gender"
        case origin = "characterDetail_origin"
        case location = "characterDetail_location"
        case numberOfEpisodes = "characterDetail_numberOfEpisodes"
        
        enum statusType: String, Localizable {
            case alive = "characterDetail_statusType_alive"
            case dead = "characterDetail_statusType_dead"
            case unknown = "characterDetail_statusType_unknown"
        }
        
        enum genderType: String, Localizable {
            case male = "characterDetail_genderType_male"
            case female = "characterDetail_genderType_female"
        }
    }
    
    enum locations: String, Localizable {
        case title = "locations_title"
        case searchPlaceholder = "locations_searchPlaceholder"
        case empty = "locations_empty"
    }
    
    enum locationDetail: String, Localizable {
        case type = "locationDetail_type"
        case dimension = "locationDetail_dimension"
        case numberOfResidents = "locationDetail_numberOfResidents"
    }
    
    enum episodes: String, Localizable {
        case title = "episodes_title"
        case searchPlaceholder = "episodes_searchPlaceholder"
        case empty = "episodes_empty"
        case season = "episodes_season"
        case episode = "episodes_episode"
    }
    
    enum episodeDetail: String, Localizable {
        case airDate = "episodeDetail_airDate"
        case season = "episodeDetail_season"
        case episode = "episodeDetail_episode"
        case numberOfCharacters = "episodeDetail_numberOfCharacters"
    }
}
