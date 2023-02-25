//
//  RMSettingsViewController.swift
//  RickMortyApp
//
//  Created by Dhiman Das on 17/2/23.
//
import SafariServices
import UIKit
import SwiftUI
import StoreKit

/// Controller to show  various app options and settings
final class RMSettingsViewController: UIViewController {
    
//    private let viewModel = RMSettingViewViewModel(
//        cellViewModels: RMSettingsOption.allCases.compactMap({
//            return RMSettingsCellViewModel(type: $0)
//        })
//    )
    
    public var settingsSwiftUIController : UIHostingController<RMSettingsView>?

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .systemBackground
        title = "Settings"
        addSwiftUIContainer()
    }
    
    func addSwiftUIContainer() {
        
        let settingsSwiftUIController = UIHostingController(rootView: RMSettingsView(
            viewModel: RMSettingViewViewModel(
                cellViewModels: RMSettingsOption.allCases.compactMap({
                    return RMSettingsCellViewModel(type: $0){ [weak self] option in
                        self?.handleTap(option: option)
                    }
                })
            )
            ))
        
        
        addChild(settingsSwiftUIController)
        settingsSwiftUIController.didMove(toParent: self)
        view.addSubviews(settingsSwiftUIController.view)
        settingsSwiftUIController.view.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            settingsSwiftUIController.view.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            settingsSwiftUIController.view.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor),
            settingsSwiftUIController.view.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor),
            settingsSwiftUIController.view.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            
        
        ])
        
        self.settingsSwiftUIController = settingsSwiftUIController
    }


    private func handleTap(option : RMSettingsOption){
        
        guard Thread.current.isMainThread else {
            return
        }
        
        if let url = option.targetUrl {
            let vc = SFSafariViewController(url: url)
            present(vc , animated: true)
        }
        else if option == .rateApp {
            
            if let windowScene = view.window?.windowScene {
                SKStoreReviewController.requestReview(in: windowScene)
            }
        }
    
    }

}
