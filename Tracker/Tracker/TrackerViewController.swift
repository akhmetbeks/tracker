//
//  TrackerViewController.swift
//  Tracker
//
//  Created by Sultan Akhmetbek on 18.08.2025.
//

import UIKit

final class TrackerViewController: UIViewController {
    private let categoryStore: TrackerCategoryStore
    private let trackerStore: TrackerStore
    private let recordStore: TrackerRecordStore
    private var categories: [TrackerCategory] = []
    private var filteredCategories: [TrackerCategory] = []
    private var emptyViewConstraints: [NSLayoutConstraint] = []
    private var collectionViewContraints: [NSLayoutConstraint] = []
    private var collectionView: UICollectionView?
    private let stackView = UIStackView()
    private let searchBar = UISearchBar()
    private let cellParam = GeometricParams(cellCount: 2, leftInset: 16, rightInset: 16, cellSpacing: 9)
    
    private var selectedDate: Date? {
        didSet {
            filterCategories()
            
            showCollectionView = !filteredCategories.isEmpty
            
            if showCollectionView { collectionView?.reloadData() }
        }
    }
    
    private var showCollectionView: Bool = false {
        didSet {
            starImage.isHidden = showCollectionView
            emptyTasksLabel.isHidden = showCollectionView
            collectionView?.isHidden = !showCollectionView
        }
    }

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
    
    init(categoryStore: TrackerCategoryStore, trackerStore: TrackerStore, recordStore: TrackerRecordStore) {
        self.categoryStore = categoryStore
        self.trackerStore = trackerStore
        self.recordStore = recordStore
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        view.backgroundColor = .ybBlack
        
        categoryStore.delegate = self
        trackerStore.delegate = self
        categories = categoryStore.categories
        
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
            action: #selector(addTrackerTapped)
        )
        navigationItem.leftBarButtonItem?.tintColor = .text
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: datePicker)
        
        searchBar.placeholder = "Поиск"
        searchBar.searchBarStyle = .minimal
        searchBar.translatesAutoresizingMaskIntoConstraints = false
        
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
        
        guard let collectionView else { return }
        collectionView.register(TrackerViewCell.self, forCellWithReuseIdentifier: TrackerViewCell.identifier)
        collectionView.register(TrackerSectionHeader.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: TrackerSectionHeader.identifier)
        collectionView.backgroundColor = .ybBlack
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        
        collectionView.dataSource = self
        collectionView.delegate = self
        
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        stackView.addSubview(starImage)
        stackView.addSubview(emptyTasksLabel)
        stackView.addSubview(searchBar)
        stackView.addSubview(collectionView)
        
        view.addSubview(stackView)
        
        configureConstraints()
        
        selectedDate = Date()
    }
       
    @objc private func addTrackerTapped() {
        let vc = TrackerAddViewController()
        
        vc.onTrackerAdded = { [weak self] item in
            guard let self, let tracker = item.trackers.first else { return }
            
            if let index = self.categories.firstIndex(where: { $0.title == item.title }) {
                let category = self.categories[index]
                var newTrackers = category.trackers
                newTrackers.append(tracker)
                self.categories[index] = TrackerCategory(title: item.title, trackers: newTrackers)
                filterCategories()
                try? self.trackerStore.addTracker(tracker, to: item.title)
            } else {
                self.categories.append(item)
                filterCategories()
                try? self.categoryStore.addCategory(item)
            }
        }
        vc.modalPresentationStyle = .pageSheet
        present(UINavigationController(rootViewController: vc), animated: true)
    }
    
    @objc private func pickedDate(_ sender: UIDatePicker) {
        selectedDate = sender.date
    }
    
    private func filterCategories() {
        guard let selectedWeekday = getWeekday() else { return }
        filteredCategories = categories.compactMap({
            let filteredTrackers = $0.trackers.filter({ $0.weekdays.contains(selectedWeekday) })
            if filteredTrackers.isEmpty { return nil }
            return TrackerCategory(title: $0.title, trackers: filteredTrackers)
        })
        
        showCollectionView = !filteredCategories.isEmpty
    }
    
    private func getWeekday() -> WeekdaysEnum? {
        guard let date = selectedDate else { return nil }
        let weekday = Calendar.current.component(.weekday, from: date)
        return WeekdaysEnum.allCases[weekday - 2]
    }
    
    private func configureConstraints() {
        NSLayoutConstraint.activate([
            searchBar.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            searchBar.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            searchBar.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            searchBar.heightAnchor.constraint(equalToConstant: 36),
            stackView.topAnchor.constraint(equalTo: searchBar.bottomAnchor),
            stackView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            stackView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
        
        emptyViewConstraints = [
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
        
        NSLayoutConstraint.activate(emptyViewConstraints)
        NSLayoutConstraint.activate(collectionViewContraints)
    }
    
    private func toggleCompletion(at indexPath: IndexPath) {
        guard let selectedDate, selectedDate <= Date() else { return }
        let tracker = filteredCategories[indexPath.section].trackers[indexPath.item]
        if recordStore.hasRecord(for: tracker.id, on: selectedDate) {
            try? recordStore.removeRecord(for: tracker.id, on: selectedDate)
        } else {
            let record = TrackerRecord(id: tracker.id, date: selectedDate)
            try? recordStore.addRecord(record)
        }

        collectionView?.reloadItems(at: [indexPath])
    }
}

// MARK: - UICollectionViewDataSource
extension TrackerViewController: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        filteredCategories.count
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        filteredCategories[section].trackers.count
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        var id = ""
        
        if kind == UICollectionView.elementKindSectionHeader { id = TrackerSectionHeader.identifier }
        
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
        
        if let selectedDate {
            let tracker = filteredCategories[indexPath.section].trackers[indexPath.item]
            
            let isCompleted = recordStore.hasRecord(for: tracker.id, on: selectedDate)
            let count = recordStore.getCount(for: tracker.id)
            cell.configure(with: tracker, isCompleted: isCompleted, count: count)
        }
        
        return cell
    }
}

// MARK: - UICollectionViewDelegateFlowLayout
extension TrackerViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let availableWidth = collectionView.frame.width - cellParam.paddingWidth
        let cellWidth = availableWidth / CGFloat(cellParam.cellCount)
        return CGSize(width: cellWidth, height: 148)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        CGSize(width: collectionView.bounds.width, height: 50)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        cellParam.cellSpacing
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        toggleCompletion(at: indexPath)
    }
}

// MARK: - TrackerStoreDelegate
extension TrackerViewController: TrackerCategoryStoreDelegate, TrackerStoreDelegate {
    func didInsertTracker(to categoryTitle: String) {
        if let sectionIndex = filteredCategories.firstIndex(where: { $0.title == categoryTitle }) {
            collectionView?.reloadSections([sectionIndex])
        }
    }
    
    func didInsertSections(_ sections: IndexSet) {
        collectionView?.performBatchUpdates {
            collectionView?.insertSections(sections)
        }
    }
}
