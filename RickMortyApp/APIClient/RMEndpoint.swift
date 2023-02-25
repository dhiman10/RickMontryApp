//
//  RMEndpoint.swift
//  RickMortyApp
//
//  Created by Dhiman Das on 17/2/23.
//

import Foundation
/// Represt unique API endPoint
@frozen enum RMendpoint : String, Hashable, CaseIterable {
    /// End point to character info
    case character
    
    /// End point to location info
    case location
    
    /// End point to episode info
    case episode 
}
