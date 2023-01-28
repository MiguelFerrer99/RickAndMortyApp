//
//  CharacterLocationRepresentable.swift
//  RickAndMorty
//
//  Created by Miguel Ferrer Fornali on 12/1/23.
//

protocol CharacterLocationRepresentable {
    var name: String { get }
}

struct CharacterLocationRepresented: CharacterLocationRepresentable {
    var name: String
    
    init(_ dto: CharacterLocationDTO) {
        name = dto.name
    }
}
