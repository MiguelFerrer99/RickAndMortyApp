//
//  HomeRepresentables.swift
//  iOSCleanArchitecture
//
//  Created by Miguel Ferrer Fornali on 20/11/22.
//

enum HomeDataCategory {
    case characters(info: CharactersInfoRepresentable)
    case locations
    case episodes
    
    func getTitle() -> String {
        switch self {
        case .characters: return .home.charactersSectionTitle.localized
        case .locations: return .home.locationsSectionTitle.localized
        case .episodes: return .home.episodesSectionTitle.localized
        }
    }
}

protocol HomeDataCollectionViewInfoCellRepresentable {
    var title: String { get }
    var urlImage: String { get }
}

struct DefaultHomeDataCollectionViewInfoCellRepresentable: HomeDataCollectionViewInfoCellRepresentable {
    var title: String
    var urlImage: String
}
