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
        brain.pushOperand(5)
        XCTAssertFalse(brain.ready)
        brain.performOperation(operation.add)
        brain.pushOperand(8)
        XCTAssertEqual(13, brain.evaluate())
    }
    
    func testContinuousCalculation(){
        brain.pushOperand(8)
        brain.performOperation(operation.add)
        brain.pushOperand(4)
        brain.performOperation(operation.minus)
        XCTAssertEqual(12, brain.last)
        brain.pushOperand(2)
        brain.performOperation(operation.times)
        XCTAssertEqual(10, brain.last)
    }
    
    func testRecursiveCalculation(){
        brain.pushOperand(5)
        brain.performOperation("+")
        brain.pushOperand(8)
        brain.performOperation("×")
        XCTAssertEqual(13, brain.last)
        brain.pushOperand(2)
        XCTAssertEqual(26, brain.evaluate())
    }
    
    func testBadCalculation_ShouldReturn(){
        brain.performOperation("+")
        brain.pushOperand(5)
        brain.performOperation("×")
        brain.pushOperand(8)
        XCTAssertEqual(40, brain.evaluate())
    }
    
    func testOpEquality(){
        XCTAssertFalse(Op.operand(4) == Op.operand(6))
        XCTAssertTrue(Op.binaryOperation(operation.div, /) == Op.binaryOperation(operation.div, /))
        XCTAssertTrue(Op.binaryOperation(operation.minus, -) == Op.binaryOperation(operation.minus, -))
    }
    
    struct operation {
        static let add = "+"
        static let times = "×"
        static let div = "÷"
        static let minus = "−"
    }

}
