//
//  UIColor+Extension.swift
//  Tracker
//
//  Created by Sultan Akhmetbek on 03.10.2025.
//

import UIKit

extension UIColor {
    func toData() -> Data? {
        try? NSKeyedArchiver.archivedData(withRootObject: self, requiringSecureCoding: false)
    }
}
