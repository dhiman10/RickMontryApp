//
//  RMSearchInputView.swift
//  RickMortyApp
//
//  Created by Dhiman Das on 26/2/23.
//

import UIKit

protocol RMsearchInputViewDelegate : AnyObject {
    func rmSearchInputView(_ inputView: RMSearchInputView , didSelectOption option : RMSearchInputViewViewModel.DynamicOption)
}

class RMSearchInputView: UIView {

    weak var delegate : RMsearchInputViewDelegate?
    
    private let searchbar : UISearchBar = {
        let searchbar = UISearchBar()
        searchbar.placeholder = "Search"
        searchbar.translatesAutoresizingMaskIntoConstraints = false
        return searchbar
    }()
    
    private var viewModel : RMSearchInputViewViewModel? {
        
        didSet {
            guard let viewModel = viewModel , viewModel.hasDynamicOptions else {
                return
            }
            let options = viewModel.options
            createOptionsSelectionViews(options: options)
        }
    }
    
    private var stackView : UIStackView?
    
    //MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        translatesAutoresizingMaskIntoConstraints = false
         addSubviews(searchbar)
        addConstraints()

    }
    required init?(coder: NSCoder) {
        fatalError()
    }
    

    
    private func addConstraints() {
  
        NSLayoutConstraint.activate([
            
            searchbar.topAnchor.constraint(equalTo: topAnchor, constant: 3),
            searchbar.leftAnchor.constraint(equalTo: leftAnchor),
            searchbar.rightAnchor.constraint(equalTo: rightAnchor),
            searchbar.heightAnchor.constraint(equalToConstant: 55)
        ])
    }
    
     public func confiqure(with viewModel : RMSearchInputViewViewModel) {
        
        searchbar.placeholder = viewModel.searchPlaceholertext
         self.viewModel = viewModel
    }
    
    private func stackViewCreateOption() -> UIStackView {
        
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .horizontal
        stackView.spacing = 6
        stackView.distribution = .fillEqually
        stackView.alignment = .center
        addSubviews(stackView)
        
        
        NSLayoutConstraint.activate([
            
            stackView.topAnchor.constraint(equalTo: searchbar.bottomAnchor),
            stackView.leftAnchor.constraint(equalTo: leftAnchor),
            stackView.rightAnchor.constraint(equalTo: rightAnchor),
            stackView.heightAnchor.constraint(equalToConstant: 55)
        ])
        
        return stackView
    }

    public func createOptionsSelectionViews(options : [RMSearchInputViewViewModel.DynamicOption]) {
         
        let stackView = stackViewCreateOption()
 
        self.stackView = stackView
        for x in 0..<options.count {
            let option = options[x]
            let button = createButton(with: option, tag: x)

            stackView.addArrangedSubview(button)
        }
    }
    
    private func createButton(with option: RMSearchInputViewViewModel.DynamicOption, tag : Int)->UIButton {
        
        let button = UIButton()
        
        button.setAttributedTitle(NSAttributedString(string: option.rawValue,
        attributes: [
            .font : UIFont.systemFont(ofSize: 18, weight: .medium),
            .foregroundColor : UIColor.label
                                                        
        ]), for: .normal)
        
         button.backgroundColor = .secondarySystemFill
        button.setTitleColor(.label, for: .normal)
        button.addTarget(self, action: #selector(didTapButton(_:)), for: .touchUpInside)
        button.tag = tag
        button.layer.cornerRadius = 6
        
        return button
    }
    
    @objc private func didTapButton(_ sender : UIButton) {
    
        guard let options = viewModel?.options else {
            return
        }
        let tag = sender.tag
        let selected = options[tag]
        
        delegate?.rmSearchInputView(self, didSelectOption: selected)
   
    }

    
    public func presentKeyboard() {
        searchbar.becomeFirstResponder()
    }
    
    public func update(option : RMSearchInputViewViewModel.DynamicOption , value : String) {
        
        guard let buttons = stackView?.arrangedSubviews , let allOptions = viewModel?.options, let index = allOptions.firstIndex(of: option)
        
        else {
            return
        }
    
        let button : UIButton = buttons[index] as! UIButton
        
        button.setAttributedTitle(NSAttributedString(string: value.uppercased(),
        attributes: [
            .font : UIFont.systemFont(ofSize: 18, weight: .medium),
            .foregroundColor : UIColor.link
                                                        
        ]), for: .normal)
        
    }
}
