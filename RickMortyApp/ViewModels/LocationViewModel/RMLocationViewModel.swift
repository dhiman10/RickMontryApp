//
//  RMLocationViewModel.swift
//  RickMortyApp
//
//  Created by Dhiman Das on 25/2/23.
//

import Foundation

protocol RMLocationViewViewModelDelegate : AnyObject {
    func didFectchInitialLocations()
}

final class RMLocationViewModel {
    
    weak var delegate: RMLocationViewViewModelDelegate?
    private var locations: [RMLocation] = [] {
        
        didSet {
            for location in locations {
                let cellViewModel = RMLocationTableViewCellViewModel(location: location)
                if !cellViewModels.contains(cellViewModel) {
                    cellViewModels.append(cellViewModel)

                }
            }
        }
    }
    
    public private(set) var cellViewModels: [RMLocationTableViewCellViewModel] = []

    private var apiInfo : RMGetAllLoactionsResponse.Info?
    
    init() {
        
    }
    
    public func location(at index : Int)-> RMLocation? {
        
        guard index < locations.count && index >= 0 else {
            return nil
        }
        return self.locations[index]
    }
    
    public func fetchLocations () {
        RMService.shared.excute(.listLocationRequest, expecting: RMGetAllLoactionsResponse.self) { [weak self] result in
            //print(result)
            switch result {
            case .success(let model):
                self?.apiInfo = model.info
                self?.locations = model.results
                DispatchQueue.main.async {
                    self?.delegate?.didFectchInitialLocations()
                }
            case .failure:
                break
            }
            
        }
        
    }
    
    private var hasMoreResutls : Bool {
        return false
    }
}
