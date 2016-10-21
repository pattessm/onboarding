//
//  OnboardConstraintHelper.swift
//  AsunderU
//
//  Created by Samuel Patteson on 2/18/16.
//  Copyright © 2016 Asunder. All rights reserved.
//

import Foundation

class OnboardConstraintHelper {
    
    class func getOnboardConstraints() -> (isSmall:Bool, labelConstant:CGFloat, buttonSize:CGSize) {
        
        var constant:CGFloat = 16.0
        var buttonSize = CGSizeMake(70.0, 28.0)
        var isSmall = true
        
        let screenSize: CGRect = UIScreen.mainScreen().bounds
        
        if screenSize.height > 660.0  {
            constant = 40.0
            buttonSize = CGSizeMake(93.0, 37.0)
            isSmall = false
        }
        return (isSmall, constant, buttonSize)
    }
}