//
//  BasicWeatherTests.swift
//  BasicWeatherTests
//
//  Created by R K on 1/4/24.
//

import XCTest
@testable import BasicWeather

final class BasicWeatherTests: XCTestCase {

    func testAverage() {
        // setup
        let n1: [Double] = [1, 2, 3, 4, 5]
        let n2: [Double] = [64, 5, 48, 816]
        
        // execute
        let r1 = n1.average
        let r2 = n2.average
        
        // assert
        XCTAssertEqual(r1, 3)
        XCTAssertEqual(r2, 233.25)
    }
}
