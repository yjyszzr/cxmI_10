//
//  MessageCenterCell.swift
//  彩小蜜
//
//  Created by HX on 2018/3/26.
//  Copyright © 2018年 韩笑. All rights reserved.
//

import UIKit

class MessageCenterCell: UITableViewCell {

    private var titleLB : UILabel!
    private var moneyLB : UILabel!
    private var timeLB : UILabel!
    private var stateLB: UILabel!
    private var detailLB: UILabel!
    
    private var detailTitle : UILabel!
    private var detailIcon : UIImageView!
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        initSubview()
        
    }
    override func layoutSubviews() {
        super.layoutSubviews()
        titleLB.snp.makeConstraints { (make) in
            make.top.equalTo(self.contentView).offset(12)
            make.left.equalTo(self.contentView).offset(leftSpacing)
            make.width.equalTo(100)
            make.height.equalTo(20)
        }
        moneyLB.snp.makeConstraints { (make) in
            make.top.equalTo(titleLB.snp.bottom).offset(1)
            make.left.height.equalTo(titleLB)
            make.right.equalTo(self.contentView.snp.centerX).offset(-20)
        }
        timeLB.snp.makeConstraints { (make) in
            make.top.equalTo(timeLB)
            make.left.equalTo(timeLB.snp.right).offset(10)
            make.right.equalTo(self.contentView).offset(-rightSpacing)
            make.height.equalTo(timeLB)
        }
        stateLB.snp.makeConstraints { (make) in
            make.top.equalTo(moneyLB)
            make.left.equalTo(self.contentView.snp.centerX).offset(-20)
            make.height.equalTo(moneyLB)
            make.right.equalTo(self.contentView).offset(-rightSpacing)
        }
        detailLB.snp.makeConstraints { (make) in
            make.top.equalTo(moneyLB.snp.bottom)
            make.bottom.equalTo(self.contentView).offset(-12)
            make.left.equalTo(moneyLB)
            make.right.equalTo(detailTitle.snp.left).offset(-10)
        }
        detailTitle.snp.makeConstraints { (make) in
            make.bottom.equalTo(detailLB)
            make.height.equalTo(timeLB)
            make.width.equalTo(100)
            make.right.equalTo(detailIcon.snp.left).offset(1)
        }
        detailIcon.snp.makeConstraints { (make) in
            make.centerY.equalTo(detailTitle.snp.centerY)
            make.right.equalTo(self.contentView).offset(-rightSpacing)
            make.height.width.equalTo(12)
        }
    }
    
    private func initSubview() {
        self.selectionStyle = .none
        
        titleLB = UILabel()
        titleLB.font = Font18
        titleLB.textColor = Color787878
        titleLB.textAlignment = .left
        titleLB.text = "中奖通知"
        
        moneyLB = UILabel()
        moneyLB.font = Font18
        moneyLB.textColor = Color787878
        moneyLB.textAlignment = .left
        moneyLB.text = "中奖3000.00元"
        
        timeLB = UILabel()
        timeLB.font = Font14
        timeLB.textColor = ColorA0A0A0
        timeLB.textAlignment = .left
        timeLB.text = "01月30日 08： 30"
        
        detailLB = UILabel()
        detailLB.font = Font14
        detailLB.textColor = Color787878
        detailLB.textAlignment = .left
        detailLB.numberOfLines = 0
        detailLB.text =
        """
        彩种： 精彩足球
        投注金额： 50.00元
        投注时间： 2018年02月03日
        """
        
        stateLB = UILabel()
        stateLB.font = Font14
        stateLB.textColor = ColorA0A0A0
        stateLB.textAlignment = .left
        stateLB.text = "奖金已打入您的可用余额"
        
        detailTitle = UILabel()
        detailTitle.font = Font14
        detailTitle.textColor = ColorA0A0A0
        detailTitle.textAlignment = .right
        detailTitle.text = "查看详情"
        
        detailIcon = UIImageView()
        detailIcon.image = UIImage(named: "jump")
        
        self.contentView.addSubview(titleLB)
        self.contentView.addSubview(timeLB)
        self.contentView.addSubview(moneyLB)
        self.contentView.addSubview(stateLB)
        self.contentView.addSubview(detailLB)
        self.contentView.addSubview(detailTitle)
        self.contentView.addSubview(detailIcon)
    }
    
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
