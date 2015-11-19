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

extension Double {
    public var description: String {get{return
        "\(Currencies.tempCurrency) \(self)" }}
}

class Calculator {
    var displayDelegate:DisplayDelegete?
    var brain = Brain()
    lazy var picker:CurrencyPicker =  {
        let picker = CurrencyPicker()
        picker.parent = self
        return picker }()
    
    private var period = false
    private var operation:String?
    private var temp:String = "0"{
        didSet{
            displayDelegate?.update(temp)
        }
    }
    
    func negate(){
        if brain.ready {
            temp = negate(temp)
        }
        if !brain {
            temp = negate("\(brain.last!)")
            brain.update(Double(temp)!)
        }
    }
    
    private func negate(string:String)->String{
        if string.containsString("-"){
            return string.stringByReplacingOccurrencesOfString("-", withString: "")
        }else {
            return "-" + string
        }
    }
    
    func delete(){
        if brain.ready{
            if temp.characters.count != 1 {
             temp = String(temp.characters.dropLast())
            } else{
                temp = "0"
            }
        }
    }
    
    func percentage() {
        if brain.ready {
            let formatter = NSNumberFormatter()
            formatter.numberStyle = NSNumberFormatterStyle.DecimalStyle
            formatter.maximumFractionDigits = 6
            let percet = formatter.numberFromString(temp)!.doubleValue / 100
            temp = "\(percet)"
        }
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
    
    func updateDisplay(value:Double){
        brain.update(value)
        temp = "\(value)"
    }
    
    func addPeriod(){
        let dot = "."
        if !period { temp += dot }
         period = true
        if brain.ready { brain.switchState() }
    }
    
    func updateOperation(operation: String){
        self.operation = operation
        evaluate()
    }

    func clear(){
        temp = "0"
        operation = nil
        period = false
        picker.reset()
        brain = Brain()
    }
    
    func evaluate(){
        if brain.ready {
            brain.pushOperand(Double(temp)!)
            displayDelegate?.updateHistory(temp.hasSuffix(".") ? "\(Double(temp+"0")!.description)" : "\(Double(temp)!.description)")
        }
        if operation == nil {
            if let result = brain.evaluate() {
                brain.switchState()
                displayDelegate?.update("\(result)")
            }
        } else {
            brain.performOperation(operation!)
            if let last = brain.last {
                displayDelegate?.update("\(last)")
            }
        }
        picker.update()
    }
    
    class CurrencyPicker: NSObject,UIPickerViewDataSource, UIPickerViewDelegate{
        weak var parent:Calculator!
        var currencies = Currencies()
        let array:[String]
        
        override init() {
            array = Array(currencies.currencyList)
            super.init()
        }

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
            return currencies.currencyList.count
        }
        
        func update(){
            picker.selectRow(array.indexOf(currencies.baseCurrency)!, inComponent: 0, animated: true)
            currencies.tempCurrency = currencies.baseCurrency
        }
        
        func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
            let title = array[row]
            currencies.tempCurrency = title
            
            if !parent.brain.ready && parent.operation == nil{
                if !parent.brain {
                    currencies.swap()
                    parent.updateDisplay(currencies.convert(parent.brain.last!))
                }
                currencies.baseCurrency = title
            }
        }
    
        func pickerView(pickerView: UIPickerView, attributedTitleForRow row: Int, forComponent component: Int) -> NSAttributedString? {
            let title = array[row]
            return NSAttributedString(string:title, attributes: [NSForegroundColorAttributeName:UIColor.whiteColor(), NSFontAttributeName:UIFont(descriptor: UIFontDescriptor.preferredFontDescriptorWithTextStyle(UIFontTextStyleTitle2), size: 14)]);
        }
    }
}