//
//  LocationDetailRepresentable.swift
//  RickAndMorty
//
//  Created by Miguel Ferrer Fornali on 29/1/23.
//

protocol LocationDetailRepresentable {
    var name: String { get }
    var type: String { get }
    var dimension: String { get }
    var numberOfResidents: Int { get }
}

struct DefaultLocationDetailRepresentable: LocationDetailRepresentable {
    var name: String
    var type: String
    var dimension: String
    var numberOfResidents: Int
}
