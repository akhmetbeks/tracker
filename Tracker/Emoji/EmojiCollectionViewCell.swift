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
            label.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            label.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
        ])
    }
    
    func setup(with emoji: String, isActive: Bool) {
        label.text = emoji
    }
}
