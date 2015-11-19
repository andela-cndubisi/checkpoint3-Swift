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
    weak var operation: UIButton!
    
    @IBAction func digitPressed(sender: UIButton) {
        calculator.addDigit(sender.currentTitle!)
    }
    
    @IBAction func enterPressed(sender: UIButton) {
        calculator.evaluate()
        if operation != nil{
            operation.layer.borderWidth = 0
            operation = nil
        }
    }
    
    @IBAction func operationPressed(sender: UIButton) {
        if operation != nil && operation.currentTitle != sender.currentTitle{
            operation.layer.borderWidth = 0
        }
        operation = sender
        sender.layer.borderColor = UIColor.whiteColor().CGColor
        sender.layer.borderWidth = 2
        calculator.updateOperation(sender.currentTitle!)
    }
    
    @IBAction func periodPressed(sender: UIButton) {
        calculator.addPeriod()
    }
    @IBAction func deleteDigit(sender: UISwipeGestureRecognizer) {
        switch sender.state{
        case .Ended:
            calculator.delete()
        default : break
        }
    }
    
    @IBAction func percent(){
        calculator.percentage()
    }
    

    
    @IBAction func clear(sender: UIButton) {
        calculator.clear()
        if operation != nil {
            operation.layer.borderWidth = 0
            operation = nil
        }
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
        super.viewDidLoad()
        calculator.displayDelegate = self
        pickerView.dataSource = calculator.picker
        pickerView.delegate = calculator.picker
        let edgeSwipe = UIScreenEdgePanGestureRecognizer(target: self, action: "showPickerView:")
        edgeSwipe.edges = .Right
        self.view.addGestureRecognizer(edgeSwipe)
        let hideGesture = UISwipeGestureRecognizer(target: self, action: "hidePickerView:")
        hideGesture.direction = .Right
        pickerView.addGestureRecognizer(hideGesture)
    }
    
    func showPickerView(sender: UIScreenEdgePanGestureRecognizer){
        switch sender.state{
        case .Ended:
            if !self.view.frame.contains(pickerView.frame) {
                UIView.animateWithDuration(0.1, animations: {
                    self.pickerView.frame.origin.x -= self.pickerView.frame.width
                    
                    }, completion:{ (_) -> Void  in
                        self.resultDisplay.frame.size.width -= self.pickerView.frame.size.width
                        self.historyLabel.frame.size.width = self.resultDisplay.frame.size.width
                })
            }
        default : break
        }
    }
    
    func hidePickerView(sender:UISwipeGestureRecognizer){
        switch sender.state {
        case .Ended , .Began:
            UIView.animateWithDuration(0.1, animations: { () -> Void in
                self.pickerView.frame.origin.x += self.pickerView.frame.width
                }, completion: { (_) -> Void in
                    self.resultDisplay.frame.size.width += self.pickerView.frame.size.width
                    self.historyLabel.frame.size.width = self.resultDisplay.frame.size.width
            })
        default:
            break
        }
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
    }
}