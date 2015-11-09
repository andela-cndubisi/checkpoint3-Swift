//
//  Calculator.swift
//  CurrencyCalculator
//
//  Created by andela-cj on 03/11/2015.
//  Copyright © 2015 andela-cj. All rights reserved.
//

import Foundation



class Calculator {
    private var memory = Array<Double>()
    private var opera = Brain()
    private var period = false
    var displayDelegate:DisplayDelegete?
    private var temp:String?{
        didSet{
            displayDelegate?.update(Double(temp!))
        }
    }
    
    func addDigigt(digit:String){
        let dot = "."
        if (opera.isTyping){
            temp! += digit
            if (digit == dot){
                period = true
            }
        }else{
            temp = digit
            if (digit == dot){
                period = true
                temp = "0"+digit
            }
            opera.isTyping = true
        }
    }
    
    func updateOperation(operation: String){
        opera.pushOperand(Double(temp!)!)
        opera.performOperation(operation)
        displayDelegate?.update(opera.result)
    }


    func clear(){
        temp = "0"
        opera = Brain()
    }
    
    func evaluate(){
        if opera.isTyping {
            opera.addDigit(Double(temp!)!)
        }
        if let result = opera.evaluate() {
            displayDelegate?.update(result)
        }
    }
}