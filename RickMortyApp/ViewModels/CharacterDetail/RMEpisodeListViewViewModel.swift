//
//  RMEpisodeLIstViewViewModel.swift
//  RickMortyApp
//
//  Created by Dhiman Das on 22/2/23.
//

import Foundation
import UIKit

protocol RMEpisodeListViewModelDelegate : AnyObject {
    func didLoadInitialEpisode()
    func didSelectEpisodes(_ episode : RMEpisode)
    func didLoadMoreEpisode(with newIndexPath : [IndexPath])

}
/// ViewModel to handle Episode list View logic
final class RMEpisodeListViewViewModel : NSObject {
    
    public weak var delegate: RMEpisodeListViewModelDelegate?
    
    private var isLoadingCharcters = false
    
    private let borderColors : [UIColor] = [
        .systemGreen,
        .systemBlue,
        .systemOrange,
        .systemPink,
        .systemPurple,
        .systemYellow,
        .systemIndigo,
    ]
    
    private var episodes: [RMEpisode] = [] {
        didSet {
            for episode in episodes {
                let viewModel = RMEpisodeCellViewModel(
                    episodeDataUrl: URL(string: episode.url),
                    borderColor: borderColors.randomElement() ?? .systemBlue
                )
                
                if !cellViewModels.contains(viewModel) {
                cellViewModels.append(viewModel)
                }
                else {
                   // print("Found object")
                }
            }
        }
    }
    
    
    private var cellViewModels: [RMEpisodeCellViewModel] = []
    
    private var apiInfo: RMGetAllEpisodeResponse.Info? = nil

    
    /// Fetch intial set of Episode(s20)
    public func fectchEpisode() {
        
        RMService.shared.excute(.listEpisodeRequest, expecting: RMGetAllEpisodeResponse.self) { [weak self]
            result in

            switch result {
            case .success(let responseModel):
                let results = responseModel.results
                self?.episodes = results
                self?.apiInfo = responseModel.info
                DispatchQueue.main.async {
                    self?.delegate?.didLoadInitialEpisode()
                }
            case .failure(let error):
                print(String(describing: error))

            }
        }

    }
    
    /// Prepare if Additionlas Episodes are needed
    public func fetchAdditionalEpisodes(url : URL) {
        
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
    
        RMService.shared.excute(request, expecting: RMGetAllEpisodeResponse.self) { [weak self] result in
            
            guard let strongSelf = self else {
                return
            }
            switch result {
            case .success(let responseModel):
                
                let moreresults = responseModel.results
                let info = responseModel.info
                strongSelf.apiInfo = info
                let orginalCount = strongSelf.episodes.count
                let newCount = moreresults.count
                let totaCount = orginalCount + newCount
                let startingIndex = totaCount - newCount


                let indexpathsToAdd :[IndexPath] = Array(startingIndex..<(startingIndex + newCount)).compactMap({
                    return IndexPath(row: $0, section: 0)
                })
                
                self?.episodes.append(contentsOf: moreresults)
                
               // Thread.sleep(forTimeInterval: 1.0)

                DispatchQueue.main.async {
                    strongSelf.delegate?.didLoadMoreEpisode(with: indexpathsToAdd)
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

extension RMEpisodeListViewViewModel : UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return cellViewModels.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
       guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: RMEpisodeCollectionViewCell.cellIdentifier, for: indexPath) as? RMEpisodeCollectionViewCell else {
            fatalError("Unsupported cell")
        }
        let viewModel = cellViewModels[indexPath.row]
        cell.confiqure(with: viewModel)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let bounds = collectionView.bounds
        let width = (bounds.width - 20)
        return CGSize(width: width, height: 100)
        
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
        let selection = episodes[indexPath.row]
        delegate?.didSelectEpisodes(selection)
    }
    
}

//MARK: - UIScrollView

extension RMEpisodeListViewViewModel : UIScrollViewDelegate {
    
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
                    self?.fetchAdditionalEpisodes(url: url)
                }
            t.invalidate()
        }
        
        
    }
}
