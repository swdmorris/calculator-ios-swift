//
//  CalculatorBrain.swift
//  Calculator
//
//  Created by Spencer Morris on 2/5/15.
//  Copyright (c) 2015 SpencerMorris. All rights reserved.
//

import Foundation

class CalculatorBrain
{
    private enum Op
    {
        case Operand(Double)
        case UnaryOperation(String, Double -> Double)
        case BinaryOperation(String, (Double, Double) -> Double)
    }
    
    private var opStack = [Op]() // array initialization syntax
    
    private var knownOps = [String: Op]() // dictionary initialization syntax
    
    init() {
        knownOps["✕"] = Op.BinaryOperation("✕", { $0 * $1 }) // could replace '{ $0 * $1 }' with '*'
        knownOps["+"] = Op.BinaryOperation("+", { $0 + $1 })
        knownOps["-"] = Op.BinaryOperation("-", { $1 - $0 })
        knownOps["÷"] = Op.BinaryOperation("÷", { $1 / $0 })
        knownOps["sin"] = Op.UnaryOperation("sin", { sin($0) })
        knownOps["cos"] = Op.UnaryOperation("cos", { sin($0) })
        knownOps["√"] = Op.UnaryOperation("√", sqrt) // implied sqrt
    }
    
    private func evaluate(ops: [Op]) -> (result: Double?, remainingOps: [Op]) {
        if !ops.isEmpty {
            var remainingOps = ops
            let op = remainingOps.removeLast()
            switch op {
            case .Operand(let operand):
                return (operand, remainingOps)
            case .UnaryOperation(_, let operation): // _ means 'i dont care about variable'
                let operationEvaluation = evaluate(remainingOps)
                if let operand = operationEvaluation.result {
                    return (operation(operand), operationEvaluation.remainingOps)
                }
            case .BinaryOperation(_, let operation):
                let op1Evaluation = evaluate(remainingOps)
                if let operand1 = op1Evaluation.result {
                    let op2Evaluation = evaluate(op1Evaluation.remainingOps)
                    if let operand2 = op2Evaluation.result {
                        return (operation(operand1, operand2), op2Evaluation.remainingOps)
                    }
                }
            }
        }
        
        return (nil, ops)
    }
    
    func evaluate() -> Double? {
        let (result, remainder) = evaluate(opStack)
        return result
    }
    
    func pushOperand(operand: Double) -> Double? {
        opStack.append(Op.Operand(operand))
        return evaluate()
    }
    
    func performOperation(symbol: String) -> Double? {
        if let operation = knownOps[symbol] {
            opStack.append(operation)
        }
        return evaluate()
    }
    
    func clear() {
        opStack.removeAll(keepCapacity: true)
    }
}