//
//  HomeInfoRepresentable.swift
//  RickAndMorty
//
//  Created by Miguel Ferrer Fornali on 17/1/23.
//

protocol HomeInfoRepresentable {
    var charactersInfo: CharactersInfoRepresentable? { get }
    var locationsInfo: LocationsInfoRepresentable? { get }
    var episodesInfo: EpisodesInfoRepresentable? { get }
}

struct DefaultHomeInfoRepresentable: HomeInfoRepresentable {
    var charactersInfo: CharactersInfoRepresentable?
    var locationsInfo: LocationsInfoRepresentable?
    var episodesInfo: EpisodesInfoRepresentable?
}
