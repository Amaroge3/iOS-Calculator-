//
//  ViewController.swift
//  Calculator
//
//  Created by Andi Maroge on 7/5/16.
//  Copyright © 2016 Andi Maroge. All rights reserved.
//

import UIKit
import Foundation
class ViewController: UIViewController {

    @IBOutlet weak var display: UILabel!
    var calcBrain =  CalculatorBrain()
    var userIsInMiddleOfTyping = false
    
        
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    //displayvalue getter and setter
    private var displayValue: Double {
        get{
            return Double(display.text!)!
        }
        set{
            display.text = String(newValue)
        }
    }
    //undo action button
    @IBAction func undoAction(sender: UIButton) {
    calcBrain.undo()
        if let brainDisplayValue = calcBrain.displayValue {
            calcBrain.accumulator = brainDisplayValue
            displayValue = brainDisplayValue
        }
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.

      
    }
    //description label that shows the previously entered numbers
    @IBOutlet weak var descriptionLabel: UILabel!
    
    
    //method called when the digits are touched on the gui
    @IBAction func touchDigit(sender: UIButton) {
       
        
        calcBrain.displayValue = displayValue

        if (!userIsInMiddleOfTyping){
            if let title = sender.currentTitle{
                if(title != "."){
                display.text! = title
                userIsInMiddleOfTyping = true
                    calcBrain.setDescription(sender.currentTitle!)
                    descriptionLabel.text! = calcBrain.description
                }
                else{
                    display.text! = "0" + title
                    userIsInMiddleOfTyping = true
                    calcBrain.setDescription("0" + sender.currentTitle!)
                    descriptionLabel.text! = calcBrain.description
                }
            }
        }
        else {
            if var title = sender.currentTitle{
                //limits the number of times the dot is entered into the calculator to one
                if(display.text!.containsString(".") && title == "."){
                        title = ""
                    
                }
                else{
                    display.text = display.text! + title
                    calcBrain.setDescription(sender.currentTitle!)
                    descriptionLabel.text! = calcBrain.description
                }
               
            }
        }

        //communicates with the model to update the description of the description label
       
    }
    
    
    //save a variable to use
    @IBAction func saveVariable(sender:UIButton) {
        calcBrain.M = displayValue
    calcBrain.setDescription(sender.currentTitle!)
    descriptionLabel.text! = calcBrain.description
    }
    
    
    //load variable
    @IBAction func loadVariable(sender: UIButton) {
        if let variable = calcBrain.M{
            displayValue = variable
            calcBrain.accumulator = displayValue
        }
        calcBrain.setOperand(sender.currentTitle!)
        calcBrain.M = nil
        calcBrain.setDescription(sender.currentTitle!)
        descriptionLabel.text! = calcBrain.description
        print(calcBrain.variableValues["M"]!)
    }
    
    
    //called when one of the operation buttons are pressed
    @IBAction func performOperation(sender: UIButton){
        calcBrain.addUndoAction(displayValue)
        calcBrain.displayValue = displayValue
      
       
        
        //sets the description when user is in the middle of typing
        if (userIsInMiddleOfTyping){
            calcBrain.setDescription(" " + sender.currentTitle! + " ")
        }
            
        //sets the description also when the user is not in the middle of typing a number
        else if (!userIsInMiddleOfTyping){
            calcBrain.setDescription(String(displayValue) + " " + sender.currentTitle! + " ")
            
        }

        
        if (userIsInMiddleOfTyping){
        calcBrain.setOperand(displayValue)
        userIsInMiddleOfTyping = false
        }
    
        
        //when clear is pressed clear the screen and make a new instance of CalculatorBrain
        if let mathematicalOperation = sender.currentTitle{
            if(mathematicalOperation == "Clear"){
                displayValue = 0
            }
                calcBrain.performOperation(mathematicalOperation)
                displayValue = calcBrain.result
                descriptionLabel.text! = calcBrain.description
            
        }

    }


}

