//
//  CharactersEndpoint.swift
//  RickAndMorty
//
//  Created by Miguel Ferrer Fornali on 11/1/23.
//

enum CharactersEndpoint {
    case characters(page: Int)
    
    var endpoint: APIEndpoint {
        get {
            switch self {
            case .characters(page: let page):
                return APIEndpoint(path: "/character",
                                   httpMethod: .get,
                                   parameters: ["page": "\(page)"],
                                   mock: "Characters")
            }
        }
    }
}
