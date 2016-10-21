//
//  ASOnboardNotif.swift
//  AsunderU
//
//  Created by Samuel Patteson on 2/19/16.
//  Copyright © 2016 Asunder. All rights reserved.
//

import Foundation

class ASOnboardNotif : UIViewController {
    
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
    
    override func viewWillDisappear(_ animated: Bool) {
        self.deregisterForNotifs()
        super.viewDidDisappear(animated)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        // do intro animations
        UIView.animateWithDuration(1.25, delay: 0.50, options: [.CurveEaseInOut, .AllowAnimatedContent], animations: { () -> Void in
            self.coverImageView.alpha = 0.0
            }, completion:nil)
    }
    
//MARK:- Notification Register/Deregister
    func registerForNotifs() {
        NotificationCenter.default.addObserver(self, selector: #selector(ASOnboardNotif.didChooseNotifAuth(_:)),
            name: NSNotification.Name(rawValue: ASAuthNotifNames.kRegisterNotifsSuccess.rawValue), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(ASOnboardNotif.didChooseNotifAuth(_:)),
            name: NSNotification.Name(rawValue: ASAuthNotifNames.kRegisterNotifsFailed.rawValue), object: nil)
    }
    
    func deregisterForNotifs() {
        NotificationCenter.default.removeObserver(self, name:NSNotification.Name(rawValue: ASAuthNotifNames.kRegisterNotifsSuccess.rawValue), object: nil)
        NotificationCenter.default.removeObserver(self, name:NSNotification.Name(rawValue: ASAuthNotifNames.kRegisterNotifsFailed.rawValue), object: nil)
    }
    
    func didChooseNotifAuth(_ notif:Foundation.Notification) {
        NotificationCenter.default.post(Foundation.Notification(name: ASAuthNotifNames.kPushNotifAuthAnswered.rawValue, object: nil))
    }
    
//MARK:- IBActions
    @IBAction func didSelectNotifButton(_ sender: AnyObject) {
        
        UIApplication.sharedApplication().registerUserNotificationSettings(UIUserNotificationSettings(forTypes: [UIUserNotificationType.Alert,UIUserNotificationType.Sound, UIUserNotificationType.Badge], categories: nil))
        
        UIApplication.sharedApplication().registerForRemoteNotifications()
    }
}
