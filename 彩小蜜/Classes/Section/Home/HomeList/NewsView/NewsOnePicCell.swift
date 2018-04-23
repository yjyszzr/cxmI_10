//
//  NewsOnePicCell.swift
//  彩小蜜
//
//  Created by 笑 on 2018/4/18.
//  Copyright © 2018年 韩笑. All rights reserved.
//

import UIKit

fileprivate let PicWidth : CGFloat = (screenWidth - 12 * 2 - 3 * 2) / 3

class NewsOnePicCell: UITableViewCell {

    // MARK: - 属性 public
    public var newsInfo : NewsInfoModel!{
        didSet{
            guard newsInfo != nil else { return }
            bottomView.newsInfo = newsInfo
            
            titleLb.text = newsInfo.title
            if newsInfo.listStyle == "4" {
                guard newsInfo.articleThumb.count == 1 else { return }
                guard let url = URL(string: newsInfo.articleThumb[0]) else { return }
                icon.kf.setImage(with: url)
                videoIcon.isHidden = false
            }else {
                guard newsInfo.articleThumb.count == 1 else { return }
                guard let url = URL(string: newsInfo.articleThumb[0]) else { return }
                icon.kf.setImage(with: url)
                videoIcon.isHidden = true
            }
        }
    }
    
    // MARK: - 属性 private
    private var titleLb : UILabel!
    private var icon : UIImageView!
    private var bottomView: NewsBottomView!
    private var videoIcon : UIImageView!
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        initSubview()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
    }
    
    private func initSubview() {
        
        self.selectionStyle = .none
        
        icon = UIImageView()
        icon.image = UIImage(named: "Racecolorfootball")
        
        videoIcon = UIImageView()
        videoIcon.image = UIImage(named: "Racecolorfootball")
        
        titleLb = getLabel()
        
        bottomView = NewsBottomView()
        
        self.contentView.addSubview(icon)
        self.contentView.addSubview(titleLb)
        self.contentView.addSubview(bottomView)
        icon.addSubview(videoIcon)
        
        icon.snp.makeConstraints { (make) in
            make.top.equalTo(12 * defaultScale)
            make.right.equalTo(-12 * defaultScale)
            make.bottom.equalTo(-12 * defaultScale)
            make.width.equalTo(PicWidth)
        }
        titleLb.snp.makeConstraints { (make) in
            make.top.equalTo(icon)
            make.left.equalTo(leftSpacing)
            make.right.equalTo(icon.snp.left).offset(-21 * defaultScale)
            make.height.equalTo(30 * defaultScale)
        }
        bottomView.snp.makeConstraints { (make) in
            make.bottom.equalTo(-10 * defaultScale)
            make.left.equalTo(titleLb)
            make.right.equalTo(titleLb)
        }
        videoIcon.snp.makeConstraints { (make) in
            make.top.left.right.bottom.equalTo(0)
        }
        
    }
    
    private func getLabel() -> UILabel {
        let lab = UILabel()
        lab.font = Font15
        lab.textColor = Color505050
        lab.textAlignment = .left
        lab.numberOfLines = 2
        lab.contentMode = .topLeft
        return lab
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
