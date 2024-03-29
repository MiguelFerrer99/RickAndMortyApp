//
//  CharacterRepresentable.swift
//  RickAndMorty
//
//  Created by Miguel Ferrer Fornali on 12/1/23.
//

enum CharacterStatus: String {
    case alive = "Alive"
    case dead = "Dead"
    case unknown = "Unknown"
    
    func getText() -> String {
        switch self {
        case .alive: return .characterDetail.statusType.alive.localized
        case .dead: return .characterDetail.statusType.dead.localized
        case .unknown: return .characterDetail.statusType.unknown.localized
        }
    }
}

enum CharacterGender: String {
    case male = "Male"
    case female = "Female"
    
    func getText() -> String {
        switch self {
        case .male: return .characterDetail.genderType.male.localized
        case .female: return .characterDetail.genderType.female.localized
        }
    }
}

protocol CharacterRepresentable {
    var id: String { get }
    var name: String { get }
    var status: CharacterStatus { get }
    var species: String { get }
    var gender: CharacterGender { get }
    var urlImage: String { get }
    var origin: CharacterLocationRepresentable { get }
    var location: CharacterLocationRepresentable { get }
    var numberOfEpisodes: Int { get }
}

struct CharacterRepresented: CharacterRepresentable {
    var id: String
    var name: String
    var status: CharacterStatus
    var species: String
    var gender: CharacterGender
    var urlImage: String
    var origin: CharacterLocationRepresentable
    var location: CharacterLocationRepresentable
    var numberOfEpisodes: Int
    
    init(_ dto: CharacterDTO) {
        id = "\(dto.id)"
        name = dto.name
        status = CharacterStatus(rawValue: dto.status) ?? .unknown
        species = dto.species
        gender = CharacterGender(rawValue: dto.gender) ?? .male
        urlImage = dto.image
        origin = CharacterLocationRepresented(dto.origin)
        location = CharacterLocationRepresented(dto.location)
        numberOfEpisodes = dto.episodes.count
    }
}
