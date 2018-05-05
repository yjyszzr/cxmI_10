//
//  RegisterViewController.swift
//  彩小蜜
//
//  Created by HX on 2018/3/8.
//  Copyright © 2018年 韩笑. All rights reserved.
//

import UIKit

fileprivate let mobileCellIdentifier = "mobileCellIdentifier"
fileprivate let passwordCellIdentifier = "passwordCellIdentifier"
fileprivate let vcodeCellIdentifier = "vcodeCellIdentifier"

class RegisterViewController: BaseViewController, UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate, ValidatePro, CustomTextFieldDelegate, RegisterFooterViewDelegate {
    
    
    func didTipSelectedAgreement(isAgerr: Bool) {
        self.canRegister = isAgerr
    }
    // 跳转注册协议
    func didTipAgreement() {
        let regis = WebViewController()
        regis.urlStr = webRegisterAgreement
        pushViewController(vc: regis)
    }
    

    // MARK: - 点击事件
    @objc private func registerClicked(_ sender: UIButton) {
        guard canRegister else {
            showHUD(message: "请同意注册协议")
            return
        }
        guard validate(.phone, str: self.phoneTF.text) else {
            showHUD(message: "请输入正确的手机号")
            return
        }
        guard validate(.password, str: self.passwordTF.text) else{
            showHUD(message: "密码格式错误，请重新输入")
            return
        }
        guard self.vcodeTF.text != nil else {
            showHUD(message: "请输入验证码")
            return
        }
        
        registerRequest()
    }
    
    func countdown(button:CountdownButton) {
        guard validate(.phone, str: self.phoneTF.text) else {
            showHUD(message: "请输入合法的手机号")
            return
        }
        button.isCounting = true
        sendSmsRequest(button)
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        if let textf = textField as? CustomTextField {
            textf.changeImg(string)
        }
        
        return true
    }
    
    
    
    // MARK: - 属性
    private var phoneTF : CustomTextField!     // 输入手机号
    private var passwordTF : CustomTextField!  // 输入密码
    private var vcodeTF : UITextField!         // 输入验证码
    private var canRegister: Bool = true
    
    
    // MARK: - 生命周期
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "彩小秘 · 注册"
        self.view.addSubview(tableView)
    }
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        tableView.snp.makeConstraints { (make) in
            make.top.left.right.bottom.equalTo(self.view)
        }
    }
    
    // MARK: 网络请求
    private func registerRequest() {
        self.showProgressHUD()
        _ = loginProvider.rx.request(.register(mobile: self.phoneTF.text!, password: self.passwordTF.text!, vcode: vcodeTF.text!))
        .asObservable()
        .mapObject(type: UserDataModel.self)
        .subscribe { (event) in
            self.dismissProgressHud()
            switch event {
            case .next(let data):
                self.showHUD(message: data.showMsg)
                
                if self.getUserData() == nil {
                    self.save(userInfo: data)
                    self.pushRootViewController()
                }else {
                    self.save(userInfo: data)
                    self.popToCurrentVC()
                }
            case .error(let error):
                guard let hxError = error as? HXError else { return }
                switch hxError {
                case .UnexpectedResult(_, let resultMsg):
                    self.showConfirm(message: resultMsg!, confirm: { (action) in
                        self.popViewController()
                    })
                default : break
                }
            case .completed:
                break
            }
        }
    }
    
    private func sendSmsRequest(_ button : CountdownButton) {
        self.showProgressHUD()
        _ = loginProvider.rx.request(.sendSms(mobile: self.phoneTF.text!, smsType: "1"))
            .asObservable()
            .mapBaseObject(type: DataModel.self)
            .subscribe { (event) in
                self.dismissProgressHud()
                switch event {
                case .next(let data):
                    switch data.code {
                    case "301010" :
                        self.showConfirm(message: data.msg, confirm: { (action) in
                            DispatchQueue.main.async {
                                 self.popViewController()
                            }
                        })
                        button.isCounting = false
                        break
                    default :
                        
                        break
                    }
                case .error(let error):
                    guard let hxError = error as? HXError else { return }
                    switch hxError {
                    case .UnexpectedResult(_, let resultMsg):
                        self.showConfirm(message: resultMsg!, confirm: { (action) in
                            self.popViewController()
                        })
                    default : break
                    }
                case .completed : break
                }
        }
    }
    
    //MARK: - 懒加载
    lazy private var tableView : UITableView = {
        let table = UITableView(frame: CGRect.zero, style: .plain)
        table.dataSource = self
        table.delegate = self
        table.backgroundColor = ColorF4F4F4
        table.isScrollEnabled = false
        table.separatorInset = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10)
        table.register(MobileTextFieldCell.self, forCellReuseIdentifier: mobileCellIdentifier)
        table.register(PasswordTextFieldCell.self, forCellReuseIdentifier: passwordCellIdentifier)
        table.register(VcodeTextFieldCell.self, forCellReuseIdentifier: vcodeCellIdentifier)
        
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(didTipTap))
        table.addGestureRecognizer(tap)
        let footer = RegisterFooterView()
        
        footer.delegate = self
        footer.register.addTarget(self, action: #selector(registerClicked(_:)), for: .touchUpInside)
        table.tableFooterView = footer
        
        return table
    }()
    
    //MARK: - tableview dataSource
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        switch indexPath.row {
        case 0:
            let cell = tableView.dequeueReusableCell(withIdentifier: mobileCellIdentifier, for: indexPath) as! MobileTextFieldCell
            cell.textfield.delegate = self
            self.phoneTF = cell.textfield
            return cell
        case 1:
            let cell = tableView.dequeueReusableCell(withIdentifier: passwordCellIdentifier, for: indexPath) as! PasswordTextFieldCell
            cell.textfield.delegate = self
            self.passwordTF = cell.textfield
            return cell
        case 2:
            let cell = tableView.dequeueReusableCell(withIdentifier: vcodeCellIdentifier, for: indexPath) as! VcodeTextFieldCell
            cell.textfield.delegate = self
            cell.textfield.customDelegate = self
            self.vcodeTF = cell.textfield
            return cell
        default:
            return UITableViewCell()
        }
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return CGFloat(loginTextFieldHeight)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.passwordTF.resignFirstResponder()
        self.phoneTF.resignFirstResponder()
        self.vcodeTF.resignFirstResponder()
    }
    
    @objc private func didTipTap() {
        self.passwordTF.resignFirstResponder()
        self.phoneTF.resignFirstResponder()
        self.vcodeTF.resignFirstResponder()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    
}
