//
//  RegisterInputPhoneViewController.swift
//  mibo
//
//  Created by TeamMac2 on 16/1/26.
//  Copyright © 2016年 TeamMac2. All rights reserved.
//

import UIKit
import SwiftyJSON
import Alamofire
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


class RegisterInputPhoneViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var loginBtn: UIButton!
    @IBOutlet weak var phoneNumTF: UITextField!
    @IBOutlet weak var confirmBtn: UIButton!
    @IBOutlet weak var backbar: UIButton!
    
    @IBOutlet weak var zoneBtn: UIButton!
    @IBOutlet weak var PhoneView: UIView!
    
    @IBOutlet weak var titlelbl: UILabel!
    
    @IBOutlet weak var resetView: UIView!
    @IBOutlet weak var oldpass: UITextField!
    @IBOutlet weak var newpass1: UITextField!
    @IBOutlet weak var newpass2: UITextField!
    @IBOutlet weak var doneBtn: UIButton!
    @IBOutlet weak var registerBtn: UIButton!
    var isReset = 0 //0:注册 1:重置密码 2:第三方绑定 3:修改密码 4设置支付密码 5重置支付密码
    
    
    var openid:String = ""
    var platform:String = ""
    var nickname:String = ""
    var head:String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        resetView.isHidden = true
        loginBtn.isHidden = false
        if isReset == 0{
            titlelbl.text = "注册"
        }else if isReset == 1{
            titlelbl.text = "重置密码"
        }else if isReset == 2{
            titlelbl.text = "绑定手机"
        }else if isReset == 3{
            titlelbl.text = "修改密码"
            resetView.isHidden = false
            loginBtn.isHidden = true
        }else if isReset == 4{
            titlelbl.text = "设置支付密码"
            loginBtn.setTitle("", for: UIControlState.normal)
        }else if isReset == 5{
            titlelbl.text = "重置支付密码"
            loginBtn.setTitle("", for: UIControlState.normal)
        }
        
        
        phoneNumTF.setValue(CommonConfig.MainFontGrayColor, forKeyPath: "_placeholderLabel.textColor")
        
        // Do any additional setup after loading the view.
        
        backbar.setTitle(IconFontIconName.icon_back.rawValue, for: UIControlState())
        PhoneView.layer.borderColor = CommonConfig.SliderBlackColor.cgColor
        PhoneView.layer.borderWidth = 1
        PhoneView.layer.cornerRadius = 5
        PhoneView.clipsToBounds = true
        confirmBtn.layer.cornerRadius = 15
        confirmBtn.clipsToBounds = true
        doneBtn.layer.cornerRadius = 15
        doneBtn.clipsToBounds = true
        phoneNumTF.delegate = self
        oldpass.delegate = self
        newpass1.delegate = self
        newpass2.delegate = self
        oldpass.clearButtonMode = .whileEditing
        newpass1.clearButtonMode = .whileEditing
        newpass2.clearButtonMode = .whileEditing
        phoneNumTF.addTarget(self, action: #selector(RegisterInputPhoneViewController.textFieldDidChange(_:)), for: UIControlEvents.editingChanged)
        phoneNumTF.text = ""
    }
    
    func textFieldDidChange(_ textFeild:UITextField){
        if textFeild == phoneNumTF{
            if textFeild.text?.characters.count > 11 {
                let str = textFeild.text! as NSString
                textFeild.text = str.substring(to: 11)
            }
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        //收起键盘
        phoneNumTF.resignFirstResponder()
        oldpass.resignFirstResponder()
        newpass1.resignFirstResponder()
        newpass2.resignFirstResponder()
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        return true
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        //收起键盘
        textField.resignFirstResponder()
        return true
    }
    
    func textFieldShouldClear(_ textField: UITextField) -> Bool {
        
        return true
    }
    
    @IBAction func zoneClick(_ sender: UIButton) {
        
    }
    
    @IBAction func finish(_ sender: AnyObject) {
        
        let phoneNums = phoneNumTF.text!
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
        CommonConfig.getMobCode(phoneNums, zone: "+\(zoneBtn.tag)", successCallBack: { () in
            let verify = UIStoryboard(name: "Me", bundle: nil).instantiateViewController(withIdentifier: "VerifyPhoneViewController") as! VerifyPhoneViewController
            verify.phoneNums = self.phoneNumTF.text!
            verify.zones = self.zoneBtn.tag
            verify.identifyId = 1
            verify.isReset = self.isReset
            verify.openid = self.openid
            verify.platform = self.platform
            verify.nickname = self.nickname
            verify.head = self.head
            self.navigationController?.pushViewController(verify, animated: true)
            //self.present(verify, animated: true, completion: nil)
            
        }) { (error) in
        }
        
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
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func goback(_ sender: AnyObject) {
        self.navigationController?.popViewController(animated: true)
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func resetClick(_ sender: UIButton) {
        RequestManager.RequestData(RequestUrl.Router.resetLoginpwd(userid:CommonConfig.UserInfoCache.userId,oldpassword: oldpass.text!, newpassword1: newpass1.text!, newpassword2:newpass2.text!), successCallBack: { (result) in
            CommonConfig.UserInfoCache.password = self.newpass1.text!
            //            noticeOnlyText("修改成功")
            self.noticeOnlyText("修改成功")
            self.navigationController?.popViewController(animated: true)
            self.dismiss(animated: true, completion: nil)
        }) { (fail) in
            self.noticeOnlyText(fail)
        }
    }
    
}
