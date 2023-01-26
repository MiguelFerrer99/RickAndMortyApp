//
//  LocationsUseCase.swift
//  RickAndMorty
//
//  Created by Miguel Ferrer Fornali on 26/1/23.
//

protocol LocationsUseCase {
    func getLocations(ofPage page: Int) async -> LocationsInfoRepresentable?
}

final class DefaultLocationsUseCase {
    private let repository: LocationRepository

    init(dependencies: LocationsDependenciesResolver) {
        self.repository = dependencies.resolve()
    }
}

extension DefaultLocationsUseCase: LocationsUseCase {
    func getLocations(ofPage page: Int) async -> LocationsInfoRepresentable? {
        let locationsInfo = try? await repository.getLocations(ofPage: page)
        return locationsInfo
    }
}
