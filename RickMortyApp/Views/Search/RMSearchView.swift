//
//  RMSearchView.swift
//  RickMortyApp
//
//  Created by Dhiman Das on 26/2/23.
//

import Foundation
import UIKit

protocol RMSearchViewDelegate : AnyObject {
    func rmSearchView(_ searchView: RMSearchView , didSelectOption option : RMSearchInputViewViewModel.DynamicOption)
}

final class RMSearchView : UIView {
    
    let viewModel : RMSearchViewViewModel
    
    public var delegate : RMSearchViewDelegate?
    
    private let searchInputView = RMSearchInputView()
    
    private let noresultsView = RMNoSearchResultsView()
    
    //MARK: - Init
    init(frame: CGRect, viewModel : RMSearchViewViewModel){
        self.viewModel = viewModel
        super.init(frame: frame)
        translatesAutoresizingMaskIntoConstraints = false
        addSubviews(noresultsView, searchInputView)
        addConstraints()
        searchInputView.confiqure(with: RMSearchInputViewViewModel(type: viewModel.confiq.type))
        searchInputView.delegate = self
        viewModel.registerOptionChangedBlock {
            touple in
            self.searchInputView.update(option: touple.0, value: touple.1)
            
            
        }
    }
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    private func addConstraints() {
  
        NSLayoutConstraint.activate([
            
            searchInputView.topAnchor.constraint(equalTo: topAnchor),
            searchInputView.leftAnchor.constraint(equalTo: leftAnchor),
            searchInputView.rightAnchor.constraint(equalTo: rightAnchor),
            searchInputView.heightAnchor.constraint(equalToConstant: viewModel.confiq.type == .episode ? 55 :110),


            noresultsView.heightAnchor.constraint(equalToConstant: 150),
            noresultsView.widthAnchor.constraint(equalToConstant: 150),
            noresultsView.centerXAnchor.constraint(equalTo: centerXAnchor),
            noresultsView.centerYAnchor.constraint(equalTo: centerYAnchor),

        ])
        
    }
    
    public func presentKeyboard() {
        searchInputView.presentKeyboard()
    }

    
}

//MARK: - UICollectionView

extension RMSearchView : UICollectionViewDelegate, UICollectionViewDataSource {
    
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 0

    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        return UICollectionViewCell()
        
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
    }
    
}

//MARK: - RMsearchInputViewDelegate

extension RMSearchView :  RMsearchInputViewDelegate {
    
    func rmSearchInputView(_ inputView: RMSearchInputView, didSelectOption option: RMSearchInputViewViewModel.DynamicOption) {

        delegate?.rmSearchView(self, didSelectOption: option)
    }
    
    
    
}
