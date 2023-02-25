//
//  RMDetailEpisodeViewModel.swift
//  RickMortyApp
//
//  Created by Dhiman Das on 19/2/23.
//

import Foundation
import UIKit

protocol RMEpisodeDataRender {
    
    var name : String {get }
    var air_date : String {get }
    var episode : String {get }

}

final class RMEpisodeCellViewModel: Hashable, Equatable {

    private let episodeDataUrl : URL?
    private var isFetching = false
    private var dataBlock : ((RMEpisodeDataRender)->Void)?
    
    public let borderColor : UIColor
    
    private var episode : RMEpisode? {
        didSet {
            guard let model = episode else {
                return
            }
            dataBlock?(model)
        }
    }
    
    //MARK: - Init
    init(episodeDataUrl : URL?, borderColor: UIColor = .systemBlue){
        self.episodeDataUrl = episodeDataUrl
        self.borderColor = borderColor
    }
    
    //MARK: - public
    
    public func registerForData(_ block : @escaping (RMEpisodeDataRender) ->Void){
        
        self.dataBlock = block
    }

    public func fetchEpisode() {
        
        guard !isFetching else {
            if let model = episode {
                dataBlock?(model)
            }
            return
        }
        guard let url = episodeDataUrl ,
              let request = RMRequest(url: url) else {
                  return
              }
        isFetching = true
        
        RMService.shared.excute(request, expecting: RMEpisode.self) {
          [weak self]  result in
            
            switch result {
            case .success(let model):
                DispatchQueue.main.sync {
                    self?.episode = model
                }
            case .failure(let failure):
                print(String(describing: failure))

            }
        }
        
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(self.episodeDataUrl?.absoluteString ?? "")
    }
    
    static func == (lhs: RMEpisodeCellViewModel, rhs: RMEpisodeCellViewModel) -> Bool {
        return lhs.hashValue == rhs.hashValue
    }
}
