//
//  RMEpisodeDetailViewController.swift
//  RickMortyApp
//
//  Created by Dhiman Das on 22/2/23.
//

import UIKit


/// VC to show details about single Episode
final class RMEpisodeDetailViewController : UIViewController,RMEpisodeDetailViewModelDelegate {
    
    private let viewModel : RMEpisodeDetailViewViewModel
    
    private let detailView = RMEpisodeDetailView()
    //MARK: - Init
    
    init(url: URL?){
        self.viewModel = RMEpisodeDetailViewViewModel(endPointUrl: url)
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

        title = "Episode"
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .action, target: self, action: #selector(didTapShare))
        
        viewModel.delegate = self
        viewModel.fetchEpisodeData()
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
    
    //MARK: - Delegate
    func didFetchEpisodeDetails() {
        detailView.confiqure(with: viewModel)
    }
}

extension RMEpisodeDetailViewController : RMEpisodeDetailViewDelegate {
    
    func rmEpisodeDetailView(_ detailView: RMEpisodeDetailView, didSelect character: RMCharacter) {
        
        let vc = RMCharacterDetailViewController(viewModel: .init(character: character))
        vc.title = character.name
        vc.navigationItem.largeTitleDisplayMode = .never
        navigationController?.pushViewController(vc, animated: true)
        
    }
    
}
