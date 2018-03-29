//
//  LoginNetAPIManager.swift
//  彩小蜜
//
//  Created by HX on 2018/3/12.
//  Copyright © 2018年 韩笑. All rights reserved.
//

import Moya
import RxSwift

let loginProvider = MoyaProvider<LoginNetAPIManager>(plugins:[RequestLoadingPlugin()])

enum LoginNetAPIManager {
    case loginByPass (mobile: String, password: String)
    case loginBySms (mobile: String, smsCode: String)
    case logout
    case register (mobile: String, password: String, vcode: String)
    case resetPass
    case validateMobile (mobile: String)
    case updatePass (mobile: String, password: String)
    /// smsType: 短信类型:0-短信登录验证码 1-注册验证码 2-忘记密码验证码
    case sendSms (mobile: String, smsType: String)

}

extension LoginNetAPIManager: TargetType {
    var baseURL : URL {
        return URL(string: baseURLStr + xpath)!
    }
    
    var headers: [String : String]? {
        return ["Content-Type" : "application/json"]
    }
    
    var path : String {
        return ""
    }
    
    var xpath : String {
        
        switch self {
       
        case .loginByPass:
            return "7071/login/loginByPass"
        case .loginBySms:
            return "7071/login/loginBySms"
        case .logout:
            return "7071/login/logout"
        case .register:
            return "7071/user/register"
        case .resetPass:
            return ""
        case .validateMobile:
            return "7071/user/validateMobile"
        case .updatePass:
            return "7071/user/updateLoginPass"
        case .sendSms:
            return "7071/sms/sendSmsCode"
            
            
            
        }
        
    }
    
    var method : Moya.Method {
        switch self {
        default:
            return .post
        }
    }

    var task: Task {
        
        var dic : [String: Any] = [:]
        
        
        switch self {
        case .register(let mobile ,let password, let vcode):
            dic["mobile"]   = mobile
            dic["password"] = password
            dic["smsCode"]  = vcode
            dic["loginSource"] = "2"
        case .loginByPass(let mobile, let password):
            dic["mobile"]   = mobile
            dic["password"] = password
            dic["loginSource"] = "2"
        case .loginBySms(let mobile, let smsCode):
            dic["mobile"]   = mobile
            dic["smsCode"]  = smsCode
            dic["loginSource"] = "2"
        case .validateMobile(let mobile ):
            dic["mobileNumber"] = mobile
        case .updatePass(let mobile, let password):
            dic["mobileNumber"] = mobile
            dic["userLoginPass"] = password
        case .sendSms(let mobile, let smsType):
            dic["mobile"] = mobile
            dic["smsType"] = smsType
        default:
            return .requestPlain
        }
        
        let jsonStr = try? JSONSerialization.data(withJSONObject: dic, options: .prettyPrinted)
        return .requestData(jsonStr!)
    }
    
    var parameterEncoding: ParameterEncoding {
        switch self {
        case .register :
            return URLEncoding.default
        default:
            return URLEncoding.default
        }
    }
    
    var sampleData: Data {
        return "{}".data(using: String.Encoding.utf8)!
    }
}
