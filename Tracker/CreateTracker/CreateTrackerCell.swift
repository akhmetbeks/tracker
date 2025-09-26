//
//  CreateTrackerSection.swift
//  Tracker
//
//  Created by Sultan Akhmetbek on 23.08.2025.
//

import UIKit

final class CreateTrackerCell: UITableViewCell {
    static let identifier = "CreateTrackerCell"
    private var content: UIListContentConfiguration!
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        backgroundColor = .background
        selectionStyle = .none
        accessoryType = .disclosureIndicator
        
        content = defaultContentConfiguration()
        self.contentConfiguration = content
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setTitle(_ title: String) {
        content.text = title
        content.textProperties.font = .ypRegular
        content.textProperties.color = .text
        self.contentConfiguration = content
    }
    
    func setSubtitle(_ subtitle: String) {
        content.secondaryText = subtitle
        content.secondaryTextProperties.font = .ypRegular
        content.secondaryTextProperties.color = .secondaryLabel
        self.contentConfiguration = content
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        self.contentConfiguration = nil
    }
}
