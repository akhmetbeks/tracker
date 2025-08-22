//
//  TrackerViewCell.swift
//  Tracker
//
//  Created by Sultan Akhmetbek on 22.08.2025.
//

import UIKit

final class TrackerViewCell: UICollectionViewCell {
    private var records: [TrackerRecord] = []
    
    private let button = UIButton(type: .system)
    private let countLabel = UILabel()
    
    private var isDone = false {
        didSet {
            let image = UIImage(resource: isDone ? .check : .plus)
            button.setImage(image, for: .normal)
            
            let count = records.filter { $0.id == tracker?.id }.count
            countLabel.text = "\(count) дней"
        }
    }
    
    var tracker: Tracker?
    var selectedDate = Date() {
        didSet {
            records = records.filter { $0.date == selectedDate }
        }
    }
    
    static let identifier = "TrackerViewCell"
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        contentView.layer.cornerRadius = 8
        contentView.layer.masksToBounds = true
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    func configure() {
        let containerView = UIView()
        
        guard let tracker else { return }
        containerView.backgroundColor = tracker.color
        containerView.layer.cornerRadius = 16
        containerView.translatesAutoresizingMaskIntoConstraints = false
        
        let titleLabel = UILabel()
        titleLabel.text = tracker.title
        titleLabel.font = .ypMedium
        titleLabel.numberOfLines = 2
        titleLabel.lineBreakMode = .byWordWrapping
        titleLabel.textColor = .text
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        
        countLabel.font = .ypMedium
        countLabel.textColor = .text
        countLabel.translatesAutoresizingMaskIntoConstraints = false
        
        button.addTarget(self, action: #selector(toggleDone), for: .touchUpInside)
        button.tintColor = tracker.color
        button.translatesAutoresizingMaskIntoConstraints = false
        
        isDone = records.contains(where: { $0.id == tracker.id })
        
        contentView.addSubview(containerView)
        contentView.addSubview(countLabel)
        contentView.addSubview(button)
        containerView.addSubview(titleLabel)
        
        NSLayoutConstraint.activate([
            containerView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            containerView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            containerView.topAnchor.constraint(equalTo: contentView.topAnchor),
            containerView.bottomAnchor.constraint(equalTo: countLabel.topAnchor, constant: -16),

            titleLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 12),
            titleLabel.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -12),
            titleLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -12),
            
            countLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 12),
            countLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -24),
            button.topAnchor.constraint(equalTo: containerView.bottomAnchor, constant: 8),
            button.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -12),
            button.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -16),
            button.widthAnchor.constraint(equalToConstant: 34),
            button.heightAnchor.constraint(equalToConstant: 34)
        ])
    }
    
    @objc private func toggleDone() {
        guard let tracker else { return }
        
        if isDone {
            if records.isEmpty == false {
                records.removeLast()
                isDone = false
            }
        } else {
            if selectedDate <= Date() {
                records.append(TrackerRecord(id: tracker.id, date: selectedDate))
                isDone = true
            }
        }
    }
}
