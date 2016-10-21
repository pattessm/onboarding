//
//  OnboardDataStructFactory.swift
//  AsunderU
//
//  Created by Samuel Patteson on 2/18/16.
//  Copyright © 2016 Asunder. All rights reserved.
//

import Foundation

class OnboardDataStructFactory {
    
    class func createOnboardDataStruct(_ title:String, desc:String, imageName:String) -> OnboardDataStruct {
        
        return OnboardDataStruct(bgImageName:imageName, titleAttributedString: OnboardDataStructFactory.createAttributedStringForTitle(title), subtitleAttributedString: OnboardDataStructFactory.createAttributedStringForDesc(desc))
    }
    
    class func createAttributedStringForTitle(_ title:String) -> NSAttributedString {
        
        let (titleSize, _) = OnboardDataStructFactory.getOptimumFontSizes()
        
        return ASAttributedStringHelper.createAttributedString(title, font: UIFont(name: "BebasNeue", size: titleSize)!, color: ASColorPallette.offWhite(), lineHeightMultiple: 0.75, kerning: 1, alignment: NSTextAlignment.Center, maxLineHeight: titleSize + 2.0, minLineHeight: titleSize + 2.0)
    }
    
    class func createAttributedStringForDesc(_ desc:String) -> NSAttributedString {
        
        let (_, descSize) = OnboardDataStructFactory.getOptimumFontSizes()

                return ASAttributedStringHelper.createAttributedString(desc, font: UIFont(name: "Hero", size: descSize)!, color: ASColorPallette.acidYellow(), lineHeightMultiple: 1, kerning: 3, alignment: NSTextAlignment.Center, maxLineHeight: descSize + 5.0, minLineHeight: descSize + 2.0)
    }
    
    class func getOptimumFontSizes() -> (CGFloat, CGFloat) {
        var titleSize:CGFloat = 46.0
        var descSize:CGFloat = 12.0
        
        let screenSize: CGRect = UIScreen.mainScreen().bounds
        
        if screenSize.height > 734.0 {
            titleSize = 78.0
            descSize = 17.0
        }
        else if screenSize.height > 665.0 {
            titleSize = 60.0
            descSize = 15.0
        }
        
        return (titleSize, descSize)
    }

    class func createDataStructDataArray() -> [OnboardDataStruct] {
        
        let titles = ["STORIES\nARE\nEVERYWHERE",
            "GET OUT,\nLOOK\nAROUND",
            "ENGAGE\nYOUR\nSENSES",
            "LET'S\nGET\nSET UP",
            "I TURN MY\nCAMERA\nON",
            "LET\nASUNDER\nALERT YOU",
            "WOULD YOU\nLIKE TO\nKNOW MORE?"]
        
        let imageNames = ["onboard1", "onboard2", "onboard3", "onboard4", "onboard5", "onboard6", "onboard7"]
        
        let descs = ["EXPERIENCE STORIES TRIGGERED\nBY THE PLACES AND OBJECTS\nAROUND YOU",
            "EXPLORE YOUR CITY IN A NEW WAY AS YOU TRAVEL FROM ONE\nSTORY LOCATION TO ANOTHER",
            "EXPLORE RICH STORYTELLING\nVIA AUDIO, PHOTOS, VIDEO, \nAND AUGMENTED REALITY",
            "IN ORDER TO WORK,\nASUNDER NEEDS ACCESS TO\nYOUR LOCATION",
            "ENJOY AUGEMENTED REALITY\nAND CREATE VISUAL STORIES BY\n GIVING ASUNDER ACCESS TO YOUR CAMERA",
            "WHEN YOU'RE NEAR A NEW STORY, ASUNDER WILL ALERT YOU WITH YOUR PERMISSION",
            "REGISTER WITH ASUNDER TO\nENJOY AND CREATE THE BEST TRANSMEDIA ADVENTURES\nIN THE UNIVERSE!"]
        
        var array:[OnboardDataStruct] = []
        var onboardStruct:OnboardDataStruct
        
        for (i in 0 ..< imageNames.count ) {
            onboardStruct = OnboardDataStructFactory.createOnboardDataStruct(titles[i], desc: descs[i], imageName: imageNames[i])
            array.append(onboardStruct)
        }
        
        return array
    }
}
