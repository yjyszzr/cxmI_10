//
//  WithdrawalProgressVC.swift
//  彩小蜜
//
//  Created by HX on 2018/3/27.
//  Copyright © 2018年 韩笑. All rights reserved.
//

import UIKit

fileprivate let WithdrawalProgressCellId = "WithdrawalProgressCellId"

class CXMWithdrawalProgressVC: BaseViewController, UITableViewDelegate, UITableViewDataSource {
    //MARK: - 点击事件
    //MARK: - 属性
    
    public var withdawalSn : String!
    
    private var header : WithdrawalProgressHeader!
    private var footer : WithdrawalProgressFooter!
    private var progressModel: ProgressModel!
    
    //MARK: - 生命周期
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "提现详情"
        self.view.addSubview(tableView)
        progressRequest()
    }
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        tableView.snp.makeConstraints { (make) in
            make.top.left.right.bottom.equalTo(self.view)
        }
    }
    //MARK: - 网络请求
    private func progressRequest() {
        self.showProgressHUD()
        weak var weakSelf = self
        //withdawalSn = "2018051114558208280020"
        _ = userProvider.rx.request(.withdrawProgressList(withdawSn: withdawalSn))
            .asObservable()
            .mapObject(type: ProgressModel.self)
            .subscribe(onNext: { (data) in
                self.dismissProgressHud()
                weakSelf?.progressModel = data
                weakSelf?.header.progressModel = data
                weakSelf?.footer.progressModel = data
                weakSelf?.tableView.reloadData()
            }, onError: { (error) in
                self.dismissProgressHud()
                guard let err = error as? HXError else { return }
                switch err {
                case .UnexpectedResult(let code, let msg):
                    switch code {
                    case 600:
                        weakSelf?.removeUserData()
                        weakSelf?.pushLoginVC(from: self)
                    default : break
                    }
                    
                    if 300000...310000 ~= code {
                        print(code)
                        self.showHUD(message: msg!)
                    }
                default: break
                }
            }, onCompleted: nil , onDisposed: nil )
    }
    //MARK: -
   
    //MARK: - 懒加载
    lazy private var tableView : UITableView = {
        let table = UITableView(frame: CGRect.zero, style: .grouped)
        table.delegate = self
        table.dataSource = self
        table.separatorStyle = .none
        
        header = WithdrawalProgressHeader()
        footer = WithdrawalProgressFooter()
        
        table.tableHeaderView = header
        table.tableFooterView = footer
        
        table.register(WithdrawalProgressCell.self, forCellReuseIdentifier: WithdrawalProgressCellId)
        return table
    }()
    
    func numberOfSections(in tableView: UITableView) -> Int {
        guard progressModel != nil else { return 0 }
        return progressModel.userWithdrawLogs.count
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: WithdrawalProgressCellId, for: indexPath) as! WithdrawalProgressCell
        
        if indexPath.section == 0 {
            cell.topLine.isHidden = true
        }else {
            cell.topLine.isHidden = false
        }
        if indexPath.section == progressModel.userWithdrawLogs.count - 1 {
            cell.bottomLine.isHidden = true
        }else {
            cell.bottomLine.isHidden = false
        }
        
        cell.progressModel = progressModel.userWithdrawLogs[indexPath.section]
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60 * defaultScale
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0.01
    }
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.01
    }
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return nil
    }
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return nil
    }
    
    
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    

   
   

}
