//
//  ViewController.swift
//  Calculator
//
//  Created by Vladimir Fibe on 24.01.2022.
//

import UIKit

class ViewController: UIViewController {
  @IBOutlet weak var display: UILabel!
  var userIsInTheMiddleOfTyping = false
  private var brain = CalculatorBrain()
  var displayValue: Double {
    get {
      return Double(display.text!) ?? 0
    }
    set {
      display.text = String(newValue)
    }
  }
  @IBAction func touchDigit(_ sender: UIButton) {
    guard let digit = sender.currentTitle else { return }
    if userIsInTheMiddleOfTyping {
      let textCurrentlyInDisplay = display.text!
      display.text = textCurrentlyInDisplay + digit
    } else {
      display.text = digit
      userIsInTheMiddleOfTyping = true
    }
  }
  @IBAction func performOperation(_ sender: UIButton) {
    if userIsInTheMiddleOfTyping {
      brain.setOperand(displayValue)
      userIsInTheMiddleOfTyping = false
    }
    guard let mathematicalSymbol = sender.currentTitle else { return }
    brain.performOperation(mathematicalSymbol)
    if let result = brain.result {
      displayValue = result
    }
  }
  
}

