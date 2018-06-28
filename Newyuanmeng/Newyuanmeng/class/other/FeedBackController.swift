//
//  FeedBackController.swift
//  huabi
//
//  Created by TeamMac2 on 16/9/18.
//  Copyright © 2016年 ltl. All rights reserved.
//

import UIKit
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


class FeedBackController: UIViewController,UITextViewDelegate,UITextFieldDelegate {

    @IBOutlet weak var titlelbl: UILabel!
    
    @IBOutlet weak var mainBtn: UIButton!
    @IBOutlet weak var backBtn: UIButton!
    
    @IBOutlet weak var typeBtn: UIButton!
    
    @IBOutlet weak var textView: UITextView!
    
    @IBOutlet weak var confirmBtn: UIButton!
    
    @IBOutlet weak var phone: UITextField!
    
    @IBOutlet weak var phonelbl: TTTAttributedLabel!

    @IBOutlet weak var view1: UIView!
    
    @IBOutlet weak var chooseview: UIView!
    var placeholders = "亲，想说什么都可以"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.textView.textColor = UIColor.init(hexCode: "8a8a8a")
        self.textView.font = UIFont.systemFont(ofSize: 13)
        backBtn.setTitle(IconFontIconName.icon_back.rawValue, for: UIControlState())
        mainBtn.setTitle(IconFontIconName.icon_goods_backhome.rawValue, for: UIControlState())
        phone.setValue(CommonConfig.MainFontGrayColor, forKeyPath: "_placeholderLabel.textColor")
        let tapGesturer1 = UITapGestureRecognizer(target: self, action: #selector(self.hidden))
        view1.isUserInteractionEnabled = true
        view1.addGestureRecognizer(tapGesturer1)
        confirmBtn.layer.cornerRadius = 5
        confirmBtn.clipsToBounds = true
        phonelbl.attributedText = CommonConfig.setNSMutableAttributedTextColor("客服电话:4008715988", target: ["4008715988"], textColor: [CommonConfig.MainRedColor], size: [13], firstSize: 13)
        chooseview.isHidden = true
        // Do any additional setup after loading the view.
    }
    
    func hidden(){
        textView.resignFirstResponder()
        phone.resignFirstResponder()
    }
    
    
    func textFieldDidChange(_ textFeild:UITextField){
        if textFeild == phone{
            if textFeild.text?.characters.count > 11 {
                let str = textFeild.text! as NSString
                textFeild.text = str.substring(to: 11)
            }
        }
    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        hidden()
        return true
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        let text = textView.text
        if text == placeholders {
            self.textView.text = ""
            self.textView.textColor = CommonConfig.MainFontBlackColor
            self.textView.font = UIFont.systemFont(ofSize: 13)
            self.confirmBtn.setTitleColor(UIColor.white, for: UIControlState())
            self.confirmBtn.backgroundColor = CommonConfig.MainRedColor
            self.confirmBtn.isEnabled = true
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView == self.textView {
            let text = textView.text
            if text?.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines) .characters.count == 0 {
                self.textView.text = placeholders
                self.textView.textColor = UIColor.init(hexCode: "8a8a8a")
                self.textView.font = UIFont.systemFont(ofSize: 13)
                self.confirmBtn.setTitleColor(CommonConfig.SliderBlackColor, for: UIControlState())
                self.confirmBtn.backgroundColor = CommonConfig.MainFontGrayColor
                self.confirmBtn.isEnabled = false
            }
        }
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if text == "\n" {
            textView.resignFirstResponder()
            return false
        }
        return true
    }
    
    
    
    
    @IBAction func chooseResult(_ sender: UIButton) {
        typeBtn.setTitle(sender.titleLabel?.text!, for: UIControlState())
        type = sender.tag
        chooseview.isHidden = true
    }
    
    var type = 0

    @IBAction func confirmClick(_ sender: AnyObject) {
        hidden()
        if type == 0 {
            noticeOnlyText("请选择类型!")
            return
        }
        if phone.text != "" {
            if !MySDKHelper.isMobile(phone.text!){
                noticeOnlyText("请输入正确的手机号!")
                return
            }
        }
        RequestManager.RequestData(RequestUrl.Router.sendComplaint(user_id: CommonConfig.UserInfoCache.userId, type: type, content: textView.text, mobile: phone.text!), successCallBack: { (result) in
//            print(result)
            self.noticeOnlyText("提交成功!")
            }) { (fail) in
//                print(fail)
                self.noticeOnlyText("提交失败!")
        }
    }
    
    @IBAction func choosetype(_ sender: UIButton) {
        hidden()
        chooseview.isHidden = false
    }

    @IBAction func backclick(_ sender: AnyObject) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func mainclick(_ sender: AnyObject) {
        (UIApplication.shared.delegate as! AppDelegate).showMainPage()
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
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
