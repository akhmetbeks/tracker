//
//  TabBarViewController.swift
//  Tracker
//
//  Created by Sultan Akhmetbek on 18.08.2025.
//

import UIKit

final class TabBarController: UITabBarController {
    override func awakeFromNib() {
        super.awakeFromNib()
           
        let trackerController = TrackerViewController()
        trackerController.tabBarItem = UITabBarItem(title: "Tracker", image: UIImage(resource: .tracker), tag: 0)
        
        let statsController = UIViewController()
        statsController.tabBarItem = UITabBarItem(title: "Statistics", image: UIImage(resource: .stats), tag: 1)
        
        let firstNavController = UINavigationController(rootViewController: trackerController)
        let secondNavController = UINavigationController(rootViewController: statsController)
          
        self.viewControllers = [firstNavController, secondNavController]
    }
}
