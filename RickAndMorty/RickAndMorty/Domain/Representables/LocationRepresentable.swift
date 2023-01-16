//
//  LocationRepresentable.swift
//  RickAndMorty
//
//  Created by Miguel Ferrer Fornali on 16/1/23.
//

protocol LocationRepresentable {
    var id: String { get }
    var name: String { get }
    var type: String { get }
    var dimension: String { get }
    var numberOfResidents: Int { get }
}

struct LocationRepresented: LocationRepresentable {
    var id: String
    var name: String
    var type: String
    var dimension: String
    var numberOfResidents: Int
    
    init(_ dto: LocationDTO) {
        self.id = "\(dto.id)"
        self.name = dto.name
        self.type = dto.type
        self.dimension = dto.dimension
        self.numberOfResidents = dto.residents.count
    }
}
