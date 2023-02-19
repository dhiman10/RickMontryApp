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
    enum RMserviceError : Error {
        case failedToCreateRequest
        case failedToCGetData

    }
    
    /// Send Rick and Morty API Call
    /// - Parameters:
    ///   - request: Request instance
    ///   - type: The Type of Object we wxpect to get back
    ///   - completion: Callback with Data or error
    public func excute<T: Codable>(_ request : RMRequest, expecting type : T.Type , completion : @escaping (Result<T,Error>) ->Void) {
        
        guard let urlrequest = self.request(from: request) else {
            completion(.failure(RMserviceError.failedToCreateRequest))
            return
        }
        let task = URLSession.shared.dataTask(with: urlrequest){ data , response, error in
            
            guard let data = data , error == nil else {
                completion(.failure(RMserviceError.failedToCGetData))
                return
            }
            //Decode respons
            do
            {
               // let jshon = try JSONSerialization.jsonObject(with: data)
                //print(String(describing: jshon))
                let result = try JSONDecoder().decode(type.self, from: data)
                completion(.success(result))
                
            }
            catch {
                completion(.failure(error))
            }
            
        }
        task.resume()
        
    }
    
    private func request(from rmRequest : RMRequest) -> URLRequest? {
        
        guard let url = rmRequest.url else {
            return nil
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = rmRequest.httpMethod
        
        return request
        
    }
    
}
