//
//  RoutineDTOTests.swift
//  oqloqTests
//
//  Created by Saglam, Fatih on 16.07.2024.
//

import XCTest
@testable import oqloq

class RoutineDTOTests: XCTestCase {
    
    func testPresentableRoutineConversion() {
        // Define the date formatter to create test dates
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy/MM/dd HH:mm"
        
        // Test 1: Regular time conversion
        let startTime1 = dateFormatter.date(from: "2024/07/15 06:30")!
        let endTime1 = dateFormatter.date(from: "2024/07/15 18:45")!
        let routine1 = RoutineDTO(startTime: startTime1, endTime: endTime1, color: .red)
        let presentable1 = routine1.presentable
        
        XCTAssertEqual(presentable1.start, (6.5 / 24.0), accuracy: 0.0001)
        XCTAssertEqual(presentable1.end, (18.75 / 24.0), accuracy: 0.0001)
        
        // Test 2: Edge case - start and end at midnight
        let startTime2 = dateFormatter.date(from: "2024/07/15 00:00")!
        let endTime2 = dateFormatter.date(from: "2024/07/15 00:00")!
        let routine2 = RoutineDTO(startTime: startTime2, endTime: endTime2, color: .blue)
        let presentable2 = routine2.presentable
        
        XCTAssertEqual(presentable2.start, 0.0, accuracy: 0.0001)
        XCTAssertEqual(presentable2.end, 0.0, accuracy: 0.0001)
        
        // Test 3: Edge case - end time next day
        let startTime3 = dateFormatter.date(from: "2024/07/15 23:59")!
        let endTime3 = dateFormatter.date(from: "2024/07/16 00:01")!
        let routine3 = RoutineDTO(startTime: startTime3, endTime: endTime3, color: .green)
        let presentable3 = routine3.presentable
        
        XCTAssertEqual(presentable3.start, (23.9833 / 24.0), accuracy: 0.0001)
        XCTAssertEqual(presentable3.end, (0.0167 / 24.0), accuracy: 0.0001)
        
        // Test 4: Edge case - start time previous day, end time next day
        let startTime4 = dateFormatter.date(from: "2024/07/15 23:00")!
        let endTime4 = dateFormatter.date(from: "2024/07/16 07:00")!
        let routine4 = RoutineDTO(startTime: startTime4, endTime: endTime4, color: .green)
        let presentable4 = routine4.presentable
        
        let expectedStart4 = (23.0 / 24.0)
        let expectedEnd4 = (7.0 / 24.0)
        
        XCTAssertEqual(presentable4.start, expectedStart4, accuracy: 0.0001)
        XCTAssertEqual(presentable4.end, expectedEnd4, accuracy: 0.0001)
    }
}
