//
//  ColorCollectionViewCell.swift
//  Tracker
//
//  Created by Sultan Akhmetbek on 03.09.2025.
//


import UIKit

final class ColorCollectionViewCell: UICollectionViewCell {
    private let view = UIView()
    private let innerView = UIView()
    static let identifier = "ColorCollectionViewCell"
    
    override init(frame: CGRect) {
        super.init(frame: frame)

        view.backgroundColor = .clear
        view.layer.cornerRadius = 12
        innerView.layer.cornerRadius = 8
        view.translatesAutoresizingMaskIntoConstraints = false
        innerView.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(innerView)
        contentView.addSubview(view)
        
        configureConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureConstraints() {
        NSLayoutConstraint.activate([
            view.topAnchor.constraint(equalTo: contentView.topAnchor),
            view.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            view.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            view.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            innerView.topAnchor.constraint(equalTo: view.topAnchor, constant: 9),
            innerView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 9),
            innerView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -9),
            innerView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -9),
        ])
    }
    
    func setup(with color: UIColor, isActive: Bool) {
        innerView.backgroundColor = color
        
        if isActive {
            view.layer.borderWidth = 6
            view.layer.borderColor = color.withAlphaComponent(0.3).cgColor
        } else {
            view.layer.borderWidth = 0
        }
    }
}
