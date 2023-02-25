//
//  RMEpisodViewController.swift
//  RickMortyApp
//
//  Created by Dhiman Das on 17/2/23.
//

import UIKit

/// Controller to show and search for Episode

final class RMEpisodViewController: UIViewController, RMEpisodeListViewDelegate {

    
    private let episodeListView = RMEpisodeListView()

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.view.backgroundColor = .systemBackground
        title = "Episode"
        
        setUpView()
        addSearchbutton()
    }
    
    private func addSearchbutton() {
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .search, target: self, action: #selector(didTapSearch))
    }
    
    @objc private func didTapSearch() {
        
    }
    
    func setUpView() {
        
        view.addSubview(episodeListView)
        episodeListView.delegate = self
        NSLayoutConstraint.activate([
            episodeListView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            episodeListView.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor),
            episodeListView.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor),
            episodeListView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        
        ])
    }
    //MARK: - RMEpisodeListViewDelegate
 
    func rmEpisodeListView(_ CharacterListView: RMEpisodeListView, didSelectEpisode episode: RMEpisode) {
        
        let detailVc = RMEpisodeDetailViewController(url: URL(string: episode.url))
        detailVc.navigationItem.largeTitleDisplayMode = .never
        navigationController?.pushViewController(detailVc, animated: true)
    }
    

}
