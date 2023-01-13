//
//  HomeRepository.swift
//  iOSCleanArchitecture
//
//  Created by Miguel Ferrer Fornali on 19/11/22.
//

import Combine

protocol HomeRepository {
    //func getCharacters() -> AnyPublisher<CharactersInfoRepresentable, Error>
}

final class DefaultHomeRepository {
    private let dependencies: HomeExternalDependenciesResolver
    private let apiService: APIService
    
    init(dependencies: HomeExternalDependenciesResolver) {
        self.dependencies = dependencies
        self.apiService = dependencies.resolveAPIService()
    }
}

extension DefaultHomeRepository: HomeRepository {
//    func getCharacters() -> AnyPublisher<CharactersInfoRepresentable, Error> {
//        
//    }
}
