//
//  TrackerSectionHeader.swift
//  Tracker
//
//  Created by Sultan Akhmetbek on 22.08.2025.
//

import UIKit

final class TrackerSectionHeader: UICollectionReusableView {
    private let label = UILabel()
    
    static let identifier = "TrackerSectionHeader"
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubview(label)
        label.font = .systemFont(ofSize: 19, weight: .bold)
        label.textColor = .text
        label.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            label.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 12),
            label.topAnchor.constraint(equalTo: topAnchor),
            label.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
}
