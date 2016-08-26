//
//  GraphView.swift
//  Calculator
//
//  Created by Andi Maroge on 8/10/16.
//  Copyright © 2016 Andi Maroge. All rights reserved.
//

import UIKit


var midRecX: CGFloat?
var midRecY: CGFloat?

@IBDesignable

class GraphView: UIView {
    
    var axes = AxesDrawer(color: UIColor.redColor(), contentScaleFactor: 25)
    
    
    @IBInspectable
    var scale: CGFloat = 0.90 { didSet { setNeedsDisplay() } }
    
    var pointsPerUnit: CGFloat = 10 { didSet{ setNeedsDisplay() } }
    
    var recCenter: CGPoint?{ didSet { setNeedsDisplay() } }
    
    var minX: CGFloat {
        get{
            return bounds.minX
        }
        set{
            newValue
        }
    }
    var maxX: CGFloat {
        get{
            return bounds.maxX
        }
        set {
            newValue
        }
    }
    var minY: CGFloat {
        get {
            return bounds.minY
        }
        set {
            newValue
        }
    }
    var maxY: CGFloat {
        get{
            return bounds.maxY
        }
        set {
            newValue
        }
    }
    
    
    var midRectX: CGFloat { return self.bounds.midX }
    var midRectY: CGFloat { return self.bounds.midY }
    
    
    var fromGraphPoint: CGPoint?{
        didSet{
            setNeedsDisplay()
        }
    }
    var toGraphPoint: CGPoint?{
        didSet{
            setNeedsDisplay()
        }
    }
    
    
    enum Line {
        case LeftDiagonal
        case RightDiagonal
        case RightStraight
        case LeftStraight
    }
    
    func drawLine (fromPoint: CGPoint, toPoint: CGPoint) -> UIBezierPath{
        let path = UIBezierPath()
        path.moveToPoint(fromPoint)
        path.addLineToPoint(toPoint)
        return path
    }
    
    override func drawRect(rect: CGRect) {
        
        let rectWidth: CGFloat = maxX * scale
        let rectHeight: CGFloat = maxY * scale
        
        
        let rectangle = CGRect(x: (maxX - rectWidth) / 2, y: (maxY - rectHeight) / 2, width: rectWidth, height: rectHeight)
        
        midRecX = bounds.midX
        midRecY = bounds.midY
        
        if recCenter == nil{
            recCenter = CGPoint(x: rectangle.midX, y: rectangle.midY)
        }
        
        axes.drawAxesInRect(rectangle, origin: recCenter!, pointsPerUnit: pointsPerUnit)
        
        
        if midRecX != nil && midRecY != nil
            && fromGraphPoint != nil && toGraphPoint != nil{
            drawLine(fromGraphPoint!, toPoint: toGraphPoint!).stroke()
        }
    }
    
    
   
}


