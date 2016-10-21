//
//  OnboardingViewController.swift
//  AsunderU
//
//  Created by Samuel Patteson on 2/17/16.
//  Copyright © 2016 Asunder. All rights reserved.
//

import Foundation
import UIKit

class OnboardingViewController: UIPageViewController {
    
    var index = 0
    let onboardDataArray = OnboardDataStructFactory.createDataStructDataArray()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = ASColorPallette.darkBlue()
        dataSource = self
        setViewControllers([getASOnboardZero(0)], direction: .forward, animated: false, completion: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.registerForNotifs()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        self.deregisterForNotifs()
        super.viewDidDisappear(animated)
    }
    
    func getASOnboardZero(_ index:Int) -> ASOnboardZero {
        self.index = index
        let onboardZero = UIStoryboard(name: "Onboarding", bundle: nil).instantiateViewController(withIdentifier: "ASOnboardZeroID") as! ASOnboardZero
        onboardZero.data = onboardDataArray[index]
        onboardZero.index = index

        if index == onboardDataArray.count - 1 {
            onboardZero.isLast = true
        }
        
        return onboardZero
    }
    
    func getASOnboardLocation(_ index:Int) -> ASOnboardLoc {
        self.index = index
        let onboardLoc = UIStoryboard(name:"Onboarding", bundle:nil).instantiateViewController(withIdentifier: "OnboardLocID") as! ASOnboardLoc
        onboardLoc.data = onboardDataArray[index]
        onboardLoc.index = index
        return onboardLoc
    }
    
    func getASOnboardCamera(_ index:Int) -> ASOnboardCamera {
        self.index = index
        let onboardCamera = UIStoryboard(name:"Onboarding", bundle:nil).instantiateViewController(withIdentifier: "OnboardCameraID") as! ASOnboardCamera
        onboardCamera.data = onboardDataArray[index]
        onboardCamera.index = index
        return onboardCamera
    }
    
    func getASOnboardNotif(_ index:Int) -> ASOnboardNotif {
        self.index = index
        let onboardNotif = UIStoryboard(name:"Onboarding", bundle:nil).instantiateViewController(withIdentifier: "OnboardNotifID") as! ASOnboardNotif
        onboardNotif.data = onboardDataArray[index]
        onboardNotif.index = index
        return onboardNotif
    }
    
    //MARK:- Notification Register/Deregister
    func registerForNotifs() {
        NotificationCenter.default.addObserver(self, selector: #selector(OnboardingViewController.didChangeLocationAccess(_:)), name: NSNotification.Name(rawValue: ASAuthNotifNames.kDidChooseLocationAuth.rawValue), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(OnboardingViewController.didAnswerCameraAuth(_:)), name: NSNotification.Name(rawValue: ASAuthNotifNames.kCameraAuthAnswered.rawValue), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(OnboardingViewController.didAnswerPushAuth(_:)), name: NSNotification.Name(rawValue: ASAuthNotifNames.kPushNotifAuthAnswered.rawValue), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(OnboardingViewController.didSelectStart(_:)), name: NSNotification.Name(rawValue: ASAuthNotifNames.kDidSelectStart.rawValue), object: nil)
    }
    
    func deregisterForNotifs() {
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: ASAuthNotifNames.kDidChooseLocationAuth.rawValue), object: nil)
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: ASAuthNotifNames.kCameraAuthAnswered.rawValue), object: nil)
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: ASAuthNotifNames.kPushNotifAuthAnswered.rawValue), object: nil)
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: ASAuthNotifNames.kDidSelectStart.rawValue), object: nil)
    }
    
    func didChangeLocationAccess(_ notif:Foundation.Notification) {
        DispatchQueue.main.async { [unowned self] () -> Void in
            self.setViewControllers([self.getASOnboardCamera(4)], direction: .Forward, animated: true, completion: nil)
        }
    }
    
    func didAnswerCameraAuth(_ notif:Foundation.Notification) {
        DispatchQueue.main.async { [unowned self] () -> Void in
            self.setViewControllers([self.getASOnboardNotif(5)], direction: .Forward, animated: true, completion: nil)
        }
    }
    
    func didAnswerPushAuth(_ notif:Foundation.Notification) {
        DispatchQueue.main.async { [unowned self] () -> Void in
            self.setViewControllers([self.getASOnboardZero(6)], direction: .forward, animated: true, completion: nil)
        }
    }
    
    func didSelectStart(_ notif:Foundation.Notification) {
        DispatchQueue.main.async { [unowned self] () -> Void in
            self.dismiss(animated: true, completion: nil)
        }
    }
}

extension OnboardingViewController : UIPageViewControllerDataSource {
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        if viewController.isKind(of: ASOnboardZero.self) {
            switch (viewController as! ASOnboardZero).index! {
            case 2:
                return getASOnboardZero(1)
            case 1:
                return getASOnboardZero(0)
            default:
                return nil
            }
        }
        else if viewController.isKind(of: ASOnboardLoc.self) {
            return nil
        }
        else {
            return nil
        }
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        if viewController.isKind(of: ASOnboardZero.self) {
            switch (viewController as! ASOnboardZero).index! {
            case 0:
                return getASOnboardZero(1)
            case 1:
                return getASOnboardZero(2)
            case 2:
                return getASOnboardLocation(3)
            default:
                return nil
            }
        }
        else if viewController.isKind(of: ASOnboardLoc.self) {
            return nil
        }
        else {
            return nil
        }
    }
    
    func presentationCount(for pageViewController: UIPageViewController) -> Int {
        return onboardDataArray.count
    }
    
    func presentationIndex(for pageViewController: UIPageViewController) -> Int {
        return index
    }
}
