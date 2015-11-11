//
//  MainViewController.swift
//  CurrencyCalculator
//
//  Created by andela-cj on 03/11/2015.
//  Copyright © 2015 andela-cj. All rights reserved.
//

import UIKit

class MainViewController: UIViewController, DisplayDelegete{
    let calculator = Calculator()
    @IBOutlet weak var pickerView: UIPickerView!
    @IBOutlet weak var resultDisplay: UILabel!
    @IBOutlet weak var historyLabel: UILabel!
    
    @IBAction func digitPressed(sender: UIButton) {
        calculator.addDigit(sender.currentTitle!)
    }
    
    @IBAction func enterPressed(sender: UIButton) {
        calculator.evaluate()
    }
    
    @IBAction func operationPressed(sender: UIButton) {
        calculator.updateOperation(sender.currentTitle!)
    }
    
    @IBAction func periodPressed(sender: UIButton) {
        calculator.addPeriod()
    }
    @IBAction func clear(sender: UIButton) {
        calculator.clear()
        historyLabel.text = ""
    }
    
    func updateHistory(action:String){
        historyLabel.text! += action + " "
    }
    
    func update(result: String?) {
        if let re = result {
            if re.hasSuffix("."){
                resultDisplay.text = re
                return
            }
            let formatter = NSNumberFormatter()
            formatter.numberStyle = NSNumberFormatterStyle.DecimalStyle
            formatter.maximumFractionDigits = 6
            if let res = formatter.numberFromString(re){
                resultDisplay.text = res.stringValue
            }
        }
    }
    
    override func viewDidLoad() {
        calculator.displayDelegate = self
        pickerView.dataSource = calculator.inner
        pickerView.delegate = calculator.inner
    }
}