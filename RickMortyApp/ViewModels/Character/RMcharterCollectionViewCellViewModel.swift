//
//  RMcharterCollectionViewCellViewModel.swift
//  RickMortyApp
//
//  Created by Dhiman Das on 18/2/23.
//

import Foundation

final class RMcharterCollectionViewCellViewModel : Hashable, Equatable {

    
    
    
    public let characterName : String
    private let characterStatus : RMCharStatus
    private let  characterImageUrl : URL?

    
    //MARK: - Init
    init(characterName : String ,
         characterStatus : RMCharStatus,
         characterImageUrl : URL?) {
        self.characterName = characterName
        self.characterStatus = characterStatus
        self.characterImageUrl = characterImageUrl
        
    }
    
    public var characterStatustext : String {
        return "Status: \(characterStatus.text)"
    }
    
    public func fetchImage(completion :@escaping (Result<Data, Error>)-> Void) {
        
        // TODO : Abstract to Image Manager
        guard  let url = characterImageUrl else {
            completion(.failure(URLError(.badURL)))
            return
        }
        
        RMImageLoader.shared.downLoadImage(url, completion: completion)
    }
    
    
    //MARK: - Hash
    
    static func == (lhs: RMcharterCollectionViewCellViewModel, rhs: RMcharterCollectionViewCellViewModel) -> Bool {
        return lhs.hashValue == rhs.hashValue
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(characterName)
        hasher.combine(characterStatus)
        hasher.combine(characterImageUrl)
    }
}
