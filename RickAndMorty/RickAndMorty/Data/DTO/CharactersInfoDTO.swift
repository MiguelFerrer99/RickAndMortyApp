//
//  CharactersInfoDTO.swift
//  RickAndMorty
//
//  Created by Miguel Ferrer Fornali on 11/1/23.
//

struct CharactersInfoDTO: Decodable {
    let info: CharactersInfoPaginationDTO
    let results: [CharacterDTO]
}
