//
//  Calculator.swift
//  CurrencyCalculator
//
//  Created by andela-cj on 03/11/2015.
//  Copyright © 2015 andela-cj. All rights reserved.
//

import Foundation

public protocol DisplayDelegete{
    func update(result:Double?)
    func updateHistory(action:String)
}

class Calculator {
    var displayDelegate:DisplayDelegete?
    private var memory = Array<Double>()
    private var brain = Brain()
    private var period = false
    private var operation:String?
    private var temp:String = "0"{
        didSet{
            displayDelegate?.update(Double(temp)!)
        }
    }
    
    func addDigigt(digit:String){
        let dot = "."
        if  brain.ready {
            temp += digit
            if (digit == dot){
                period = true
            }
        }else{
            temp = digit
            if (digit == dot){
                period = true
                temp = "0"+digit
            }
            brain.switchState()
            displayDelegate?.updateHistory(operation ?? "")
        }
    }
    
    func updateOperation(operation: String){
        if brain.ready {
            brain.pushOperand(Double(temp)!)
            displayDelegate?.updateHistory(temp)
        }
        self.operation = operation
        brain.performOperation(operation)
        displayDelegate?.update(brain.result)
      
    }

    func clear(){
        temp = "0"
        brain = Brain()
    }
    
    func evaluate(){
        if brain.ready {
            brain.addDigit(Double(temp)!)
            displayDelegate?.updateHistory(temp)
        }
        if let result = brain.evaluate() {
            displayDelegate?.update(result)
        }
    }
}