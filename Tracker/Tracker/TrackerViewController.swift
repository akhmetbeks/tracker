//
//  TrackerViewController.swift
//  Tracker
//
//  Created by Sultan Akhmetbek on 18.08.2025.
//

import UIKit

final class TrackerViewController: UIViewController {
    private var categories: [TrackerCategory] = [
        TrackerCategory(title: "Домашний уют", trackers: [
            Tracker(id: 1, title: "Поливать растения", color: .ybColor3, emoji: "", weekdays: [.friday, .wednesday]),
            Tracker(id: 3, title: "Test 3", color: .ybColor2, emoji: "", weekdays: [.friday,.saturday]),
        ]),
        TrackerCategory(title: "Радостные мелочи", trackers: [
            Tracker(id: 2, title: "Кошка заслонила камеру на созвоне", color: .ybColor6, emoji: "", weekdays: [.monday,.thursday]),
            Tracker(id: 4, title: "Бабушка прислала открытку в вотсапе", color: .ybColor1, emoji: "", weekdays: [.monday,.wednesday]),
            Tracker(id: 7, title: "Test 7", color: .ybColor8, emoji: "", weekdays: [.saturday,.sunday]),
            Tracker(id: 5, title: "Test 5", color: .ybColor16, emoji: "", weekdays: [.friday])
        ])
    ]
    
    private var filteredCategories: [TrackerCategory] = []
    
    private var emptyViewContraints: [NSLayoutConstraint] = []
    private var collectionViewContraints: [NSLayoutConstraint] = []
    private var collectionView: UICollectionView?
    private var selectedDate: Date? {
        didSet {
            guard let selectedDate else { return }
            let weekday = Calendar.current.component(.weekday, from: selectedDate)
            let selectedWeekday = WeekdaysEnum.allCases[weekday - 1]
            filteredCategories = categories.compactMap({
                let filteredTrackers = $0.trackers.filter({
                    $0.weekdays.contains(selectedWeekday)
                })
                
                if filteredTrackers.isEmpty { return nil }
                
                return TrackerCategory(title: $0.title, trackers: filteredTrackers)
            })
            
            showCollectionView = !filteredCategories.isEmpty
            
            if showCollectionView {
                collectionView?.reloadData()
            }
        }
    }
    
    private var showCollectionView: Bool = false {
        didSet {
            if collectionView?.isHidden == true && showCollectionView == false {
                return
            }
            
            starImage.isHidden = showCollectionView
            emptyTasksLabel.isHidden = showCollectionView
            collectionView?.isHidden = !showCollectionView
        }
    }
        
    private let cellParam = GeometricParams(cellCount: 2, leftInset: 16, rightInset: 16, cellSpacing: 9)
    
    private let stackView = UIStackView()
    
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
    
    override func viewDidLoad() {
        view.backgroundColor = .ybBlack
        
        let datePicker = UIDatePicker()
        datePicker.date = selectedDate ?? Date()
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
        
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
        
        guard let collectionView else { return }
        collectionView.register(TrackerViewCell.self, forCellWithReuseIdentifier: TrackerViewCell.identifier)
        collectionView.register(TrackerSectionHeader.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "header")
        collectionView.backgroundColor = .ybBlack
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        
        collectionView.dataSource = self
        collectionView.delegate = self
        
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        stackView.addSubview(starImage)
        stackView.addSubview(emptyTasksLabel)
        stackView.addSubview(collectionView)
        
        view.addSubview(stackView)
        
        configureConstraints()
        
        selectedDate = Date()
    }
       
    @objc func addTapped() {
        let vc = CreateTrackerViewController()
        vc.modalPresentationStyle = .pageSheet
        present(UINavigationController(rootViewController: vc), animated: true)
    }
    
    @objc func pickedDate(_ sender: UIDatePicker) {
        selectedDate = sender.date
    }
    
    private func configureConstraints() {
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            stackView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            stackView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
        
        emptyViewContraints = [
            starImage.centerXAnchor.constraint(equalTo: stackView.centerXAnchor),
            starImage.centerYAnchor.constraint(equalTo: stackView.centerYAnchor),
            emptyTasksLabel.topAnchor.constraint(equalTo: starImage.bottomAnchor, constant: 8),
            emptyTasksLabel.centerXAnchor.constraint(equalTo: stackView.centerXAnchor),
        ]
        
        guard let collectionView else { return }
        
        collectionViewContraints = [
            collectionView.topAnchor.constraint(equalTo: stackView.safeAreaLayoutGuide.topAnchor),
            collectionView.bottomAnchor.constraint(equalTo: stackView.safeAreaLayoutGuide.bottomAnchor),
            collectionView.leadingAnchor.constraint(equalTo: stackView.leadingAnchor, constant: cellParam.leftInset),
            collectionView.trailingAnchor.constraint(equalTo: stackView.trailingAnchor, constant: -cellParam.rightInset)
        ]
        
        NSLayoutConstraint.activate(emptyViewContraints)
        NSLayoutConstraint.activate(collectionViewContraints)
    }
}

extension TrackerViewController: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return filteredCategories.count
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return filteredCategories[section].trackers.count
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        var id = ""
        if kind == UICollectionView.elementKindSectionHeader {
                id = "header"
        }
        
        guard let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: id, for: indexPath) as? TrackerSectionHeader else {
            return UICollectionReusableView()
        }
        
        header.label.text = filteredCategories[indexPath.section].title
        return header
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: TrackerViewCell.identifier, for: indexPath) as? TrackerViewCell else {
            return UICollectionViewCell()
        }
        
        let tracker = filteredCategories[indexPath.section].trackers[indexPath.item]
        
        cell.tracker = tracker
        cell.selectedDate = selectedDate ?? Date()
        cell.configure()
        
        return cell
    }
}

extension TrackerViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let availableWidth = collectionView.frame.width - cellParam.paddingWidth
        let cellWidth = availableWidth / CGFloat(cellParam.cellCount)
        return CGSize(width: cellWidth, height: cellWidth * 0.8)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: collectionView.bounds.width, height: 50)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return cellParam.cellSpacing
    }
}
