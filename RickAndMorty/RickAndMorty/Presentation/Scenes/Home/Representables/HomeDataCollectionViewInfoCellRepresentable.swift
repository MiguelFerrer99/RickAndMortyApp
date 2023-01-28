//
//  HomeDataCollectionViewInfoCellRepresentable.swift
//  RickAndMorty
//
//  Created by Miguel Ferrer Fornali on 17/1/23.
//

enum HomeDataCollectionViewInfoCellStyle {
    case character(String, String)
    case location(String, String)
    case episode(String, String, String)
}

protocol HomeDataCollectionViewInfoCellRepresentable {
    var style: HomeDataCollectionViewInfoCellStyle { get }
}

struct DefaultHomeDataCollectionViewInfoCellRepresentable: HomeDataCollectionViewInfoCellRepresentable {
    var style: HomeDataCollectionViewInfoCellStyle
}
