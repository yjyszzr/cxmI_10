//
//  BaseViewController.swift
//  彩小蜜
//
//  Created by HX on 2018/3/5.
//  Copyright © 2018年 韩笑. All rights reserved.
//

import UIKit
import SnapKit

import DZNEmptyDataSet

public var currentVC : UIViewController?

class BaseViewController: UIViewController, AlertPro, DZNEmptyDataSetSource, DZNEmptyDataSetDelegate, DateProtocol{

    // public
    public func pushLoginVC(from vc: UIViewController) {
        let login = LoginViewController()
        currentVC = vc
        self.navigationController?.pushViewController(login, animated: true)
    }
    public func popToCurrentVC() {
        for vc in (self.navigationController?.viewControllers)! {
            if currentVC != nil, vc == currentVC {
                self.navigationController?.popToViewController(vc, animated: true)
            }
        }
    }
    
    public func pushPagerView(pagerType: PagerViewType) {
        let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
        let vc = storyboard.instantiateViewController(withIdentifier: "BasePagerViewController") as! BasePagerViewController
        vc.pagerType = pagerType
        pushViewController(vc: vc)
    }
    
    public func pushViewController(vc: UIViewController) {
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    public func pushRootViewController() {
        pushRootViewController(0)
    }
    public func pushRootViewController(_ index: Int) {
        guard let window = UIApplication.shared.keyWindow else { return }
        let root = MainTabBarController()
        root.selectedIndex = index
        window.rootViewController = root
    }
    
    public func popViewController() {
        self.navigationController?.popViewController(animated: true)
    }
    public func popToLoginViewController() {
        for vc in (self.navigationController?.viewControllers)! {
            if vc .isKind(of: LoginViewController.self) {
                self.navigationController?.popToViewController(vc, animated: true)
            }
        }
    }
    
    public func present(_ vc: UIViewController) {
        self.present(vc, animated: true, completion: nil)
    }
    
    public func hideBackBut() {
        self.navigationItem.leftBarButtonItem = nil
    }
    public func hideNavigationBar() {
        self.navigationController?.navigationBar.isHidden = true
    }
    public func setEmpty(title: String, _ tableView: UITableView) {
        tableView.emptyDataSetDelegate = self
        tableView.emptyDataSetSource = self
        self.emptyTitle = title
    }
    
    //MARK: - 属性
    public var isHidenBar : Bool! {
        didSet{
            if isHidenBar == true {
                hideTabBar()
            }else {
                showTabBar()
            }
        }
    }
    
    private var emptyTitle: String!
    
    //MARK: - 生命周期
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = ColorF4F4F4
        setNavigation()
        self.isHidenBar = true
    }

    private func setNavigation() {
        self.navigationController?.navigationBar.isHidden = false
        setLiftButtonItem()
        
    }
    //MARK: - 空列表视图
    func image(forEmptyDataSet scrollView: UIScrollView!) -> UIImage! {
        return UIImage(named: "empty")
    }
    func title(forEmptyDataSet scrollView: UIScrollView!) -> NSAttributedString! {
        let att = NSAttributedString(string: emptyTitle, attributes: [NSAttributedStringKey.foregroundColor: ColorA0A0A0, NSAttributedStringKey.font: Font15])
        return att
    }
    func backgroundColor(forEmptyDataSet scrollView: UIScrollView!) -> UIColor! {
        return ColorF4F4F4
    }
    func verticalOffset(forEmptyDataSet scrollView: UIScrollView!) -> CGFloat {
        return -80
    }
    
    private func showTabBar() {
        self.tabBarController?.tabBar.isHidden = false
    }
    private func hideTabBar() {
        self.tabBarController?.tabBar.isHidden = true
    }
    
    private func setLiftButtonItem() {
        
        let leftBut = UIButton(type: .custom)
        leftBut.frame = CGRect(x: 0, y: 0, width: 16, height: 16)
        
        leftBut.setBackgroundImage(UIImage(named:"ret"), for: .normal)
        
        leftBut.addTarget(self, action: #selector(back(_:)), for: .touchUpInside)
        
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(customView: leftBut)
    }
    
    @objc func back(_ sender: UIButton) {
        popViewController()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    

}
