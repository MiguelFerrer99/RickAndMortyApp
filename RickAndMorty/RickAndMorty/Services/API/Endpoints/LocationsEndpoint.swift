//
//  LocationsEndpoint.swift
//  RickAndMorty
//
//  Created by Miguel Ferrer Fornali on 16/1/23.
//

enum LocationsEndpoint {
    case locations(name: String?, page: Int?)
    
    var endpoint: APIEndpoint {
        get {
            switch self {
            case .locations(name: let optionalName, page: let optionalPage):
                var parameters: [String: String] = [:]
                if let page = optionalPage { parameters["page"] = "\(page)" }
                if let name = optionalName { parameters["name"] = name }
                return APIEndpoint(path: "/location",
                                   httpMethod: .get,
                                   parameters: parameters,
                                   mock: "Locations")
            }
        }
    }
}
