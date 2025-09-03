//
//  EmojiCollectionView.swift
//  Tracker
//
//  Created by Sultan Akhmetbek on 02.09.2025.
//

import UIKit

final class EmojiCollectionView: UIView {
    private let collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
    private let emojiList = ["🐶", "🦄", "🍎", "🍿", "🥦", "🎮",
                     "🥎", "🥊", "🥋", "🎱", "📚", "📱",
                     "🛀🏻", "🏄🏻‍♂️", "🏀", "🏊🏻‍♀️", "♟️", "🔮"]
    private var selectedEmoji: String?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .ybBlack
        translatesAutoresizingMaskIntoConstraints = false
        
        collectionView.register(EmojiCollectionViewCell.self, forCellWithReuseIdentifier: EmojiCollectionViewCell.identifier)
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
            collectionView.topAnchor.constraint(equalTo: topAnchor),
            collectionView.leadingAnchor.constraint(equalTo: leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
}

extension EmojiCollectionView: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let itemsPerRow: CGFloat = 6
        let innerPadding: CGFloat = 5
        let padding: CGFloat = 16 * 2
        let totalPadding = innerPadding * (itemsPerRow + 1) + padding
        let availableWidth = collectionView.bounds.width - totalPadding
        let widthPerItem = availableWidth / itemsPerRow

        return CGSize(width: widthPerItem, height: widthPerItem)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        5
    }
}

extension EmojiCollectionView: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        emojiList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: EmojiCollectionViewCell.identifier, for: indexPath) as? EmojiCollectionViewCell else {
            return UICollectionViewCell()
        }
        
        let emoji = emojiList[indexPath.row]
        
        cell.setup(with: emoji, isActive: emoji == selectedEmoji)
        return cell
    }
}
