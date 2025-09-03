//
//  EmojiCell.swift
//  Tracker
//
//  Created by Sultan Akhmetbek on 02.09.2025.
//

import UIKit

final class EmojiCollectionViewCell: UICollectionViewCell {
    private let label = UILabel()
    static let identifier = "EmojiCollectionViewCell"
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        label.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(label)
        configureConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureConstraints() {
        NSLayoutConstraint.activate([
            label.topAnchor.constraint(equalTo: contentView.topAnchor),
            label.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            label.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            label.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ])
    }
    
    func setup(with emoji: String, isActive: Bool) {
        label.text = emoji
        label.textAlignment = .center
        if isActive {
            label.backgroundColor = .ybLightGrey
            label.layer.cornerRadius = 16
            label.layer.masksToBounds = true
        } else {
            label.backgroundColor = .clear
        }
    }
}
