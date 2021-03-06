//
//  PaymentMethodCell.swift
//  彩小蜜
//
//  Created by 笑 on 2018/4/9.
//  Copyright © 2018年 韩笑. All rights reserved.
//

import UIKit

class PaymentMethodCell: UITableViewCell {

    public var paymentInfo : PaymentList! {
        didSet{
            guard paymentInfo != nil else { return }
            title.text = paymentInfo.payName
            if let url = URL(string: paymentInfo.payImg) {
                icon.kf.setImage(with: url)
            }
        }
    }
    
    public var title : UILabel!
    public var selectedIcon : UIImageView!
    public var icon : UIImageView!
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        initSubview()
    }
    
    
    override func layoutSubviews() {
        super.layoutSubviews()
        icon.snp.makeConstraints { (make) in
            make.width.height.equalTo(28 * defaultScale)
            make.left.equalTo(leftSpacing)
            make.centerY.equalTo(self.contentView.snp.centerY)
        }
        title.snp.makeConstraints { (make) in
            make.top.bottom.equalTo(0)
            make.left.equalTo(icon.snp.right).offset(15 * defaultScale)
            make.right.equalTo(selectedIcon.snp.left).offset(-1)
        }
        
        selectedIcon.snp.makeConstraints { (make) in
            make.centerY.equalTo(self.contentView.snp.centerY)
            make.right.equalTo(-rightSpacing)
            make.width.height.equalTo(24 * defaultScale)
        }
    }
    private func initSubview() {
        self.selectionStyle = .none
        
        icon = UIImageView()
        icon.image = UIImage(named: "WeChatrecharge")
        
        title = UILabel()
        title.font = Font14
        title.textColor = Color787878
        title.textAlignment = .left
        
        selectedIcon = UIImageView()
        selectedIcon.image = UIImage(named: "chargesure")
        
        self.contentView.addSubview(icon)
        self.contentView.addSubview(title)
        self.contentView.addSubview(selectedIcon)
    }
    
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        if selected {
            selectedIcon.image = UIImage(named: "chargesure")
        }else {
            selectedIcon.image = UIImage(named: "butongyi")
        }
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
