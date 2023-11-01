//
//  InfoPaginationDTO.swift
//  RickAndMorty
//
//  Created by Miguel Ferrer Fornali on 11/1/23.
//

struct InfoPaginationDTO: Decodable {
    let count: Int
    let pages: Int
    let next: String?
}
