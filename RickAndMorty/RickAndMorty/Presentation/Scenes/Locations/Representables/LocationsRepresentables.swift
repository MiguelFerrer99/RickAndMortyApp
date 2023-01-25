//
//  LocationsRepresentables.swift
//  RickAndMorty
//
//  Created by Miguel Ferrer Fornali on 25/1/23.
//

protocol LocationsViewModelRepresentable {
    var locations: [LocationRepresentable] { get }
    var isLastPage: Bool { get }
}

struct DefaultLocationsViewModelRepresentable: LocationsViewModelRepresentable {
    var locations: [LocationRepresentable]
    var isLastPage: Bool
}
