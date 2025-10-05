//
//  TrackerTests.swift
//  TrackerTests
//
//  Created by Sultan Akhmetbek on 05.10.2025.
//

import XCTest
import SnapshotTesting
@testable import Tracker

final class TrackerViewControllerSnapshotTests: XCTestCase {
    // MARK: - Properties
    private var container: StoreContainer!
    private var recordStore: TrackerRecordStore!
    private var sut: TrackerViewController!
    
    override func setUp() {
        super.setUp()
        container = (UIApplication.shared.delegate as! AppDelegate).storeContainer
        recordStore = container.recordStore
        sut = TrackerViewController(categoryStore: container.categoryStore, trackerStore: container.trackerStore, recordStore: recordStore)
    }
    
    override func tearDown() {
        container = nil
        recordStore = nil
        sut = nil
        super.tearDown()
    }
    
    //MARK: - Tests
    func test_mainScreen_lightTheme_snapshot() {
        assertSnapshot(
            of: sut,
            as: .image(traits: .init(userInterfaceStyle: .light)),
            testName: "TrackerViewController_Light")
    }
    
    func test_mainScreen_darkTheme_snapshot() {
        assertSnapshot(
            of: sut,
            as: .image(traits: .init(userInterfaceStyle: .dark)),
            testName: "TrackerViewController_Dark")
    }
}
