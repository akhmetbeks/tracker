//
//  TrackerTests.swift
//  TrackerTests
//
//  Created by Sultan Akhmetbek on 05.10.2025.
//

import XCTest
import SnapshotTesting
@testable import Tracker

final class TrackerTests: XCTestCase {
    func testTrackerViewController() {
        let container = (UIApplication.shared.delegate as! AppDelegate).storeContainer
        let recordStore = container.recordStore
        let vc = TrackerViewController(
            categoryStore: container.categoryStore,
            trackerStore: container.trackerStore,
            recordStore: recordStore)
        assertSnapshot(of: vc, as: .image(traits: .init(userInterfaceStyle: .light)), testName: "TrackerViewController")
    }
    
    func testTrackerViewControllerDark() {
        let container = (UIApplication.shared.delegate as! AppDelegate).storeContainer
        let recordStore = container.recordStore
        let vc = TrackerViewController(
            categoryStore: container.categoryStore,
            trackerStore: container.trackerStore,
            recordStore: recordStore)
        assertSnapshot(of: vc, as: .image(traits: .init(userInterfaceStyle: .dark)), testName: "TrackerViewControllerDark")
    }
}
