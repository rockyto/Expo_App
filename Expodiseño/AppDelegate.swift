//
//  AppDelegate.swift
//  Expodiseño
//
//  Created by expo on 02/03/17.
//  Copyright © 2017 Creategia360. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    var drawerContainer:MMDrawerController?
    
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        //Personaliza la vista
        self.window = UIWindow(frame: UIScreen.main.bounds)
        self.window! .backgroundColor = UIColor(red: 35/255, green: 34/255, blue: 34/255, alpha:1)
        self.window!.makeKeyAndVisible()
        
        let mainStoryboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        
        //Recuerda al usuario
        let userId = UserDefaults.standard.string(forKey: "userId")
        if (userId != nil )
        {
            
            //let mainStoryboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
            let navigationController = mainStoryboard.instantiateViewController(withIdentifier: "PrincipalViewController") as! PrincipalViewController
            let mainPageNav = UINavigationController(rootViewController: navigationController)
            self.window?.rootViewController = mainPageNav
            
            //logomask
            navigationController.view.layer.mask = CALayer()
            navigationController.view.layer.mask?.contents = UIImage(named: "logoGrande500pts")!.cgImage
            navigationController.view.layer.mask?.bounds = CGRect(x:0, y:0, width: 60, height: 60)
            navigationController.view.layer.mask?.anchorPoint = CGPoint (x: 0.5, y: 0.5)
            navigationController.view.layer.mask?.position = CGPoint (x: navigationController.view.frame.width / 2, y: navigationController.view.frame.height / 2)
            
            //logo mask background view
            let maskBigView = UIView(frame: navigationController.view.frame)
            maskBigView.backgroundColor = UIColor.white
            navigationController.view.addSubview(maskBigView)
            navigationController.view.bringSubview(toFront: maskBigView)
            
            //logo mask animation
            let transformAnimation = CAKeyframeAnimation (keyPath: "bounds")
            transformAnimation.duration = 0.5
            transformAnimation.beginTime = CACurrentMediaTime() + 1
            
            let initalBounds = NSValue(cgRect: (navigationController.view.layer.mask?.bounds)!)
            let secondBounds = NSValue(cgRect: CGRect(x: 0, y: 0, width: 50, height: 50))
            let finalBounds = NSValue(cgRect: CGRect(x: 0, y: 0, width: 2000, height: 2000))
            
            transformAnimation.values = [initalBounds, secondBounds, finalBounds]
            transformAnimation.keyTimes = [0, 0.5, 1]
            transformAnimation.timingFunctions = [CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut), CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)]
            transformAnimation.isRemovedOnCompletion = false
            transformAnimation.fillMode = kCAFillModeForwards
            navigationController.view.layer.mask?.add(transformAnimation, forKey: "maskAnimation")
            
            UIView.animate(withDuration: 0.1, delay: 1.35, options: UIViewAnimationOptions.curveEaseIn,
                           animations: {
                            maskBigView.alpha = 0.0
            },
                           completion: {finished in
                            maskBigView.removeFromSuperview()
            })
            
            
            
            UIView.animate(withDuration: 0.25,
                           delay: 1.3,
                           options: UIViewAnimationOptions(),
                           animations: {
                            self.window!.rootViewController!.view.transform = CGAffineTransform(scaleX: 1.05, y: 1.05)
                            
                            
            },
                           completion: {finished in
                            UIView.animate(withDuration: 0.3,
                                           delay: 0.0,
                                           options : UIViewAnimationOptions.curveEaseInOut,
                                           animations: {
                                            self.window!.rootViewController!.view.transform = CGAffineTransform.identity
                            },
                                           completion: nil
                            )
            })
            
       buildNavigationDrawer()
        
        }
            //Fin de recordar al usuario
            
        else{
            
            
            
            //rootViewController from storyboard
            
            let navigationController = mainStoryboard.instantiateViewController(withIdentifier: "navigationController")
            self.window!.rootViewController = navigationController
            
            
            //logomask
            navigationController.view.layer.mask = CALayer()
            navigationController.view.layer.mask?.contents = UIImage(named: "logoGrande500pts")!.cgImage
            navigationController.view.layer.mask?.bounds = CGRect(x:0, y:0, width: 60, height: 60)
            navigationController.view.layer.mask?.anchorPoint = CGPoint (x: 0.5, y: 0.5)
            navigationController.view.layer.mask?.position = CGPoint (x: navigationController.view.frame.width / 2, y: navigationController.view.frame.height / 2)
            
            //logo mask background view
            let maskBigView = UIView(frame: navigationController.view.frame)
            maskBigView.backgroundColor = UIColor.white
            navigationController.view.addSubview(maskBigView)
            navigationController.view.bringSubview(toFront: maskBigView)
            
            //logo mask animation
            let transformAnimation = CAKeyframeAnimation (keyPath: "bounds")
            transformAnimation.duration = 0.5
            transformAnimation.beginTime = CACurrentMediaTime() + 1
            
            let initalBounds = NSValue(cgRect: (navigationController.view.layer.mask?.bounds)!)
            let secondBounds = NSValue(cgRect: CGRect(x: 0, y: 0, width: 50, height: 50))
            let finalBounds = NSValue(cgRect: CGRect(x: 0, y: 0, width: 2000, height: 2000))
            
            transformAnimation.values = [initalBounds, secondBounds, finalBounds]
            transformAnimation.keyTimes = [0, 0.5, 1]
            transformAnimation.timingFunctions = [CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut), CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)]
            transformAnimation.isRemovedOnCompletion = false
            transformAnimation.fillMode = kCAFillModeForwards
            navigationController.view.layer.mask?.add(transformAnimation, forKey: "maskAnimation")
            
            UIView.animate(withDuration: 0.1, delay: 1.35, options: UIViewAnimationOptions.curveEaseIn,
                           animations: {
                            maskBigView.alpha = 0.0
            },
                           completion: {finished in
                            maskBigView.removeFromSuperview()
            })
            
            
            
            UIView.animate(withDuration: 0.25,
                           delay: 1.3,
                           options: UIViewAnimationOptions(),
                           animations: {
                            self.window!.rootViewController!.view.transform = CGAffineTransform(scaleX: 1.05, y: 1.05)
                            
                            
            },
                           completion: {finished in
                            UIView.animate(withDuration: 0.3,
                                           delay: 0.0,
                                           options : UIViewAnimationOptions.curveEaseInOut,
                                           animations: {
                                            self.window!.rootViewController!.view.transform = CGAffineTransform.identity
                            },
                                           completion: nil
                            )
            })
            
        }
        
        
        // Override point for customization after application launch.
        return true
    }
    
    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }
    
    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }
    
    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }
    
    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }
    
    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
    
    func CAAnimationDelegate (anim: CAAnimation!, finished flag: Bool){
        self.window!.rootViewController!.view.layer.mask=nil
    }
    
    func buildNavigationDrawer(){
    
        let mainStoryBoard:UIStoryboard = UIStoryboard(name:"Main", bundle:nil)
        let navigationController:PrincipalViewController = mainStoryBoard.instantiateViewController(withIdentifier: "PrincipalViewController") as! PrincipalViewController
        let leftSideMenu:LeftSideViewController = mainStoryBoard.instantiateViewController(withIdentifier: "LeftSideViewController") as! LeftSideViewController
        let rightSideMenu:RightSideViewController = mainStoryBoard.instantiateViewController(withIdentifier: "RightSideViewController") as! RightSideViewController
        
        
        let mainPageNav = UINavigationController(rootViewController: navigationController)
        let leftSideMenuNav = UINavigationController(rootViewController:leftSideMenu)
        let rightSideMenuNav = UINavigationController(rootViewController:rightSideMenu)
        
        
        //  self.window!.rootViewController = navigationController
        drawerContainer = MMDrawerController(center: mainPageNav, leftDrawerViewController: leftSideMenuNav, rightDrawerViewController: rightSideMenuNav)
        
        drawerContainer!.openDrawerGestureModeMask = MMOpenDrawerGestureMode.panningCenterView
        drawerContainer!.closeDrawerGestureModeMask = MMCloseDrawerGestureMode.panningCenterView
        
        window?.rootViewController = drawerContainer
        //self.window?.rootViewController = mainPageNav
        
    }
    
}

