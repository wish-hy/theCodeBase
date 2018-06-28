//
//  VerifyPhoneViewController.swift
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


class VerifyPhoneViewController: UIViewController ,UITextFieldDelegate {
    
    @IBOutlet weak var verifyCode: UITextField!
    @IBOutlet weak var password: UITextField!
    @IBOutlet weak var confirmBtn: UIButton!
    @IBOutlet weak var getCode: UIButton!
    @IBOutlet weak var backbar: UIButton!
    @IBOutlet weak var secureBtn: UIButton!
    @IBOutlet weak var textlbl: UILabel!
    
    @IBOutlet weak var codeview: UIView!
    
    @IBOutlet weak var passview: UIView!
    
    @IBOutlet weak var doneView: UIView!
    
    @IBOutlet weak var phonelbl: UILabel!
    
    @IBOutlet weak var sureBtn: UIButton!
    
    @IBOutlet weak var viewtitle: UILabel!
    
    @IBOutlet weak var donetitle: UILabel!
    @IBOutlet weak var loginBtn: UIButton!
    
    var phoneNums = ""
    var zones = 86
    var otherType:String = ""
    var otherId:String = ""
    var identifyId:Int = 1//0:注册成功，1:短信验证
    var isReset = 0 //0:注册 1:重置密码 2:第三方绑定 ，4设置支付密码 5重置支付密码
    var timer: Timer!
    var countDown = 60
    
    var openid:String = ""
    var platform:String = ""
    var nickname:String = ""
    var head:String = ""
    
    
    @IBAction func secureClick(_ sender: UIButton) {
        let texts = password.text
        password.isSecureTextEntry = !password.isSecureTextEntry
        password.text = ""
        password.text = texts
        if password.isSecureTextEntry {
            password.insertText(texts!)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if identifyId == 1 {
            if isReset == 1{
                viewtitle.text = "重置密码"
            }else if isReset == 0{
                viewtitle.text = "设置密码"
            }else if isReset == 2{
                viewtitle.text = "设置密码"
            }else if isReset == 4{
                viewtitle.text = "设置支付密码"
                loginBtn.setTitle("", for: UIControlState.normal)
                sureBtn.setTitle("完成", for: UIControlState.normal)
            }else if isReset == 4{
                viewtitle.text = "重设支付密码"
                loginBtn.setTitle("", for: UIControlState.normal)
                sureBtn.setTitle("完成", for: UIControlState.normal)
            }
        }else if identifyId == 0{
            if isReset == 1{
                donetitle.text = "重置成功"
                viewtitle.text = "重置成功"
            }else if isReset == 0{
                donetitle.text = "注册成功"
                viewtitle.text = "注册成功"
            }
            else if isReset == 2{
                donetitle.text = "绑定成功"
                viewtitle.text = "绑定成功"
            }
        }
        textlbl.text = "已发送一条带验证码的短信至 " + phoneNums
        phonelbl.text = phoneNums
        verifyCode.setValue(CommonConfig.SliderBlackColor, forKeyPath: "_placeholderLabel.textColor")
        password.setValue(CommonConfig.SliderBlackColor, forKeyPath: "_placeholderLabel.textColor")
        backbar.setTitle(IconFontIconName.icon_back.rawValue, for: UIControlState())
        // Do any additional setup after loading the view.
        password.isSecureTextEntry = true
        confirmBtn.layer.cornerRadius = 15
        getCode.layer.cornerRadius = 5
        confirmBtn.clipsToBounds = true
        sureBtn.layer.cornerRadius = 15
        sureBtn.clipsToBounds = true
        getCode.titleLabel?.font = UIFont.systemFont(ofSize: 13)
        getCode.layer.borderWidth = 1
        getCode.layer.borderColor = CommonConfig.SliderBlackColor.cgColor
        getCode.clipsToBounds = true
        codeview.layer.borderWidth = 1
        codeview.layer.borderColor = CommonConfig.SliderBlackColor.cgColor
        codeview.layer.cornerRadius = 5
        codeview.clipsToBounds = true
        passview.layer.borderWidth = 1
        passview.layer.borderColor = CommonConfig.SliderBlackColor.cgColor
        passview.layer.cornerRadius = 5
        passview.clipsToBounds = true
        self.secureBtn.setIconFont(IconFontIconName.icon_eye)
        self.secureBtn.setTitleColor(CommonConfig.MainFontGrayColor, for: UIControlState())
        password.delegate = self
        verifyCode.delegate = self
        password.autocorrectionType = .yes
        password.clearButtonMode = .whileEditing
        password.text = ""
        verifyCode.text = ""
        
        
        if identifyId == 0 {
            self.doneView.isHidden = false
            
        }else if identifyId == 1{
            self.doneView.isHidden = true
            self.timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: "heartbeat", userInfo: nil, repeats: true)
            self.getCode.isEnabled = false
            
        }
    }
    
