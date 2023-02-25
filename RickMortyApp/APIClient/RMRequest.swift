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
    let endPoint : RMendpoint
    
    /// Path component for API , if Any
    private let pathComponents : [String]
    
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
    init(endPoint : RMendpoint , pathComponents : [String] = [] ,queryParameters : [URLQueryItem] = []) {
        self.endPoint = endPoint
        self.pathComponents = pathComponents
        self.queryParameters = queryParameters
    }
    
    /// Attempt to create request
    convenience init?(url : URL) {
    
       // character?page=2

        let string = url.absoluteString
        if !string.contains(Constants.basUrl) {
            return nil
        }
        let trimmed = string.replacingOccurrences(of: Constants.basUrl+"/" , with: "")
        
        if trimmed.contains("/") {
            let components = trimmed.components(separatedBy: "/")
            if !components.isEmpty {
                let endPointString = components[0]
                var pathComponents :[String] = []
                if components.count > 1 {
                    pathComponents = components
                    pathComponents.removeFirst()
                }
                if let rmEndPoint = RMendpoint(rawValue: endPointString) {
                    self.init(endPoint: rmEndPoint, pathComponents: pathComponents)
                    return
                }
            }
        }
        else if trimmed.contains("?") {
            // character?page=2

            let components = trimmed.components(separatedBy: "?")
            if !components.isEmpty , components.count>=2 {
                let endPointString = components[0]
                let queryItemString = components[1]
                
                let queryItem : [URLQueryItem] = queryItemString.components(separatedBy: "&").compactMap({
                    guard $0.contains("=") else {
                        return nil
                    }
                    let parts = $0.components(separatedBy: "=")
                    return URLQueryItem(name: parts[0], value: parts[1])
                    
                })
            
                if let rmEndPoint = RMendpoint(rawValue: endPointString) {
                    self.init(endPoint: rmEndPoint, queryParameters: queryItem)
                    return
                }
            }
        }
        
        
        
    return nil
    }
    
    
}

extension RMRequest {
    static let listCharactersRequest = RMRequest(endPoint: .character)
    static let listEpisodeRequest = RMRequest(endPoint: .episode)
    static let listLocationRequest = RMRequest(endPoint: .location)

}
