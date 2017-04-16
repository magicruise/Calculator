//
//  CalculatorBrain.swift
//  Calculator
//
//  Created by LSMSE on 2017. 4. 17..
//  Copyright © 2017년 LSMSE. All rights reserved.
//

import Foundation

struct CalculatorBrain {
    
    // internal ---
    
    // made this be an optional, it's initialized to nil automatically
    private var accumulator: Double?
    
    private var description = " " // 6. returns a description of the sequence of operands and operations that led to the value returned by result
    
    private var resultIsPending = false // 5. returns whether there is a binary operation pending
    
    // associated values are something not specific to optionals, it's for all enums in Swift
    private enum Operation {
        case constant(Double)
        case unaryOperation((Double) -> Double)
        case binaryOperation((Double,Double) -> Double)
        case equals
    }
    
    // put all constants in a table
    private var operations: Dictionary<String,Operation> = [
        "π" : Operation.constant(Double.pi),
        "e" : Operation.constant(M_E),
        "√" : Operation.unaryOperation(sqrt),
        "cos" : Operation.unaryOperation(cos),
        "sin" : Operation.unaryOperation(sin),
        "tan" : Operation.unaryOperation(tan),
        
        // Swift will let you have any number of arguments you want, called $0, $1, ..., for however how many
        "×" : Operation.binaryOperation({ $0 * $1 }),
        "÷" : Operation.binaryOperation({ $0 / $1 }),
        "−" : Operation.binaryOperation({ $0 - $1 }),
        "+" : Operation.binaryOperation({ $0 + $1 }),
        "±" : Operation.unaryOperation({ -$0 }),
        
        "=" : Operation.equals
    ]
    
    // public API ---
    
    mutating func performOperation (_ symbol: String) {
        
        // look up the symbol in that table and get the value
        if let operation = operations[symbol] {
            switch operation {
            case .constant(let /* associatedConstant */ value):
                accumulator = value
                break
            case .unaryOperation(let function):
                if accumulator != nil { // checking to see if accumulator is in the not set state
                    accumulator = function(accumulator!)
                }
            case .binaryOperation(let function):
                if accumulator != nil {
                    if resultIsPending { // 5.
                        performPendingBinaryOperation()
                    } else {
                        resultIsPending = true // 5.
                        pendingBinaryOperation = PendingBinaryOperation(function: function, firstOperand: accumulator!)
                        accumulator = nil
                    }
                }
            case .equals:
                performPendingBinaryOperation()
                resultIsPending = false // 5.
                pendingBinaryOperation = nil // 5.
            }
        }
    }
    
    // internal ---
    
    private mutating func performPendingBinaryOperation() {
        if pendingBinaryOperation != nil && accumulator != nil {
            accumulator = pendingBinaryOperation!.perform(with: accumulator!)
            // 5. pendingBinaryOperation = nil
            if resultIsPending { // 5.
                pendingBinaryOperation!.firstOperand = accumulator!
            }
        }
    }
    
    private var pendingBinaryOperation: PendingBinaryOperation?
    
    private struct PendingBinaryOperation {
        let function: (Double, Double) -> Double
        var firstOperand: Double // 5.
        // 5. let firstOperand: Double
        
        func perform(with secondOperand: Double) -> Double {
            return function(firstOperand, secondOperand)
        }
    }
    
    // public API ---
    
    mutating func setOperand(_ operand: Double) {
        accumulator = operand // cannot assign to this property, because self is immutable
    }
    
    var result: Double? { // read-only computed property
        get {
            return accumulator
        }
    }
}

