//
//  CharactersInfoBO.swift
//  iOSCleanArchitecture
//
//  Created by Miguel Ferrer Fornali on 20/11/22.
//

protocol CharactersInfoRepresentable {
    var info: CharactersInfoPaginationRepresentable { get }
    var results: [CharacterRepresentable] { get }
}

struct CharactersInfoRepresented: CharactersInfoRepresentable {
    var info: CharactersInfoPaginationRepresentable
    var results: [CharacterRepresentable]
    
    init(_ dto: CharactersInfoDTO) {
        info = CharactersInfoPaginationRepresented(dto.info)
        results = dto.results.compactMap { CharacterRepresented($0) }
    }
}
