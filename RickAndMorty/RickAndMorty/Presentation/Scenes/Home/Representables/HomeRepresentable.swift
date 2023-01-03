//
//  HomeRepresentable.swift
//  iOSCleanArchitecture
//
//  Created by Miguel Ferrer Fornali on 20/11/22.
//

enum HomeDataCategory: Int {
    case characters = 0
    case locations = 1
    case episodes = 2
    
    func getTitle() -> String {
        switch self {
        case .characters: return .home.charactersSectionTitle.localized
        case .locations: return .home.locationsSectionTitle.localized
        case .episodes: return .home.episodesSectionTitle.localized
        }
    }
}
