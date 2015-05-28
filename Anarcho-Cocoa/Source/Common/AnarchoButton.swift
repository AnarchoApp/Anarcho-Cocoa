//
//  AnarchoButton.swift
//  Anarcho-Cocoa
//
//  Created by Maksim on 28.05.15.
//  Copyright (c) 2015 Dima Sai. All rights reserved.
//

import Foundation
import UIKit

class AnarchoButton :  UIButton {
    
    var standartWidth : CGFloat!
    var spinner : UIActivityIndicatorView!
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        spinner = UIActivityIndicatorView(activityIndicatorStyle:.White)
        spinner.startAnimating()
        spinner.frame.origin.x = (self.frame.height - spinner.frame.width) / 2
        spinner.frame.origin.y = (self.frame.height - spinner.frame.height) / 2
        self.addSubview(spinner)
        spinner.alpha = 0.0
        self.layer.cornerRadius = self.frame.height / 2
    }
    
    func startLoading (width : NSLayoutConstraint) {
        self.standartWidth = width.constant
        self.setTitleColor(UIColor.clearColor(), forState: UIControlState.Normal)
        
        UIView.animateWithDuration(0.2, delay: 0, options: UIViewAnimationOptions.CurveEaseIn, animations:
            {() -> Void in
                
                width.constant = self.frame.height
                self.layoutIfNeeded()
                
            }) { (value: Bool) -> Void in
                
                UIView.animateWithDuration(0.2, animations: { () -> Void in
                    
                    self.spinner.alpha = 1.0
                })
                
        }
    }
    
    func endLoading (width : NSLayoutConstraint) {
        UIView.animateWithDuration(0.2, animations: { () -> Void in
            self.spinner.alpha = 0.0
            
            UIView.animateWithDuration(0.2, delay: 0, options: UIViewAnimationOptions.CurveEaseIn, animations:
                {() -> Void in
                    
                    width.constant = self.standartWidth
                    self.layoutIfNeeded()
                    
                }) { (value: Bool) -> Void in
                    self.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
            }
        })
    }
}