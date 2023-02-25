//
//  RMCharacterViewController.swift
//  RickMortyApp
//
//  Created by Dhiman Das on 17/2/23.
//

import UIKit

/// Controller to show and search for Characters

final class RMCharacterViewController : UIViewController , RMCharacterListViewDelegate{
    
    
    private let characterListView = RMCharacterListView()

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.view.backgroundColor = .systemBackground
        title = "Character"

        setUpView()
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
    
    func setUpView() {
        
        view.addSubview(characterListView)
        characterListView.delegate = self
        NSLayoutConstraint.activate([
            characterListView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            characterListView.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor),
            characterListView.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor),
            characterListView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        
        ])
    }
    //MARK: - RMCharacterListViewDelegate
    func rmCharacterListView(_ CharacterListView: RMCharacterListView, didSelectCharacter character: RMCharacter) {
        
        let viewModel = RMCharacterDetailViewModel(character: character)
        let detailVc = RMCharacterDetailViewController(viewModel: viewModel)
        detailVc.navigationItem.largeTitleDisplayMode = .never
        navigationController?.pushViewController(detailVc, animated: true)
        
    }
    

}
