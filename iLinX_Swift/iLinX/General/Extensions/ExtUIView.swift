//
//  ExtUIView.swift
//  iLinX
//
//  Created by Vikas Ninawe on 23/10/18.
//  Copyright © 2018 Redbytes Software. All rights reserved.
//  Purpose:

import UIKit

extension UIView {
    
    func makeBorder(color : UIColor) {
        self.layer.borderWidth = 1
        self.layer.cornerRadius = 5
        self.layer.borderColor = color.cgColor
    }
    
    func setDropShadow() {
        self.layer.masksToBounds = false
        self.layer.shadowColor = UIColor.red.cgColor
        self.layer.shadowOpacity = 0.5
        self.layer.shadowRadius = 3
        self.layer.shadowOffset = CGSize(width: 0, height: 3)
    }
    
    func setDropShadowWithRoundedCorner() {
        self.layer.cornerRadius = 3
        self.layer.masksToBounds = false
        self.layer.shadowColor = UIColor.black.cgColor
        self.layer.shadowOpacity = 0.5
        self.layer.shadowRadius = 2
        self.layer.shadowOffset = CGSize(width: 0, height: 1)
    }
    
    func setGradientBackground() {
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = self.bounds
        gradientLayer.startPoint = CGPoint(x: 0.0, y: 1.0)
        gradientLayer.endPoint = CGPoint(x: 1.0, y: 1.0)
        gradientLayer.colors = [ UIColor.white.cgColor, UIColor.black.cgColor]
        self.layer.addSublayer(gradientLayer)
        
        let arrSubviews = self.subviews
        for i in arrSubviews{
            self.bringSubviewToFront(i)
        }
    }
    
    func setGradientBackgroundToButtonWithRoundedCorner() {
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = self.bounds
        gradientLayer.cornerRadius = self.frame.height*0.5
        gradientLayer.startPoint = CGPoint(x: 0.0, y: 1.0)
        gradientLayer.endPoint = CGPoint(x: 1.0, y: 1.0)
        gradientLayer.colors = [ UIColor.white.cgColor, UIColor.black.cgColor]
        self.layer.addSublayer(gradientLayer)
        
        let arrSubviews = self.subviews
        for i in arrSubviews{
            self.bringSubviewToFront(i)
        }
    }
    
    func addShadowTopBottom(){
        self.layer.masksToBounds = false
        self.layer.shadowColor = UIColor.black.cgColor
        self.layer.shadowOpacity = 0.3
        self.layer.shadowRadius = 2
        self.layer.shadowOffset = CGSize(width: 0, height: -1)
        
        self.layer.shadowColor = UIColor.black.cgColor
        self.layer.shadowOpacity = 0.4
        self.layer.shadowRadius = 2
        self.layer.shadowOffset = CGSize(width: 0, height: 1)
    }
    
    func addShadowBottom(){
        self.layer.masksToBounds = false
        self.layer.shadowColor = UIColor.lightGray.cgColor
        self.layer.shadowOpacity = 0.3
        self.layer.shadowRadius = 2
        self.layer.shadowOffset = CGSize(width: 0, height: 2)
    }
    
    func addShadowAllSide()
    {
        self.layer.shadowColor = UIColor.lightGray.cgColor
        self.layer.shadowOffset = CGSize(width: 0, height: 5)
        self.layer.shadowOpacity = 0.3
        self.layer.shadowRadius = 2.0
        self.layer.masksToBounds = false
        self.layer.shouldRasterize = true
        self.layer.rasterizationScale = UIScreen.main.scale
        
        //TAT
        /*
        self.layer.masksToBounds = false
        self.layer.cornerRadius = 7
        
        let shadowLayer = UIView(frame: self.frame)
        shadowLayer.backgroundColor = UIColor.clear
        shadowLayer.layer.shadowColor = UIColor.lightGray.cgColor
        shadowLayer.layer.shadowPath = UIBezierPath(roundedRect: bounds, cornerRadius: self.layer.cornerRadius).cgPath
        shadowLayer.layer.shadowOffset = CGSize.zero
        shadowLayer.layer.shadowOpacity = 0.3
        shadowLayer.layer.shadowRadius = 2
        shadowLayer.layer.masksToBounds = true
        shadowLayer.clipsToBounds = false
        
        self.superview?.addSubview(shadowLayer)
        self.superview?.bringSubview(toFront: self)
        self.clipsToBounds = true
        */
    }
    
    func addShadowAllSideWithoutInsertingView(){
        self.layer.cornerRadius = 7
        
        self.backgroundColor = UIColor.clear
        self.layer.shadowColor = UIColor.lightGray.cgColor
        self.layer.shadowPath = UIBezierPath(roundedRect: bounds, cornerRadius: self.layer.cornerRadius).cgPath
        self.layer.shadowOffset = CGSize.zero
        self.layer.shadowOpacity = 0.3
        self.layer.shadowRadius = 2
        self.layer.masksToBounds = true
        self.clipsToBounds = false
    }
    
    func slideInFromLeft(_ duration: TimeInterval = 1.0, completionDelegate: CAAnimationDelegate? = nil) {
        let slideInFromLeftTransition = CATransition()
        if let delegate: CAAnimationDelegate = completionDelegate {
            slideInFromLeftTransition.delegate = delegate
        }
        slideInFromLeftTransition.type = CATransitionType.push
        slideInFromLeftTransition.subtype = CATransitionSubtype.fromLeft
        slideInFromLeftTransition.duration = duration
        slideInFromLeftTransition.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut)
        slideInFromLeftTransition.fillMode = CAMediaTimingFillMode.removed
        self.layer.add(slideInFromLeftTransition, forKey: "slideInFromLeftTransition")
    }
    
    func slideInFromRight(_ duration: TimeInterval = 1.0, completionDelegate: CAAnimationDelegate? = nil) {
        let slideInFromRightTransition = CATransition()
        if let delegate: CAAnimationDelegate = completionDelegate {
            slideInFromRightTransition.delegate = delegate
        }
        slideInFromRightTransition.type = CATransitionType.push
        slideInFromRightTransition.subtype = CATransitionSubtype.fromRight
        slideInFromRightTransition.duration = duration
        slideInFromRightTransition.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut)
        slideInFromRightTransition.fillMode = CAMediaTimingFillMode.removed
        self.layer.add(slideInFromRightTransition, forKey: "slideInFromLeftTransition")
    }
    
    func slideLeft(){
        let transition = CATransition()
        transition.timeOffset = 3.0
        transition.type = CATransitionType.push
        transition.subtype = CATransitionSubtype.fromRight
        self.layer.add(transition, forKey: nil)
    }
    
    func slideRight(){
        let transition = CATransition()
        transition.timeOffset = 3.0
        transition.type = CATransitionType.push
        transition.subtype = CATransitionSubtype.fromLeft
        self.layer.add(transition, forKey: nil)
    }
    
}


extension UIButton{
    func setBorderWithRoundedCorner(){
        //self.backgroundColor = .clear
        self.layer.cornerRadius = 5
        self.layer.borderWidth = 1
        self.layer.borderColor = UIColor.iLinXBlueColor.cgColor
    }
}