    func heartbeat() {
        self.getCode.setTitleColor(CommonConfig.MainFontGrayColor, for: UIControlState())
        self.countDown -= 1
        if self.countDown == 0 {
            getCode.titleLabel?.font = UIFont.systemFont(ofSize: 14)
            self.getCode.setTitle("重新获取", for: UIControlState())
            self.getCode.backgroundColor = UIColor.init(red: Int(233/255.0), green:Int(84/255.0), blue: Int(38/255.0))
            self.normalState()
            return
        }
        getCode.titleLabel?.font = UIFont.systemFont(ofSize: 13)
        self.getCode.setTitle("正在获取(\(countDown))", for: UIControlState.disabled)
        self.getCode.backgroundColor = UIColor.white
    }
    
    func normalState() {
        if self.timer == nil {
            return
        }
        self.timer.invalidate()
        self.timer = nil
        self.getCode.isEnabled = true
    }
    
    
    func textFieldDidChange(_ textFeild:UITextField){
        if identifyId != 2{
            if textFeild == password{
                if textFeild.text?.characters.count > 20 {
                    let str = textFeild.text! as NSString
                    textFeild.text = str.substring(to: 20)
                }
            }
        }else {
            if textFeild == verifyCode{
                if textFeild.text?.characters.count > 6 {
                    let str = textFeild.text! as NSString
                    textFeild.text = str.substring(to: 6)
                }
            }
        }
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if textField == password {
            if textField.isSecureTextEntry {
                textField.insertText(password.text!)
            }
        }
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        UIApplication.shared.setStatusBarStyle(.default, animated: false)
        self.navigationController?.setNavigationBarHidden(true, animated: false)
        self.setNeedsStatusBarAppearanceUpdate()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        self.normalState()
    }
    
    override var preferredStatusBarStyle : UIStatusBarStyle {
        return .default
    }
    
    override var prefersStatusBarHidden : Bool {
        return false
    }
    
