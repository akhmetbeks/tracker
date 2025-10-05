//
//  AnalyticsEnum.swift
//  Tracker
//
//  Created by Sultan Akhmetbek on 05.10.2025.
//

enum AnalyticsEventEnum: String {
    case open
    case close
    case click
}

enum AnalyticsScreenEnum {
    case main
    
    var name: String {
        switch self {
        case .main:
            "Main"
        }
    }
}

enum AnalyticsItemEnum: String {
    case addTrack
    case track
    case filter
    case edit
    case delete
    
    var name: String {
        switch self {
        case .addTrack:
            "add_track"
        default:
            self.rawValue
        }
    }
}
