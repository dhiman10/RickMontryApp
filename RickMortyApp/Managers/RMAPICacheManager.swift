//
//  RMAPICacheManager.swift
//  RickMortyApp
//
//  Created by Dhiman Das on 22/2/23.
//

import Foundation

/// Manages in memory session scroped API  Caches
final class RMAPICacheManager {
    
    // API URL : Data
    
    private var cacheDictionary :[RMendpoint :NSCache<NSString , NSData>
    ] = [:]
    
    
    init() {
        setUpCache()
    }
    
    //MARK: - Public
    
    public func cachedResponse(for endpoint : RMendpoint, url : URL?)->Data? {
        
        guard let targetCache = cacheDictionary[endpoint] , let url = url else {
            return nil
        }
        let key = url.absoluteString as NSString
        
        //print(targetCache.object(forKey: key) as Data?)
        return targetCache.object(forKey: key) as Data?
        
        
    }
    
    public func setCache(for endpoint : RMendpoint, url : URL?, data : Data) {
        
        guard let targetCache = cacheDictionary[endpoint] , let url = url else {
            return
        }
        let key = url.absoluteString as NSString
        targetCache.setObject(data as NSData, forKey: key)
        
    }

    
    //MARK: - Private
    private func setUpCache() {
        RMendpoint.allCases.forEach({ endpoint in
            cacheDictionary[endpoint] = NSCache<NSString ,NSData>()
        })
    }
    
}
