import UIKit

class CalculatorViewController: UIViewController {
    private var displayValue: Double {
        get {
            let text = displayLabel.text ?? "0"
            return Double(text) ?? 0.0
        }
        set {
            displayLabel.text = String(newValue)
        }
    }
    private var userIsInTheMiddleOfTyping = false
    private var brain = CalculatorBrain()
    private var spacing = 14.0

    private let displayLabel = UILabel()
    private let calculatorStack = UIStackView()
    private var zeroButton: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()
        setupCalculatorStack()
    }

    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        calculatorStack.frame = view.layoutMarginsGuide.layoutFrame
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        zeroButton.configuration?.contentInsets = .init(top: 0, leading: 0, bottom: 0, trailing: zeroButton.frame.height + spacing / 2)
    }

    func setupCalculatorStack() {
        view.addSubview(calculatorStack)
        calculatorStack.axis = .vertical
        calculatorStack.spacing = spacing

        calculatorStack.addArrangedSubview(UIView())
        setupDisplayLabel()
        calculatorStack.addArrangedSubview(makeStack(with: makeViews(with: [.ac, .plusMinus, .perecent, .divide])))
        calculatorStack.addArrangedSubview(makeStack(with: makeViews(with: [.seven, .eight, .nine, .multiply])))
        calculatorStack.addArrangedSubview(makeStack(with: makeViews(with: [.four, .five, .six, .minus])))
        calculatorStack.addArrangedSubview(makeStack(with: makeViews(with: [.one, .two, .three, .plus])))
        calculatorStack.addArrangedSubview(makeStack(with: [makeButton(with: .zero), makeStack(with: makeViews(with: [.point, .equals]))]))
    }

    private func setupDisplayLabel() {
        calculatorStack.addArrangedSubview(displayLabel)
        let font = UIFont.systemFont(ofSize: 90, weight: .light)
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.tailIndent = -20
        paragraphStyle.alignment = .right
        let attibutes: [NSAttributedString.Key: Any] = [
            .font: font,
            .foregroundColor: UIColor.label,
            .paragraphStyle: paragraphStyle
        ]
        displayLabel.attributedText = NSMutableAttributedString(
            string: "0", attributes: attibutes)
    }

    private func makeButton(with title: ButtonTitle) -> UIButton {
        let button = UIButton(type: .system)
        var config = UIButton.Configuration.filled()
        var attText = AttributedString(title.text)
        attText.font = .systemFont(ofSize: 40)
        config.attributedTitle = attText
        config.cornerStyle = .capsule
        config.baseBackgroundColor = title.backgroundColor
        config.baseForegroundColor = title.foregroundColor
        button.configuration = config

        if title == .zero {
            zeroButton = button
        } else {
            button.widthAnchor.constraint(equalTo: button.heightAnchor).isActive = true
        }

        button.addAction(UIAction { _ in
            title.isDigit ? self.touchDigit(title.text) : self.performOperation(title.text)
        }, for: .primaryActionTriggered)
        return button
    }

    private func makeStack(with views: [UIView]) -> UIStackView {
        let stack = UIStackView(arrangedSubviews: views)
        stack.spacing = spacing
        stack.distribution = .fillEqually
        stack.alignment = .fill
        return stack
    }

    private func makeViews(with titles: [ButtonTitle]) -> [UIView] {
        titles.map {makeButton(with: $0)}
    }

    func touchDigit(_ digit: String) {
        if userIsInTheMiddleOfTyping {
            let textCurrentlyInDisplay = displayLabel.text!
            displayLabel.text = textCurrentlyInDisplay + digit
        } else {
            displayLabel.text = digit
            userIsInTheMiddleOfTyping = true
        }
    }

    func performOperation(_ mathematicalSymbol: String) {
        if userIsInTheMiddleOfTyping {
            brain.setOperand(displayValue)
            userIsInTheMiddleOfTyping = false
        }
        brain.performOperation(mathematicalSymbol)
        if let result = brain.result {
            displayValue = result
        }
    }
}

@available (iOS 17.0, *)
#Preview {
    CalculatorViewController()
}
