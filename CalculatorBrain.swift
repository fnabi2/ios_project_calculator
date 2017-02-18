//
//  CalculatorBrain.swift
//  calculator
//
//  Created by Famun Nabi on 2/9/17.
//  Copyright © 2017 Famun Nabi. All rights reserved.
//

import Foundation

class CalculatorBrain {
    private var accumulator = 0.0
    
    func setOperand(operand: Double) {
        accumulator = operand
        description = String(accumulator)
        if isPartialResult {
            binOperandCount += 1
        }
    }
    
    private var operations: Dictionary<String, Operation> = [
        "π" : Operation.Constant(M_PI),
        "e" : Operation.Constant(M_E),
        "√" : Operation.UnaryOperation(sqrt),
        "±" : Operation.UnaryOperation({ -$0 }),
        "cos" : Operation.UnaryOperation(cos),
        "×" : Operation.BinaryOperation({ $0 * $1 }),
        "÷" : Operation.BinaryOperation({ $0 / $1 }),
        "+" : Operation.BinaryOperation({ $0 + $1 }),
        "−" : Operation.BinaryOperation({ $0 - $1 }),
        "=" : Operation.Equals,
        "c" : Operation.Clear
    ]
    
    private enum Operation {
        case Constant(Double)
        case UnaryOperation((Double) -> Double)
        case BinaryOperation((Double, Double) -> Double)
        case Equals
        case Clear
    }
    
    func performOperation(symbol: String) {
        if let operation = operations[symbol] {
            switch operation {
            case .Constant(let value):
                description = symbol
                accumulator = value
            case .UnaryOperation(let function):
                if !isPartialResult {
                    operationStrList.insert("(", at: 0)
                    operationStrList.insert(symbol, at: 0)
                    description = ")"
                } else {
                    let listSize = operationStrList.count
                    operationStrList.insert(symbol, at: listSize - 1)
                    operationStrList.insert("(", at: listSize)
                    description = ")"
                }
                accumulator = function(accumulator)
            case .BinaryOperation(let function):
                description = symbol

                executePendingBinaryOperation()
                pending = PendingBinaryOperationInfo(binaryFunction: function, firstOperand: accumulator)
                binOperandCount += 1
                
            case .Equals:
                if isPartialResult {
                    if binOperandCount % 2 != 0 {
                        description = String(accumulator)
                    }
                    binOperandCount = 0
                }
                executePendingBinaryOperation()

            case .Clear:
                clear()
            }
        }
    }
    
    private func executePendingBinaryOperation() {
        if pending != nil {
            accumulator = pending!.binaryFunction(pending!.firstOperand, accumulator)
            pending = nil
        }
    }
    
    private func clear() {
        if pending != nil {
            pending = nil
        }
        accumulator = 0.0
        operationStrList = [String]()
        binOperandCount = 0
    }
    
    private var pending: PendingBinaryOperationInfo?
    
    private struct PendingBinaryOperationInfo {
        var binaryFunction: (Double, Double) -> Double
        var firstOperand: Double
    }
    
    var isPartialResult: Bool {
        get {
            if pending != nil {
                return true
            } else {
                return false
            }
        }
    }
    
    private var operationStrList = [String]()
    private var binOperandCount = 0

    var description: String {
        get {
            if operationStrList.count > 0 {
                var retString = ""
                for item in operationStrList {
                    retString += item
                }
                return retString
            } else {
                return ""
            }
        }
        
        set {
            operationStrList.append(newValue)
        }
    }
    
    var result: Double {
        get {
            return accumulator
        }
    }
}
