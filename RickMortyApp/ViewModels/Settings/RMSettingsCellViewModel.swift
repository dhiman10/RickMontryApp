//
//  RMSettingsCellViewModel.swift
//  RickMortyApp
//
//  Created by Dhiman Das on 23/2/23.
//

import Foundation
import UIKit
struct RMSettingsCellViewModel : Identifiable {
    
    let id = UUID()
    public let type : RMSettingsOption
    public let onTaphander : (RMSettingsOption)-> Void


    
    //MARK: - Init
    init(type : RMSettingsOption, onTapHander :@escaping(RMSettingsOption)-> Void){
        self.type = type
        self.onTaphander = onTapHander
    }
    
    //MARK: - public

    
    public var image : UIImage? {
        return type.iconImage
    }
    public var title: String {
        return type.displayTitle
    }
    
    public var iconContainerColor : UIColor
    {
        return type.iconContainerColor
    }
    
  
}
