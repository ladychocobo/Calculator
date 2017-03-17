//
//  OperatorCalculation.swift
//  calculator
//
//  Created by Jamie Chen on 3/17/17.
//  Copyright © 2017 Jamie Chen. All rights reserved.
//

import Foundation

struct OperatorCalculation {
    private var _result: Double?
    var result: Double? {
        return self._result
    }
    
    private enum Operation {
        case constant(Double)
        case unaryOperation((Double) -> Double)
        case binaryOperation((Double, Double) -> Double)
        case equal
    }
    
    private struct PendingBinaryOperation {
        let function: (Double, Double) -> Double
        let firstOperand: Double
        
        func perform(with secondOperand: Double) -> Double {
            return function(firstOperand, secondOperand)
        }
    }
    
    private var _operation:PendingBinaryOperation?
    
    private var mathOperator:Dictionary<String, Operation> = [
        "X²" : Operation.unaryOperation({ $0 * $0 }),
        "π" : Operation.constant(Double.pi),    // Double.pi,
        "e" : Operation.constant(M_E),          // M_E,
        "√" : Operation.unaryOperation(sqrt),
        "±" : Operation.unaryOperation({ -$0 }),
        "%" : Operation.unaryOperation({ $0 / 100 }),
        "÷" : Operation.binaryOperation({$0 / $1}),
        "x" : Operation.binaryOperation({$0 * $1}),
        "-" : Operation.binaryOperation({$0 - $1}),
        "+" : Operation.binaryOperation({$0 + $1}),
        "=" : Operation.equal]
    
    mutating func performOperation(_ symbol: String) {
        if let operation = mathOperator[symbol] {
            switch operation {
            case .constant(let value):
                self._result = value
            case .unaryOperation(let function):
                if self._result != nil {
                    _result = function(_result!)
                }
            case .binaryOperation(let function):
                if self._result != nil {
                    _operation = PendingBinaryOperation(function: function, firstOperand: _result!)
                    self._result = nil
                }
            case .equal:
                performPendingBinaryOperation()
            }
        }
    }
    
    private mutating func performPendingBinaryOperation() {
        if _operation != nil && _result != nil {
            self._result  = self._operation?.perform(with: self._result!)
            self._operation = nil
        }
    }
    
    mutating func setOperand(_ operand:Double) {
        self._result = operand
    }
}
