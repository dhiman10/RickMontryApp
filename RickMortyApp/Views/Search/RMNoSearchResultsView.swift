//
//  RMNoSearchResultsView.swift
//  RickMortyApp
//
//  Created by Dhiman Das on 26/2/23.
//

import UIKit

final class RMNoSearchResultsView: UIView {
    
    private let viewModel = RMNoSearchResultsViewViewModel()
    
    private let iconView : UIImageView = {
        let iconView = UIImageView()
        iconView.contentMode = .scaleAspectFit
        iconView.tintColor = .systemBlue
        iconView.translatesAutoresizingMaskIntoConstraints = false
        return iconView
    }()
    
    private let label : UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.font = .systemFont(ofSize: 20, weight: .medium)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    //MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        isHidden = true
        translatesAutoresizingMaskIntoConstraints = false
        //backgroundColor = UIColor.purple
        addSubviews(iconView, label)
        addConstraints()
        confiq()
    }
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    private func confiq() {
        label.text = viewModel.title
        iconView.image = viewModel.image
    }

    
    private func addConstraints() {
  
        NSLayoutConstraint.activate([
            
            iconView.widthAnchor.constraint(equalToConstant: 90),
            iconView.heightAnchor.constraint(equalToConstant: 90),
            iconView.topAnchor.constraint(equalTo: topAnchor),
            iconView.centerXAnchor.constraint(equalTo: centerXAnchor),

            label.leftAnchor.constraint(equalTo: leftAnchor),
            label.rightAnchor.constraint(equalTo: rightAnchor),
            label.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -10),
            label.heightAnchor.constraint(greaterThanOrEqualToConstant: 40),
           // label.topAnchor.constraint(equalTo: iconView.bottomAnchor, constant: 10),

            
            
        ])
        
//        label.backgroundColor = UIColor.red
//        iconView.backgroundColor = UIColor.yellow


    }

}
