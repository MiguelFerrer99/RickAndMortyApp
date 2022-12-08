//
//  AuthorInfoRepresentable.swift
//  RickAndMorty
//
//  Created by Miguel Ferrer Fornali on 7/12/22.
//

protocol AuthorInfoRepresentable {
    var iPad: Bool { get }
}

final class DefaultAuthorInfoRepresentable: AuthorInfoRepresentable {
    var iPad: Bool
    
    init(iPad: Bool) {
        self.iPad = iPad
    }
}
