//
//  ViewController.swift
//  calculator
//
//  Created by Famun Nabi on 2/2/17.
//  Copyright © 2017 Famun Nabi. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    @IBOutlet private weak var display: UILabel!
    @IBOutlet private weak var opInProgress: UILabel!
    
    private var userInTheMiddleOfTyping = false
    private var isGet = false
    
    private func getValue(digit : String, isFirstDigit: Bool)->String {
        var retVal : String = ""
        if digit == "." {
            if !isGet {
                isGet = true
                if isFirstDigit {
                    retVal = "0."
                } else {
                    retVal = "."
                }
            }
        } else {
            retVal = digit
        }
        return retVal
    }

    @IBAction private func touchDigit(_ sender: UIButton) {
        let digit = sender.currentTitle!

        if userInTheMiddleOfTyping {
            let texCurrentlyInDisplay = display.text!
            display.text = texCurrentlyInDisplay + getValue(digit: digit, isFirstDigit: false)
        } else {
            display.text = getValue(digit: digit, isFirstDigit: true)
        }
        userInTheMiddleOfTyping = true
    }
    
    private var displayValue: Double {
        get {
            return Double(display.text!)!
        }
        set {
            display.text = String(newValue)
        }
    }
    
    private var brain = CalculatorBrain()
    
    @IBAction private func performOperation(_ sender: UIButton) {
        if userInTheMiddleOfTyping {
            brain.setOperand(operand: displayValue)
            userInTheMiddleOfTyping = false
            isGet = false
        }
        if let mathematicalSymbol = sender.currentTitle {
            brain.performOperation(symbol: mathematicalSymbol)
        }
        displayValue = brain.result
        if brain.isPartialResult {
            opInProgress.text = brain.description + "..."
        } else {
            opInProgress.text = brain.description + "="
        }
    }
}

