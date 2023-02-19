//
//  RMFooterLoadingCharacterCollectionReusableView.swift
//  RickMortyApp
//
//  Created by Dhiman Das on 18/2/23.
//

import UIKit

class RMFooterLoadingCharacterCollectionReusableView: UICollectionReusableView {
        
    static let identifier = "RMFooterLoadingCharacterCollectionReusableView"
    
    private let spinner : UIActivityIndicatorView = {
        let spinner = UIActivityIndicatorView(style: .large)
        spinner.hidesWhenStopped = true
        spinner.translatesAutoresizingMaskIntoConstraints = false
        
       return spinner
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .systemBackground
        addSubview(spinner)
        addconstaints()
    }
    required init?(coder: NSCoder) {
        fatalError("unsupported")
    }


    private func addconstaints() {
        
        NSLayoutConstraint.activate([
            spinner.widthAnchor.constraint(equalToConstant: 100),
            spinner.heightAnchor.constraint(equalToConstant: 100),
            spinner.centerXAnchor.constraint(equalTo: centerXAnchor),
            spinner.centerYAnchor.constraint(equalTo: centerYAnchor),
        
        ])
    }
    
    public func startAnimatiing () {
        spinner.startAnimating()
    }
    
}
