//
//  TrackerViewController.swift
//  Tracker
//
//  Created by Sultan Akhmetbek on 18.08.2025.
//

import UIKit

final class TrackerViewController: UIViewController {
    private var tasks: [String] = []
    
    private let starImage: UIImageView = {
        let image = UIImageView(image: UIImage(resource: .star))
        image.translatesAutoresizingMaskIntoConstraints = false
        return image
    }()
    
    private let emptyTasksLabel: UILabel = {
        let label = UILabel()
        label.text = "Что будем отслеживать?"
        label.font = .ypMedium
        label.textColor = .text
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
        
    @objc func addTapped() {
    }
    
    override func viewDidLoad() {
        view.backgroundColor = .background
        
        navigationItem.title = "Трекеры"
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.largeTitleDisplayMode = .always
        navigationItem.leftBarButtonItem = UIBarButtonItem(
            image: UIImage(systemName: "plus"),
            style: .plain,
            target: self,
            action: #selector(addTapped)
        )
        navigationItem.leftBarButtonItem?.tintColor = .text
        
        [starImage, emptyTasksLabel].forEach(view.addSubview)
        
        NSLayoutConstraint.activate([
            starImage.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            starImage.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            emptyTasksLabel.topAnchor.constraint(equalTo: starImage.bottomAnchor, constant: 8),
            emptyTasksLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
        ])
    }
}
