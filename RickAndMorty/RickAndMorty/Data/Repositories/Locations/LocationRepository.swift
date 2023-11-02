//
//  LocationRepository.swift
//  RickAndMorty
//
//  Created by Miguel Ferrer Fornali on 26/1/23.
//

protocol LocationRepository {
    func getLocations(withName name: String?, ofPage page: Int) async throws -> LocationsInfoRepresentable
}

struct DefaultLocationRepository {
    private let apiService: APIService
    
    init(dependencies: LocationsDependenciesResolver) {
        apiService = dependencies.external.resolve()
    }
}

extension DefaultLocationRepository: LocationRepository {
    func getLocations(withName name: String?, ofPage page: Int) async throws -> LocationsInfoRepresentable {
        let locactionsInfoDTO = try await apiService.load(endpoint: LocationsEndpoint.locations(name: name, page: page).endpoint, of: LocationsInfoDTO.self)
        let locationsInfo = LocationsInfoRepresented(locactionsInfoDTO)
        return locationsInfo
    }
}
