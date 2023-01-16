//
//  LocationsInfoDTO.swift
//  RickAndMorty
//
//  Created by Miguel Ferrer Fornali on 16/1/23.
//

struct LocationsInfoDTO: Decodable {
    let info: InfoPaginationDTO
    let results: [LocationDTO]
}
