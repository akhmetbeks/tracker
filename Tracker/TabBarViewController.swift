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
           
        let trackerController = TrackerViewController(
            categoryStore: TrackerCategoryStore(),
            trackerStore: TrackerStore(),
            recordStore: TrackerRecordStore())
        
        trackerController.tabBarItem = UITabBarItem(title: "Трекеры", image: UIImage(resource: .tracker), tag: 0)
        
        let statsController = UIViewController()
        statsController.tabBarItem = UITabBarItem(title: "Статистика", image: UIImage(resource: .stats), tag: 1)
        
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
