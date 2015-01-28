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
    
    var userIsInTheMiddleOfTypingANumber = false

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
        let operation = sender.currentTitle!
        if userIsInTheMiddleOfTypingANumber {
            enterButtonPressed()
        }
        
        switch operation {
        case "✕": performOperation({ $0 * $1 })
        case "+": performOperation({ $0 + $1 })
        case "-": performOperation({ $1 - $0 })
        case "÷": performOperation({ $1 / $0 })
        case "√": performOperation({ sqrt($0) })
        default: break
        }
    }
    
    func performOperation(operation: (Double, Double) -> Double) {
        if operandStack.count >= 2 {
            displayValue = operation(operandStack.removeLast(), operandStack.removeLast())
            enterButtonPressed()
        }
    }
    
    func performOperation(operation: Double -> Double) {
        if operandStack.count >= 1 {
            displayValue = operation(operandStack.removeLast())
            enterButtonPressed()
        }
    }
    
    var operandStack = Array<Double>()
    
    @IBAction func enterButtonPressed()
    {
        userIsInTheMiddleOfTypingANumber = false
        operandStack.append(displayValue)
        println("Operand Stack = \(operandStack)")
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
}

