//
//  CurrencyCalculatorTests.swift
//  CurrencyCalculatorTests
//
//  Created by andela-cj on 03/11/2015.
//  Copyright © 2015 andela-cj. All rights reserved.
//

import XCTest
@testable import CurrencyCalculator

class CurrencyCalculatorTests: XCTestCase {
    var brain = Brain()
    
    func testAddition() {
        brain.addDigit(5)
        XCTAssertFalse(brain.isTyping)
        brain.performOperation(operation.add)
        brain.addDigit(8)
        XCTAssertEqual(13, brain.result)
    }
    
    func testContinuousCalculation(){
        brain.addDigit(8)
        brain.performOperation(operation.add)
        brain.addDigit(4)
        brain.performOperation(operation.minus)
        XCTAssertEqual(12, brain.result)
        brain.addDigit(2)
        brain.performOperation(operation.times)
        XCTAssertEqual(10, brain.result)
    }
    
    func testRecursiveCalculation(){
        brain.pushOperand(5)
        brain.performOperation("+")
        brain.pushOperand(8)
        brain.performOperation("×")
        XCTAssertEqual(13, brain.result)
        brain.pushOperand(2)
        XCTAssertEqual(26, brain.evaluate())
    }
    
    func testBadCalculation_ShouldReturn(){
        brain.performOperation("+")
        brain.pushOperand(5)
        brain.performOperation("×")
        brain.pushOperand(8)
        XCTAssertEqual(nil, brain.evaluate())
    }
    
    struct operation {
        static let add = "+"
        static let times = "×"
        static let div = "÷"
        static let minus = "−"
    }

}
