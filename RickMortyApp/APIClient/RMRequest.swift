//
//  RMRequest.swift
//  RickMortyApp
//
//  Created by Dhiman Das on 17/2/23.
//

import Foundation

/// Object that represent a single API call
final class RMRequest {
    
//https://rickandmortyapi.com/api/character/?name=rick&status=alive
    
    
    /// Api Constant
    private struct Constants {
        static let basUrl = "https://rickandmortyapi.com/api"
    }
    
    /// Desired Endpoint
    private let endPoint : RMendpoint
    
    /// Path component for API , if Any
    private let pathComponents : Set<String>
    
    /// Query arguments for API, if Any
    private let queryParameters : [URLQueryItem]
    
    /// Constructed url for the api request in string format
    private var urlString : String {
        var string = Constants.basUrl
        string += "/"
        string += endPoint.rawValue
        
        if !pathComponents.isEmpty {
            pathComponents.forEach({
                string += "/\($0)"
            })
        }
        
        if !queryParameters.isEmpty {
            string += "?"
            
            let argumentString = queryParameters.compactMap({
                guard let value = $0.value else { return nil}
                return "\($0.name)=\(value)"
                
            }).joined(separator:"&")
      
            string += argumentString
        }
        
        return string

    }
    
    /// Computed & constructed API url
    public var url : URL? {
        return URL(string: urlString)
    }
    
    /// Desired HTTP Method
    public let httpMethod = "GET"
    
    //MARK: - Public
    
    /// Construct request
    /// - Parameters:
    ///   - endPoint: Target Endpoint
    ///   - pathComponents: Collection of Path components
    ///   - queryParameters: Collection of query parameters
    init(endPoint : RMendpoint , pathComponents : Set<String> ,queryParameters : [URLQueryItem] = []) {
        self.endPoint = endPoint
        self.pathComponents = pathComponents
        self.queryParameters = queryParameters
    }
    
    
}
