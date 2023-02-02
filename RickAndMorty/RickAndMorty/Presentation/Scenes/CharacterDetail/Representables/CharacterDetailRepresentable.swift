//
//  CharacterDetailRepresentable.swift
//  RickAndMorty
//
//  Created by Miguel Ferrer Fornali on 30/1/23.
//

protocol CharacterDetailRepresentable {
    var name: String { get }
    var image: String { get }
    var status: CharacterStatus { get }
    var species: String { get }
    var gender: CharacterGender { get }
    var origin: CharacterLocationRepresentable { get }
    var location: CharacterLocationRepresentable { get }
    var numberOfEpisodes: Int { get }
}

struct DefaultCharacterDetailRepresentable: CharacterDetailRepresentable {
    var name: String
    var image: String
    var status: CharacterStatus
    var species: String
    var gender: CharacterGender
    var origin: CharacterLocationRepresentable
    var location: CharacterLocationRepresentable
    var numberOfEpisodes: Int
}
