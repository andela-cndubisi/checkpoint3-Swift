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
}

protocol currencyTyp{
    var currency:String?{get set}
}
protocol currencyList{
    var currencyList:[String]{get set}
}

struct ExchangeRates{
    let USD:Double = 1.0
    let KWD:Double = 0.3021
    let BHD:Double = 0.3772
    let OMR:Double =  0.3851
    let GBP:Double = 0.6584
    let JOD :Double = 0.708
    let KYD :Double = 0.8200
    let EUR :Double = 0.8942
    let CHF :Double = 0.9785
    let AZN :Double = 1.0465
    let CAD :Double = 1.3334
}


public struct Currencies:currencyList {
    var currencyList = ["USD","KWD","BHD", "OMR","GBP","JOD", "KYD", "EUR", "CHF","AZN","CAD"]

}

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