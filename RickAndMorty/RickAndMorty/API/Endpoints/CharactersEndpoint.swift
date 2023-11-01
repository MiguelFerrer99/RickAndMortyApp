//
//  CharactersEndpoint.swift
//  RickAndMorty
//
//  Created by Miguel Ferrer Fornali on 11/1/23.
//

enum CharactersEndpoint {
    case characters(name: String?, page: Int?)
    
    var endpoint: APIEndpoint {
        get {
            switch self {
            case .characters(name: let optionalName, page: let optionalPage):
                var parameters: [String: String] = [:]
                if let page = optionalPage { parameters["page"] = "\(page)" }
                if let name = optionalName { parameters["name"] = name }
                return APIEndpoint(path: "/character",
                                   httpMethod: .get,
                                   parameters: parameters,
                                   mock: "Characters")
            }
        }
    }
}
