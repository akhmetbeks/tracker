//
//  SplashViewController.swift
//  Tracker
//
//  Created by Sultan Akhmetbek on 18.08.2025.
//

import UIKit

final class SplashViewController: UIViewController {
    private let logo: UIImageView = {
        let logo = UIImageView(image: UIImage(resource: .logo))
        logo.translatesAutoresizingMaskIntoConstraints = false
        return logo
    }()
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        view.addSubview(logo)
        
        NSLayoutConstraint.activate([
            logo.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            logo.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
        
        navigateToTabBarController()
    }
    
    private func navigateToTabBarController() {
        guard
            let windowScene = UIApplication.shared.connectedScenes
                .first(where: { $0.activationState == .foregroundActive }) as? UIWindowScene,
            let window = windowScene.windows.first
        else {
            return
        }
        
        var controller: UIViewController
        
        if UserDefaults.standard.bool(forKey: Constants.hasSeenOnboardingKey) {
            controller = UIStoryboard(name: "Main", bundle: .main).instantiateViewController(withIdentifier: "TabBarViewController")
        } else {
            controller = OnboardingPageController()
        }
        
        window.rootViewController = controller
    }
}
