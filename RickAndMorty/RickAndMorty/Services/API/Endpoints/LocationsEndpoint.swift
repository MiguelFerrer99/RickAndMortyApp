//
//  LocationsEndpoint.swift
//  RickAndMorty
//
//  Created by Miguel Ferrer Fornali on 16/1/23.
//

enum LocationsEndpoint {
    case locations(page: Int)
    
    var endpoint: APIEndpoint {
        get {
            switch self {
            case .locations(page: let page):
                return APIEndpoint(path: "/location",
                                   httpMethod: .get,
                                   parameters: ["page": "\(page)"],
                                   mock: "Locations")
            }
        }
    }
}
