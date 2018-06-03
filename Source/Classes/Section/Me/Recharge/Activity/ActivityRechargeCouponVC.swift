//
//  ActivityRechargeCouponVC.swift
//  彩小蜜
//
//  Created by 笑 on 2018/6/3.
//  Copyright © 2018年 韩笑. All rights reserved.
//

import UIKit

class ActivityRechargeCouponVC: BasePopViewController {

    private var couponView : UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.popStyle = .fromCenter
        initSubview()
    }

    private func initSubview() {
        self.viewHeight = 280
        
        couponView = UIButton(type: .custom)
        couponView.setBackgroundImage(UIImage(named: "activityBonus"), for: .normal)
        
        self.pushBgView.backgroundColor = UIColor.clear
        self.pushBgView.addSubview(couponView)
        
        couponView.snp.makeConstraints { (make) in
            make.center.equalTo(self.pushBgView.snp.center)
            make.height.width.equalTo(280)
        }
        
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
