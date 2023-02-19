//
//  RMCharacterDetailViewController.swift
//  RickMortyApp
//
//  Created by Dhiman Das on 18/2/23.
//

import UIKit

/// Controller to show info about single Character
final class RMCharacterDetailViewController: UIViewController {
    
    private let viewModel : RMCharacterDetailViewModel
    
    init(viewModel : RMCharacterDetailViewModel)
    {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)

    }
    required init?(coder: NSCoder) {
        fatalError("Unsupported")
    }

    //MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .purple
        title = viewModel.title

        // Do any additional setup after loading the view.
    }
    


}
