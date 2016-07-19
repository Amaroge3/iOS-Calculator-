//
//  CalculatorBrain.swift
//  Calculator
//
//  Created by Andi Maroge on 7/6/16.
//  Copyright © 2016 Andi Maroge. All rights reserved.
//

import Foundation


/*
 The model of the calculator. Has the functionalities of the calculator.
 */
class CalculatorBrain{
    
    //total variable
    var accumulator = 0.0
    var pending: PendingBinaryOperationInfo?
    
    //description string for the description label
    var description = ""
    
    struct PendingBinaryOperationInfo {
        var binaryFunction: (Double, Double) -> Double
        var firstOperand: Double
    }
    //read only result property
    var result: Double {
        get{
            return accumulator
        }
    }
    //sets the operand
    func setOperand(operand: Double){
        accumulator = operand
    }
    //operation types with associated values
    enum Operation {
        case Constant(Double)
        case Unary((Double) -> Double)
        case Binary((Double, Double) -> Double)
        case Equals
    }
    
    
    
    func isUnary(operandsAndOperators: String) -> Bool{
        if let operand = operations[operandsAndOperators]{
            switch operand{
            case Operation.Equals:
                print("equals")
                return true
            case Operation.Binary(_):
                print("binary")
            case Operation.Constant(_):
                print("contant")
            case Operation.Unary(_):
                print("unary")
            }
        }
    
        return false
    }
    //executes the pending binary operation
    func executePendingBinaryOperation(){
 
        if pending != nil {
            accumulator = pending!.binaryFunction(pending!.firstOperand, accumulator)
            pending = nil
        }
        
    }
    
    
    //dictionary that looks up a string for its corresponding operation
    private var operations: Dictionary <String, Operation> = [
       
        "∏" : Operation.Constant(M_PI),
        "℮" : Operation.Constant(M_E),
        "√" : Operation.Unary(sqrt),
        "sin" : Operation.Unary(cos),
        "cos" : Operation.Unary(cos),
        "log(n)" : Operation.Unary(log),
        "pow" : Operation.Binary(pow),
        "×" : Operation.Binary({ $0 * $1 }),
        "+" : Operation.Binary({ $0 + $1 }),
        "-" : Operation.Binary({ $0 - $1 }),
        "÷" : Operation.Binary({ $0 / $1 }),
        "=" : Operation.Equals
    ]
    
    
    //set the description of the top most label
    internal func setDescription(operandsAndOperators: String){
        if (isUnary(operandsAndOperators)){
            description = description + operandsAndOperators + "("
        }
        else {
            description += operandsAndOperators

        }
    }
    
    //performs the operation when an operation button is clicked on the gui
    internal func performOperation(symbol: String){
       
        if let operation = operations[symbol]{
            switch operation{
            case .Constant(let value):
                accumulator = value
            case .Unary(let function):
                accumulator = function(accumulator)
            case .Binary(let function):
                executePendingBinaryOperation()
                pending = PendingBinaryOperationInfo(binaryFunction: function, firstOperand: accumulator)
            case .Equals:
                executePendingBinaryOperation()
            }
        }
        isUnary(symbol)
    }
}
