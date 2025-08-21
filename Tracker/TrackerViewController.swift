//
//  TrackerViewController.swift
//  Tracker
//
//  Created by Sultan Akhmetbek on 18.08.2025.
//

import UIKit

final class TrackerViewController: UIViewController {
    private var categories: [TrackerCategory] = []
    
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
    
    @objc func pickedDate(_ sender: UIDatePicker) {
    }
    
    override func viewDidLoad() {
        view.backgroundColor = .background
        
        let datePicker = UIDatePicker()
        datePicker.preferredDatePickerStyle = .compact
        datePicker.datePickerMode = .date
        datePicker.addTarget(self, action: #selector(pickedDate(_:)), for: .valueChanged)
        
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
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: datePicker)
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
        collectionView.register(TrackerViewCell.self, forCellWithReuseIdentifier: TrackerViewCell.identifier)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.dataSource = self
        collectionView.delegate = self
        view.addSubview(collectionView)
        
//        [starImage, emptyTasksLabel].forEach(view.addSubview)
//        
//        NSLayoutConstraint.activate([
//            starImage.centerXAnchor.constraint(equalTo: view.centerXAnchor),
//            starImage.centerYAnchor.constraint(equalTo: view.centerYAnchor),
//            emptyTasksLabel.topAnchor.constraint(equalTo: starImage.bottomAnchor, constant: 8),
//            emptyTasksLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
//        ])
        
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
    }
}

extension TrackerViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: TrackerViewCell.identifier,
            for: indexPath) as? TrackerViewCell else {
            return UICollectionViewCell()
        }
        
        cell.configure(with: Tracker(id: UUID(), title: "Test", color: .green, emoji: "", weekdays: [.friday,.saturday]), isDone: true)
        
        return cell
    }
}

extension TrackerViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let param = GeometricParams(cellCount: 2, leftInset: 16, rightInset: 16, cellSpacing: 9)
        let availableWidth = collectionView.frame.width - param.paddingWidth
        let cellWidth = availableWidth / CGFloat(param.cellCount)
        return CGSize(width: cellWidth, height: cellWidth * 0.8)
    }
}

extension TrackerViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, contextMenuConfigurationForItemsAt indexPaths: [IndexPath], point: CGPoint) -> UIContextMenuConfiguration? {
        return UIContextMenuConfiguration { actions in
            return UIMenu()
        }
    }
}
