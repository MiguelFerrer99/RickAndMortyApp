//
//  CharactersInfoPaginationDTO.swift
//  RickAndMorty
//
//  Created by Miguel Ferrer Fornali on 11/1/23.
//

struct CharactersInfoPaginationDTO: Decodable {
    let count: Int
    let pages: Int
    let next: String?
}
