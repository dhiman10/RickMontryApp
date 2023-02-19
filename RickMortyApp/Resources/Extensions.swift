//
//  Extensions.swift
//  RickMortyApp
//
//  Created by Dhiman Das on 18/2/23.
//

import Foundation
import UIKit

extension UIView {
    func addSubviews(_ views : UIView...) {
        views.forEach({
           addSubview($0)
        })
    }
    
}
