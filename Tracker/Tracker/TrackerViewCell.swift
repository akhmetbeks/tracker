//
//  TrackerViewCell.swift
//  Tracker
//
//  Created by Sultan Akhmetbek on 22.08.2025.
//

import UIKit

final class TrackerViewCell: UICollectionViewCell {
    private let countLabel = UILabel()
    private let checkmarkImageView = UIImageView()
    
    static let identifier = "TrackerViewCell"
    private var tracker: Tracker?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        contentView.layer.cornerRadius = 8
        contentView.layer.masksToBounds = true
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    func configure(with tracker: Tracker, isCompleted: Bool, count: Int) {
        self.tracker = tracker
        let containerView = UIView()
        
        containerView.backgroundColor = tracker.color
        containerView.layer.cornerRadius = 16
        containerView.translatesAutoresizingMaskIntoConstraints = false
        
        let titleLabel = UILabel()
        titleLabel.text = tracker.title
        titleLabel.font = .ypMedium
        titleLabel.textColor = .white
        titleLabel.numberOfLines = 2
        titleLabel.lineBreakMode = .byWordWrapping
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        
        let emojiLabel = UILabel()
        emojiLabel.text = tracker.emoji
        emojiLabel.textAlignment = .center
        emojiLabel.backgroundColor = .white.withAlphaComponent(0.3)
        emojiLabel.layer.cornerRadius = 12
        emojiLabel.layer.masksToBounds = true
        emojiLabel.translatesAutoresizingMaskIntoConstraints = false
        
        countLabel.text = "\(count) дней"
        countLabel.font = .ypMedium
        countLabel.textColor = .text
        countLabel.translatesAutoresizingMaskIntoConstraints = false
        
        let image = UIImage(resource: isCompleted ? .check : .plus)
            .withRenderingMode(.alwaysTemplate)
        checkmarkImageView.image = image
        checkmarkImageView.tintColor = tracker.color
        checkmarkImageView.translatesAutoresizingMaskIntoConstraints = false
        
        contentView.addSubview(containerView)
        contentView.addSubview(countLabel)
        contentView.addSubview(checkmarkImageView)
        containerView.addSubview(emojiLabel)
        containerView.addSubview(titleLabel)
        
        NSLayoutConstraint.activate([
            containerView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            containerView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            containerView.topAnchor.constraint(equalTo: contentView.topAnchor),
            containerView.bottomAnchor.constraint(equalTo: countLabel.topAnchor, constant: -16),

            emojiLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 12),
            emojiLabel.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 12),
            emojiLabel.widthAnchor.constraint(equalToConstant: 24),
            emojiLabel.heightAnchor.constraint(equalToConstant: 24),
            
            titleLabel.topAnchor.constraint(equalTo: emojiLabel.bottomAnchor, constant: 8),
            titleLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 12),
            titleLabel.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -12),
            titleLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -12),
            
            countLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 12),
            countLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -24),
            checkmarkImageView.topAnchor.constraint(equalTo: containerView.bottomAnchor, constant: 8),
            checkmarkImageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -12),
            checkmarkImageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -16),
            checkmarkImageView.widthAnchor.constraint(equalToConstant: 34),
            checkmarkImageView.heightAnchor.constraint(equalToConstant: 34)
        ])
    }
}
