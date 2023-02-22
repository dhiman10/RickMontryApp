//
//  RMDetailPhotoViewModel.swift
//  RickMortyApp
//
//  Created by Dhiman Das on 19/2/23.
//

import Foundation

final class RMPhotoCellViewModel {
    
    private let imageUrl : URL?
    
    init(imageUrl : URL?){
        
        self.imageUrl = imageUrl
    }
    
    public func fetchImage(completion :@escaping (Result<Data , Error>)->Void) {
        
        guard let imageUrl = imageUrl else {
            completion(.failure(URLError(.badURL)))
            return
        }
        RMImageLoader.shared.downLoadImage(imageUrl, completion: completion)
    }
    
}
