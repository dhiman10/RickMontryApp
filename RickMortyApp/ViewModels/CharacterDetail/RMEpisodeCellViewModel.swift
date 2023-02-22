//
//  RMDetailEpisodeViewModel.swift
//  RickMortyApp
//
//  Created by Dhiman Das on 19/2/23.
//

import Foundation

protocol RMEpisodeDataRender {
    
    var name : String {get }
    var air_date : String {get }
    var episode : String {get }

}

final class RMEpisodeCellViewModel {
    
    private let episodeDataUrl : URL?
    
    private var isFetching = false
    private var dataBlock : ((RMEpisodeDataRender)->Void)?
    
    private var episode : RMEpisode? {
        didSet {
            guard let model = episode else {
                return
            }
            dataBlock?(model)
        }
    }
    
    //MARK: - Init
    init(episodeDataUrl : URL?){
        self.episodeDataUrl = episodeDataUrl
    }
    
    //MARK: - public
    
    public func registerForData(_ block : @escaping (RMEpisodeDataRender) ->Void){
        
        //print(block)
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
            result in
            
            switch result {
            case .success(let model):
                DispatchQueue.main.sync {
                    self.episode = model
                }
            case .failure(let failure):
                print(String(describing: failure))

            }
        }
        
    }
}
