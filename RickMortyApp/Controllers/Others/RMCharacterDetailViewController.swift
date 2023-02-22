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
    private let detailView : RMCharacterDetailView
    
    
    init(viewModel : RMCharacterDetailViewModel)
    {
        self.viewModel = viewModel
        self.detailView = RMCharacterDetailView(frame: .zero, viewModel: viewModel)
        super.init(nibName: nil, bundle: nil)

    }
    required init?(coder: NSCoder) {
        fatalError("Unsupported")
    }

    //MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        title = viewModel.title
        view.addSubview(detailView)
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .action, target: self, action: #selector(didTapShare))
        
        addConstraints()
        
        detailView.collectionView?.delegate = self
        detailView.collectionView?.dataSource = self
        
    
    }
    @objc private func didTapShare() {
        
    }
    
    private func addConstraints() {
        
        NSLayoutConstraint.activate([
            detailView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            detailView.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor),
            detailView.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor),
            detailView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        
        ])
    }
    
}
//MARK: - CollectionView

extension RMCharacterDetailViewController : UICollectionViewDelegate , UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        viewModel.sections.count
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {

        let sectionType = viewModel.sections[section]
        
        switch sectionType {
        case .photo :
            return 1
        case .information(let viewModels) :
            return viewModels.count
        case .episodes(let viewModels):
            return viewModels.count

        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
 
        
        let sectionType = viewModel.sections[indexPath.section]
        switch sectionType {
        case .photo(let viewModel) :
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: RMDetailPhotoCollectionViewCell.cellIdentifier, for: indexPath) as? RMDetailPhotoCollectionViewCell else {
                fatalError()
            }
            cell.confiqure(with: viewModel)

            return cell
            
        case .information(let viewModels) :
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: RMDetailInfoCollectionViewCell.cellIdentifier, for: indexPath) as? RMDetailInfoCollectionViewCell else {
                fatalError()
            }
            cell.confiqure(with: viewModels[indexPath.row])
            return cell
        case .episodes(let viewModels):

            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: RMDetailEpisodeCollectionViewCell.cellIdentifier, for: indexPath) as? RMDetailEpisodeCollectionViewCell else {
                fatalError()
            }
            cell.confiqure(with: viewModels[indexPath.row])
            //cell.backgroundColor = .green
            return cell
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        print("didSelectItemAt")
        
        let sectionType = viewModel.sections[indexPath.section]
        print(viewModel.episodes.count)
        
        switch sectionType {
        case .photo ,.information :
            break
        case .episodes:
            let episodes = self.viewModel.episodes
            let selection = episodes[indexPath.row]
            let vc = RMEpisodeDetailViewController(url: URL(string: selection))
            navigationController?.pushViewController(vc, animated: true)
        }
        
    }
    
  
}
