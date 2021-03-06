//
//  FootballFilterModel.swift
//  彩小蜜
//
//  Created by HX on 2018/4/2.
//  Copyright © 2018年 韩笑. All rights reserved.
//

import Foundation

import HandyJSON

class FilterData: HandyJSON {
    
    required init() { }
}

class FilterModel: NSObject, HandyJSON {
    var isSelected : Bool = false
    var leagueAddr: String!
    var leagueId: String!
    var leagueName: String!
    required override init() { }
}

// 记录串关，
class FootballPlayFilterModel: NSObject, NSCopying {
    func copy(with zone: NSZone? = nil) -> Any {
        let model = FootballPlayFilterModel()
        
        model.isSelected = self.isSelected
     
        return model
    }
    
    var isSelected : Bool = false
    var playTitle: String = ""
    var title : String!
    /// 传给服务端用到的 11，21，31，41，51，61，71，81 串关
    var titleNum: String!
}
