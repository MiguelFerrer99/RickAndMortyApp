//
//  EpisodesInfoDTO.swift
//  RickAndMorty
//
//  Created by Miguel Ferrer Fornali on 17/1/23.
//

struct EpisodesInfoDTO: Decodable {
    let info: InfoPaginationDTO
    let results: [EpisodeDTO]
}
