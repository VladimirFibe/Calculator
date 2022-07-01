//
//  ViewController.swift
//  Calculator
//
//  Created by Vladimir Fibe on 24.01.2022.
//

import UIKit

class ViewController: UIViewController {
  
  @IBOutlet weak var zero: UIButton!
  @IBOutlet var buttons: [UIButton]!
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
  override func viewDidLoad() {
    super.viewDidLoad()
    
  }
  override func viewWillAppear(_ animated: Bool) {
    let height = 0.5 * zero.frame.height
    let width = 0.5 * (zero.titleLabel?.intrinsicContentSize.width ?? 0)
    buttons.forEach {
      $0.layer.cornerRadius = height - 4
      $0.titleLabel?.font = .systemFont(ofSize: height)
    }
    zero.contentHorizontalAlignment = .leading
    zero.titleEdgeInsets = UIEdgeInsets(top: 0, left: height - width, bottom: 0, right: 0)
  }
}

// http://www.appbuildingblocks.com/build-ios-calculator-app-tutorial-part-1/
