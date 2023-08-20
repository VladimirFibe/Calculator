import Foundation

struct CalculatorBrain {
    private var accumulator: Double?
    
    private var operations: Dictionary<String, Operation> = [
        "AC": Operation.constant(0),
        "𝝅": Operation.constant(Double.pi),
        "e": Operation.constant(M_E),
        "%": Operation.unaryOperation({$0 / 100.0}),
        "±": Operation.unaryOperation({-$0}),
        "+": Operation.binaryOperation({$0 + $1}),
        "-": Operation.binaryOperation({$0 - $1}),
        "×": Operation.binaryOperation({$0 * $1}),
        "÷": Operation.binaryOperation({$0 / $1}),
        "=": Operation.equals
    ]
    
    mutating func performOperation(_ symbol: String) {
        if let operation = operations[symbol] {
            switch operation {
            case .constant(let value):
                accumulator = value
            case .unaryOperation(let function):
                if let accumulator {
                    self.accumulator = function(accumulator)
                }
            case .binaryOperation(let function):
                if let accumulator {
                    pendingBinaryOperation = PendingBinaryOperation(function: function, firstOperand: accumulator)
                    self.accumulator = nil
                }
            case .equals:
                performPendingBinaryOperation()
            }
        }
    }
    
    private mutating func performPendingBinaryOperation() {
        if let accumulator = accumulator {
            self.accumulator = pendingBinaryOperation?.perform(with: accumulator)
        }
    }
    
    mutating func setOperand(_ operand: Double) {
        accumulator = operand
    }
    
    var result: Double? {
        accumulator
    }
    
    private enum Operation {
        case constant(Double)
        case unaryOperation((Double) -> Double)
        case binaryOperation((Double, Double) -> Double)
        case equals
    }
    
    private struct PendingBinaryOperation {
        let function: (Double, Double) -> Double
        let firstOperand: Double
        func perform(with secondOperand: Double) -> Double {
            function(firstOperand, secondOperand)
        }
    }
    
    private var pendingBinaryOperation: PendingBinaryOperation?
}
