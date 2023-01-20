//
//  CharacterDTO.swift
//  RickAndMorty
//
//  Created by Miguel Ferrer Fornali on 11/1/23.
//

struct CharacterDTO: Decodable {
    let id: Int
    let name: String
    let status: String
    let species: String
    let gender: String
    let image: String
    let origin: CharacterLocationDTO
    let location: CharacterLocationDTO
    let episodes: [String]
    
    enum CodingKeys: String, CodingKey {
        case id
        case name
        case status
        case species
        case gender
        case image
        case origin
        case location
        case episodes = "episode"
    }
}
