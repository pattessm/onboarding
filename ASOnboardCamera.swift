//
//  ASOnboardCamera.swift
//  AsunderU
//
//  Created by Samuel Patteson on 2/19/16.
//  Copyright © 2016 Asunder. All rights reserved.
//

import Foundation
import AVFoundation

class ASOnboardCamera:UIViewController {
    
    var index:Int?
    var data:OnboardDataStruct?
    var didUpdateConstraints:Bool = false
    
    @IBOutlet weak var descBottomLayout: NSLayoutConstraint!
    @IBOutlet weak var titleTopLayout: NSLayoutConstraint!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var subtitleLabel: UILabel!
    @IBOutlet weak var laterButton: UIButton!
    @IBOutlet weak var okayButton: UIButton!
    @IBOutlet weak var btnMasterHeight: NSLayoutConstraint!
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
            descBottomLayout.constant = constant - 10.0
            btnMasterHeight.constant = buttonSize.height
            if isSmall {
                laterButton.titleLabel?.font = UIFont(name: "BebasNeue", size: 17.0)
                okayButton.titleLabel?.font = UIFont(name:"BebasNeue", size:17.0)
            }
            if let coverImage = UIImage(named: (data?.bgImageName)!) {
                self.coverImageView.image = ASImageHelper.sharedInstance.noirImage(coverImage)!
            }
            view.setNeedsUpdateConstraints()
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        // do intro animations
        UIView.animateWithDuration(1.25, delay: 0.50, options: [.CurveEaseInOut, .AllowAnimatedContent], animations: { () -> Void in
            self.coverImageView.alpha = 0.0
            }, completion:nil)
    }
    
    @IBAction func didSelectCameraOK(_ sender: AnyObject) {
        
        if AVCaptureDevice.authorizationStatus(forMediaType: AVMediaTypeVideo) ==  AVAuthorizationStatus.notDetermined {
            AVCaptureDevice.requestAccess(forMediaType: AVMediaTypeVideo, completionHandler: { (granted) -> Void in
                NotificationCenter.default.post(Foundation.Notification(name: ASAuthNotifNames.kCameraAuthAnswered.rawValue, object: nil))
            })
        }
        else { // This is real edge-case-y. User reinstalled the app or user is in test
            NotificationCenter.default.post(Foundation.Notification(name: ASAuthNotifNames.kCameraAuthAnswered.rawValue, object: nil))
        }
    }
    
    @IBAction func didSelectCameraLater(_ sender: AnyObject) {
        // send message to skip to next page
        NotificationCenter.default.post(Foundation.Notification(name: ASAuthNotifNames.kCameraAuthAnswered.rawValue, object: nil))
    }
}
