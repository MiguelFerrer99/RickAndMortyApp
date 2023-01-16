//
//  EpisodeRepresentable.swift
//  RickAndMorty
//
//  Created by Miguel Ferrer Fornali on 17/1/23.
//

import Foundation

protocol EpisodeRepresentable {
    var id: String { get }
    var name: String { get }
    var airDate: Date { get }
    var season: String { get }
    var episode: String { get }
    var numberOfCharacters: Int { get }
}

struct EpisodeRepresented: EpisodeRepresentable {
    var id: String
    var name: String
    var airDate: Date
    var season: String
    var episode: String
    var numberOfCharacters: Int
    
    init(_ dto: EpisodeDTO) {
        self.id = "\(dto.id)"
        self.name = dto.name
        self.airDate = dto.air_date.toDate(dateFormat: "MMMM d, yyyy") ?? Date()
        self.season = dto.episode.substring(3) ?? ""
        self.episode = dto.episode.substring(ofLast: 3) ?? ""
        self.numberOfCharacters = dto.characters.count
    }
}
