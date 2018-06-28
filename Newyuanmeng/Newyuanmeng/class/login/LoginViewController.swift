//
//  LoginViewController.swift
//  mibo
//
//  Created by TeamMac2 on 16/2/20.
//  Copyright © 2016年 TeamMac2. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
// FIXME: comparison operators with optionals were removed from the Swift Standard Libary.
// Consider refactoring the code to use the non-optional operators.
fileprivate func < <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
    switch (lhs, rhs) {
    case let (l?, r?):
        return l < r
    case (nil, _?):
        return true
    default:
        return false
    }
}

// FIXME: comparison operators with optionals were removed from the Swift Standard Libary.
// Consider refactoring the code to use the non-optional operators.
fileprivate func > <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
    switch (lhs, rhs) {
    case let (l?, r?):
        return l > r
    default:
        return rhs < lhs
    }
}

let screenWidth = UIScreen.main.bounds.size.width //屏幕宽度
let screenHeight = UIScreen.main.bounds.size.height //屏幕高度
let newScale = screenWidth / 750.0  //0.426667
let AppStoreInfoLocalFilePath = NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.documentDirectory, FileManager.SearchPathDomainMask.userDomainMask, true).first! + "/EACEF35FE363A75A/"

class LoginViewController: UIViewController, UITextFieldDelegate, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var secureBtn: UIButton!
    @IBOutlet weak var loginback: UIView!
    @IBOutlet weak var loginPhoneNum: UITextField!
    @IBOutlet weak var loginPassword: UITextField!
    @IBOutlet weak var resetPassword: UIButton!
    @IBOutlet weak var loginBtn: UIButton!
    @IBOutlet weak var listView: UITableView!
    @IBOutlet weak var SinaBtn: UIButton!
    @IBOutlet weak var WXBtn: UIButton!
    @IBOutlet weak var QQBtn: UIButton!
    @IBOutlet weak var left: UILabel!
    @IBOutlet weak var right: UILabel!
    
    @IBOutlet weak var backBtn: UIButton!
    
    var isShowBack:Bool = true
    
    
    var pushId = ""
    var PhoneList:NSDictionary = [:]
    let cellIdentify = "PhoneListCell"
    var numList:NSMutableArray = []
    var passList:NSMutableArray = []
    var input:String = ""
    let errorText = "用户不存在！"
    var isGoods:Bool = false
    var ispresent:Bool = false
    
    @IBAction func secureClick(_ sender: UIButton) {
        let texts = loginPassword.text
        loginPassword.isSecureTextEntry = !loginPassword.isSecureTextEntry
        loginPassword.text = ""
        loginPassword.text = texts
        if loginPassword.isSecureTextEntry {
            loginPassword.insertText(texts!)
        }
    }
    
    @IBAction func backClick(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func register(_ sender: UIButton) {
        let register = UIStoryboard(name: "Me", bundle: nil).instantiateViewController(withIdentifier: "RegisterInputPhoneViewController") as! RegisterInputPhoneViewController
        register.isReset = 0
        self.navigationController?.pushViewController(register, animated: true)
        //self.present(register, animated: true, completion: nil)
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        UIApplication.shared.setStatusBarStyle(.default, animated: false)
        self.navigationController?.setNavigationBarHidden(true, animated: false)
        self.setNeedsStatusBarAppearanceUpdate()
    }
    
    override var preferredStatusBarStyle : UIStatusBarStyle {
        return .default
    }
    
    override var prefersStatusBarHidden : Bool {
        return false
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.backBtn.setTitle(IconFontIconName.icon_back.rawValue, for: UIControlState())
        self.resetPassword.setAttributedTitle(CommonConfig.setLineForText("忘记密码",color: CommonConfig.MainFontGrayColor,font: UIFont.systemFont(ofSize: 10)), for: UIControlState())
        //initLayoutConstraint()
//        getPhoneList()
        self.secureBtn.setIconFont(IconFontIconName.icon_eye)
        self.secureBtn.setTitleColor(CommonConfig.MainFontGrayColor, for: UIControlState())
        self.loginback.layer.borderWidth = 1
        self.loginback.layer.borderColor = CommonConfig.SliderBlackColor.cgColor
        self.loginback.layer.cornerRadius = 5
        self.loginback.clipsToBounds = true
        // Do any additional setup after loading the view.
        loginPassword.isSecureTextEntry = true
        loginPassword.setValue(CommonConfig.MainFontGrayColor, forKeyPath: "_placeholderLabel.textColor")
        loginPhoneNum.setValue(CommonConfig.MainFontGrayColor, forKeyPath: "_placeholderLabel.textColor")
        loginBtn.layer.cornerRadius = 6
        loginBtn.clipsToBounds = true
        SinaBtn.setIconFont(IconFontIconName.icon_sina, normalColor: CommonConfig.MainRedColor)
        WXBtn.setIconFont(IconFontIconName.icon_wechat,normalColor: CommonConfig.MainGreenColor)
        QQBtn.setIconFont(IconFontIconName.icon_qq,normalColor: UIColor.init(hexCode: "31b6e7"))
        SinaBtn.titleLabel?.font = UIFont.init(name: "iconfont", size: 42)
        QQBtn.titleLabel?.font = UIFont.init(name: "iconfont", size: 42)
        WXBtn.titleLabel?.font = UIFont.init(name: "iconfont", size: 42)
        loginPhoneNum.delegate = self
        loginPassword.delegate = self
        loginPassword.autocorrectionType = .yes
        loginPassword.clearButtonMode = .whileEditing
        loginPassword.isSecureTextEntry = true
        loginPhoneNum.addTarget(self, action: #selector(LoginViewController.textFieldDidChange(_:)), for: UIControlEvents.editingChanged)
        self.backBtn.isHidden = !isShowBack
        //        loginPassword.text = "123456789"
        //        loginPhoneNum.text = "15773002846"
        WXBtn.isHidden = !WXApi.isWXAppInstalled()
        QQBtn.isHidden = !QQApiInterface.isQQInstalled()
        
        if WXApi.isWXAppInstalled() {
//            print("isWXAppInstalled")
        }else{
//            print("isWXAppInstalled no")
        }
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let nowTextTag = textField.tag
        if nowTextTag == 1{
            if range.length == 0 {
                input = ((textField.text)! + string)
            }else{
                input.remove(at: input.characters.index(before: input.endIndex))
            }
            if range.location < 10 && range.location > 0{//添加
                listView.isHidden = false
                self.reloadDataList(input)
            }else if range.location == 0{
                listView.isHidden = false
                if range.length == 1{
                    listView.isHidden = true
                }
                self.reloadDataList("-1")
            }else{
                listView.isHidden = true
            }
        }else{
            listView.isHidden = true
        }
        return true
    }
    
    func textFieldDidChange(_ textFeild:UITextField){
        if textFeild == loginPhoneNum{
            if textFeild.text?.characters.count > 11 {
                let str = textFeild.text! as NSString
                textFeild.text = str.substring(to: 11)
            }
        }
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if textField == loginPassword {
            if textField.isSecureTextEntry {
                textField.insertText(loginPassword.text!)
            }
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        listView.isHidden = true
        //收起键盘
        loginPhoneNum.resignFirstResponder()
        loginPassword.resignFirstResponder()
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        //收起键盘
        textField.resignFirstResponder()
        return true
    }
    
    @IBAction func resetPassword(_ sender: UIButton) {
        
        let register = UIStoryboard(name: "Me", bundle: nil).instantiateViewController(withIdentifier: "RegisterInputPhoneViewController") as! RegisterInputPhoneViewController
        register.isReset = 1
        self.navigationController?.pushViewController(register, animated: true)
        //self.present(register, animated: true, completion: nil)
    }
    
    @IBAction func loginBtnClick(_ sender: UIButton) {
        let phoneNums = loginPhoneNum.text!
        let passwordsCount = loginPassword.text!.characters.count
        let newPassword = loginPassword.text!
        if phoneNums.characters.count != 11 {
            self.noticeOnlyText("请输入正确的手机号码")
            return
        }else{
            let check = MySDKHelper.isMobile(phoneNums)
            if check == false{
                self.noticeOnlyText("请输入正确的手机号码")
                return
            }
        }
//        if passwordsCount < 8 || passwordsCount > 20{
//            self.noticeOnlyText("请输入8-20位密码")
//            return
//        }
        
        //        if CommonConfig.checkPassword(newPassword) < 2 {
        //            self.noticeOnlyText("数字、字母、符号至少包含两种")
        //            return
        //        }
        
//        print(newPassword)
        RequestManager.RequestData(RequestUrl.Router.userLogin(account: phoneNums, password: newPassword),showLoading: true,successCallBack: {resultJson in
                                    var detail = resultJson["content"]
                                    CommonConfig.Token = detail["token"].stringValue
            
                                    //  将user_id   Token 保存到本地
                                    let userDefaults = UserDefaults.standard
                                    /**
                                     存储数据
                                     */
                                    userDefaults.set(CommonConfig.Token , forKey: "token")
                                    userDefaults.set(detail["user_id"].stringValue, forKey: "user_id")
                                    print("\(CommonConfig.Token)")
                                    /**
                                     同步数据
                                     */
                                    userDefaults.synchronize()
            
            RequestManager.RequestData(RequestUrl.Router.getUserInfo(user_id: detail["user_id"].intValue,token:CommonConfig.Token), successCallBack: { (result) in
                                        print("用户数据获取成功%@",result)
                                        detail = result["content"]["userinfo"]
                                        detail["password"].stringValue = newPassword
                                        detail["otherType"].stringValue = "0"
                                        detail["account"].stringValue = phoneNums
                                        if detail["nickname"].stringValue == ""
                                        {
                                            detail["nickname"].stringValue = detail["user_id"].stringValue
                                        }
                                        
                                        
                                        CommonConfig.setLoginSuccessInfo(detail)
                                        JPUSHService.setAlias(detail["user_id"].stringValue, callbackSelector: #selector(self.tagsAliasCallBack(resCode:tags:alias:)), object: self)
                                        
//                                        let notificationName = Notification.Name(rawValue: "DownloadImageNotification")
//                                        NotificationCenter.default.post(name: notificationName, object: self)
                                        if self.isGoods {
                                            self.navigationController?.popViewController(animated: true)
                                        }else{
//                                            self.navigationController?.popViewController(animated: true)
                                            self.navigationController?.popToRootViewController(animated: true)
                                        }
                                        if self.ispresent
                                        {
                                            self .dismiss(animated: true, completion: nil)
                                        }
                                    }, failCallBack: { (fail) in

                                        self.noticeOnlyText(fail)
                                    })
                                    
        },
                                   failCallBack: {failStr in

                                    self.noticeOnlyText(failStr)
                                    
        })
    }
    // 别名注册回调
    func tagsAliasCallBack(resCode:CInt, tags:NSSet, alias:NSString) {
        print("别名上传响应结果：\(resCode)")
    }
    
    func CustomLogin(_ openid:String, platform:String,nickname:String,head:String,token:String)
    {
        print("openid：\(openid)")
        print("platform：\(platform)")
        print("nickname：\(nickname)")
        print("head：\(head)")
        print("token：\(token)")
        CommonConfig.Token = token
        RequestManager.RequestData(RequestUrl.Router.userThirdLogin(platform: platform, openid: openid), successCallBack: { (result) in
//            print(result)
            
            if result["content"] == nil{
//                print("用户未绑定")
                
                let RegisterInputPhoneViewController = UIStoryboard(name: "Me", bundle: nil).instantiateViewController(withIdentifier: "RegisterInputPhoneViewController") as! RegisterInputPhoneViewController
                RegisterInputPhoneViewController.isReset = 2
                RegisterInputPhoneViewController.openid = openid
                RegisterInputPhoneViewController.platform = platform
                RegisterInputPhoneViewController.nickname = nickname
                RegisterInputPhoneViewController.head = head
                self.navigationController?.pushViewController(RegisterInputPhoneViewController, animated: true)
                
            }else{
                
                var detail = result["content"]
                CommonConfig.Token = detail["token"].stringValue
                //                CommonConfig.UserInfoCache.userId = detail["user_id"].intValue
                print("user_ID\(detail["user_id"])")
                RequestManager.RequestData(RequestUrl.Router.getUserInfo(user_id: detail["user_id"].intValue, token: CommonConfig.Token), successCallBack: { (resultDetail) in
                    print("\(resultDetail)")
                    detail = resultDetail["content"]["userinfo"]
                    CommonConfig.setLoginSuccessInfo(detail)
                    
                    if self.isGoods {
                        self.navigationController?.popViewController(animated: true)
                    }else{
                        self.navigationController?.popToRootViewController(animated: true)
                    }
                }, failCallBack: { (failDetail) in
                    self.noticeOnlyText(failDetail)
                })
                
                
            }
        }) { (fail) in
//            print(fail)
            self.noticeOnlyText(fail)
        }
    }
    
    
    func verifyPhone(_ openid:String, platform:String,nickname:String,head:String){
        let register = UIStoryboard(name: "Me", bundle: nil).instantiateViewController(withIdentifier: "RegisterInputPhoneViewController") as! RegisterInputPhoneViewController
        register.isReset = 2
        register.openid = openid
        register.platform = platform
        register.nickname = nickname
        register.head = head
        self.navigationController?.pushViewController(register, animated: true)
    }
    
    @IBAction func qqBtnClick(_ sender: UIButton) {
//        UMengHelper.getAuthWithUserInfoFromQQ()
        UMengHelper.getAuthWithUserInfo(from: self, platformType: .QQ, onLoginSucceed: { (typeFlag,ID,icon,nickname,unionId,token,gender) in
            self.CustomLogin(ID, platform: "qq", nickname: nickname, head: icon, token: token)
        }, onLoginCancel: { failstr in
            
            print("取消登录333");
            print(failstr)
        }
        )
    }
    @IBAction func weixinBtnClick(_ sender: UIButton) {
        UMengHelper.getAuthWithUserInfoFromWechat()
        UMengHelper.getAuthWithUserInfo(from: self, platformType:  .wechatSession, onLoginSucceed: { (typeFlag,ID,icon,nickname,unionId,token,gender) in
            self.CustomLogin(unionId, platform: "weixin", nickname: nickname, head: icon, token: token)
        }, onLoginCancel: { failstr in
            
            print("取消登录");
            print(failstr)
        }
        )
    }
    @IBAction func sinaBtnClick(_ sender: UIButton) {
//        UMengHelper.getAuthWithUserInfoFromSina()
        UMengHelper.getAuthWithUserInfo(from: self, platformType:  .sina, onLoginSucceed: { (typeFlag,ID,icon,nickname,unionId,token,gender) in
            self.CustomLogin(ID, platform: "sina", nickname: nickname, head: icon, token: token)
        }, onLoginCancel: { failstr in
            print("取消登录22");
            print(failstr)
        }
        )
    }
    
    func reloadDataList(_ title:String){
        numList.removeAllObjects()
        passList.removeAllObjects()
        let keys = PhoneList.allKeys
        let values = PhoneList.allValues
        for i in 0..<keys.count {
            let phone = keys[i] as! String
            let pass = values[i] as! String
            if title == "-1" {
                passList.add(pass)
                numList.add(phone)
            }else {
                if (phone.range(of: title) != nil) {
                    passList.add(pass)
                    numList.add(phone)
                }
            }
        }
        if PhoneList.count != 0 {
//            print("ShopPhoneList",PhoneList)
        }
        listView.reloadData()
    }
    
    func getPhoneList(){
        PhoneList =  UserDefaults.standard.object(forKey: "ShopPhoneList") as! NSDictionary
        listView.backgroundColor = UIColor.clear
        listView.showsHorizontalScrollIndicator = false
        listView.showsVerticalScrollIndicator = false
        listView.separatorStyle = .none
        listView.isHidden = true
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return numList.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 30.0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentify)! as UITableViewCell
        let phoneLabel = cell.viewWithTag(999) as! UILabel
        cell.backgroundColor = UIColor.white
        if numList.count != 0 {
            phoneLabel.text = numList[indexPath.row] as! String
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        loginPhoneNum.text = numList[indexPath.row] as! String
        loginPassword.text = passList[indexPath.row] as! String
        input = numList[indexPath.row] as! String
        listView.isHidden = true
    }
    
    // MARK: - Navigation
    
    //    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
    //        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .Plain, target: nil, action: nil)
    //        if let controller = segue.destinationViewController as? VerifyPhoneViewController {
    //            
    //            if segue.identifier == "toResetPassword" {
    //                
    //            }
    //            
    //        }
    //    }
    
}
