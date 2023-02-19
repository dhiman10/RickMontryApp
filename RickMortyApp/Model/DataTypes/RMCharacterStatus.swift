//
//  RMCharacterStatus.swift
//  RickMortyApp
//
//  Created by Dhiman Das on 17/2/23.
//

import Foundation

enum RMCharStatus : String , Codable {
    case alive = "Alive"
    case dead = "Dead"
    case `unknown` = "unknown"
    
    var text : String {
        switch self {
        case .alive, .dead:
            return rawValue
        case .unknown:
            return "Unknown"
        }
    }
}
