//
//  RMLocationViewController.swift
//  RickMortyApp
//
//  Created by Dhiman Das on 17/2/23.
//

import UIKit

/// Controller to show and search for Locations

final class RMLocationViewController: UIViewController, RMLocationViewViewModelDelegate , RMLocationViewDelegate{
    
    private let primaryView = RMLoactionView()

    private let viewModel = RMLocationViewModel()
    
    //MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .systemBackground
        primaryView.delegate = self
        view.addSubview(primaryView)
        title = "Location"
        addSearchbutton()
        addConstraints()
        viewModel.delegate = self
        viewModel.fetchLocations()


    }
    
    private func addSearchbutton() {
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .search, target: self, action: #selector(didTapSearch))
    }
    
    private func addConstraints() {
        NSLayoutConstraint.activate([
            primaryView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            primaryView.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor),
            primaryView.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor),
            primaryView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
        
    
    }
    
    @objc private func didTapSearch() {
        
        let vc = RMSearchViewController(config: RMSearchViewController.Config(type: .location))
        vc.navigationItem.largeTitleDisplayMode = .never
        navigationController?.pushViewController(vc, animated: true)
        
    }
    
    //MARK: - RMLocationViewDelegate

    func rmLocationView(_ locationView: RMLoactionView, didSelect location: RMLocation) {
        let vc = RMLocationDetailViewController(location: location)
        vc.navigationItem.largeTitleDisplayMode = .never
        navigationController?.pushViewController(vc, animated: true)
    }
    
    //MARK: - RMLocationViewViewModelDelegate
    
    func didFectchInitialLocations() {
        
        primaryView.configure(with: viewModel)
    }


}
