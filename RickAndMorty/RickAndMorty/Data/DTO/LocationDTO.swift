//
//  LocationDTO.swift
//  RickAndMorty
//
//  Created by Miguel Ferrer Fornali on 16/1/23.
//

struct LocationDTO: Decodable {
    let id: Int
    let name: String
    let type: String
    let dimension: String
    let residents: [String]
}
