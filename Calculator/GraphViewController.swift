//
//  GraphViewController.swift
//  Calculator
//
//  Created by Andi Maroge on 8/2/16.
//  Copyright © 2016 Andi Maroge. All rights reserved.
//

import Foundation
import UIKit


class GraphViewController: UIViewController {
    

    
    //outlet that shows the result of the calculator
    @IBOutlet weak var equation: UILabel! { didSet{ equation!.text! = String(calcResult) } }
    //pointsPerUnit outlet --- shows the points per unit
    @IBOutlet weak var pointsPerUnitLabel: UILabel!
    //description label outlet --- shows the description of what the user calculated in the graph view
    @IBOutlet weak var descriptionLabel: UILabel!{
        didSet{ descriptionLabel!.text! = descriptionOfCalculator }
    }
    //computed property that returns the Calculator view controller
    var calculatorController: CalculatorViewController { return CalculatorViewController() }
    
    //computed property of points per unit
    var pointsPerUnit: CGFloat{ return graphView.pointsPerUnit }
    
    //result of the calculator that is segued to this controller from the Calculator controller
    var calcResult: Double = 0
    
    //description value that is segued to this variable from the Caculator controller
    var descriptionOfCalculator = ""

    //the swipe movement speed of the graph when the user swipes in a direction
    var swipeMovementSpeed: CGFloat = 20
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        pointsPerUnitLabel!.text! = "Points per unit: " + String(graphView.pointsPerUnit)
        
    }
    
    override func viewWillTransitionToSize(size: CGSize, withTransitionCoordinator coordinator: UIViewControllerTransitionCoordinator) {
        if UIDevice.currentDevice().orientation.isLandscape.boolValue {
            graphView.recCenter! = CGPoint(x: midRecX!, y:  midRecY!)
            updateUI()
        }
        else {
            graphView.recCenter! = CGPoint(x: midRecX!, y:  midRecY!)
            updateUI()
        }
    }
    
    
    //changes the location of the graphview when the user double taps at a location on the graphView
    @IBAction func doubleTap(sender: UITapGestureRecognizer) {
    
        let doubleTapX = sender.locationInView(graphView).x
        let doubleTapY = sender.locationInView(graphView).y
        
        //changes the origin of the graph, updates it, and also updates the line's x or y value.
        if doubleTapX > graphView.recCenter!.x{
            graphView.recCenter!.x += midRecX! - sender.locationInView(graphView).x
            graphView.fromGraphPoint!.x += midRecX! - sender.locationInView(graphView).x
            graphView.toGraphPoint!.x += midRecX! - sender.locationInView(graphView).x

        }
        if doubleTapX < graphView.recCenter!.x{
            graphView.recCenter!.x += midRecX! - sender.locationInView(graphView).x
            graphView.fromGraphPoint!.x += midRecX! - sender.locationInView(graphView).x
            graphView.toGraphPoint!.x += midRecX! - sender.locationInView(graphView).x
        }
        if doubleTapY > graphView.recCenter!.y{
            graphView.recCenter!.y += midRecY! - sender.locationInView(graphView).y
            graphView.fromGraphPoint!.y += midRecY! - sender.locationInView(graphView).y
            graphView.toGraphPoint!.y += midRecY! - sender.locationInView(graphView).y
        }
        if doubleTapY < graphView.recCenter!.y{
            graphView.recCenter!.y += midRecY! - sender.locationInView(graphView).y
            graphView.fromGraphPoint!.y += midRecY! - sender.locationInView(graphView).y
            graphView.toGraphPoint!.y += midRecY! - sender.locationInView(graphView).y
        }
    }
    
    //graphs the result of the calculator when the user taps once on the graph view
    @IBAction func graphTap(sender: UITapGestureRecognizer) {
        
        if sender.numberOfTouchesRequired == 1{
            updateUI()
            sender.enabled = false
        }
    }
    
    
    //method to update the line drawn
    func updateUI() {
        if graphView != nil {
        
            let recCenter = graphView.recCenter
            if midRecX != nil && midRecY != nil
                && recCenter != nil{
                
                    graphView.fromGraphPoint = CGPoint(x: graphView.minX, y: midRecY! - CGFloat(calcResult) * pointsPerUnit)
                    graphView.toGraphPoint = CGPoint(x: graphView.maxX, y: midRecY! - CGFloat(calcResult) * pointsPerUnit)
            }
        }
    }
    
    
    //graph view outlet and gesture recognizer
    @IBOutlet weak var graphView: GraphView! {
        didSet {
            let changeGraphScale = UIPinchGestureRecognizer(target: self, action: #selector(GraphViewController.changeGraphPoints(_:)))
        
            graphView.addGestureRecognizer(changeGraphScale)
        
            
            let moveUp = UISwipeGestureRecognizer(target: self, action: #selector(GraphViewController.moveUp(_:)))
                moveUp.direction = .Down
            let moveDown = UISwipeGestureRecognizer(target: self, action: #selector(GraphViewController.moveDown(_:)))
                moveDown.direction = .Up
            let moveLeft = UISwipeGestureRecognizer(target: self, action: #selector(GraphViewController.moveLeft(_:)))
                moveLeft.direction = .Right
            let moveRight = UISwipeGestureRecognizer(target: self, action: #selector(GraphViewController.moveRight(_:)))
                moveRight.direction = .Left

            graphView.addGestureRecognizer(moveUp)
            graphView.addGestureRecognizer(moveDown)
            graphView.addGestureRecognizer(moveLeft)
            graphView.addGestureRecognizer(moveRight)
        }
        
        
        
    }
    
    //move up function for swipe
    func moveUp(recognizer: UISwipeGestureRecognizer){
        graphView.recCenter!.y -= swipeMovementSpeed
        graphView.fromGraphPoint!.y -= swipeMovementSpeed
        graphView.toGraphPoint!.y -= swipeMovementSpeed

    }
    //move down function for swipe
    func moveDown(recognizer: UISwipeGestureRecognizer){
        graphView.recCenter!.y += swipeMovementSpeed
        graphView.fromGraphPoint!.y += swipeMovementSpeed
        graphView.toGraphPoint!.y += swipeMovementSpeed

    }
    //move left function for swipe
    func moveLeft(recognizer: UISwipeGestureRecognizer){
        graphView.recCenter!.x -= swipeMovementSpeed
        graphView.fromGraphPoint!.x -= swipeMovementSpeed
        graphView.toGraphPoint!.x -= swipeMovementSpeed

    }
    //move right function for swipe
    func moveRight(recognizer: UISwipeGestureRecognizer){
        graphView.recCenter!.x += swipeMovementSpeed
        graphView.fromGraphPoint!.x += swipeMovementSpeed
        graphView.toGraphPoint!.x += swipeMovementSpeed

    }
    
    //changes the graph pointsPerUnit when pinching
    func changeGraphPoints(recognizer: UIPinchGestureRecognizer){
        switch recognizer.state{
            case .Changed, .Ended:
                graphView.pointsPerUnit *= recognizer.scale
                recognizer.scale = 1.0
                
                pointsPerUnitLabel!.text! = String(graphView.pointsPerUnit)
            
            updateUI()
            default:
                break
        }
    }
}