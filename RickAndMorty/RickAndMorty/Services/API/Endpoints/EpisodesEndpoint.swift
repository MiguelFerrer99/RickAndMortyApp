//
//  EpisodesEndpoint.swift
//  RickAndMorty
//
//  Created by Miguel Ferrer Fornali on 17/1/23.
//

enum EpisodesEndpoint {
    case episodes(page: Int)
    
    var endpoint: APIEndpoint {
        get {
            switch self {
            case .episodes(page: let page):
                return APIEndpoint(path: "/episode",
                                   httpMethod: .get,
                                   parameters: ["page": page],
                                   mock: "Episodes")
            }
        }
    }
}
