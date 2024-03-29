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
    var season: Int { get }
    var episode: Int { get }
    var numberOfCharacters: Int { get }
}

struct EpisodeRepresented: EpisodeRepresentable {
    var id: String
    var name: String
    var airDate: Date
    var season: Int
    var episode: Int
    var numberOfCharacters: Int
    
    init(_ dto: EpisodeDTO) {
        self.id = "\(dto.id)"
        self.name = dto.name
        self.airDate = dto.air_date.toDate(dateFormat: "MMMM d, yyyy") ?? Date()
        self.season = Int(dto.episode.replacingOccurrences(of: "S", with: "").split(separator: "E").map { String($0) }.first ?? "0") ?? 0
        self.episode = Int(dto.episode.replacingOccurrences(of: "S", with: "").split(separator: "E").map { String($0) }[safe: 1] ?? "0") ?? 0
        self.numberOfCharacters = dto.characters.count
    }
}
