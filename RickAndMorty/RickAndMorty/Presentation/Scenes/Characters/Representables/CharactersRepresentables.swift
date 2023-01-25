//
//  CharactersRepresentables.swift
//  RickAndMorty
//
//  Created by Miguel Ferrer Fornali on 25/1/23.
//

protocol CharactersViewModelRepresentable {
    var characters: [CharacterRepresentable] { get }
    var isLastPage: Bool { get }
}

struct DefaultCharactersViewModelRepresentable: CharactersViewModelRepresentable {
    var characters: [CharacterRepresentable]
    var isLastPage: Bool
}
