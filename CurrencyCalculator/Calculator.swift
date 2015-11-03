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
    var opera = operation()
    var isTyping = false
    var period = false
    var temp:String?
    
    func addDigigt(digit:String){
        let dot = "."
        if (isTyping){
            temp! += digit
            if (digit == dot){
                period = true
            }
        }else{
            temp! = digit
            if (digit == dot){
                period = true
                temp! = "0"+digit
            }
            isTyping = true
        }
    }
    
    func updateOperation(operation: String){
        if (operation != opera.currentOperation){
            opera.currentOperation = operation
            evaluate()
            isTyping = false
        }
    }

    func clear(){
        temp = "0"
        isTyping = false
    }
    func evaluate(){
        if(memory.count >= 2){
            if (opera.currentOperation != nil) {
                memory.append(opera.evaluate(self.memory.removeLast(),op2:self.memory.removeLast())!)
                opera.currentOperation = nil
            }
        }else{
            memory.append(Double(temp!)!)
        }
    }
    
    struct operation {
        var currentOperation:String?
        func evaluate(op1:Double, op2:Double) -> Double?{
            if (currentOperation != nil){
                switch currentOperation!{
                case "×": return op1 * op2
                case "+": return op1 + op2
                case "÷": return op1 / op2
                case "−": return op1 - op2
                default: return nil
                }
            }
            return nil
        }
    }
}