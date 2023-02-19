//
//  CharacterListViewModel.swift
//  RickMortyApp
//
//  Created by Dhiman Das on 18/2/23.
//

import Foundation
import UIKit

protocol RMCharacterListViewModelDelegate : AnyObject {
    func didLoadInitialCharacters()
    func didSelectCharacter(_ character : RMCharacter)
    func didLoadMoreCharacter(with newIndexPath : [IndexPath])

}
/// ViewModel to handle Character list View logic
final class RMCharacterListViewModel : NSObject {
    
    public weak var delegate: RMCharacterListViewModelDelegate?
    
    private var isLoadingCharcters = false
    
    private var characters: [RMCharacter] = [] {
        didSet {
            for character in characters {
                let viewModel = RMcharterCollectionViewCellViewModel(characterName: character.name, characterStatus: character.status, characterImageUrl: URL(string: character.image))
                
                if !cellViewModels.contains(viewModel) {
                cellViewModels.append(viewModel)
                }
                else {
                   // print("Found object")
                }
            }
        }
    }
    
    
    private var cellViewModels: [RMcharterCollectionViewCellViewModel] = []
    
    private var apiInfo: RMGetAllCharactersResponse.Info? = nil

    
    /// Fetch intial set of characters(20)
    public func fectchCharacter() {
        
        RMService.shared.excute(.listCharactersRequest, expecting: RMGetAllCharactersResponse.self) { [weak self]
            result in

            switch result {
            case .success(let responseModel):
                let results = responseModel.results
                self?.characters = results
                self?.apiInfo = responseModel.info
                DispatchQueue.main.async {
                    self?.delegate?.didLoadInitialCharacters()
                }
            case .failure(let error):
                print(String(describing: error))

            }
        }

    }
    
    /// Prepare if Additionlas charcters are needed
    public func fetchAdditionalCharacter(url : URL) {
        
        guard !isLoadingCharcters else {
            return
        }
        isLoadingCharcters = true
        
        print("Fetching more characters")
        guard let request = RMRequest(url: url) else {
            isLoadingCharcters = false
            print("failed to create request")
            return
        }
       // print(request.url)
    
        RMService.shared.excute(request, expecting: RMGetAllCharactersResponse.self) { [weak self] result in
            
            guard let strongSelf = self else {
                return
            }
            switch result {
            case .success(let responseModel):
                
                let moreresults = responseModel.results
                let info = responseModel.info
                strongSelf.apiInfo = info
                let orginalCount = strongSelf.characters.count
                let newCount = moreresults.count
                let totaCount = orginalCount + newCount
                let startingIndex = totaCount - newCount


                let inDexpathToadd :[IndexPath] = Array(startingIndex..<(startingIndex + newCount)).compactMap({
                    return IndexPath(row: $0, section: 0)
                })
                
                self?.characters.append(contentsOf: moreresults)
                
               // Thread.sleep(forTimeInterval: 1.0)

                DispatchQueue.main.async {
                    strongSelf.delegate?.didLoadMoreCharacter(with: inDexpathToadd)
                   // strongSelf.isLoadingCharcters = false

                }
                strongSelf.isLoadingCharcters = false


            case .failure(let error):
                print(String(describing: error))
                strongSelf.isLoadingCharcters = false

            }
        }

    }
    
    public var shouldShowLoadMoreIndicator  : Bool {
        return self.apiInfo != nil
    }

}

//MARK: - CollectionView

extension RMCharacterListViewModel : UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return cellViewModels.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
       guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: RMCharacterCollectionViewCell.cellIdentifier, for: indexPath) as? RMCharacterCollectionViewCell else {
            fatalError("Unsupported cell")
        }
        let viewModel = cellViewModels[indexPath.row]
        cell.configure(with: viewModel)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let bounds = UIScreen.main.bounds
        let width = (bounds.width - 30)/2
        return CGSize(width: width, height: width*1.5)
        
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {

        guard kind == UICollectionView.elementKindSectionFooter, let footer = collectionView.dequeueReusableSupplementaryView( ofKind : kind, withReuseIdentifier: RMFooterLoadingCharacterCollectionReusableView.identifier, for: indexPath) as? RMFooterLoadingCharacterCollectionReusableView else {
            fatalError("Unsuppoted UICollectionReusableView")

        }
        
        footer.startAnimatiing()
        
        return footer
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
        
        guard shouldShowLoadMoreIndicator else {
            return .zero
        }
        
        return CGSize(width: collectionView.frame.width, height: 100)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        let character = characters[indexPath.row]
        delegate?.didSelectCharacter(character)
    }
    
}

//MARK: - UIScrollView

extension RMCharacterListViewModel : UIScrollViewDelegate {
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        guard shouldShowLoadMoreIndicator ,
                !isLoadingCharcters ,
                !cellViewModels.isEmpty,
                let nexturl = apiInfo?.next,
                let url = URL(string: nexturl) else {
            return
        }
        
        
        Timer.scheduledTimer(withTimeInterval: 0.0, repeats: false) {
            [weak self] t in
                
                let offset = scrollView.contentOffset.y
                let totalContentheight = scrollView.contentSize.height
                let scrollViewfixedHeight = scrollView.frame.size.height
                
                if offset >= (totalContentheight - scrollViewfixedHeight - 120) {
                    self?.fetchAdditionalCharacter(url: url)
                }
            t.invalidate()
        }
        
        
    }
}
