//
//  CharactersInfoRepresentable.swift
//  iOSCleanArchitecture
//
//  Created by Miguel Ferrer Fornali on 20/11/22.
//

protocol CharactersInfoRepresentable {
    var info: InfoPaginationRepresentable { get }
    var results: [CharacterRepresentable] { get }
}

struct CharactersInfoRepresented: CharactersInfoRepresentable {
    var info: InfoPaginationRepresentable
    var results: [CharacterRepresentable]
    
    init(_ dto: CharactersInfoDTO) {
        info = InfoPaginationRepresented(dto.info)
        results = dto.results.compactMap { CharacterRepresented($0) }
    }
}
