//
//  HomeDataCategory.swift
//  iOSCleanArchitecture
//
//  Created by Miguel Ferrer Fornali on 20/11/22.
//

enum HomeDataCategory {
    case characters(info: CharactersInfoRepresentable)
    case locations(info: LocationsInfoRepresentable)
    case episodes(info: EpisodesInfoRepresentable)
    
    func getTitle() -> String {
        switch self {
        case .characters: return .home.charactersSectionTitle.localized
        case .locations: return .home.locationsSectionTitle.localized
        case .episodes: return .home.episodesSectionTitle.localized
        }
    }
}

