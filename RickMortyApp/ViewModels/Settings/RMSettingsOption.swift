//
//  RMSettingsOption.swift
//  RickMortyApp
//
//  Created by Dhiman Das on 23/2/23.
//

import Foundation
import UIKit

enum RMSettingsOption : CaseIterable {
    
    case rateApp
    case contactUs
    case terms
    case privacy
    case apiReference
    case viewSeries
    case viewCode
    
    var targetUrl : URL? {
        switch self {
        case .rateApp:
            return nil
        case .contactUs:
            return URL(string: "https://github.com/dhiman10/RickMontryApp")
        case .terms:
            return nil
        case .privacy:
            return nil
        case .apiReference:
            return URL(string: "https://rickandmortyapi.com/")
        case .viewSeries:
            return nil
        case .viewCode:
            return URL(string: "https://github.com/dhiman10/RickMontryApp")

        }
    }
    
    var displayTitle : String {
    
        switch self {
        case .rateApp:
            return "Rate App"
        case .contactUs:
            return "Contact Us"
        case .terms:
            return "Terms of Service"
        case .privacy:
            return "Privacy Policy"
        case .apiReference:
            return "API reference"
        case .viewSeries:
            return "View Video series"
        case .viewCode:
            return "View App code"

        }
        
    }
    
    var iconContainerColor : UIColor {
        switch self {
        case .rateApp:
            return .systemBlue
        case .contactUs:
            return .systemRed
        case .terms:
            return .systemGreen
        case .privacy:
            return .systemYellow
        case .apiReference:
            return .systemOrange
        case .viewSeries:
            return .systemPurple
        case .viewCode:
            return .systemIndigo
        }
    }
    
    
    
    var iconImage : UIImage? {
        switch self {
        case .rateApp:
            return UIImage(systemName: "star.fill")
        case .contactUs:
            return UIImage(systemName: "paperplane")
        case .terms:
            return UIImage(systemName: "doc")
        case .privacy:
            return UIImage(systemName: "lock")
        case .apiReference:
            return UIImage(systemName: "paperplane")
        case .viewSeries:
            return UIImage(systemName: "tv.fill")
        case .viewCode:
            return UIImage(systemName: "hammer.fill")
        }
    }
    
    
}
