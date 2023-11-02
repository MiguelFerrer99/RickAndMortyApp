//
//  LocationsUseCase.swift
//  RickAndMorty
//
//  Created by Miguel Ferrer Fornali on 26/1/23.
//

protocol LocationsUseCase {
    func getLocations(withName name: String?, ofPage page: Int) async -> LocationsInfoRepresentable
}

struct DefaultLocationsUseCase {
    private let repository: LocationRepository
    
    init(dependencies: LocationsDependenciesResolver) {
        repository = dependencies.resolve()
    }
}

extension DefaultLocationsUseCase: LocationsUseCase {
    func getLocations(withName name: String?, ofPage page: Int) async -> LocationsInfoRepresentable {
        do {
            let locationsInfo = try await repository.getLocations(withName: name, ofPage: page)
            return locationsInfo
        } catch {
            return LocationsInfoRepresented()
        }
    }
}
