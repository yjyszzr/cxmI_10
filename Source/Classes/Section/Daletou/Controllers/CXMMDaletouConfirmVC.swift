//
//  DaletouConfirmViewController.swift
//  彩小蜜
//
//  Created by 笑 on 2018/8/2.
//  Copyright © 2018年 韩笑. All rights reserved.
//

import UIKit
import RxSwift

class CXMMDaletouConfirmVC: BaseViewController {

    public var list = [DaletouDataList]() {
        didSet{
            self.dataList.removeAll()
            bettingNum.onNext(0)
            var num = 0
            for model in list {
                switch model.type {
                case .标准选号:
                    var arr = model.redList
                    arr.append(contentsOf: model.blueList)
                    
                    dataList.append(arr)
                case .胆拖选号:
                    var arr = model.danRedList
                    
                    let model1 = DaletouDataModel()
                    model1.num = "-"
                    model1.style = .red
                    arr.append(model1)
                    
                    arr.append(contentsOf: model.dragRedList)
                    if model.danBlueList.count > 0 {
                        arr.append(model1)
                    }
                    arr.append(contentsOf: model.danBlueList)
                    arr.append(model1)
                    arr.append(contentsOf: model.dragBlueList)
                }
                
                num += model.bettingNum
            }
            let value = try! bettingNum.value()
            bettingNum.onNext( value + num)
        }
        
    }
    
    public var dataList : [[DaletouDataModel]] = [[DaletouDataModel]]()
    
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var bottomView: DaletouConfirmBottom!
    
    //private var money = 2
    
    private var bettingNum = BehaviorSubject(value: 0)
    private var multiple = BehaviorSubject(value: 1)
    private var money = BehaviorSubject(value: 2)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "彩小秘 · 投注确认"
        self.bottomView.delegate = self
        self.tableView.reloadData()
        
        settingData()
        
    }

    @IBAction func addDaletou(_ sender: UIButton) {
        pushDaletouBetting(indexPath: nil)
    }
    @IBAction func machineOne(_ sender: UIButton) {
    }
    @IBAction func machineFive(_ sender: UIButton) {
    }
    
    private func settingData() {
        _ = Observable.combineLatest(bettingNum, multiple, money)
            .asObservable()
            .subscribe(onNext: { (num, multiple, money) in
                
                
                let att = NSMutableAttributedString(string: "\(num)注\(multiple)倍 共需: ")
                
                let money = NSAttributedString(string: "¥\(num * money * multiple)",
                    attributes: [NSAttributedStringKey.foregroundColor: ColorE85504])
                att.append(money)
                self.bottomView.moneyLabel.attributedText = att
                self.bottomView.multipleBut.setTitle("\(multiple)", for: .normal)
            }, onError: nil , onCompleted: nil , onDisposed: nil )
    }

}

// MARK: - 底部 视图  代理
extension CXMMDaletouConfirmVC : DaletouConfirmBottomDelegate, FootballTimesFilterVCDelegate {
    
    
    func didTipAppend(isAppend : Bool) {
        switch isAppend {
        case true:
            for model in list {
                model.money = 3
            }
            self.money.onNext(3)
        case false :
            for model in list {
                model.money = 2
            }
            self.money.onNext(2)
        }
    }
    // MARK: - 选取倍数
    func didTipMultiple() {
        let filter = CXMFootballTimesFilterVC()
        filter.delegate = self
        filter.times = "\(try! self.multiple.value())"
        self.present(filter)
    }
    
    func didTipConfirm() {
        
    }
    
    func timesConfirm(times: String) {
        self.multiple.onNext(Int(times)!)
    }
    
}

// MARK: - 选择大乐透
extension CXMMDaletouConfirmVC : CXMMDaletouViewControllerDelegate {
    func didSelected(list: DaletouDataList) {
        self.list.append(list)
        self.tableView.reloadData()
    }
    
    private func pushDaletouBetting(indexPath: IndexPath?) {
        let story = UIStoryboard(name: "Daletou", bundle: nil)
        let vc = story.instantiateViewController(withIdentifier: "DaletouViewController") as! CXMMDaletouViewController
        vc.delegate = self
        vc.isPush = true
        if let index = indexPath {
            vc.model = self.list[index.row]
            self.list.remove(at: index.row)
            self.dataList.remove(at: index.row)
        }
        pushViewController(vc: vc)
    }
}

extension CXMMDaletouConfirmVC : UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        pushDaletouBetting(indexPath: indexPath)
    }
}
extension CXMMDaletouConfirmVC : UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return list.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "DaletouConfirmCell", for: indexPath) as! DaletouConfirmCell
        cell.configure(with: list[indexPath.row])
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    
        let model = self.list[indexPath.row]
        
        var listCount = 0
        
        switch model.type {
        case .标准选号:
            listCount = model.redList.count + model.blueList.count
        case .胆拖选号:
            listCount = model.danRedList.count + 1 + model.dragRedList.count
            if model.danBlueList.count != 0 {
                listCount += 1
            }
            listCount += model.danBlueList.count
            listCount += model.dragBlueList.count
        }
        
        let count : Int = listCount / 12
        
        if count == 0 {
            return 90
        }else {
            let num : Int = listCount % 12
            if num == 0 {
                return CGFloat(70 + 21 * count)
            }else {
                return CGFloat(70 + 21 * (count + 1))
            }
        }
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        switch section {
        case 0:
            return 5
        default:
            return 3
        }
    }
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 5
    }
}
