//
//  TrackerViewController.swift
//  Tracker
//
//  Created by Sultan Akhmetbek on 18.08.2025.
//

import UIKit

final class TrackerViewController: UIViewController {
    private let analytics: AnalyticsServiceProtocol
    private let viewModel: TrackerViewModel
    private var emptyViewConstraints: [NSLayoutConstraint] = []
    private var collectionViewContraints: [NSLayoutConstraint] = []
    private var collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
    private let searchController = UISearchController()
    private let cellParam = GeometricParams(cellCount: 2, leftInset: 16, rightInset: 16, cellSpacing: 9)
    let datePicker = UIDatePicker()
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
    
    private let filtersButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle(L10n.filters, for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 17, weight: .regular)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = .ybBlue
        button.layer.cornerRadius = 16
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
      }()
    
    init(categoryStore: TrackerCategoryStore, trackerStore: TrackerStore, recordStore: TrackerRecordStore) {
        self.analytics = AppMetricaService.shared
        self.viewModel = TrackerViewModel(
            categoryStore: categoryStore,
            trackerStore: trackerStore,
            recordStore: recordStore)
        super.init(nibName: nil, bundle: nil)
        self.viewModel.delegate = self
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        view.backgroundColor = .ybBlack
        
        filtersButton.addTarget(self, action: #selector(filterTapped), for: .touchUpInside)
        
        datePicker.date = viewModel.getDate()
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
        
        UserDefaults.standard.set(TrackerFilter.all.rawValue, forKey: FiltersViewController.trackerFilter)
        
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
        
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(TrackerViewCell.self, forCellWithReuseIdentifier: TrackerViewCell.identifier)
        collectionView.register(TrackerSectionHeader.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: TrackerSectionHeader.identifier)
        collectionView.backgroundColor = .ybBlack
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.addSubview(starImage)
        stackView.addSubview(emptyTasksLabel)
        stackView.addSubview(collectionView)
        stackView.addSubview(filtersButton)
        view.addSubview(stackView)
        
        configureConstraints()
        viewModel.selectDate()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        analytics.sendEvent(.open, screen: .main, item: nil)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        analytics.sendEvent(.close, screen: .main, item: nil)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()

        let buttonHeight = filtersButton.frame.height
        collectionView.contentInset.bottom = buttonHeight + 16
        collectionView.verticalScrollIndicatorInsets.bottom = buttonHeight
    }
       
    @objc private func addTrackerTapped() {
        analytics.sendEvent(.click, screen: .main, item: .addTrack)
        
        let vc = TrackerAddViewController()
        
        vc.onTrackerAdded = { [weak self] category in
            try? self?.viewModel.addTracker(for: category)
        }
        vc.modalPresentationStyle = .pageSheet
        present(UINavigationController(rootViewController: vc), animated: true)
    }
    
    @objc private func filterTapped() {
        analytics.sendEvent(.click, screen: .main, item: .filter)
        
        let vc = FiltersViewController()
        vc.delegate = self
        vc.modalPresentationStyle = .pageSheet
        present(UINavigationController(rootViewController: vc), animated: true)
    }
    
    @objc private func pickedDate(_ sender: UIDatePicker) {
        viewModel.selectDate(sender.date)
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
                
        collectionViewContraints = [
            collectionView.topAnchor.constraint(equalTo: stackView.safeAreaLayoutGuide.topAnchor),
            collectionView.bottomAnchor.constraint(equalTo: stackView.safeAreaLayoutGuide.bottomAnchor),
            collectionView.leadingAnchor.constraint(equalTo: stackView.leadingAnchor, constant: cellParam.leftInset),
            collectionView.trailingAnchor.constraint(equalTo: stackView.trailingAnchor, constant: -cellParam.rightInset),
        ]
        
        NSLayoutConstraint.activate(emptyViewConstraints)
        NSLayoutConstraint.activate(collectionViewContraints)
        NSLayoutConstraint.activate([
            filtersButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 114),
            filtersButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -114),
            filtersButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -16),
            filtersButton.heightAnchor.constraint(equalToConstant: 50),
        ])
    }
    
    private func editTrackerOfCategory(at indexPath: IndexPath) {
        analytics.sendEvent(.click, screen: .main, item: .edit)
        
        let category = viewModel.filteredCategories[indexPath.section]
        let tracker = category.trackers[indexPath.row]
        
        let vc = CreateTrackerViewController()
        let count = viewModel.getRecordCount(at: indexPath)
        vc.showSchedule = tracker.weekdays.count != 7
        vc.setToEdit(tracker: tracker, of: category.title, count: count)
        vc.onTrackerAdded = { [weak self] newCategory in
            try? self?.viewModel.updateTracker(to: newCategory, from: indexPath)
            self?.dismiss(animated: true)
        }
        
        vc.modalPresentationStyle = .pageSheet
        present(UINavigationController(rootViewController: vc), animated: true)
    }
    
    private func showActionSheet(at indexPath: IndexPath) {
        analytics.sendEvent(.click, screen: .main, item: .delete)
        
        let alert = UIAlertController(title: "", message: L10n.deleteActionSheetMessage, preferredStyle: .actionSheet)
        alert.addAction(UIAlertAction(title: L10n.delete, style: .destructive, handler: { [weak self] _ in
            self?.viewModel.deleteTracker(at: indexPath)
        }))
        
        alert.addAction(UIAlertAction(title: L10n.cancel, style: .cancel))
        present(alert, animated: true)
    }
}

