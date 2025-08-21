//
//  TrackerViewCell.swift
//  Tracker
//
//  Created by Sultan Akhmetbek on 22.08.2025.
//

import UIKit

final class TrackerViewCell: UICollectionViewCell {
    static let identifier = "TrackerViewCell"
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        contentView.layer.cornerRadius = 8
        contentView.layer.masksToBounds = true
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    func configure(with tracker: Tracker, isDone: Bool) {
        let containerView = UIView()
        containerView.backgroundColor = tracker.color
        containerView.layer.cornerRadius = 16
        containerView.translatesAutoresizingMaskIntoConstraints = false
        
        let titleLabel = UILabel()
        titleLabel.text = tracker.title
        titleLabel.font = .ypMedium
        titleLabel.textColor = .text
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        
        let countLabel = UILabel()
        countLabel.text = "1 day"
        countLabel.font = .ypMedium
        countLabel.textColor = .text
        countLabel.translatesAutoresizingMaskIntoConstraints = false
        
        let button = UIButton(type: .system)
        let image = UIImage(resource: isDone ? .check : .plus)
        button.setImage(image, for: .normal)
        button.tintColor = tracker.color
        button.translatesAutoresizingMaskIntoConstraints = false
        
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
            
            countLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 12),
            countLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -24),
            button.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -12),
            button.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -16),
            button.widthAnchor.constraint(equalToConstant: 34),
            button.heightAnchor.constraint(equalToConstant: 34)
//            button.topAnchor.constraint(equalTo: containerView.bottomAnchor, constant: 8),
        ])
    }
}
