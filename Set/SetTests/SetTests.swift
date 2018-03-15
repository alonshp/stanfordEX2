//
//  SetTests.swift
//  SetTests
//
//  Created by Alon Shprung on 3/15/18.
//  Copyright © 2018 Alon Shprung. All rights reserved.
//

import XCTest
@testable import SetGame

class SetTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testExample() {
        let x = 9
        let y = 8
        let result = x + y
        XCTAssertEqual(result, 17)
        XCTAssertTrue(result == 17)
    }
    
    func testMatchedSet() {

    }
    
    func testUnMatchedSet() {
        
    }
    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
    
}
