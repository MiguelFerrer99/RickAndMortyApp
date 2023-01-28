//
//  EpisodesInfoRepresentable.swift
//  RickAndMorty
//
//  Created by Miguel Ferrer Fornali on 17/1/23.
//

protocol EpisodesInfoRepresentable {
    var info: InfoPaginationRepresentable { get }
    var results: [EpisodeRepresentable] { get }
}

struct EpisodesInfoRepresented: EpisodesInfoRepresentable {
    var info: InfoPaginationRepresentable
    var results: [EpisodeRepresentable]
    
    init(_ dto: EpisodesInfoDTO) {
        info = InfoPaginationRepresented(dto.info)
        results = dto.results.compactMap { EpisodeRepresented($0) }
    }
    
    init() {
        info = InfoPaginationRepresented()
        results = []
    }
}
