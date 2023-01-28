//
//  InfoPaginationRepresentable.swift
//  RickAndMorty
//
//  Created by Miguel Ferrer Fornali on 12/1/23.
//

protocol InfoPaginationRepresentable {
    var count: Int { get }
    var pages: Int { get }
    var isLast: Bool { get }
}

struct InfoPaginationRepresented: InfoPaginationRepresentable {
    var count: Int
    var pages: Int
    var isLast: Bool
    
    init(_ dto: InfoPaginationDTO) {
        count = dto.count
        pages = dto.pages
        isLast = dto.next.isNil
    }
    
    init() {
        count = 0
        pages = 0
        isLast = true
    }
}
