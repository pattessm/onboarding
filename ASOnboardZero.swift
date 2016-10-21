//
//  ASOnboardZero.swift
//  AsunderU
//
//  Created by Samuel Patteson on 2/18/16.
//  Copyright © 2016 Asunder. All rights reserved.
//

import Foundation
import UIKit

class ASOnboardZero: UIViewController {
    
    var index:Int?
    var isLast:Bool = false
    var data:OnboardDataStruct?
    var didUpdateConstraints:Bool = false
    
    @IBOutlet weak var coverImageView: UIImageView!
    @IBOutlet weak var descBottomLayout: NSLayoutConstraint!
    @IBOutlet weak var titleTopLayout: NSLayoutConstraint!
    @IBOutlet weak var bgImage: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var subtitleLabel: UILabel!
    @IBOutlet weak var buttonHeight: NSLayoutConstraint!
    @IBOutlet weak var buttonWidth: NSLayoutConstraint!
    @IBOutlet weak var startButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
            
        self.view.backgroundColor = ASColorPallette.darkBlue()
        self.bgImage.image = UIImage(named: (data?.bgImageName)!)
        self.titleLabel.attributedText = data?.titleAttributedString
        self.subtitleLabel.attributedText = data?.subtitleAttributedString
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if(!didUpdateConstraints) {
            didUpdateConstraints = true
            let (isSmall, constant, buttonSize) = OnboardConstraintHelper.getOnboardConstraints()
            titleTopLayout.constant = constant
            
            var bottomConstant = constant
            if isLast {
                bottomConstant = constant - 10.0
            }
            descBottomLayout.constant = bottomConstant
            buttonWidth.constant = buttonSize.width
            buttonHeight.constant = buttonSize.height
            if isSmall {
                startButton.titleLabel?.font = UIFont(name: "BebasNeue", size: 17.0)
            }
            if let coverImage = UIImage(named: (data?.bgImageName)!) {
                self.coverImageView.image = ASImageHelper.sharedInstance.noirImage(coverImage)!
            }
            view.setNeedsUpdateConstraints()
        }
        if(isLast) {
            startButton.isHidden = false;
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        // do intro animations

        UIView.animate(withDuration: 1.25, delay: 0.50, options: .allowAnimatedContent, animations: { () -> Void in
            self.coverImageView.alpha = 0.0
            }, completion:nil)
    }
    
    @IBAction func didSelectStart(_ sender: AnyObject) {
        NotificationCenter.default.post(Foundation.Notification(name: ASAuthNotifNames.kDidSelectStart.rawValue, object: nil))
    }
}
