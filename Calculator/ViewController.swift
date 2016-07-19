w//
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
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.

      
    }
    //description label that shows the previously entered numbers
    @IBOutlet weak var descriptionLabel: UILabel!
    
    
    //method called when the digits are touched on the gui
    @IBAction func touchDigit(sender: UIButton) {
        
        if (!userIsInMiddleOfTyping){
            if let title = sender.currentTitle{
                if(title != "."){
                display.text! = title
                userIsInMiddleOfTyping = true
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

                }
               
            }
        }

        //communicates with the model to update the description of the description label
        calcBrain.setDescription(sender.currentTitle!)
        descriptionLabel.text! = calcBrain.description
    }
    //called when one of the operation buttons are pressed
    @IBAction func performOperation(sender: UIButton){
    if (userIsInMiddleOfTyping){
        calcBrain.setOperand(displayValue)
        userIsInMiddleOfTyping = false
    }
        //adds the operation symbol to the description variable in the model class.
        calcBrain.setDescription(" " + sender.currentTitle! + " ")
        
        //when clear is pressed clear the screen and make a new instance of CalculatorBrain
        if let mathematicalOperation = sender.currentTitle{
            if(mathematicalOperation == "Clear"){
                calcBrain = CalculatorBrain()
                display.text! = "0"
                descriptionLabel!.text = ""
                calcBrain.setDescription("")
            }
            else{
                calcBrain.performOperation(mathematicalOperation)
                displayValue = calcBrain.result
                descriptionLabel.text! = calcBrain.description
            }
        }

    }


}

