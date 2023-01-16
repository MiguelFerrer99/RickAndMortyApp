//
//  LocationsInfoRepresentable.swift
//  RickAndMorty
//
//  Created by Miguel Ferrer Fornali on 16/1/23.
//

protocol LocationsInfoRepresentable {
    var info: InfoPaginationRepresentable { get }
    var results: [LocationRepresentable] { get }
}

struct LocationsInfoRepresented: LocationsInfoRepresentable {
    var info: InfoPaginationRepresentable
    var results: [LocationRepresentable]
    
    init(_ dto: LocationsInfoDTO) {
        info = InfoPaginationRepresented(dto.info)
        results = dto.results.compactMap { LocationRepresented($0) }
    }
}
