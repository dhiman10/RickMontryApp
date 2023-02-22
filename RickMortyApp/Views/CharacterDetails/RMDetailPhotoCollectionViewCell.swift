//
//  RMPhotoCollectionViewCell.swift
//  RickMortyApp
//
//  Created by Dhiman Das on 19/2/23.
//

import UIKit

final class RMDetailPhotoCollectionViewCell: UICollectionViewCell {
    
    static let cellIdentifier = "RMDetailPhotoCollectionViewCell"
    
    //MARK: - Properties
    
    private let imageView : UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    //MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.addSubview(imageView)
        setUpConstraints()
    }
    required init?(coder: NSCoder) {
        fatalError()
    }
    

    override func prepareForReuse() {
        super.prepareForReuse()
        imageView.image = nil
    }
    
    private func setUpConstraints() {
        
        NSLayoutConstraint.activate([
        
            imageView.topAnchor.constraint(equalTo: contentView.topAnchor),
            imageView.leftAnchor.constraint(equalTo: contentView.leftAnchor),
            imageView.rightAnchor.constraint(equalTo: contentView.rightAnchor),
            imageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)

        ])
        
    }

    
    public func confiqure(with viewModel : RMPhotoCellViewModel) {
    
        viewModel.fetchImage { [weak self] result in
            
            switch result {
            case .success(let data) :
                DispatchQueue.main.async {
                    self?.imageView.image = UIImage(data: data)
                }
            case .failure :
                break
            }
        }
        
    }
    
}
