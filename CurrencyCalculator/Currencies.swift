//
//  Currencies.swift
//  CurrencyCalculator
//
//  Created by Chijioke Ndubisi on 10/11/2015.
//  Copyright © 2015 andela-cj. All rights reserved.
//

import Foundation

struct Currencies{
    static var baseCurrency:String = "USD"
    static var tempCurrency:String = "USD"
    static var currencyList = ["USD":1.0
        ,"KWD":0.3021
        ,"BHD":0.3772
        ,"OMR":0.3851
        ,"GBP":0.6584
        ,"JOD":0.708
        ,"KYD":0.8200
        ,"EUR":0.8942
        ,"CHF":0.9785
        ,"AZN":1.0465
        ,"CAD":1.3334]
    
    func reset(){
        Currencies.baseCurrency = "USD"
        Currencies.tempCurrency = "USD"
    }
    
    func swap(){
        let temp = Currencies.tempCurrency
        Currencies.tempCurrency = Currencies.baseCurrency
        Currencies.baseCurrency = temp
    }

}



protocol CurrencyConverter{
    var baseCurrency:String { get }
    var tempCurrency:String { get }
    func convertToBase(value:Double) -> Double
    func convert(value:Double) -> Double
}