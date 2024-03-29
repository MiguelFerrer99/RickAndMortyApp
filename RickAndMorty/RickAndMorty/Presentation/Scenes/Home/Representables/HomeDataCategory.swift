//
//  HomeDataCategory.swift
//  iOSCleanArchitecture
//
//  Created by Miguel Ferrer Fornali on 20/11/22.
//

enum HomeDataCategory {
    case characters([CharacterRepresentable])
    case locations([LocationRepresentable])
    case episodes([EpisodeRepresentable])
    
    func getTitle() -> String {
        switch self {
        case .characters: return .home.charactersSectionTitle.localized
        case .locations: return .home.locationsSectionTitle.localized
        case .episodes: return .home.episodesSectionTitle.localized
        }
    }
    
    func getIndex() -> Int {
        switch self {
        case .characters: return 0
        case .locations: return 1
        case .episodes: return 2
        }
    }
}

typealias CategoriesLastPages = (isLastPageCharacters: Bool, isLastPageLocations: Bool, isLastPageEpisodes: Bool)
