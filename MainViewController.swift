//
//  MainViewController.swift
//  CurrencyCalculator
//
//  Created by andela-cj on 03/11/2015.
//  Copyright © 2015 andela-cj. All rights reserved.
//

import UIKit

class MainViewController: UIViewController, DisplayDelegete, UIPickerViewDataSource, UIPickerViewDelegate{
    
    
    @IBOutlet weak var currencyPicker: UIPickerView!
    @IBOutlet weak var resultDisplay: UILabel!
    
    let list = Currencies()
    var calculator = Calculator()
    
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
    
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return list.currencyList.count
    }
    
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return list.currencyList[row]
    }
    
    func pickerView(pickerView: UIPickerView, attributedTitleForRow row: Int, forComponent component: Int) -> NSAttributedString? {
        let string = list.currencyList[row]
        return NSAttributedString(string:string, attributes: [NSForegroundColorAttributeName:UIColor.whiteColor(), NSFontAttributeName:UIFont(descriptor: UIFontDescriptor.preferredFontDescriptorWithTextStyle(UIFontTextStyleTitle2), size: 14)]);
    }
    
    override func viewDidLoad() {
        calculator.displayDelegate = self
        currencyPicker.dataSource = self
        currencyPicker.delegate = self
    }
}