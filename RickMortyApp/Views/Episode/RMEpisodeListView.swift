//
//  CharacterListView.swift
//  RickMortyApp
//
//  Created by Dhiman Das on 18/2/23.
//

import Foundation
import UIKit

protocol RMEpisodeListViewDelegate : AnyObject {
    func rmEpisodeListView(_ CharacterListView : RMEpisodeListView,
                             didSelectEpisode episode : RMEpisode)
}
/// View that handles showing list of Episodes , loaded etc
final class RMEpisodeListView : UIView {
    
    public weak var delegate : RMEpisodeListViewDelegate?
    
    private let viewModel = RMEpisodeListViewViewModel()
    
    private let spinner : UIActivityIndicatorView = {
        let spinner = UIActivityIndicatorView(style: .large)
        spinner.hidesWhenStopped = true
        spinner.translatesAutoresizingMaskIntoConstraints = false
        
       return spinner
    }()
    
    private let collectionView : UICollectionView = {
       let layout = UICollectionViewFlowLayout()
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.isHidden = true
        layout.scrollDirection = .vertical
        layout.sectionInset = UIEdgeInsets(top: 0, left: 10, bottom: 10, right: 10)
        collectionView.alpha = 0.0
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.register(RMEpisodeCollectionViewCell.self, forCellWithReuseIdentifier: RMEpisodeCollectionViewCell.cellIdentifier)
        collectionView.register(RMFooterLoadingCharacterCollectionReusableView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter, withReuseIdentifier: RMFooterLoadingCharacterCollectionReusableView.identifier)
        
        return collectionView
        
    }()
    
    //MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        translatesAutoresizingMaskIntoConstraints = false
        addSubviews(collectionView,spinner)
        addConstraints()
        spinner.startAnimating()
        viewModel.fectchEpisode()
        viewModel.delegate = self
        setUpcollectionView()
        
    }
    required init?(coder: NSCoder) {
        fatalError("unsupported")
    }
    
    private func addConstraints() {
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
    
    private func setUpcollectionView (){
        
        self.collectionView.dataSource = viewModel
        self.collectionView.delegate = viewModel
        
//        DispatchQueue.main.asyncAfter(deadline: .now() + 2, execute: {
//
//            self.spinner.startAnimating()
//            self.collectionView.isHidden = false
//            UIView.animate(withDuration: 0.4) {
//                self.collectionView.alpha = 1.0
//                self.spinner.alpha = 0.0
//                self.spinner.stopAnimating()
//
//            }
//        })

    }
    
    
}

extension RMEpisodeListView : RMEpisodeListViewModelDelegate {


    
    
    func didLoadInitialEpisode() {
        spinner.stopAnimating()
        collectionView.reloadData()
        collectionView.isHidden = false
        
        UIView.animate(withDuration: 0.4) {
            self.collectionView.alpha = 1.0
        }
    }
    
    func didLoadMoreEpisode(with newIndexPath: [IndexPath]) {
        
        collectionView.performBatchUpdates {
            self.collectionView.insertItems(at: newIndexPath)
            //self.collectionView.reloadData()
        }
    }
    
    
    func didSelectEpisodes(_ episode: RMEpisode) {
        delegate?.rmEpisodeListView(self, didSelectEpisode: episode)
    }
}
