//
//  CommonExternalDependenciesResolver.swift
//  RickAndMorty
//
//  Created by Miguel Ferrer Fornali on 15/1/23.
//

protocol CommonExternalDependenciesResolver {
    func resolveAPIService() -> APIService
    func resolveCharactersUseCase() -> CharactersUseCase
    func resolveLocationsUseCase() -> LocationsUseCase
    func resolveEpisodesUseCase() -> EpisodesUseCase
}
