//
//  VisitorView.swift
//  Sina
//
//  Created by YOUNG on 16/9/5.
//  Copyright © 2016年 Young. All rights reserved.
//

import UIKit

class VisitorView: UIView {
    class func visitorView() -> VisitorView{
        return NSBundle.mainBundle() .loadNibNamed("VisitorView", owner: nil, options: nil).first as! VisitorView
    }
    
    @IBOutlet weak var rotateView: UIImageView!
    
    @IBOutlet weak var iconView: UIImageView!
    
    @IBOutlet weak var textLabel: UILabel!
    
    @IBOutlet weak var rigisterButton: UIButton!
    
    @IBOutlet weak var loginButton: UIButton!
    
    func setupVisitorViewInfo(imageName : String, text : String)  {
        iconView.image = UIImage(named: imageName)
        textLabel.text = text
        rotateView.hidden = true
    }
    
    func addRotateAnimation() {
        let animaiton = CABasicAnimation(keyPath: "transform.rotation.z")
        animaiton.fromValue = 0
        animaiton.toValue = M_PI * 2
        animaiton.repeatCount = MAXFLOAT
        animaiton.duration = 15
        animaiton.removedOnCompletion = false
        rotateView.layer.addAnimation(animaiton, forKey: nil)
        
    }
}
