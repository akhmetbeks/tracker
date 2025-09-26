//
//  CreateTrackerScheduleViewController.swift
//  Tracker
//
//  Created by Sultan Akhmetbek on 23.08.2025.
//

import UIKit

final class CreateTrackerScheduleViewController: UIViewController {
    private let tableView = UITableView()
    private let button = TrackerButton(title: "Готово")
    
    private let rowHeight: CGFloat = 75
    private let numberOfRows = CGFloat(WeekdaysEnum.allCases.count)
    
    var weekdays: [WeekdaysEnum] = []
    var setWeekdays: (([WeekdaysEnum]) -> Void)?
    
    override func viewDidLoad() {
        view.backgroundColor = .ybBlack
        navigationItem.title = "Расписание"
        
        setupTableView()
        
        button.addTarget(self, action: #selector(closePage), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        
        setupLayout()
    }
    
    private func setupTableView() {
        tableView.backgroundColor = .background
        tableView.layer.cornerRadius = 16
        tableView.layer.masksToBounds = true
        tableView.isScrollEnabled = false
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(CreateWeekDayCell.self, forCellReuseIdentifier: CreateWeekDayCell.identifier)
        
        tableView.tableFooterView = UIView()
        tableView.separatorStyle = .singleLine
        tableView.separatorInset = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
        tableView.tableHeaderView = UIView(frame: CGRect(x: 0, y: 0, width: 0, height: CGFloat.leastNormalMagnitude))
        
        tableView.translatesAutoresizingMaskIntoConstraints = false
    }
    
    private func setupLayout() {
        view.addSubview(tableView)
        view.addSubview(button)
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 16),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            tableView.heightAnchor.constraint(equalToConstant: rowHeight * numberOfRows),
            
            button.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            button.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            button.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
        ])
    }
    
    @objc private func closePage() {
        setWeekdays?(weekdays)
        dismiss(animated: true)
    }
}

extension CreateTrackerScheduleViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        75
    }
}

extension CreateTrackerScheduleViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        WeekdaysEnum.allCases.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: CreateWeekDayCell.identifier, for: indexPath)
        
        guard let cell = cell as? CreateWeekDayCell else { return UITableViewCell() }
        
        cell.setWeekday(WeekdaysEnum.allCases[indexPath.row])
        cell.isOn = weekdays.contains(WeekdaysEnum.allCases[indexPath.row])
        cell.onToggle = { [weak self] day in
            guard let self else { return }
            
            if let index = self.weekdays.firstIndex(where: { $0 == day }) {
                self.weekdays.remove(at: index)
            } else {
                self.weekdays.append(day)
            }
        }
                
        if indexPath.row == WeekdaysEnum.allCases.count - 1 {
            cell.separatorInset = UIEdgeInsets(top: 0, left: cell.bounds.size.width, bottom: 0, right: 0)
        }
        
        return cell
    }
}
