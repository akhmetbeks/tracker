//
//  Analytics.swift
//  Tracker
//
//  Created by Sultan Akhmetbek on 05.10.2025.
//
import AppMetricaCore

protocol AnalyticsServiceProtocol {
    func sendEvent(event: String, screen: String, item: String?)
}

final class AppMetricaService: AnalyticsServiceProtocol {
    static let shared = AppMetricaService()
    private init() {}
    
    func activate(apiKey: String) {
        guard let configuration = AppMetricaConfiguration(apiKey: apiKey) else { return }
        AppMetrica.activate(with: configuration)
    }
    
    func sendEvent(event: String, screen: String, item: String?) {
        var params: [AnyHashable: Any] = [:]
        params["screen"] = screen
        if item != nil { params["item"] = item }
        AppMetrica.reportEvent(name: event, parameters: params)
    }
}
