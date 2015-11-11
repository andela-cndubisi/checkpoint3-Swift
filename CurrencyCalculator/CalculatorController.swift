//
//  Calculator.swift
//  CurrencyCalculator
//
//  Created by andela-cj on 03/11/2015.
//  Copyright © 2015 andela-cj. All rights reserved.
//

import UIKit

protocol DisplayDelegete{
    func update(result:String?)
    func updateHistory(action:String)
}

class Calculator {
    var displayDelegate:DisplayDelegete?
    var brain = Brain()
    private var period = false
    private var operation:String?
    var inner = CurrencyPicker()
    private var temp:String = "0"{
        didSet{
            displayDelegate?.update(temp)
        }
    }
    
    init(){
        inner.parent = self
    }
    
    func addDigit(digit:String){
        if  brain.ready {
            temp += digit
        }else{
            brain.switchState()
            displayDelegate?.updateHistory(operation ?? "")
            operation = nil
            temp = digit
        }
    }
    
    func addPeriod(){
        let dot = "."
        if !period {
            temp += dot
        }
        period = true
        !brain.ready ? brain.switchState(): print("")
    }
    
    func updateOperation(operation: String){
        if brain.ready {
            brain.pushOperand(Double(temp)!)
            displayDelegate?.updateHistory(temp.hasSuffix(".") ? temp+"0" : temp)
        }
        self.operation = operation
        brain.performOperation(operation)
        if let re = brain.result {
            displayDelegate?.update("\(re)")
            inner.update()
        }
    }

    func clear(){
        temp = "0"
        operation = nil
        period = false
        inner.reset()
        brain = Brain()
    }
    
    func evaluate(){
        if brain.ready {
            brain.pushOperand(Double(temp)!)
            displayDelegate?.updateHistory(temp.hasSuffix(".") ? temp+"0" : temp)
        }
        if operation == nil {
            if let result = brain.evaluate() {
                brain.switchState()
                displayDelegate?.update("\(result)")
                inner.update()
            }
        }
    }
    
    class CurrencyPicker: NSObject,UIPickerViewDataSource, UIPickerViewDelegate{
        weak var parent:Calculator!
        let array = Array(Currencies.currencyList.keys)
        let currencies = Currencies()
        var picker:UIPickerView!
        func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
            picker = pickerView
            return 1
        }
        
        func reset(){
            currencies.reset()
            update()
        }
        
        func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
            return Currencies.currencyList.count
        }
        
        func update(){
            currencies.swap()
            picker.selectRow(array.indexOf(Currencies.baseCurrency)!, inComponent: 0, animated: true)
            print(" after swap base currency \(Currencies.baseCurrency) tempCurrency \(Currencies.tempCurrency)" )

        }
        
        func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
            let title = array[row]
            Currencies.tempCurrency = title

            if !parent.brain.ready && parent.operation == nil{
                if let _ = parent.brain.result{
                    parent.brain.result = parent.brain.convert(parent.brain.result!)
                    parent.displayDelegate?.update("\(parent.brain.result!)")
                    Currencies.baseCurrency = title
                }
            }
        }
    
        func pickerView(pickerView: UIPickerView, attributedTitleForRow row: Int, forComponent component: Int) -> NSAttributedString? {
            let title = Array(Currencies.currencyList.keys)[row]
            return NSAttributedString(string:title, attributes: [NSForegroundColorAttributeName:UIColor.whiteColor(), NSFontAttributeName:UIFont(descriptor: UIFontDescriptor.preferredFontDescriptorWithTextStyle(UIFontTextStyleTitle2), size: 14)]);
        }
    }
}