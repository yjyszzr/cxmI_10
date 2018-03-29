//
//  AccountDetailsVC.swift
//  彩小蜜
//
//  Created by HX on 2018/3/26.
//  Copyright © 2018年 韩笑. All rights reserved.
//

import UIKit
import XLPagerTabStrip

enum AccountDetailsType: String {
    case all = "全部"
    case bonus = "奖金"
    case recharge = "充值"
    case buy = "购彩"
    case withdrawal = "提现"
    case coupon = "红包"
}

fileprivate let AccountDetailsCellId = "AccountDetailsCellId"
fileprivate let AccountDetailSectionHeaderId = "AccountDetailSectionHeaderId"

class AccountDetailsVC: BaseViewController, IndicatorInfoProvider, UITableViewDelegate, UITableViewDataSource {

    public var accountType : AccountDetailsType = .all
    
    private var pageDataModel: BasePageModel<AccountDetailModel>!
    private var accountList: [AccountDetailModel]!
    private var statisticsModel : AccountStatisticsModel!
    
    private var footer : AccountDetailFooterView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.isHidenBar = true
        accountList = []
        self.view.addSubview(tableView)
        setEmpty(title: "暂无记录！", tableView)
        self.tableView.headerRefresh {
            self.loadNewData()
        }
        self.tableView.footerRefresh {
            self.loadNextData()
        }
        
        accountListRequest(1)
        statisticsRequest()
    }
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        tableView.snp.makeConstraints { (make) in
            make.top.left.right.bottom.equalTo(self.view)
        }
    }
    
    private func loadNewData() {
        accountListRequest(1)
    }
    private func loadNextData() {
        guard self.pageDataModel.isLastPage == false else {
            self.tableView.noMoreData()
            return }
        
        accountListRequest(self.pageDataModel.nextPage)
    }
    
    //MARK: - 网络请求
    private func accountListRequest(_ pageNum: Int) {
        var type: String!
        // 0-全部 1-奖金 2-充值 3-购彩 4-提现 5-红包
        switch accountType {
        case .all:
            type = "0"
        case .bonus:
            type = "1"
        case .recharge:
            type = "2"
        case .buy:
            type = "3"
        case .withdrawal:
            type = "4"
        case .coupon:
            type = "5"
        }
        
        weak var weakSelf = self
        _ = userProvider.rx.request(.accountDetailsList(amountType: type, pageNum: pageNum))
            .asObservable()
            .mapObject(type: BasePageModel<AccountDetailModel>.self)
            .subscribe(onNext: { (data) in
                weakSelf?.tableView.endrefresh()
                weakSelf?.pageDataModel = data
                if pageNum == 1 {
                    weakSelf?.accountList.removeAll()
                }
                weakSelf?.accountList.append(contentsOf: data.list)
                weakSelf?.tableView.reloadData()
                if weakSelf?.accountList.count == 0 {
                    weakSelf?.tableView.tableFooterView?.isHidden = true
                }
                
                let xxx = AccountListModel.getAccountList(data.list)
                print(xxx)
            }, onError: { (error) in
                if weakSelf?.accountList.count == 0 {
                    weakSelf?.tableView.tableFooterView?.isHidden = true
                }
                weakSelf?.tableView.endrefresh()
                guard let err = error as? HXError else { return }
                switch err {
                case .UnexpectedResult(let code, let msg):
                    print(code!)
                    self.showHUD(message: msg!)
                default: break
                }
            }, onCompleted: nil , onDisposed: nil )
    }
    
    private func statisticsRequest() {
        weak var weakSelf = self
        _ = userProvider.rx.request(.accountStatistics)
            .asObservable()
            .mapObject(type: AccountStatisticsModel.self)
            .subscribe(onNext: { (data) in
                //weakSelf?.statisticsModel = data
                weakSelf?.footer.dataModel = data
            }, onError: { (error) in
                guard let err = error as? HXError else { return }
                switch err {
                case .UnexpectedResult(let code, let msg):
                    print(code!)
                    self.showHUD(message: msg!)
                default: break
                }
            }, onCompleted: nil , onDisposed: nil )
    }
    
    func indicatorInfo(for pagerTabStripController: PagerTabStripViewController) -> IndicatorInfo {
        return IndicatorInfo(title: accountType.rawValue)
    }
    //MARK: - 懒加载
    lazy private var tableView : UITableView = {
        let table = UITableView(frame: CGRect.zero, style: .grouped)
        table.delegate = self
        table.dataSource = self
        table.separatorStyle = .none
        footer = AccountDetailFooterView()
        
        table.estimatedRowHeight = 80 * defaultScale
        
        table.tableFooterView = footer
        
        table.register(AccountDetailsCell.self, forCellReuseIdentifier: AccountDetailsCellId)
        table.register(AccountDetailSectionHeader.self, forHeaderFooterViewReuseIdentifier: AccountDetailSectionHeaderId)
        return table
    }()
    
    //MARK: - TABLEVIEW  DELEGATE
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let account = accountList[indexPath.section]
        
        // 提现可进入详情
        guard account.processType == "4" else { return }
       
        let progress = WithdrawalProgressVC()
        progress.withdawalSn = account.accountSn
        pushViewController(vc: progress)
    }
    
    //MARK: - TABLEVIEW  DATASOURCE
    func numberOfSections(in tableView: UITableView) -> Int {
        guard pageDataModel != nil else { return 0 }
        return accountList.count
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: AccountDetailsCellId, for: indexPath) as! AccountDetailsCell
        
        cell.accountDetail = accountList[indexPath.section]
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section > 0 {
            let acc = accountList[section]
            let axx = accountList[section - 1]

            if acc.addTime == axx.addTime {
                return 0.01
            }else {
                return orderSectionHeaderHeight
            }
        }
        return orderSectionHeaderHeight
    }
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.01
    }
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        let header = tableView.dequeueReusableHeaderFooterView(withIdentifier: AccountDetailSectionHeaderId)as! AccountDetailSectionHeader
        
        header.accountDetail = accountList[section]
        
        
        if let cell = tableView.cellForRow(at: IndexPath(row: 0, section: section)) as? AccountDetailsCell {
            if section == 0 {
                cell.line.isHidden = true
            }else {
                cell.line.isHidden = false
            }
        }
        
        if section > 0 {
            let acc = accountList[section]
            let axx = accountList[section - 1]
            
            if acc.addTime == axx.addTime {
                
                return nil
            }else {
                if let cell = tableView.cellForRow(at: IndexPath(row: 0, section: section)) as? AccountDetailsCell {
                    cell.line.isHidden = true
                }
                
                return header
            }
        }
        return header
    }
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return nil
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    

}
