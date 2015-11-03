//
//  MainViewController.swift
//  CurrencyCalculator
//
//  Created by andela-cj on 03/11/2015.
//  Copyright © 2015 andela-cj. All rights reserved.
//

import UIKit

class MainViewController: UIViewController{
    
    @IBOutlet weak var resultDisplay: UILabel!
    var brain = Calculator()
    
    @IBAction func digitPressed(sender: UIButton) {
        brain.addDigigt(sender.currentTitle!)
    }
    
    @IBAction func enterPressed(sender: UIButton) {
        brain.evaluate()
    }
    
    @IBAction func operationPressed(sender: UIButton) {
        brain.updateOperation(sender.currentTitle!)
    }
}