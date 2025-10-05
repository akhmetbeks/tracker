//
//  StatisticsViewController.swift
//  Tracker
//
//  Created by Sultan Akhmetbek on 04.10.2025.
//

import UIKit

final class StatisticsViewController: UIViewController {
    let emptyLabel = UILabel()
    let emptyImage = UIImageView()
    let tableView = UITableView()
    private let viewModel: StatisticsViewModel
    
    init(recordStore: TrackerRecordStore) {
        self.viewModel = StatisticsViewModel(recordStore: recordStore)
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        viewModel.delegate = self
        viewModel.loadStatistics()
        
        navigationItem.title = L10n.statistics
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.largeTitleDisplayMode = .always
        
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(StatisticsTableViewCell.self, forCellReuseIdentifier: StatisticsTableViewCell.identifier)
        tableView.separatorStyle = .none
        
        emptyImage.image = .emptyStatistics
        emptyLabel.text = L10n.emptyStatistics
        emptyLabel.textColor = .text
        emptyLabel.font = .systemFont(ofSize: 12, weight: .medium)
        
        setupLayout()
        toggleTableViewVisibility()
    }
    
    private func setupLayout() {
        emptyImage.translatesAutoresizingMaskIntoConstraints = false
        emptyLabel.translatesAutoresizingMaskIntoConstraints = false
        tableView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(emptyImage)
        view.addSubview(emptyLabel)
        view.addSubview(tableView)

        NSLayoutConstraint.activate([
            emptyImage.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            emptyImage.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            emptyLabel.topAnchor.constraint(equalTo: emptyImage.bottomAnchor, constant: 8),
            emptyLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 24),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -24),
        ])
    }
    
    private func toggleTableViewVisibility() {
        let hasData = viewModel.statistics.isEmpty == false
        emptyImage.isHidden = hasData
        emptyLabel.isHidden = hasData
        tableView.isHidden = !hasData
    }
}

extension StatisticsViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return viewModel.statistics.count
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: StatisticsTableViewCell.identifier, for: indexPath) as? StatisticsTableViewCell else {
            return UITableViewCell()
        }
        
        let item = Array(viewModel.statistics)[indexPath.section]
        cell.configureCell(with: item.key.title, value: item.value)
        return cell
    }
}

extension StatisticsViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        90
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 12
    }

    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let footerView = UIView()
        footerView.backgroundColor = .clear
        return footerView
    }
}

extension StatisticsViewController: StatisticsViewDelegate {
    func didUpdateData() {
        toggleTableViewVisibility()
        tableView.reloadData()
    }
}
