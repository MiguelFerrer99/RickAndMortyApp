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

protocol LocationsCollectionViewInfoCellRepresentable {
    var title: String { get }
    var image: String { get }
}

struct DefaultLocationsCollectionViewInfoCellRepresentable: LocationsCollectionViewInfoCellRepresentable {
    var title: String
    var image: String
}
