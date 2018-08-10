//
//  CXMMDLTHistoryTrendVC.swift
//  彩小蜜
//
//  Created by 笑 on 2018/8/8.
//  Copyright © 2018年 韩笑. All rights reserved.
//

import UIKit
import XLPagerTabStrip

class CXMMDLTHistoryTrendVC: BaseViewController, IndicatorInfoProvider {

    public var compute: Bool! = false
    public var count: String! = "100"
    public var drop: Bool! = true
    public var sort: Bool! = true
    
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var bottomView: UIView!
    
    private var numList : [DLTLottoNumInfo]!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addPanGestureRecognizer = false
        setSubview()
        loadNewData()
    }
    func indicatorInfo(for pagerTabStripController: PagerTabStripViewController) -> IndicatorInfo {
        return "开奖号码"
    }
}

// MARK: - 网络请求
extension CXMMDLTHistoryTrendVC {
    private func loadNewData() {
        chartDataRequest()
    }
    private func chartDataRequest() {
        
        weak var weakSelf = self
        
        _ = dltProvider.rx.request(.chartData(compute: compute, count: count, drop: drop, sort: sort, tab : "1"))
            .asObservable()
            .mapObject(type: DLTTrendModel.self)
            .subscribe(onNext: { (data) in
                weakSelf?.numList = data.lottoNums
                weakSelf?.tableView.reloadData()
            }, onError: { (error) in
                guard let err = error as? HXError else { return }
                switch err {
                case .UnexpectedResult(let code, let msg):
                    switch code {
                    case 600:
                        break
                    default : break
                    }
                    if 300000...310000 ~= code {
                        self.showHUD(message: msg!)
                    }
                    print(code)
                default: break
                }
            }, onCompleted: nil , onDisposed: nil )
    }
}

extension CXMMDLTHistoryTrendVC {
    private func setSubview() {
        self.tableView.separatorStyle = .none
        
    }
}
extension CXMMDLTHistoryTrendVC : UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
}
extension CXMMDLTHistoryTrendVC : UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return numList != nil ? numList.count : 0
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "DLTHistoryTrendCell", for: indexPath) as! DLTHistoryTrendCell
        cell.configure(with: self.numList[indexPath.row] )
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 40 * defaultScale
    }
}
