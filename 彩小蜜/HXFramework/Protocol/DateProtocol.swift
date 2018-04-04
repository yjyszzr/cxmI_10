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
}
