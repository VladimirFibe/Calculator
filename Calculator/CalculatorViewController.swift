import SwiftUI

class CalculatorViewController: UIViewController {
    #warning("поправить ввод десятично точки")
    var displayValue: Double {
        get {
            let text = display.text ?? "0"
            return Double(text) ?? 0.0
        }
        set {
            display.text = String(newValue)
        }
    }
    var userIsInTheMiddleOfTyping = false
    let display = UILabel()
    lazy var calculatorStack = UIStackView(arrangedSubviews: [display])
    private var brain = CalculatorBrain()
    override func viewDidLoad() {
        super.viewDidLoad()
        setupStack()
    }
    
    func setupStack() {
        setupDisplay()
        calculatorStack.axis = .vertical
        calculatorStack.spacing = 8
        let buttons: [[CalculatorButton]] = [
            [.ac, .plusMinus, .perecent, .divide],
            [.seven, .eight, .nine, .multiply],
            [.four, .five, .six, .minus],
            [.one, .two, .three, .plus]
        ]
        for row in buttons {
            let stack = buttonsStack()
            for button in row {
                stack.addArrangedSubview(addButton(button))
            }
            calculatorStack.addArrangedSubview(stack)
        }
        let stack = buttonsStack()
        stack.addArrangedSubview(addButton(.point))
        stack.addArrangedSubview(addButton(.equals))
        let stackWithZero = buttonsStack()
        stackWithZero.addArrangedSubview(addButton(.zero))
        stackWithZero.addArrangedSubview(stack)
        calculatorStack.addArrangedSubview(stackWithZero)
        view.addSubview(calculatorStack)
        calculatorStack.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            calculatorStack.leadingAnchor.constraint(
                equalToSystemSpacingAfter: view.leadingAnchor, multiplier: 1),
            view.trailingAnchor.constraint(
                equalToSystemSpacingAfter: calculatorStack.trailingAnchor, multiplier: 1),
            view.safeAreaLayoutGuide.bottomAnchor.constraint(
                equalToSystemSpacingBelow: calculatorStack.bottomAnchor, multiplier: 1)
        ])
    }
    func setupDisplay() {
        let textString = "0"
        let font = UIFont.systemFont(ofSize: UIScreen.main.bounds.width / 5)
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.tailIndent = -20
        paragraphStyle.alignment = .right
        let attibutes: [NSAttributedString.Key: Any] = [
            .font: font,
            .foregroundColor: UIColor.label,
            .paragraphStyle: paragraphStyle
        ]
        display.attributedText = NSMutableAttributedString(
            string: textString, attributes: attibutes)
    }
    func buttonsStack() -> UIStackView {
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.alignment = .fill
        stack.distribution = .fillEqually
        stack.spacing = 8
        return stack
    }
    private func addButton(_ button: CalculatorButton) -> UIButton {
        let uiButton = RoundCornerButton(type: .system)
        uiButton.setTitle(button.title, for: .normal)
        uiButton.backgroundColor = button.backgroundColor
        uiButton.tintColor = button.foregroundColor
        if button != .zero {
            uiButton.widthAnchor.constraint(equalTo: uiButton.heightAnchor).isActive = true
        }
        uiButton.layer.cornerRadius = 20
        switch button {
        case .zero, .one, .two, .three, .four, .five, .six, .seven, .eight, .nine, .point :
            uiButton.addTarget(self, action: #selector(touchDigit), for: .primaryActionTriggered)
        default:
            uiButton.addTarget(self, action: #selector(performOperation), for: .primaryActionTriggered)
        }
        return uiButton
    }
    @objc func touchDigit(_ sender: UIButton) {
        guard let digit = sender.currentTitle else { return }
        if userIsInTheMiddleOfTyping {
            let textCurrentlyInDisplay = display.text!
            display.text = textCurrentlyInDisplay + digit
        } else {
            display.text = digit
            userIsInTheMiddleOfTyping = true
        }
    }
    @objc func performOperation(_ sender: UIButton) {
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

struct ViewControllerRepresentable_Previews: PreviewProvider {
    static var previews: some View {
        CalculatorViewControllerRepresentable()
            .ignoresSafeArea()
    }
}

