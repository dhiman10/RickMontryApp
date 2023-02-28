//
//  RMSearchViewModel.swift
//  RickMortyApp
//
//  Created by Dhiman Das on 26/2/23.
//

import Foundation

final class RMSearchViewViewModel {
    
    let confiq : RMSearchViewController.Config
    
    private var optionMap :[RMSearchInputViewViewModel.DynamicOption : String] = [:]
    private var searchText = ""
    
    private var optionMapUpdatesBlock : (((RMSearchInputViewViewModel.DynamicOption, String))-> Void)?
  
    private var searchResultHander : (() ->Void)?
    
    //MARK: - init
    init(confiq : RMSearchViewController.Config) {
        self.confiq = confiq
      
    }
    
    public func registerSearchResultHandler(_ block : @escaping () -> Void) {
        self.searchResultHander = block
    }
    //MARK: - Public
    
    public func excuteSearch() {
        
    //https://rickandmortyapi.com/api/character/?name=rick&status=alive
        
        //Search text
        searchText = "Rick"
        
        // Build arguments
     var queryParams: [URLQueryItem] = [
         URLQueryItem(name: "name", value: searchText)
     ]
        // Add options

        let queryParameters : [URLQueryItem] =  optionMap.enumerated().compactMap({ _ , element in
            let key : RMSearchInputViewViewModel.DynamicOption = element.key
            let value : String = element.value
            return URLQueryItem(name: key.queryArument, value: value)
        })
        
        queryParams.append(contentsOf: queryParameters)
        
        //Create request

        let request = RMRequest(
            endPoint: confiq.type.endpoint,
            queryParameters: queryParams
        )
        
        print(request.url?.absoluteURL)
        // Create API Call
        RMService.shared.excute(request, expecting: RMGetAllCharactersResponse.self){
            result in
            
            switch result {
            case .success(let model):
                print(model.results.count)
            case .failure:
                break
            }
            
        }
        
        

    }
    
    public func set(query text : String){
        self.searchText = text
    }
    
    public func set (value : String , for option : RMSearchInputViewViewModel.DynamicOption){
        
        optionMap[option] = value
        
        let touple = (option, value)
        optionMapUpdatesBlock?(touple)
    }
    
    public func registerOptionChangedBlock(_ block: @escaping ((RMSearchInputViewViewModel.DynamicOption, String))-> Void) {
        
        self.optionMapUpdatesBlock = block
    }

    
}
