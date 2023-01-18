//
//  HomeUseCase.swift
//  iOSCleanArchitecture
//
//  Created by Miguel Ferrer Fornali on 19/11/22.
//

protocol HomeUseCase {
    func getInfo() async -> HomeInfoRepresentable
}

final class DefaultHomeUseCase {
    private let repository: HomeRepository

    init(dependencies: HomeDependenciesResolver) {
        self.repository = dependencies.external.resolve()
    }
}

extension DefaultHomeUseCase: HomeUseCase {
    func getInfo() async -> HomeInfoRepresentable {
        async let charactersInfo = try? repository.getCharacters(ofPage: 1)
        async let locationsInfo = try? repository.getLocations(ofPage: 1)
        async let episodesInfo = try? repository.getEpisodes(ofPage: 1)
        let homeInfo = await DefaultHomeInfoRepresentable(charactersInfo: charactersInfo, locationsInfo: locationsInfo, episodesInfo: episodesInfo)
        return homeInfo
    }
}
