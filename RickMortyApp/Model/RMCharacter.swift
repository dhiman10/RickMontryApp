//
//  RMCharacter.swift
//  RickMortyApp
//
//  Created by Dhiman Das on 17/2/23.
//

import Foundation

struct RMCharacter : Codable {
    
    let id: Int
    let name: String
    let status: RMcharStatus
    let species: String
    let type: String
    let gender: RMcharGender
    let origin: RMOrgin
    let location: RMsingleLocation
    let image: String
    let episode: [String]
    let url : String
    let created: String
    
}

struct RMOrgin : Codable {
    let name : String
    let url : String
}


