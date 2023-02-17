//
//  ViewController.swift
//  RickMortyApp
//
//  Created by Dhiman Das on 17/2/23.
//

import UIKit

final class RMTabViewController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.view.backgroundColor = UIColor.green
        setupTabs()
        
    }

    private func setupTabs() {
        
        let characterVC = RMCharacterViewController()
        let locationVC = RMLocationViewController()
        let episodeVC = RMEpisodViewController()
        let settingsVC = RMSettingsViewController()
        
        characterVC.title = "Home"
        locationVC.title = "Explore"
        episodeVC.title = "Notificatios"
        settingsVC.title = "Profile"
        
        characterVC.navigationItem.largeTitleDisplayMode = .automatic
        locationVC.navigationItem.largeTitleDisplayMode = .automatic
        episodeVC.navigationItem.largeTitleDisplayMode = .automatic
        settingsVC.navigationItem.largeTitleDisplayMode = .automatic

        characterVC.tabBarItem = UITabBarItem(title: "Characeters", image: UIImage(systemName: "person"), tag: 1)
        locationVC.tabBarItem = UITabBarItem(title: "Locations", image: UIImage(systemName: "globe"), tag: 2)
        episodeVC.tabBarItem = UITabBarItem(title: "Episodes", image: UIImage(systemName: "tv"), tag: 3)
        settingsVC.tabBarItem = UITabBarItem(title: "Settings", image: UIImage(systemName: "gear"), tag: 4)

        
        let navcharacter = UINavigationController(rootViewController: characterVC)
        let navLocation = UINavigationController(rootViewController: locationVC)
        let navepisode = UINavigationController(rootViewController: episodeVC)
        let navsettings = UINavigationController(rootViewController: settingsVC)
    
        for nav in [navcharacter , navLocation , navepisode,navsettings] {
            nav.navigationBar.prefersLargeTitles = true
        }
       
        setViewControllers([navcharacter , navLocation , navepisode,navsettings], animated : true)
        
    }
    
    

}

