//
//  RMCharacterDetailView.swift
//  RickMortyApp
//
//  Created by Dhiman Das on 18/2/23.
//

import UIKit

/// View for single Character
final class RMCharacterDetailView: UIView {

    public var collectionView : UICollectionView?
    
    private let viewModel : RMCharacterDetailViewModel
    
    private let spinner : UIActivityIndicatorView = {
        let spinner = UIActivityIndicatorView(style: .large)
        spinner.hidesWhenStopped = true
        spinner.translatesAutoresizingMaskIntoConstraints = false
        
       return spinner
    }()
    
    //MARK: - Init
    
     init(frame: CGRect, viewModel : RMCharacterDetailViewModel) {
         self.viewModel = viewModel
        super.init(frame: frame)
        translatesAutoresizingMaskIntoConstraints = false
        let collectionView = createCollectionView()
        self.collectionView = collectionView
        addSubviews(collectionView,spinner)
        addConstrints()
    }
    required init?(coder: NSCoder) {
        fatalError("unsupported")
    }
    
    private func addConstrints() {
        
        guard let collectionView = collectionView else {
            return
        }
        
        NSLayoutConstraint.activate([
            spinner.widthAnchor.constraint(equalToConstant: 100),
            spinner.heightAnchor.constraint(equalToConstant: 100),
            spinner.centerXAnchor.constraint(equalTo: centerXAnchor),
            spinner.centerYAnchor.constraint(equalTo: centerYAnchor),
            
            collectionView.topAnchor.constraint(equalTo: topAnchor),
            collectionView.leftAnchor.constraint(equalTo: leftAnchor),
            collectionView.rightAnchor.constraint(equalTo: rightAnchor),
            collectionView.bottomAnchor.constraint(equalTo: bottomAnchor),
        
        ])
    }
    
    private func createCollectionView() -> UICollectionView {
        let layout = UICollectionViewCompositionalLayout{sectionIndex , _ in
            return self.createSection(for: sectionIndex)
        }
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.register(RMDetailPhotoCollectionViewCell.self, forCellWithReuseIdentifier: RMDetailPhotoCollectionViewCell.cellIdentifier)
        collectionView.register(RMDetailInfoCollectionViewCell.self, forCellWithReuseIdentifier: RMDetailInfoCollectionViewCell.cellIdentifier)
        collectionView.register(RMDetailEpisodeCollectionViewCell.self, forCellWithReuseIdentifier: RMDetailEpisodeCollectionViewCell.cellIdentifier)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        return collectionView
    }


    //MARK: - createSection
    private func createSection(for sectionIndex : Int) -> NSCollectionLayoutSection{
        
        let secTypes = viewModel.sections
        
        switch secTypes[sectionIndex] {
        case .photo :
            return viewModel.createPhotoSectionLayout()
        case .information :
            return viewModel.createInfoSectionLayout()
        case .episodes :
            return viewModel.createElisodesSectionLayout()
        }
    }
    
   

}