    @IBAction func getVaild(_ sender: UIButton!){
        self.timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: "heartbeat", userInfo: nil, repeats: true)
        self.getCode.isEnabled = false
        setRequest(phoneNums, zone: "\(zones)")
        
    }
    
    func setRequest(_ phone:String, zone:String){
        CommonConfig.getMobCode(phone, zone: zone, successCallBack: { () in
            self.noticeOnlyText("验证码已发送")
            
        }) { (error) in
            
        }
    }
    
    
    @IBAction func confirmBtnClick(_ sender: UIButton) {
        
        var newPassword = password.text!
        var newVerifyCode = NSString.init(string:verifyCode.text!)
        
//        let passwordsCount = password.text!.characters.count
//        if passwordsCount < 8 || passwordsCount > 20{
//            self.noticeOnlyText("请输入8-20位密码")
//            return
//        }
//        if CommonConfig.checkPassword(newPassword) < 2 {
//            self.noticeOnlyText("数字、字母、符号至少包含两种")
//            return
//        }
        if newVerifyCode.length == 0 {
            noticeOnlyText("请输入验证码")
            return
        }
        if identifyId == 1{
            if isReset == 1{
                setRequestData(RequestUrl.Router.forgetLoginpwd(code: newVerifyCode.integerValue, mobile: phoneNums, newpassword: newPassword, zone: zones))
            }else if isReset == 0{
                setRequestData(RequestUrl.Router.register(validCode: newVerifyCode.integerValue, password: newPassword, mobile: phoneNums, zone: zones))
            }else if isReset == 2{
                setRequestData(RequestUrl.Router.verifyPhone(openid: openid, platform: platform, mobile: phoneNums, code: newVerifyCode.integerValue, password: newPassword, zone: zones, nickname: nickname, head: head))
            }else if isReset == 4{ //设置支付密码
                setRequestData(RequestUrl.Router.settingpaypwd(code: newVerifyCode.integerValue, mobile: phoneNums, newpassword: newPassword, zone: zones, user_id: CommonConfig.UserInfoCache.userId, token: CommonConfig.Token))
            }else if isReset == 5{//重设支付密码
                setRequestData(RequestUrl.Router.resettingpaypwd(code: newVerifyCode.integerValue, mobile: phoneNums, newpassword: newPassword, zone: zones, user_id: CommonConfig.UserInfoCache.userId, token: CommonConfig.Token))
            }
        }
    }
    
    func setRequestData(_ url:URLRequestConvertible){
        RequestManager.RequestData(url, successCallBack:{successStr in
            print(successStr)
            let verify = UIStoryboard(name: "Me", bundle: nil).instantiateViewController(withIdentifier: "VerifyPhoneViewController") as! VerifyPhoneViewController
            verify.phoneNums = self.phoneNums
            verify.zones = self.zones
            verify.identifyId = 0
            verify.isReset = self.isReset
            verify.openid = self.openid
            verify.platform = self.platform
            verify.nickname = self.nickname
            verify.head = self.head
            self.navigationController?.pushViewController(verify, animated: true)
        },failCallBack: {failStr in
            self.noticeOnlyText(failStr)
        })
    }
    
    //绑定手机成功 点击完成
    @IBAction func sureClick(_ sender: UIButton) {
        
        
//        RequestManager.RequestData(RequestUrl.Router.userThirdLogin(platform: platform, openid: openid), successCallBack: { (result) in
////            print(result)
//
//            var detail = result["content"]
//            CommonConfig.Token = detail["token"].stringValue
//            //                CommonConfig.UserInfoCache.userId = detail["user_id"].intValue
//            RequestManager.RequestData(RequestUrl.Router.getUserInfo(user_id: detail["user_id"].intValue), successCallBack: { (resultDetail) in
////                print(resultDetail)
//                detail = resultDetail["content"]["userinfo"]
//                CommonConfig.setLoginSuccessInfo(detail)
//
                self.navigationController?.popToRootViewController(animated: true)
//            }, failCallBack: { (failDetail) in
//                self.noticeOnlyText(failDetail)
//            })
//
//
//        }) { (fail) in
////            print(fail)
//            self.noticeOnlyText(fail)
//        }
        
        
        
    }
    
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        //收起键盘
        
        verifyCode.resignFirstResponder()
        password.resignFirstResponder()
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        //收起键盘
        textField.resignFirstResponder()
        return true
    }
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
    @IBAction func goback(_ sender: UIButton) {
        if sender.tag == 0 {
            self.navigationController?.popViewController(animated: true)
        
        }else if sender.tag == 1{
            let login = UIStoryboard(name: "Me", bundle: nil).instantiateViewController(withIdentifier: "LoginViewController") as! LoginViewController
            self.navigationController?.pushViewController(login, animated: true)
        }
    }
    
}
