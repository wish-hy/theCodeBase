//
//  InvoiceViewController.swift
//  huabi
//
//  Created by TeamMac2 on 16/9/9.
//  Copyright © 2016年 ltl. All rights reserved.
//

import UIKit

class InvoiceViewController: UIViewController ,UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate{

    @IBOutlet weak var headView: UIView!
    @IBOutlet weak var invoiceTableView: UITableView!
    @IBOutlet weak var typeBtn1: UIButton!
    @IBOutlet weak var typeLbl1: UILabel!
    @IBOutlet weak var typeBtn2: UIButton!
    @IBOutlet weak var typeLbl2: UILabel!
    @IBOutlet weak var wayLbl1: UILabel!
    @IBOutlet weak var wayBtn1: UIButton!
    @IBOutlet weak var wayLbl2: UILabel!
    @IBOutlet weak var wayBtn2: UIButton!
    @IBOutlet weak var titleLbl1: UILabel!
    @IBOutlet weak var titleBtn1: UIButton!
    @IBOutlet weak var titleBtn2: UIButton!
    @IBOutlet weak var titleLbl2: UILabel!
    @IBOutlet weak var titleText: UITextField!
    @IBOutlet weak var contentBtn: UIButton!
    @IBOutlet weak var contentLbl: UILabel!
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var confirmBtn: UIButton!
    
    @IBOutlet weak var hiddenview: UIView!
    @IBOutlet weak var backBtn: UIButton!
    