// MARK: - UICollectionViewDataSource
extension TrackerViewController: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        viewModel.getCategoriesCount()
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        viewModel.getTrackersCount(at: section)
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        var id = ""
        
        if kind == UICollectionView.elementKindSectionHeader { id = TrackerSectionHeader.identifier }
        
        guard let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: id, for: indexPath) as? TrackerSectionHeader else {
            return UICollectionReusableView()
        }
        
        header.label.text = viewModel.filteredCategories[indexPath.section].title
        return header
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: TrackerViewCell.identifier, for: indexPath) as? TrackerViewCell else {
            return UICollectionViewCell()
        }
        
        let tracker = viewModel.getTracker(at: indexPath)
        let isCompleted = viewModel.isCompleted(at: indexPath)
        let count = viewModel.getRecordCount(at: indexPath)
        cell.configure(with: tracker, isCompleted: isCompleted, count: count)
        
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
        analytics.sendEvent(.click, screen: .main, item: .track)
        viewModel.toggleComplete(at: indexPath)
    }
    
    func collectionView(_ collectionView: UICollectionView, contextMenuConfigurationForItemsAt indexPaths: [IndexPath], point: CGPoint) -> UIContextMenuConfiguration? {
        return UIContextMenuConfiguration(actionProvider:  { _ in
            guard let indexPath = indexPaths.first else { return nil }
            
            return UIMenu(children: [
                UIAction(title: L10n.edit, handler: { [weak self] _ in
                    self?.editTrackerOfCategory(at: indexPath)
                }),
                UIAction(title: L10n.delete, attributes: .destructive, handler: { [weak self] _ in
                    self?.showActionSheet(at: indexPath)
                }),
            ])
        })
    }
}

// MARK: -UISearchResultsUpdating
extension TrackerViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        viewModel.updateSearchResults(for: searchController.searchBar.text)
    }
}

extension TrackerViewController: TrackerViewModelDelegate {
    func didUpdateData() {
        let hasData = viewModel.filteredCategories.isEmpty == false
        starImage.isHidden = hasData
        emptyTasksLabel.isHidden = hasData
        filtersButton.isHidden = !hasData
        collectionView.isHidden = !hasData
        
        collectionView.reloadData()
    }
    
    func didChangeFilterState(isActive: Bool) {
        if isActive == false {
            datePicker.date = Date()
        }
        filtersButton.setTitleColor(isActive ? .ybRed : .white, for: .normal)
    }
}

extension TrackerViewController: FilterViewDelegate {
    func applyOnCollection(filter: TrackerFilter) {
        viewModel.setFilter(filter)
    }
}
