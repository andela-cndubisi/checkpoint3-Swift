//
//  Currencies.swift
//  CurrencyCalculator
//
//  Created by Chijioke Ndubisi on 10/11/2015.
//  Copyright © 2015 andela-cj. All rights reserved.
//

import Foundation

struct Currencies: CurrencyConverter {
    static var baseCurrency:String = "USD"
    static var tempCurrency:String = "USD"
    var baseCurrency:String { get{ return Currencies.baseCurrency } set { Currencies.baseCurrency = newValue } }
    var tempCurrency:String { get{ return Currencies.tempCurrency } set { Currencies.tempCurrency = newValue } }
    let currencyList = Array(Currencies.currencyAndRates.keys)
    
    static var currencyAndRates = ["USD":1.0
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
    
    mutating func swap(){
        let temp = tempCurrency
        tempCurrency = baseCurrency
        baseCurrency = temp
    }
    
    func convertToBase(value:Double) -> Double {
        return value * Currencies.currencyAndRates[baseCurrency]!;
    }
    
    func convert(value:Double) -> Double {
        if baseCurrency != tempCurrency {
            let currentInBase:Double = convertToBase(value);
            let rate:Double  = Currencies.currencyAndRates[tempCurrency]!
            return currentInBase / rate;
        }
        return value;
    }

    

}

protocol CurrencyConverter{
    static var currencyAndRates:[String:Double]{get}
    var baseCurrency:String { get set }
    var tempCurrency:String { get set }
    func convertToBase(value:Double) -> Double
    func convert(value:Double) -> Double
}