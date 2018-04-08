//
//  FootballRequestModel.swift
//  彩小蜜
//
//  Created by HX on 2018/4/8.
//  Copyright © 2018年 韩笑. All rights reserved.
//

import Foundation
import HandyJSON

struct FootballRequestMode : HandyJSON {
    /// 该场次的玩法  几串几
    var betType: String!
    /// 彩票种类
    var lotteryClassifyId: String!
    /// 彩票玩法类别，
    var lotteryPlayClassifyId: String!
    var matchBetCells: [FootballMatchBetCellReq]!
    /// 玩法 胜平负，让球胜平负 等
    var playType: String!
    /// 倍数
    var times: String!
}

struct FootballMatchBetCellReq {
    var betCells: [FootballPlayCellModel]!
    var changci: String!
    var isDan: Bool!
    var lotteryClassifyId: String!
    var lotteryPlayClassifyId: String!
    var matchId: String!
    /// 投注场次队名,如：中国VS日本 ,
    var matchTeam: String!
    /// 比赛时间
    var matchTime: Int!
    /// 投注赛事编码 ,
    var playCode: String!
    /// 玩法 胜平负，让球胜平负 等
    var playType: String!
}

