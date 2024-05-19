import UIKit

enum ButtonTitle: String {
    case zero = "0"
    case one = "1"
    case two = "2"
    case three = "3"
    case four = "4"
    case five = "5"
    case six = "6"
    case seven = "7"
    case eight = "8"
    case nine = "9"
    case point = "."
    case equals = "="
    case plus = "+"
    case minus = "-"
    case multiply = "×"
    case divide = "÷"
    case ac = "AC"
    case plusMinus = "±"
    case perecent = "%"
    
    var text: String {
        rawValue
    }
    
    var backgroundColor: UIColor {
        switch self {
        case .ac, .plusMinus, .perecent: return .systemGray
        case .plus, .equals, .minus, .multiply, .divide: return .systemOrange
        default: return .systemFill
        }
    }
    
    var foregroundColor: UIColor {
        switch self {
        case .ac, .plusMinus, .perecent: return .systemBackground
        default: return .label
        }
    }

    var isDigit: Bool {
        switch self {
        case .zero, .one, .two, .three, .four, .five, .six, .seven, .eight, .nine, .point :
            return true
        default:
            return false
        }
    }
}
