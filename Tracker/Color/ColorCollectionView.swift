//
//  ColorCollectionView.swift
//  Tracker
//
//  Created by Sultan Akhmetbek on 03.09.2025.
//

import UIKit

final class ColorCollectionView: UIView {
    private let collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
    private let colorList: [UIColor] = [
        .ybColor1, .ybColor2, .ybColor3, .ybColor4, .ybColor5, .ybColor6,
        .ybColor7, .ybColor8, .ybColor9, .ybColor10,.ybColor11, .ybColor12,
        .ybColor13, .ybColor14,.ybColor15, .ybColor16,.ybColor17, .ybColor18]
    
    private var selectedColor: UIColor?
    
    var delegate: CreateTrackerDelegate?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .ybBlack
        translatesAutoresizingMaskIntoConstraints = false
        
        collectionView.register(ColorCollectionViewCell.self, forCellWithReuseIdentifier: ColorCollectionViewCell.identifier)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.delegate = self
        collectionView.dataSource = self
        
        addSubview(collectionView)
        configureConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureConstraints() {
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: topAnchor, constant: 24),
            collectionView.leadingAnchor.constraint(equalTo: leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -24)
        ])
    }
}

extension ColorCollectionView: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let itemsPerRow: CGFloat = 6
        let padding: CGFloat = 16 * 2
        let availableWidth = collectionView.bounds.width - padding
        let widthPerItem = availableWidth / itemsPerRow

        return CGSize(width: widthPerItem, height: widthPerItem)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        0
    }
}

extension ColorCollectionView: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        colorList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ColorCollectionViewCell.identifier, for: indexPath) as? ColorCollectionViewCell else {
            return UICollectionViewCell()
        }
        
        let color = colorList[indexPath.row]
        
        cell.setup(with: color, isActive: color == selectedColor)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        selectedColor = colorList[indexPath.row]
        
        if let selectedColor {
            delegate?.setColor(value: selectedColor)
            collectionView.reloadData()
        }
    }
}
