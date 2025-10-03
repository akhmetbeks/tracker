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
    private var filteredCategories: [TrackerCategory] = []
    private var emptyViewConstraints: [NSLayoutConstraint] = []
    private var collectionViewContraints: [NSLayoutConstraint] = []
    private var collectionView: UICollectionView?
    private let searchController = UISearchController()
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
    
    private let stackView: UIStackView = {
        let sv = UIStackView()
        sv.axis = .vertical
        sv.spacing = 8
        sv.translatesAutoresizingMaskIntoConstraints = false
        return sv
    }()

    private let starImage: UIImageView = {
        let image = UIImageView(image: UIImage(resource: .star))
        image.translatesAutoresizingMaskIntoConstraints = false
        return image
    }()
    
    private let emptyTasksLabel: UILabel = {
        let label = UILabel()
        label.text = L10n.emptyTrackerLabel
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
        
        trackerStore.delegate = self
        
        let datePicker = UIDatePicker()
        datePicker.date = selectedDate ?? Date()
        datePicker.preferredDatePickerStyle = .compact
        datePicker.datePickerMode = .date
        datePicker.addTarget(self, action: #selector(pickedDate(_:)), for: .valueChanged)
        
        navigationItem.title = L10n.trackers
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
        
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchResultsUpdater = self
        let searchTextField = searchController.searchBar.searchTextField
        searchTextField.placeholder = L10n.search
        searchTextField.clearButtonMode = .whileEditing
        searchTextField.backgroundColor = .secondarySystemBackground
        searchTextField.layer.cornerRadius = 8
        searchTextField.clipsToBounds = true
        navigationItem.searchController = searchController
        definesPresentationContext = true
        
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
        stackView.addSubview(collectionView)
        
        view.addSubview(stackView)
        
        configureConstraints()
        
        selectedDate = Date()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        print("viewWillAppear")
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        print("viewWillDisappear")
    }
       
    @objc private func addTrackerTapped() {
        let vc = TrackerAddViewController()
        
        vc.onTrackerAdded = { [weak self] item in
            guard let self, let tracker = item.trackers.first else { return }
            try? self.trackerStore.addTracker(tracker, to: item.title)
        }
        vc.modalPresentationStyle = .pageSheet
        present(UINavigationController(rootViewController: vc), animated: true)
    }
    
    @objc private func pickedDate(_ sender: UIDatePicker) {
        selectedDate = sender.date
    }
    
    private func filterCategories() {
        guard let selectedWeekday = getWeekday() else { return }
        let categories = categoryStore.categories
        filteredCategories = categories.compactMap({
            let filteredTrackers = $0.trackers.filter({ $0.weekdays.contains(selectedWeekday) })
            if filteredTrackers.isEmpty { return nil }
            return TrackerCategory(title: $0.title, trackers: filteredTrackers)
        })
        
        showCollectionView = !filteredCategories.isEmpty
    }
    
    private func getWeekday() -> Weekday? {
        guard let date = selectedDate else { return nil }
        let weekday = Calendar.current.component(.weekday, from: date)
        return Weekday.allCases[weekday - 1]
    }
    
    private func configureConstraints() {
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 8),
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
    
    private func editTrackerOfCategory(at indexPath: IndexPath) {
        let category = filteredCategories[indexPath.section]
        let tracker = category.trackers[indexPath.row]
        
        let vc = CreateTrackerViewController()
        vc.showSchedule = tracker.weekdays.count != 7
        vc.setToEdit(tracker: tracker, of: category.title)
        vc.onTrackerAdded = { [weak self] newCategory in
            guard let tracker = newCategory.trackers.first else { return }
            try? self?.trackerStore.updateTracker(tracker, to: newCategory.title, from: category.title)
            self?.dismiss(animated: true)
        }
        
        vc.modalPresentationStyle = .pageSheet
        present(UINavigationController(rootViewController: vc), animated: true)
    }
    
    private func deleteTracker(at indexPath: IndexPath) {
        let category = filteredCategories[indexPath.section]
        let tracker = category.trackers[indexPath.row]
        try? self.trackerStore.delete(tracker, from: category.title)
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
    
    func collectionView(_ collectionView: UICollectionView, contextMenuConfigurationForItemsAt indexPaths: [IndexPath], point: CGPoint) -> UIContextMenuConfiguration? {
        return UIContextMenuConfiguration(actionProvider:  { _ in
            guard let indexPath = indexPaths.first else { return nil }
            
            return UIMenu(children: [
                UIAction(title: L10n.edit, handler: { _ in
                    self.editTrackerOfCategory(at: indexPath)
                }),
                UIAction(title: L10n.delete, attributes: .destructive, handler: { _ in
                    self.deleteTracker(at: indexPath)
                }),
            ])
        })
    }
}

// MARK: - TrackerStoreDelegate
extension TrackerViewController: TrackerStoreDelegate {
    func didDeleteTracker() {
        filterCategories()
        collectionView?.reloadData()
    }
    
    func didUpdateTracker() {
        filterCategories()
        collectionView?.reloadData()
    }
    
    func didInsertTracker(to categoryTitle: String) {
        filterCategories()
        
        if let sectionIndex = filteredCategories.firstIndex(where: { $0.title == categoryTitle }) {
            let category = filteredCategories[sectionIndex]
            if category.trackers.count > 1 {
                collectionView?.reloadSections([sectionIndex])
            } else {
                collectionView?.reloadData()
            }
        }
    }
}

// MARK: -UISearchResultsUpdating
extension TrackerViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        if let text = searchController.searchBar.text, !text.isEmpty {
            filteredCategories = categoryStore.categories.compactMap({
                let filteredTrackers = $0.trackers.filter({ $0.title.lowercased().starts(with: text.lowercased()) })
                if filteredTrackers.isEmpty { return nil }
                return TrackerCategory(title: $0.title, trackers: filteredTrackers)
            })
            
            showCollectionView = !filteredCategories.isEmpty
        } else {
            filterCategories()
        }
        
        if showCollectionView { collectionView?.reloadData()}
    }
}
