//
//  ASOnboardLoc.swift
//  AsunderU
//
//  Created by Samuel Patteson on 2/18/16.
//  Copyright © 2016 Asunder. All rights reserved.
//

import Foundation
import UIKit

class ASOnboardLoc:UIViewController {

    var index:Int?
    var data:OnboardDataStruct?
    var didUpdateConstraints:Bool = false
    
    @IBOutlet weak var descBottomLayout: NSLayoutConstraint!
    @IBOutlet weak var titleTopLayout: NSLayoutConstraint!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var subtitleLabel: UILabel!
    @IBOutlet weak var buttonHeight: NSLayoutConstraint!
    @IBOutlet weak var buttonWidth: NSLayoutConstraint!
    @IBOutlet weak var chooseButton: UIButton!
    @IBOutlet weak var coverImageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = ASColorPallette.darkBlue()
        self.titleLabel.attributedText = data?.titleAttributedString
        self.subtitleLabel.attributedText = data?.subtitleAttributedString
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if(!didUpdateConstraints) {
            didUpdateConstraints = true
            let (isSmall, constant, buttonSize) = OnboardConstraintHelper.getOnboardConstraints()
            titleTopLayout.constant = constant
            descBottomLayout.constant = constant
            buttonWidth.constant = buttonSize.width
            buttonHeight.constant = buttonSize.height
            if isSmall {
                chooseButton.titleLabel?.font = UIFont(name: "BebasNeue", size: 17.0)
            }
            if let coverImage = UIImage(named: (data?.bgImageName)!) {
                self.coverImageView.image = ASImageHelper.sharedInstance.noirImage(coverImage)!
            }
            view.setNeedsUpdateConstraints()
        }
        self.registerForNotifs()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        // do intro animations
        UIView.animate(withDuration: 1.25, delay: 0.50, options: .allowAnimatedContent, animations: { () -> Void in
            self.coverImageView.alpha = 0.0
            }, completion:nil)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        self.deregisterForNotifs()
        super.viewDidDisappear(animated)
    }
    
//MARK:- Notification Register/Deregister
    func registerForNotifs() {
        NotificationCenter.default.addObserver(self, selector: #selector(ASOnboardLoc.didChangeLocationAccess(_:)),
            name: NSNotification.Name(rawValue: ASLocationNotificationNames.LocationWasApproved.rawValue), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(ASOnboardLoc.didChangeLocationAccess(_:)),
            name: NSNotification.Name(rawValue: ASLocationNotificationNames.LocationWasDenied.rawValue), object: nil)
    }
    
    func deregisterForNotifs() {
        NotificationCenter.default.removeObserver(self, name:NSNotification.Name(rawValue: ASLocationNotificationNames.LocationWasApproved.rawValue), object: nil)
        NotificationCenter.default.removeObserver(self, name:NSNotification.Name(rawValue: ASLocationNotificationNames.LocationWasDenied.rawValue), object: nil)
    }
    
    func didChangeLocationAccess(_ notif:Foundation.Notification?) {
        // Ready to continue!
        NotificationCenter.default.post(Foundation.Notification(name: "kDidChooseLocationAuth", object: nil))
    }
    
    @IBAction func didSelectLocButton(_ sender: AnyObject) {
        let (accessGranted, shouldOpenSettings) = ASLocationManager.sharedInstance.isLocationAccessible()
        if(accessGranted) {
            self.didChangeLocationAccess(nil)
        }
        else {
            if (shouldOpenSettings) {
                // Don't open settings here.  It's an edge case user will see it, and we can always ask to 
                // go to the settings to change location access later.
                self.didChangeLocationAccess(nil)
            }
            else {
                let locManager = ASLocationManager.sharedInstance
                locManager.requestAccess()
            }
        }
    }
}
