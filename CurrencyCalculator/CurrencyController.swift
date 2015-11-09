//
//  CurrencyController.swift
//  CurrencyCalculator
//
//  Created by Chijioke Ndubisi on 09/11/2015.
//  Copyright © 2015 andela-cj. All rights reserved.
//

import UIKit
import Foundation
public struct Currencies{
    var currencyList = ["USD","KWD","BHD", "OMR","GBP","JOD", "KYD", "EUR", "CHF","AZN","CAD"]
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

class CurrencyPicker: NSObject,UIPickerViewDataSource, UIPickerViewDelegate{
    let pickerView: UIPickerView
    let list = Currencies()

    
    init(_ picker: UIPickerView){
        pickerView = picker
        super.init()
        pickerView.delegate = self
        pickerView.dataSource = self
    }
    

    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return list.currencyList.count
    }
    
    func pickerView(pickerView: UIPickerView, attributedTitleForRow row: Int, forComponent component: Int) -> NSAttributedString? {
        let title = list.currencyList[row]
        return NSAttributedString(string:title, attributes: [NSForegroundColorAttributeName:UIColor.whiteColor(), NSFontAttributeName:UIFont(descriptor: UIFontDescriptor.preferredFontDescriptorWithTextStyle(UIFontTextStyleTitle2), size: 14)]);
    }
    
    
    
}