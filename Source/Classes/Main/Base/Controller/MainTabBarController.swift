//
//  MainTabBarController.swift
//  彩小蜜
//
//  Created by HX on 2018/2/28.
//  Copyright © 2018年 韩笑. All rights reserved.
//

import UIKit
import Reachability


let NotificationConfig = "NotificationConfigName"
let TurnOn = "TurnOn"

class MainTabBarController: UITabBarController, UserInfoPro, UITabBarControllerDelegate {

    //private var configInfo : ConfigInfoModel!
    
    private var home : HomeViewController!
    public var me : BaseViewController!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        Thread.sleep(forTimeInterval: 1.0)
        
        self.view.backgroundColor = ColorFFFFFF
        self.tabBar.backgroundColor = ColorFFFFFF
        self.tabBar.barTintColor = ColorFFFFFF
        
        self.tabBar.shadowImage = UIImage(named : "line1")
        self.tabBar.backgroundImage = UIImage()
        self.delegate = self
        creatSubViewControllers(false)
        
        guard getUserData() != nil else {
            configRequest()
            return }
        
        if let reachability = Reachability() {
            do {
                try reachability.startNotifier()
            } catch {
                print("Unable to start notifier")
            }
            
            reachability.whenReachable = { reachability in
                self.configRequest()
            }
            reachability.whenUnreachable = { _ in
                
            }
        }
        
        
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    func configRequest() {
        weak var weakSelf = self
        _ = userProvider.rx.request(.configQuety)
            .asObservable()
            .mapObject(type: ConfigInfoModel.self)
            .subscribe(onNext: { (data) in
                if data.turnOn {
                    weakSelf?.home.homeStyle = .allShow
                }else {
                    weakSelf?.home.homeStyle = .onlyNews
                }
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: NotificationConfig), object: nil, userInfo: ["showStyle": data.turnOn])
                UserDefaults.standard.set(data.turnOn, forKey: TurnOn)
            }, onError: { (error) in
                guard let err = error as? HXError else { return }
                switch err {
                case .UnexpectedResult: break
                    
                    //self.showHUD(message: msg!)
                default: break
                }
                
                let turnOn = UserDefaults.standard.bool(forKey: TurnOn)
                
                if turnOn  {
                    weakSelf?.home.homeStyle = .allShow
                    NotificationCenter.default.post(name: NSNotification.Name(rawValue: NotificationConfig), object: nil, userInfo: ["showStyle": true])
                }else {
                    weakSelf?.home.homeStyle = .onlyNews
                    NotificationCenter.default.post(name: NSNotification.Name(rawValue: NotificationConfig), object: nil, userInfo: ["showStyle": false])
                }
                
                
            }, onCompleted: nil, onDisposed: nil )
    }
    
    public func creatSubViewControllers(_ turnOn: Bool)
    {
        // 主页
        home = HomeViewController()
        
//        if turnOn {
//            home.homeStyle = .allShow
//        }else {
//            home.homeStyle = .onlyNews
//        }
        
        
        let homeNav = UINavigationController(rootViewController: home)
        homeNav.tabBarItem.imageInsets = UIEdgeInsets(top: 5, left: 0, bottom: -5, right: 0)
        homeNav.title = ""
    
        homeNav.view.backgroundColor = UIColor.white
        
        let homeImage = UIImage(named: "tab_home_nor")?.withRenderingMode(.alwaysOriginal)
        let homeSelectImage = UIImage(named: "tab_home_sel")?.withRenderingMode(.alwaysOriginal)
        
        homeNav.tabBarItem.image = homeImage
        homeNav.tabBarItem.selectedImage = homeSelectImage
        homeNav.tabBarItem.title = ""
        
        
        // 开奖
        let lottery = LotteryViewController()
        
        let lotteryNav = UINavigationController(rootViewController: lottery)
        lotteryNav.tabBarItem.imageInsets = UIEdgeInsets(top: 5, left: 0, bottom: -5, right: 0)
        
        lotteryNav.view.backgroundColor = UIColor.white
        
        let loImg = UIImage(named: "tab_lot_nor")?.withRenderingMode(.alwaysOriginal)
        let loSelImg = UIImage(named: "tab_lot_sel")?.withRenderingMode(.alwaysOriginal)
        
        lotteryNav.tabBarItem.image = loImg
        lotteryNav.tabBarItem.selectedImage = loSelImg
        
        // 发现
        let surprise = SurpriseViewController()
        
        let surpriseNav = UINavigationController(rootViewController: surprise)
        surpriseNav.tabBarItem.imageInsets = UIEdgeInsets(top: 5, left: 0, bottom: -5, right: 0)
        
        surpriseNav.view.backgroundColor = UIColor.white
        
        let surpriseImg = UIImage(named: "tab_lot_nor")?.withRenderingMode(.alwaysOriginal)
        let surpriseSelImg = UIImage(named: "tab_lot_sel")?.withRenderingMode(.alwaysOriginal)
        
        lotteryNav.tabBarItem.image = surpriseImg
        lotteryNav.tabBarItem.selectedImage = surpriseSelImg
        
        // me
        //me : BaseViewController!
        
        let meNav = creatMeVC()
        
        
        self.viewControllers = [homeNav, lotteryNav, surpriseNav, meNav]
        
    }
    
    public func creatMeVC () -> UINavigationController{
//        if getUserData() != nil {
//            //            if turnOn {
//            me = MeViewController()
//            //            }else {
//            //me = NewsMeViewController()
//            //}
//        }else {
//            me = LoginViewController()
//        }
        
        me = MeViewController()
        
        let meNav = UINavigationController(rootViewController: me)
        meNav.tabBarItem.imageInsets = UIEdgeInsets(top: 5, left: 0, bottom: -5, right: 0)
        meNav.view.backgroundColor = UIColor.white
        
        let meImg = UIImage(named: "tab_min_nor")?.withRenderingMode(.alwaysOriginal)
        let meSelImg = UIImage(named: "tab_min_sel")?.withRenderingMode(.alwaysOriginal)
        
        meNav.tabBarItem.image = meImg
        meNav.tabBarItem.selectedImage = meSelImg
        
        return meNav
    }
    
    func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool {
        if viewController == self.viewControllers![2] {
            if getUserData() == nil {
                me = VCodeLoginViewController()
                //me.popRoot = true
                let meNav = UINavigationController(rootViewController: me)
                meNav.tabBarItem.imageInsets = UIEdgeInsets(top: 10, left: 0, bottom: -10, right: 0)
                meNav.view.backgroundColor = UIColor.white
                
                let meImg = UIImage(named: "tab_min_nor")?.withRenderingMode(.alwaysOriginal)
                let meSelImg = UIImage(named: "tab_min_sel")?.withRenderingMode(.alwaysOriginal)
                
                meNav.tabBarItem.image = meImg
                meNav.tabBarItem.selectedImage = meSelImg
                
                self.present(meNav, animated: true, completion: nil)
                return false
            }
        }
        
        
        return true
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
}
