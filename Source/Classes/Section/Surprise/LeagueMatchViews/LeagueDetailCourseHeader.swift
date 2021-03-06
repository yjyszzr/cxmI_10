//
//  LeagueDetailCourseHeader.swift
//  彩小蜜
//
//  Created by 笑 on 2018/9/10.
//  Copyright © 2018年 韩笑. All rights reserved.
//

import UIKit

protocol LeagueDetailCourseHeaderDelegate {
    
    func didTipLeftButton(leftSender : UIButton, rightSender: UIButton) -> Void
    func didTipRightButton(leftSender : UIButton, rightSender: UIButton) -> Void
    func didTipCenterButton(sender : UIButton) -> Void
}

class LeagueDetailCourseHeader: UITableViewHeaderFooterView {

    static let identifier : String = "LeagueDetailCourseHeader"
    
    public var delegate : LeagueDetailCourseHeaderDelegate!
    
    public var titleButton : UIButton!
    
    private var leftButton : UIButton!
    
    private var rightButton : UIButton!
    
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        initSubview()
    }
    
    private func initSubview() {
        titleButton = getButton()
        leftButton = getButton()
        rightButton = getButton()
        
        titleButton.tag = 200
        leftButton.tag = 100
        rightButton.tag = 300
        
        titleButton.setTitle("", for: .normal)

        
        let imageView = UIImageView(image: UIImage(named: "Down"))
        
        titleButton.titleLabel?.addSubview(imageView)
        
        
        leftButton.setImage(UIImage(named: "←"), for: .normal)
        rightButton.setImage(UIImage(named: "→"), for: .normal)
        
        self.contentView.addSubview(titleButton)
        self.contentView.addSubview(leftButton)
        self.contentView.addSubview(rightButton)
        
        titleButton.snp.makeConstraints { (make) in
            make.top.equalTo(0)
            make.width.equalTo(100)
            make.centerX.equalTo(self.contentView.snp.centerX)
            //make.height.equalTo(30)
            make.bottom.equalTo(-10)
        }
        leftButton.snp.makeConstraints { (make) in
            make.right.equalTo(titleButton.snp.left).offset(-10)
            make.width.equalTo(40)
            make.top.height.equalTo(titleButton)
        }
        rightButton.snp.makeConstraints { (make) in
            make.left.equalTo(titleButton.snp.right).offset(10)
            make.width.equalTo(40)
            make.top.height.equalTo(titleButton)
        }
        
        imageView.snp.makeConstraints { (make) in
            make.centerY.equalTo(titleButton.snp.centerY)
            make.right.equalTo((imageView.image?.size.width)!)
            make.width.height.equalTo(10)
        }
        
    }
    
    private func getButton() -> UIButton {
        let but = UIButton(type: .custom)
        but.setTitleColor(Color505050, for: .normal)
        but.titleLabel?.font = Font12
        but.addTarget(self, action: #selector(buttonClick(_:)), for: .touchUpInside)
        return but
    }
    
    @objc private func buttonClick(_ sender : UIButton) {
        guard delegate != nil else { return }
        
        switch sender.tag {
        case 100:
            delegate.didTipLeftButton(leftSender : leftButton, rightSender: rightButton)
        case 200:
            delegate.didTipCenterButton(sender: titleButton)
        case 300:
            delegate.didTipRightButton(leftSender : leftButton, rightSender: rightButton)
        default: break
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
