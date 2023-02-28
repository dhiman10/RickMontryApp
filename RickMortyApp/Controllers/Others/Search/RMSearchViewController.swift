//
//  RMSearchViewController.swift
//  RickMortyApp
//
//  Created by Dhiman Das on 23/2/23.
//

import UIKit

/// Configurable Controller to search
final class RMSearchViewController: UIViewController {
    
    /// Configuration of search session
    struct Config {
        enum `Type`{
            case character
            case episode
            case location
            
            var endpoint : RMendpoint{
                
                switch self {
                case .character : return .character
                case .location: return .location
                case .episode : return .episode
                }
                
            }
            
            var title : String {
                switch self {
                case .character:
                    return "Search Characters"
                case .location:
                    return "Search Location"
                case .episode:
                    return "Search Episode"
                }
            }
            
        }
        let type: `Type`
    }
    
    private let viewModel : RMSearchViewViewModel
    private let searchView : RMSearchView

    init(config : Config) {
        
        let viewModel = RMSearchViewViewModel(confiq: config)
        self.viewModel = viewModel
        self.searchView = RMSearchView(frame: .zero, viewModel: viewModel)
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("Unsupported")
    }
    
    
    //MARK: - LifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = viewModel.confiq.type.title
        view.backgroundColor = .systemBackground
        view.addSubview(searchView)
        addConstraints()
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Search", style: .done, target: self, action: #selector(didTapExecuteSearch))
        searchView.delegate = self
        
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        searchView.presentKeyboard()
    }
    
    @objc
    private func didTapExecuteSearch () {
        
        viewModel.excuteSearch()
        
    }

    func addConstraints() {
        
        NSLayoutConstraint.activate([
            searchView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            searchView.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor),
            searchView.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor),
            searchView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
        ])
        
    }
}

//MARK: - RMSearchViewDelegate

extension RMSearchViewController : RMSearchViewDelegate {
    
    func rmSearchView(_ searchView: RMSearchView, didSelectOption option: RMSearchInputViewViewModel.DynamicOption) {
        
        let vc = RMSearchOptionsPickerViewController(option: option) { [weak self] selection in
            print(selection)
            DispatchQueue.main.async {
                self?.viewModel.set(value: selection, for: option)

            }
        }
        if #available(iOS 15.0, *) {
            vc.sheetPresentationController?.detents = [.medium()]
            vc.sheetPresentationController?.prefersGrabberVisible = true
        } else {
            // Fallback on earlier versions
        }
    
        present(vc, animated: true)
    }
}
 
