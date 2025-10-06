//
//  AnalyticsEnum.swift
//  Tracker
//
//  Created by Sultan Akhmetbek on 05.10.2025.
//

enum Analytics {
    enum Event: String {
        case open, close, click
    }

    enum Screen: String {
        case main = "Main"
    }

    enum Item: String {
        case addTrack = "add_track"
        case track
        case filter
        case edit
        case delete
    }
}
