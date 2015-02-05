//
//  ViewController.swift
//  Calculator
//
//  Created by Spencer Morris on 1/26/15.
//  Copyright (c) 2015 SpencerMorris. All rights reserved.
//

import UIKit

class ViewController: UIViewController
{
    @IBOutlet weak var displayLabel: UILabel!
    @IBOutlet weak var historyLabel: UILabel!
    
    var userIsInTheMiddleOfTypingANumber = false
    var brain = CalculatorBrain()
    
    @IBAction func appendDigit(sender: UIButton) {
        let digit = sender.currentTitle!
        if userIsInTheMiddleOfTypingANumber {
            if digit == "." && displayLabel.text!.rangeOfString(".") != nil {
                // if digit is decimal point and number already has decimal, don't allow it to be added
                println("tried to add decimal to number with decimal already")
            } else {
                displayLabel.text = displayLabel.text! + digit
            }
        } else {
            displayLabel.text = digit
            userIsInTheMiddleOfTypingANumber = true
        }
        println("digit = \(digit)")
    }
    
    @IBAction func operateButtonPressed(sender: UIButton)
    {
        if userIsInTheMiddleOfTypingANumber {
            enterButtonPressed()
        }
        if let operation = sender.currentTitle {
            if let result = brain.performOperation(operation) {
                historyLabel.text = "\(historyLabel.text!) \(operation)"
                displayValue = result
            }
        }
        
    }
    
    @IBAction func enterButtonPressed()
    {
        userIsInTheMiddleOfTypingANumber = false
        if let result = brain.pushOperand(displayValue) {
            historyLabel.text = "\(historyLabel.text!) \(displayValue) ⏎"
            displayValue = result
        } else {
            displayValue = 0
        }
    }
    
    var displayValue: Double {
        get {
            return (displayLabel.text! as NSString).doubleValue
        }
        
        set {
            displayLabel.text = "\(newValue)"
            userIsInTheMiddleOfTypingANumber = false
        }
    }
    
    @IBAction func clearButtonPressed()
    {
        // reset all outlets and local vars
        brain.clear()
        displayLabel.text = "0"
        userIsInTheMiddleOfTypingANumber = false
        historyLabel.text = ""
    }
    
}

