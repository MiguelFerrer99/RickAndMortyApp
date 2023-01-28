//
//  EpisodesEndpoint.swift
//  RickAndMorty
//
//  Created by Miguel Ferrer Fornali on 17/1/23.
//

enum EpisodesEndpoint {
    case episodes(name: String?, page: Int?)
    
    var endpoint: APIEndpoint {
        get {
            switch self {
            case .episodes(name: let optionalName, page: let optionalPage):
                var parameters: [String: String] = [:]
                if let page = optionalPage { parameters["page"] = "\(page)" }
                if let name = optionalName { parameters["name"] = name }
                return APIEndpoint(path: "/episode",
                                   httpMethod: .get,
                                   parameters: parameters,
                                   mock: "Episodes")
            }
        }
    }
}
