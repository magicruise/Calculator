//
//  ViewController.swift
//  Calculator
//
//  Created by LSMSE on 2017. 4. 17..
//  Copyright © 2017년 LSMSE. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var display: UILabel!
    
    @IBOutlet weak var displayDescription: UILabel!
    
    var userIsInTheMiddleOfTyping = false
    
    @IBAction func touchDigit(_ sender: UIButton) {
        let digit = sender.currentTitle!
        if userIsInTheMiddleOfTyping {
            let textCurrentlyInDisplay = display.text!
            if !digit.contains(".") || !textCurrentlyInDisplay.contains(".") { // 2. decimal point
                display.text = textCurrentlyInDisplay + digit
            }
        } else {
            display.text = digit
            userIsInTheMiddleOfTyping = true
        }
    }
    
    var displayValue: Double {
        get {
            return Double(display.text!)!
        }
        set {
            display.text = String(newValue)
        }
    }
    
    private var brain = CalculatorBrain()
    
    @IBAction func performOperation(_ sender: UIButton) {
        if userIsInTheMiddleOfTyping {
            // 7.
            // If the userIsInTheMiddleOfTyping, you can leave the UILabel showing whatever was there 
            // before the user started typing the number.
            if !brain.resultIsPending {
                brain.clear()
            }
            
            brain.setOperand(displayValue)
            userIsInTheMiddleOfTyping = false
        }
        if let mathematicalSymbol = sender.currentTitle {
            brain.performOperation(mathematicalSymbol)
        }
        
        // 7.
        // If resultIsPending is true, put . . . on the end of the UILabel, else put =.
        if brain.resultIsPending {
            displayDescription.text = brain.description + "..."
        } else {
            displayDescription.text = brain.description + "="
        }
        
        if let result = brain.result {
            displayValue = result
        }
    }
    
    // 8.
    @IBAction func clear() {
        userIsInTheMiddleOfTyping = false
        display.text = "0"
        displayDescription.text = " "
        brain.clear()
    }
}

