//
//  MainViewController.swift
//  CurrencyCalculator
//
//  Created by andela-cj on 03/11/2015.
//  Copyright © 2015 andela-cj. All rights reserved.
//

import UIKit

class MainViewController: UIViewController, DisplayDelegete{
    
    @IBOutlet weak var pickerView: UIPickerView!
    @IBOutlet weak var resultDisplay: UILabel!

    @IBOutlet weak var historyLabel: UILabel!
    
    let list = Currencies()
    var calculator = Calculator()
    var currencyPicker:CurrencyPicker?
    
    @IBAction func digitPressed(sender: UIButton) {
        calculator.addDigigt(sender.currentTitle!)
    }
    
    @IBAction func enterPressed(sender: UIButton) {
        calculator.evaluate()
    }
    
    @IBAction func operationPressed(sender: UIButton) {
        calculator.updateOperation(sender.currentTitle!)
    }
    
    @IBAction func clear(sender: UIButton) {
        calculator.clear()
        historyLabel.text = ""
    }
    
    func updateHistory(action:String){
        historyLabel.text! += action + " "
    }
    
    func update(result: Double?) {
        if let re = result {
            let formatter = NSNumberFormatter()
            formatter.numberStyle = NSNumberFormatterStyle.DecimalStyle
            formatter.maximumFractionDigits = 6
            if let res = formatter.stringForObjectValue(re){
                resultDisplay.text = res
            }
        }
    }
    
    override func viewDidLoad() {
        calculator.displayDelegate = self
        currencyPicker =  CurrencyPicker(pickerView)
    }
}