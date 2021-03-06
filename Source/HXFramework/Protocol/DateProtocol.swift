//
//  DateProtocol.swift
//  彩小蜜
//
//  Created by HX on 2018/4/4.
//  Copyright © 2018年 韩笑. All rights reserved.
//

import Foundation

protocol DateProtocol { }

extension DateProtocol {
    func timeStampToHHmm(_ timeStamp : Int) -> String {
        let timeInterval : TimeInterval = TimeInterval(timeStamp)
        
        let date = Date(timeIntervalSince1970: timeInterval)
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH: mm"
        
        return dateFormatter.string(from: date)
    }
    func timeStampToMDHHmm(_ timeStamp : Int?) -> String {
        if timeStamp != nil {
            let timeInterval : TimeInterval = TimeInterval(timeStamp!)
            
            let date = Date(timeIntervalSince1970: timeInterval)
            
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "MM-dd HH: mm"
            
            return dateFormatter.string(from: date)
        }else {
            return ""
        }
        
    }
    func timeStampToYMDHHmm(_ timeStamp : Int?) -> String {
        if timeStamp != nil {
            let timeInterval : TimeInterval = TimeInterval(timeStamp!)
            
            let date = Date(timeIntervalSince1970: timeInterval)
            
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd HH: mm"
            
            return dateFormatter.string(from: date)
        }else {
            return ""
        }
    }
    
    func timeStampToYMDHms(_ timeStamp : Int?) -> String {
        if timeStamp != nil {
            let timeInterval : TimeInterval = TimeInterval(timeStamp!)
            
            let date = Date(timeIntervalSince1970: timeInterval)
            
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
            
            return dateFormatter.string(from: date)
        }else {
            return ""
        }
    }
    
    func timeStampToDate(_ timeStamp : Int?) -> Date {
        let timeInterval : TimeInterval = TimeInterval(timeStamp!)
        let date = Date(timeIntervalSince1970: timeInterval)
        return date
    }
    
    func timeStampToYMD(_ timeStamp : Int?) -> String {
        if timeStamp != nil {
            let timeInterval : TimeInterval = TimeInterval(timeStamp!)
            
            let date = Date(timeIntervalSince1970: timeInterval)
            
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd"
            
            return dateFormatter.string(from: date)
        }else {
            return ""
        }
    }
    
    func getWeek(_ timeStamp : Int, _ format : String = "星期") -> String {
        
        let date = Date(timeIntervalSince1970: TimeInterval(timeStamp))
        
        let weaks = ["\(format)日", "\(format)一","\(format)二","\(format)三","\(format)四","\(format)五","\(format)六"]
        
        let calendar: Calendar = Calendar(identifier: .gregorian)
        var comps: DateComponents = DateComponents()
        comps = calendar.dateComponents([.year,.month,.day, .weekday, .hour, .minute,.second], from: date)
        guard let index = comps.weekday else { return "" }
        
        return weaks[index - 1]
    }
}










