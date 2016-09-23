//
//  ProgressView.swift
//  Sina
//
//  Created by YOUNG on 16/9/23.
//  Copyright © 2016年 Young. All rights reserved.
//

import UIKit

class ProgressView: UIView  {
    
    var progress : CGFloat  = 0 {
        didSet{
            setNeedsDisplay()
        }
    }
    
    override func drawRect(rect: CGRect) {
        super.drawRect(rect)
        let center = CGPoint(x: rect.width/2, y: rect.height/2)
        let radius : CGFloat = rect.width/2 - 3
        let startAngle : CGFloat = CGFloat(-M_PI_2)
        let endAngle : CGFloat = CGFloat(M_PI * 2) * progress + startAngle
        
       let path = UIBezierPath(arcCenter: center, radius: radius, startAngle: startAngle, endAngle: endAngle, clockwise: true)
        
        path.addLineToPoint(center)
        path.closePath()
        
        UIColor.cyanColor().setFill()
        path.fill()
    }
    

}
