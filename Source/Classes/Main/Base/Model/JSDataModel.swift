//
//  JSDataModel.swift
//  彩小蜜
//
//  Created by 笑 on 2018/5/8.
//  Copyright © 2018年 韩笑. All rights reserved.
//

import Foundation
import HandyJSON

struct JSDataModel : HandyJSON {
    var token : String = UserInfoManager().getToken()
    var channel : String = Channel
}
