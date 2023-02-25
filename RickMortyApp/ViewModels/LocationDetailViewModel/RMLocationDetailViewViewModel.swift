//
//  File.swift
//  RickMortyApp
//
//  Created by Dhiman Das on 25/2/23.
//

import Foundation


//class RMLocationDetailViewViewModel


protocol RMLocationDetailViewModelDelegate : AnyObject {
    func didFetchLocationDetails()
}

final class RMLocationDetailViewViewModel {
    
    private let endPointUrl : URL?
    
    
    private var dataTuple :(location : RMLocation ,characters : [RMCharacter])? {
        
        didSet {
            createCellViewModels()
            delegate?.didFetchLocationDetails()
        }
    }
    
    enum sectionType {
        case information (viewModels : [RMEpisodeInfoCollectionViewCellViewModel])
        case characters(viewModel : [RMcharterCollectionViewCellViewModel])
    }
    
    public weak var delegate : RMLocationDetailViewModelDelegate?

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

    
    /// Fetch backing Location model

    public func fetchLocationData() {
        guard let url = endPointUrl, let request = RMRequest(url: url) else {
            return
        }
        RMService.shared.excute(request, expecting: RMLocation.self) { [weak self] result in
            
            switch result {
            case .success(let model):
                self?.fetchrelatedCharacters(location: model)
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
        let location = dataTuple.location
        let characters = dataTuple.characters
        
        var createdDateString = location.created
        if let date = RMInfoCellViewModel.dateFormatter.date(from: createdDateString) {
            createdDateString = RMInfoCellViewModel.shortDateFormatter.string(from: date)
        }
        
        
        cellViewModels = [
            .information(viewModels: [
                .init(title: "Location Name", value: location.name),
                .init(title: "Type", value: location.type),
                .init(title: "Dimension", value: location.dimension),
                .init(title: "Created", value: createdDateString ),
            ]),
            .characters(viewModel: characters.compactMap({character in
                return RMcharterCollectionViewCellViewModel(characterName: character.name, characterStatus: character.status, characterImageUrl: URL(string: character.image))
            }))
            
        ]

        
    }


    
    private func fetchrelatedCharacters(location : RMLocation) {
        
        let requests : [RMRequest] = location.residents.compactMap({
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
            self.dataTuple = (location : location ,
                              characters : characters)
        }
        
    }
}

