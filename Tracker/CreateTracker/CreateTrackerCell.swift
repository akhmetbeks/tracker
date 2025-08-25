//
//  CreateTrackerSection.swift
//  Tracker
//
//  Created by Sultan Akhmetbek on 23.08.2025.
//

import UIKit

final class CreateTrackerCell: UITableViewCell {
    private let label = UILabel()
    private let image = UIImageView()
    private let stack = UIStackView()
    
    static let identifier = "CreateTrackerCell"
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        setupView()
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupView() {
        backgroundColor = .background
        
        label.font = .ypRegular
        label.textColor = .text
        
        image.image = UIImage(resource: .chevronRight)
        image.contentMode = .scaleAspectFit
        
        stack.axis = .horizontal
        stack.distribution = .equalSpacing
        stack.alignment = .center
        
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.addArrangedSubview(label)
        stack.addArrangedSubview(image)
        contentView.addSubview(stack)
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            stack.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            stack.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            stack.heightAnchor.constraint(equalToConstant: 75),
        ])
    }
    
    func setTitle(_ title: String) {
        label.text = title
    }
}
