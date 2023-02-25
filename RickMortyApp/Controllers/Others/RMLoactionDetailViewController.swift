//
//  RMLoactionDetailViewController.swift
//  RickMortyApp
//
//  Created by Dhiman Das on 25/2/23.
//

import UIKit

final class RMLocationDetailViewController: UIViewController, RMLocationDetailViewModelDelegate, RMLocationDetailViewDelegate {

    
 
    
    private let viewModel : RMLocationDetailViewViewModel
    
    private let detailView = RMLocationDetailView()
    //MARK: - Init
    
    init(location: RMLocation){
        let url = URL(string: location.url)
        self.viewModel = RMLocationDetailViewViewModel(endPointUrl: url)
        super.init(nibName: nil, bundle: nil)
    }
    required init?(coder: NSCoder) {
        fatalError()
    }
    //MARK: - LifeCycle

    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubviews(detailView)
        addConstraints()
        detailView.delegate = self

        title = "Location"
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .action, target: self, action: #selector(didTapShare))
        
        viewModel.delegate = self
        viewModel.fetchLocationData()
    }
    
    func addConstraints() {
        
        detailView.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            detailView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            detailView.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor),
            detailView.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor),
            detailView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
        ])
        
    }
    
    @objc private func didTapShare() {
        
    }
    
  
    //MARK: - ViewDelegate

    func didFetchLocationDetails() {
        
        detailView.confiqure(with: viewModel)
    }
    
    func rmLocationDetailView(_ detailView: RMLocationDetailView, didSelect character: RMCharacter) {
        let vc = RMCharacterDetailViewController(viewModel: .init(character: character))
        vc.title = character.name
        vc.navigationItem.largeTitleDisplayMode = .never
        navigationController?.pushViewController(vc, animated: true)
    }
    
    
    
}

