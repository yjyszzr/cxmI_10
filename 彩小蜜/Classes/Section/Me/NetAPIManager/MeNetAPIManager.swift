//
//  MeNetAPIManager.swift
//  彩小蜜
//
//  Created by HX on 2018/3/12.
//  Copyright © 2018年 韩笑. All rights reserved.
//

import Moya
import RxSwift

let userProvider = MoyaProvider<MeNetAPIManager>(plugins:[RequestLoadingPlugin()])

enum MeNetAPIManager {
    /// 用户信息
    case userInfo
    /// 实名认证
    case realNameAuth (idcode: String, realName: String)
    /// 实名认证信息
    case realInfo
    /// 添加银行卡
    case addBankCard (bankCardNo : String)
    /// 查询银行卡信息
    case bankList
    /// 提现界面的数据显示
    case withDrawDataShow
    /// 设置当前银行卡为默认卡
    case setBankDefault (cardId : String)
    /// 删除银行卡
    case deleteBank (status: String, cardId: String)
    /// 优惠券列表  红包状态:空字符串-全部 0-未使用 1-已使用 2-已过期
    case couponList (status: String, pageNum: Int)
    /// 单个优惠券
    case coupon (userBonusId: String)
    /// 订单列表 -1 -所有订单 2-待开奖 4-已中奖
    case orderInfoList (fyId: String, orderStatus: String, pageNum: Int)
    /// 订单详情
    case orderInfo (orderId: String)
    /// 出票方案
    case orderScheme (programmeSn: String)
    /// 账户明细列表
    case accountDetailsList (amountType: String, pageNum: Int)
    /// 统计账户信息
    case accountStatistics
    /// 消息列表 0通知，1消息 
    case messageList (msgType: String, pageNum: Int)
}

extension MeNetAPIManager : TargetType {
    var baseURL : URL {
        return URL(string : baseURLStr)!
    }
    
    var headers: [String : String]? {
        return ["Content-Type" : "application/json",
                "token" : UserInfoManager().getToken()
            //"token" : "eyJhbGciOiJSUzI1NiJ9.eyJzdWIiOiIxZDg4OTYxZDUtYjI0Yi00NzAxLWJhZWMtNzBkZmUxY2MwMDAzIiwidXNlcklkIjoiNDAwMDY4In0.1aBwA_Rasiew0kiLK8uR3AiUGj1iJ6ZZ8Hvup5v8tNUVMpQWWHVQBSrUBGCxZ28Lmsk0I-cQGQkOcAdoJKJQE1GGjDqSfAWGD951Kyq187C_axWKNazkRK1b-RIuuXV4ZSSSYhn0o45KsLCUh1YO76Q19oFnuVCbrF8DTvXTbSY"
        ]
    }
    
    var path : String {
        switch self {
        case .userInfo:
            return "/user/userInfoExceptPass"
        case .realNameAuth:
            return "/user/real/realNameAuth"
        case .realInfo:
            return "/user/real/userRealInfo"
        case .addBankCard:
            return "/user/bank/addBankCard"
        case .bankList:
            return "/user/bank/queryUserBankList"
        case .withDrawDataShow:
            return "/user/bank/queryWithDrawShow"
        case .setBankDefault:
            return "/user/bank/updateUserBankDefault"
        case .deleteBank:
            return "/user/bank/deleteUserBank"
        case .couponList:
            return "/user/bonus/queryBonusListByStatus"
        case .coupon:
            return "/user/bonus/queryUserBonus"
        case .orderInfoList:
            return "/order/getOrderInfoList"
        case .orderInfo:
            return "/order/getOrderDetail"
        case .orderScheme:
            return "/order/getTicketScheme"
        case .accountDetailsList:
            return "/user/account/getUserAccountList"
        case .messageList:
            return "/user/message/list"
        case .accountStatistics:
            return "/user/account/countMoneyCurrentMonth"
            
            
            
        }
    }
    
    var task: Task {
        var dic : [String: Any] = [:]
        
        switch self {
        case .realNameAuth(let idcode, let realName):
            dic["idcode"] = idcode
            dic["realName"] = realName
        case .addBankCard(let bankCardNo):
            dic["bankCardNo"] = bankCardNo.replacingOccurrences(of: " ", with: "")
            
        case .userInfo:
            dic["str"] = "d14fs54df4sf韩笑孟宪征"
        case .realInfo:
            dic["str"] = "d14fs54df4sf韩笑孟宪征"
        case .bankList:
            dic["str"] = "d14fs54df4sf韩笑孟宪征"
        case .withDrawDataShow:
            dic["str"] = "d14fs54df4sf韩笑孟宪征"
        case .setBankDefault ( let cardId ):
            dic["id"] = cardId
        case .deleteBank (let status, let cardId):
            dic["id"] = cardId
            dic["status"] = status
        case .couponList(let status, let pageNum):
            dic["status"] = status
            dic["pageNum"] = pageNum
            dic["pageSize"] = "20"
        case .coupon(let userBonusId):
            dic["userBonusId"] = userBonusId
        case .orderInfoList(let fyId, let orderStatus, let pageNum):
            dic["lotteryClassifyId"] = fyId
            dic["orderStatus"] = orderStatus
            dic["pageNum"] = pageNum
        case .orderInfo(let orderId):
            dic["orderId"] = orderId
        case .orderScheme(let programmeSn):
            dic["programmeSn"] = programmeSn
        case .accountDetailsList(let amountType, let pageNum):
            dic["amountType"] = amountType
            dic["pageNum"] = pageNum
            dic["pageSize"] = "20"
        case .accountStatistics:
            dic["str"] = "ss"
        case .messageList(let msgType, let pageNum):
            dic["msgType"] = msgType
            dic["pageNum"] = pageNum
            dic["pageSize"] = "20"
            
            
            
        default:
            return .requestPlain
        }
        
        let jsonStr = try? JSONSerialization.data(withJSONObject: dic, options: .prettyPrinted)
    
        
        return .requestData(jsonStr!)
    }
    
    var method : Moya.Method {
        switch self {
        default:
            return .post
        }
    }
    
    var parameterEncoding: ParameterEncoding {
        switch self {
        default:
            return URLEncoding.default
        }
    }
    
    var sampleData: Data {
        return "{}".data(using: String.Encoding.utf8)!
    }
}
