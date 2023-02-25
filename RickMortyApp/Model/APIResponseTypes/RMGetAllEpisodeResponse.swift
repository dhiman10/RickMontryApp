//
//  RMGetAllEpisodeResponse.swift
//  RickMortyApp
//
//  Created by Dhiman Das on 22/2/23.
//

import Foundation

struct RMGetAllEpisodeResponse : Codable {
    
    struct Info : Codable {
        
        let count: Int
        let pages: Int
        let next : String
        let prev : String?
        
    }
    
    let info : Info
    let results : [RMEpisode]
    
}
