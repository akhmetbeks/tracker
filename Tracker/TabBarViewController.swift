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
        
        let container = (UIApplication.shared.delegate as! AppDelegate).storeContainer
        let trackerController = TrackerViewController(
            categoryStore: container.categoryStore,
            trackerStore: container.trackerStore,
            recordStore: container.recordStore)
        
        trackerController.tabBarItem = UITabBarItem(title: L10n.trackers, image: UIImage(resource: .tracker), tag: 0)
        
        let statsController = UIViewController()
        statsController.tabBarItem = UITabBarItem(title: L10n.statistics, image: UIImage(resource: .stats), tag: 1)
        
        let firstNavController = UINavigationController(rootViewController: trackerController)
        let secondNavController = UINavigationController(rootViewController: statsController)
          
        self.viewControllers = [firstNavController, secondNavController]
        
        let appearance = UITabBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = .ybBlack
        appearance.shadowColor = .black
        
        self.tabBar.standardAppearance = appearance
        
        if #available(iOS 15.0, *) {
            self.tabBar.scrollEdgeAppearance = appearance
        }
    }
    
    override func viewDidLoad() {
        self.selectedIndex = 0
    }
}
