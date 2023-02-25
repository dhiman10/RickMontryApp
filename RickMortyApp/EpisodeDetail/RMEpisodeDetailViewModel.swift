//
//  RMEpisodeDetailViewModel.swift
//  RickMortyApp
//
//  Created by Dhiman Das on 22/2/23.
//

import UIKit

protocol RMEpisodeDetailViewModelDelegate : AnyObject {
    func didFetchEpisodeDetails()
}

final class RMEpisodeDetailViewViewModel {
    
    private let endPointUrl : URL?
    
    
    private var dataTuple :(episode : RMEpisode ,characters : [RMCharacter])? {
        
        didSet {
            createCellViewModels()
            delegate?.didFetchEpisodeDetails()
        }
    }
    
    enum sectionType {
        case information (viewModels : [RMEpisodeInfoCollectionViewCellViewModel])
        case characters(viewModel : [RMcharterCollectionViewCellViewModel])
    }
    
    public private(set) var cellViewModels : [sectionType] = []
    //MARK: - Init
    init(endPointUrl : URL?){
        self.endPointUrl = endPointUrl
    }
    
    //MARK: - Public
    
    public func  character(at index: Int) ->RMCharacter? {
        
        guard let dataTuple = dataTuple else {
            return nil
        }
        return dataTuple.characters[index]
        
    }

   public weak var delegate : RMEpisodeDetailViewModelDelegate?
    
    /// Fetch backing episode model

    public func fetchEpisodeData() {
        guard let url = endPointUrl, let request = RMRequest(url: url) else {
            return
        }
        RMService.shared.excute(request, expecting: RMEpisode.self) { [weak self] result in
            
            switch result {
            case .success(let model):
                self?.fetchrelatedCharacters(episode: model)
            case .failure:
                break
            }
            
        }
    
    }
    
    //MARK: - Private
    
    private func createCellViewModels() {
    
        guard let dataTuple = dataTuple else {
            return
        }
        let episode = dataTuple.episode
        let characters = dataTuple.characters
        
        var createdDateString = episode.created
        if let date = RMInfoCellViewModel.dateFormatter.date(from: createdDateString) {
            createdDateString = RMInfoCellViewModel.shortDateFormatter.string(from: date)
        }
        
        
        cellViewModels = [
            .information(viewModels: [
                .init(title: "Episode Name", value: episode.name),
                .init(title: "Air Date", value: episode.air_date),
                .init(title: "Episode", value: episode.episode),
                .init(title: "Created", value: createdDateString ),
            ]),
            .characters(viewModel: characters.compactMap({character in
                return RMcharterCollectionViewCellViewModel(characterName: character.name, characterStatus: character.status, characterImageUrl: URL(string: character.image))
            }))
            
        ]

        
    }


    
    private func fetchrelatedCharacters(episode : RMEpisode) {
        
        let requests : [RMRequest] = episode.characters.compactMap({
            return URL(string: $0)
        }).compactMap({
            return RMRequest(url: $0)
        })
        
        let group = DispatchGroup()
        var characters : [RMCharacter] = []
        
        for request in requests {
            group.enter()
            RMService.shared.excute(request, expecting: RMCharacter.self) { result in
                defer {
                    group.leave()
                }
                
                switch result {
                case .success(let model):
                    characters.append(model)
                case .failure:
                    break
                }
                
            }
            
        }
        
        group.notify(queue: .main){
            self.dataTuple = (episode : episode ,
                              characters : characters)
        }
        
    }
}
