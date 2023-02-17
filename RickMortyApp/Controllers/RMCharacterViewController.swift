//
//  RMCharacterViewController.swift
//  RickMortyApp
//
//  Created by Dhiman Das on 17/2/23.
//

import UIKit

/// Controller to show and search for Characters

final class RMCharacterViewController : UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.view.backgroundColor = UIColor.green
        
        let request = RMRequest(endPoint: .character)
        print(request.url)

    }
}
