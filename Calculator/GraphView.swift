//
//  GraphView.swift
//  Calculator
//
//  Created by Andi Maroge on 8/2/16.
//  Copyright © 2016 Andi Maroge. All rights reserved.
//

import UIKit


@IBDesignable
class GraphView: UIView {
    var axes = AxesDrawer(color: UIColor.redColor(), contentScaleFactor: 1)
    var scale = 0.90
    
    
    
    
    
    var rectCenter: CGPoint {
        return CGPoint(x: (bounds.midX), y: bounds.midY)
    }
    

    
    enum Line {
        case LeftDiagonal
        case RightDiagonal
        case RightStraight
        case LeftStraight
    }
    
    
    func drawLine (fromPoint: CGPoint, toPoint: CGPoint) -> UIBezierPath{
        var path = UIBezierPath()
        path.moveToPoint(fromPoint)
        path.addLineToPoint(toPoint)
        path.moveToPoint(fromPoint)
        path.addLineToPoint(toPoint)
        return path
    }
    override func drawRect(rect: CGRect) {
        axes.drawAxesInRect(rect, origin: rectCenter, pointsPerUnit: 30)

        
        
    }
}
