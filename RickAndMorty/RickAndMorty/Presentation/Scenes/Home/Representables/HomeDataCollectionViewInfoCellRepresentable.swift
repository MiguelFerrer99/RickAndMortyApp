//
//  HomeDataCollectionViewInfoCellRepresentable.swift
//  RickAndMorty
//
//  Created by Miguel Ferrer Fornali on 17/1/23.
//

protocol HomeDataCollectionViewInfoCellRepresentable {
    var title: String { get }
    var urlImage: String? { get }
}

struct DefaultHomeDataCollectionViewInfoCellRepresentable: HomeDataCollectionViewInfoCellRepresentable {
    var title: String
    var urlImage: String?
}
