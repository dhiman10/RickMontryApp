//
//  RMLocationViewController.swift
//  RickMortyApp
//
//  Created by Dhiman Das on 17/2/23.
//

import UIKit

/// Controller to show and search for Locations

final class RMLocationViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.view.backgroundColor = .systemBackground

        title = "Location"
        addSearchbutton()

    }
    
    private func addSearchbutton() {
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .search, target: self, action: #selector(didTapSearch))
    }
    
    @objc private func didTapSearch() {
        
        let vc = RMSearchViewController(config: RMSearchViewController.Config(type: .character))
        vc.navigationItem.largeTitleDisplayMode = .never
        navigationController?.pushViewController(vc, animated: true)
        
    }


}
