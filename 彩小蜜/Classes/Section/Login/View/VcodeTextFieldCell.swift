//
//  VcodeTextFieldCell.swift
//  彩小蜜
//
//  Created by HX on 2018/3/15.
//  Copyright © 2018年 韩笑. All rights reserved.
//

import UIKit

class VcodeTextFieldCell: UITableViewCell {

    
    public var textfield : CustomTextField!
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        initSubview()
        
        
    }
    
    private func initSubview() {
        textfield = CustomTextField(style: .vcode, img: "userID")
        textfield.borderStyle = .none
        
        
        self.contentView.addSubview(textfield)
        
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        textfield.snp.makeConstraints { (make) in
            make.top.equalTo(self.contentView).offset(5)
            make.bottom.equalTo(self.contentView).offset(-5)
            make.left.equalTo(self.contentView).offset(5)
            make.right.equalTo(self.contentView).offset(-5)
        }
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
