//
//  HomeRepository.swift
//  iOSCleanArchitecture
//
//  Created by Miguel Ferrer Fornali on 19/11/22.
//

protocol HomeRepository {}

final class DefaultHomeRepository: HomeRepository {
    private let dependencies: LoadingDependenciesResolver
    
    init(dependencies: LoadingDependenciesResolver) {
        self.dependencies = dependencies
    }
}
