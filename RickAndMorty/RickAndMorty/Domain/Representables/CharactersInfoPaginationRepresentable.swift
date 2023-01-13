//
//  CharactersInfoPaginationBO.swift
//  RickAndMorty
//
//  Created by Miguel Ferrer Fornali on 12/1/23.
//

protocol CharactersInfoPaginationRepresentable {
    var count: Int { get }
    var pages: Int { get }
    var isLast: Bool { get }
}

struct CharactersInfoPaginationRepresented: CharactersInfoPaginationRepresentable {
    var count: Int
    var pages: Int
    var isLast: Bool
    
    init(_ dto: CharactersInfoPaginationDTO) {
        count = dto.count
        pages = dto.pages
        isLast = dto.next.isNil
    }
}
