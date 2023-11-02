//
//  HomeUseCase.swift
//  iOSCleanArchitecture
//
//  Created by Miguel Ferrer Fornali on 19/11/22.
//

protocol HomeUseCase {
    func getInfo() async -> HomeInfoRepresentable
}

struct DefaultHomeUseCase {
    private let repository: HomeRepository
    
    init(dependencies: HomeDependenciesResolver) {
        repository = dependencies.resolve()
    }
}

extension DefaultHomeUseCase: HomeUseCase {
    func getInfo() async -> HomeInfoRepresentable {
        async let charactersInfo = try? repository.getCharacters()
        async let locationsInfo = try? repository.getLocations()
        async let episodesInfo = try? repository.getEpisodes()
        let homeInfo = await DefaultHomeInfoRepresentable(charactersInfo: charactersInfo, locationsInfo: locationsInfo, episodesInfo: episodesInfo)
        return homeInfo
    }
}
