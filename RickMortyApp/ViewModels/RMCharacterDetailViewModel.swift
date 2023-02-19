//
//  RMCharacterDetailViewModel.swift
//  RickMortyApp
//
//  Created by Dhiman Das on 18/2/23.
//

import Foundation

final class RMCharacterDetailViewModel {
    
    private let character : RMCharacter
    
    init(character : RMCharacter) {
        self.character = character
    }
    
    public var title : String {
        character.name.uppercased()
    }
}