    var isinvoice = "1"    //是否需要发票 0不需要 1需要
    var invoicetype = "0" //发票类型 0是个人 1是单位
    var invoicetitle = ""    //抬头
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setInfo()
        // Do any additional setup after loading the view.
    }
    
    func setInfo(){
        self.hiddenview.isHidden = true
        let size = CommonConfig.getTextRectSize("发票金额为现金支付金额(扣除礼品卡余额、抵用券、返利金额等)。", font: UIFont.systemFont(ofSize: 10), size: CGSize(width: screenWidth-20, height: 0))
        self.invoiceTableView.tableHeaderView?.frame = CGRect(x: 0, y: 0, width: screenWidth, height: 36+84+36+84+36+84+36+84+36+size.height+5)
        backBtn.setTitle(IconFontIconName.icon_back.rawValue, for: UIControlState())
        setBtn(typeBtn1)
        setBtn(typeBtn2)
        setBtn(wayBtn1)
        setBtn(wayBtn2)
        setBtn(titleBtn1)
        setBtn(titleBtn2)
        setBtn(contentBtn)
        btnInit()
        confirmBtn.layer.cornerRadius = 5
        confirmBtn.clipsToBounds = true
        isinvoice = "1"
        let usSwitch1 = ZJSwitch.init(frame: CGRect(x: screenWidth - 65 - 15, y: 9, width: 65, height: 25))
        usSwitch1.backgroundColor = UIColor.clear
        usSwitch1.tintColor = CommonConfig.MainGrayColor
        usSwitch1.onTintColor = CommonConfig.MainYellowColor
        usSwitch1.textFont = UIFont.systemFont(ofSize: 13)
        usSwitch1.onText = "需要"
        usSwitch1.offText = ""
        usSwitch1.addTarget(self, action: #selector(InvoiceViewController.SwitchEventOne(_:)), for: .valueChanged)
        usSwitch1.isOn = true
        headView.addSubview(usSwitch1)
        let usSwitch2 = ZJSwitch.init(frame: CGRect(x: screenWidth - 65 - 15, y: 9, width: 65, height: 25))
        usSwitch2.backgroundColor = UIColor.clear
        usSwitch2.tintColor = CommonConfig.MainGrayColor
        usSwitch2.onTintColor = CommonConfig.MainYellowColor
        usSwitch2.textFont = UIFont.systemFont(ofSize: 13)
        usSwitch2.onText = "需要"
        usSwitch2.offText = ""
        usSwitch2.addTarget(self, action: #selector(InvoiceViewController.SwitchEventTwo(_:)), for: .valueChanged)
        usSwitch2.isOn = true
        contentView.addSubview(usSwitch2)
    }
    func SwitchEventOne(_ sender:ZJSwitch){
        if sender.isOn {
            isinvoice = "1"
            self.hiddenview.isHidden = true
        }else{
            self.hiddenview.isHidden = false
            btnInit()
        }
    }
    var isNeedList:Bool = true
    func SwitchEventTwo(_ sender:ZJSwitch){
        if sender.isOn {
            isNeedList = true
        }else{
            isNeedList = false
        }
    }
    
    func btnInit(){
        isinvoice = "0"
        invoicetype = "0"
        invoicetitle = ""
        changeBtnColor(true, btn1: typeBtn1, btn2: typeBtn2, lbl1: typeLbl1, lbl2: typeLbl2)
        changeBtnColor(true, btn1: wayBtn1, btn2: wayBtn2, lbl1: wayLbl1, lbl2: wayLbl2)
        changeBtnColor(true, btn1: titleBtn1, btn2: titleBtn2, lbl1: titleLbl1, lbl2: titleLbl2)
    }
    
    func setBtn(_ btn:UIButton){
        btn.layer.cornerRadius = 11
        btn.layer.borderColor = CommonConfig.MainFontGrayColor.cgColor
        btn.layer.borderWidth = 1
        btn.clipsToBounds = true
    }
    
    func changeBtnColor(_ type:Bool,btn1:UIButton,btn2:UIButton,lbl1:UILabel,lbl2:UILabel){
        
        if type {
            btn1.setTitle(IconFontIconName.icon_circle.rawValue, for: UIControlState())
            btn2.setTitle("", for: UIControlState())
            lbl1.textColor = CommonConfig.MainFontBlackColor
            lbl2.textColor = CommonConfig.MainFontGrayColor
        }else{
            btn1.setTitle("", for: UIControlState())
            btn2.setTitle(IconFontIconName.icon_circle.rawValue, for: UIControlState())
            lbl1.textColor = CommonConfig.MainFontGrayColor
            lbl2.textColor = CommonConfig.MainFontBlackColor
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 0
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 1
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell")! as UITableViewCell
        cell.backgroundColor = UIColor.white
        cell.selectionStyle = .none
        return cell
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        titleText.resignFirstResponder()
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        invoicetype = "1"
        changeBtnColor(false, btn1: titleBtn1, btn2: titleBtn2, lbl1: titleLbl1, lbl2: titleLbl2)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    @IBAction func invoiceClick(_ sender: UIButton) {
        titleText.resignFirstResponder()
        if sender.tag == 0 {
            changeBtnColor(true, btn1: typeBtn1, btn2: typeBtn2, lbl1: typeLbl1, lbl2: typeLbl2)
        }else if sender.tag == 1 {
            changeBtnColor(false, btn1: typeBtn1, btn2: typeBtn2, lbl1: typeLbl1, lbl2: typeLbl2)
        }else if sender.tag == 2 {
            changeBtnColor(true, btn1: wayBtn1, btn2: wayBtn2, lbl1: wayLbl1, lbl2: wayLbl2)
        }else if sender.tag == 3 {
            changeBtnColor(false, btn1: wayBtn1, btn2: wayBtn2, lbl1: wayLbl1, lbl2: wayLbl2)
        }else if sender.tag == 4 {
            invoicetype = "0"
            changeBtnColor(true, btn1: titleBtn1, btn2: titleBtn2, lbl1: titleLbl1, lbl2: titleLbl2)
            titleText.text = ""
        }else if sender.tag == 5 {
            invoicetype = "1"
            changeBtnColor(false, btn1: titleBtn1, btn2: titleBtn2, lbl1: titleLbl1, lbl2: titleLbl2)
        }
    }
    
    @IBAction func confirmClick(_ sender: UIButton) {
        if invoicetype == "1" {
            invoicetitle = titleText.text!
        }
        let notice = Notification.init(name: Notification.Name(rawValue: "orderInvoice"), object:["invoicetype":invoicetype,"isinvoice":isinvoice,"invoicetitle":invoicetitle])
        NotificationCenter.default.post(notice)
        self.navigationController?.popViewController(animated: true)
    }
    
    
    @IBAction func backClick(_ sender: AnyObject) {
        self.navigationController?.popViewController(animated: true)
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
