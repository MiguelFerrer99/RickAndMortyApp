//
//  LocationsUseCase.swift
//  RickAndMorty
//
//  Created by Miguel Ferrer Fornali on 18/1/23.
//

protocol LocationsUseCase {
    func getInfo(ofPage page: Int) async -> LocationsInfoRepresentable?
}

final class DefaultLocationsUseCase {
    private let repository: HomeRepository

    init(repository: HomeRepository) {
        self.repository = repository
    }
}

extension DefaultLocationsUseCase: LocationsUseCase {
    func getInfo(ofPage page: Int) async -> LocationsInfoRepresentable? {
        return try? await repository.getLocations(ofPage: page)
    }
}
