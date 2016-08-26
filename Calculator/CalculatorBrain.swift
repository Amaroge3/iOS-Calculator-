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
    var isPartialResult = true
    //description string for the description label
    var description = ""
    var lastOperation = ""
    
    //internal program of the calculator
    private var internalProgram = [AnyObject]()
    
    
    //variable dictionary
    var variableValues: Dictionary <String,Double> = [:]
    
    //display of the label
    var displayValue: Double? = nil
    
    //variable optional for saving value
    var M: Double? = 0.0
    
    //previous values of display for undo button
    var previousActions = [String]()
    
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
        internalProgram.append(operand)
    }
    //operation types with associated values
    enum Operation {
        case Constant(Double)
        case Unary((Double) -> Double)
        case Binary((Double, Double) -> Double)
        case Equals
        case Clear
    }
    //clear the calculator
    func clear(){
        accumulator = 0
        pending = nil
        description = ""
        internalProgram.removeAll()
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
        "log" : Operation.Unary(log),
        "pow" : Operation.Binary(pow),
        "×" : Operation.Binary({ $0 * $1 }),
        "+" : Operation.Binary({ $0 + $1 }),
        "-" : Operation.Binary({ $0 - $1 }),
        "÷" : Operation.Binary({ $0 / $1 }),
        "=" : Operation.Equals,
        "Clear": Operation.Clear
    ]
    
    
    //set the description of the top most label
    internal func setDescription(operandsAndOperators: String){
        
        switch operandsAndOperators{
        case "√", "cos", "sin", "log":
            isPartialResult = false
            description = ""
            description += operandsAndOperators + "(" + String(displayValue!) + ")"
            lastOperation = operandsAndOperators
        case "pow":
            isPartialResult = true
            description += operandsAndOperators + "("
            lastOperation = operandsAndOperators
        default:
            if isPartialResult == true && lastOperation == "pow"{
                description += operandsAndOperators + ")"
                isPartialResult = false
                lastOperation = ""
            }
            else{
                description += operandsAndOperators
            }
        }
    }
    
    typealias PropertyList = AnyObject
    
    
    var program: PropertyList{
        get{
            return internalProgram
        }
        set{
            clear()
            if let arrayOfOps = newValue as? [AnyObject]{
                for op in arrayOfOps{
                    if let operand = op as? Double {
                        setOperand(operand)
                    } else if let operation = op as? String{
                        performOperation(operation)
                    }
                }
            }
        }
    }
    
    //save to dictionary the variable value
    func setOperand(variableName: String){
        if let mValue = M {
            variableValues[variableName] = mValue
        }
    }
    
    //undo operation for the Undo button
    func undo(){
        if (previousActions.count > 0){
            displayValue = Double(previousActions.removeLast())
        }
    }
    
    //function to add the last value
    func addUndoAction(displayValue: Double){
        previousActions.append(String(displayValue))
    }
    
    
    
    //performs the operation when an operation button is clicked on the gui
    internal func performOperation(symbol: String){
        internalProgram.append(symbol)
        if let operation = operations[symbol]{
            switch operation{
            case .Constant(let value):
                accumulator = value
            case .Unary(let function):
                accumulator = function(accumulator)
            case .Binary(let function):
                executePendingBinaryOperation()
                pending = PendingBinaryOperationInfo(binaryFunction: function, firstOperand: accumulator)
                isPartialResult = true
            case .Equals:
                executePendingBinaryOperation()
                isPartialResult = false
            case .Clear:
                clear()
            }
        }
    }
}
