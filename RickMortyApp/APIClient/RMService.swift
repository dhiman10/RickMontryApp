//
//  RMService.swift
//  RickMortyApp
//
//  Created by Dhiman Das on 17/2/23.
//

import Foundation

/// Primary API service to get Rick and Morty data
final class RMService {
    
    /// Shared singleton instance
    static let shared = RMService()
    
    /// Privatized constructor
    private init() {
        
    }
    
    /// Send Rick and Morty API Call
    /// - Parameters:
    ///   - request: Request instance
    ///   - completion: Callback with Data or error
    public func excute(_ request : RMRequest , completion : @escaping () ->Void) {
        
    }
    
}