//
//  AddressViewController.swift
//  huabi
//
//  Created by TeamMac2 on 16/9/2.
//  Copyright © 2016年 ltl. All rights reserved.
//

import UIKit
import SwiftyJSON

class AddressViewController: UIViewController ,UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate{

    
    @IBOutlet weak var addbackview: UIView!
    
    @IBOutlet weak var backBtn: UIButton!
    @IBOutlet weak var addBtn: UIButton!
    @IBOutlet weak var titlelbl: UILabel!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var view1: UIView!
    @IBOutlet weak var view2: UIView!
    
    @IBOutlet weak var tableView2: UITableView!
    
    @IBOutlet weak var name: UITextField!
    @IBOutlet weak var addrBtn: UIButton!
    @IBOutlet weak var addrText: UITextField!
    @IBOutlet weak var phoneText: UITextField!
    @IBOutlet weak var saveBtn: UIButton!
    
    @IBOutlet weak var switchView: UIView!
    
    @IBOutlet weak var top1: NSLayoutConstraint!
    @IBOutlet weak var top2: NSLayoutConstraint!
    @IBOutlet weak var saveH: NSLayoutConstraint!
    
    var addrList:Array<JSON> = []
    var isAdd:Bool = false
    var editid = ""
    var provinceid = ""
    var cityid = ""
    var areaid = ""
    var editAddress = ""
    var editName = ""
    var editAddress2 = ""
    var editPhone = ""
    var editZip = ""
    var editUsing = 0
    var isGoods:Bool = false
    var isOrder:Bool = false
//    var isPromoter:Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let tapGesturer1 = UITapGestureRecognizer(target: self, action: #selector(AddressViewController.hidden1))
        addbackview.isUserInteractionEnabled = true
        addbackview.addGestureRecognizer(tapGesturer1)
        let tapGesturer2 = UITapGestureRecognizer(target: self, action: #selector(AddressViewController.hidden2))
        switchView.isUserInteractionEnabled = true
        switchView.addGestureRecognizer(tapGesturer2)
        initSetting()
        // Do any additional setup after loading the view.
    }
    
    func hidden1(){
        hiddenKeyborad()
    }
    
    func hidden2(){
        hiddenKeyborad()
    }
    
    func initSetting(){
        top1.constant = 94*newScale
        top2.constant = 200*newScale
        saveH.constant = 628*newScale
        saveBtn.layer.cornerRadius = 5
        saveBtn.clipsToBounds = true
        name.setValue(CommonConfig.MainFontGrayColor, forKeyPath: "_placeholderLabel.textColor")
        addrText.setValue(CommonConfig.MainFontGrayColor, forKeyPath: "_placeholderLabel.textColor")
        phoneText.setValue(CommonConfig.MainFontGrayColor, forKeyPath: "_placeholderLabel.textColor")
        backBtn.setTitle(IconFontIconName.icon_back.rawValue, for: UIControlState())
        name.text = editName
        var addresss = editAddress
        if addresss == "" {
            addresss = "区域选择"
        }
        addrBtn.setTitle(addresss, for: UIControlState())
        addrText.text = editAddress2
        phoneText.text = editPhone
        let usSwitch = ZJSwitch.init(frame: CGRect(x: screenWidth - 82, y: (45-28)/2, width: 60, height: 28))
        usSwitch.backgroundColor = UIColor.clear
        usSwitch.tintColor = CommonConfig.MainGrayColor
        usSwitch.onTintColor = CommonConfig.MainYellowColor
        usSwitch.textFont = UIFont.systemFont(ofSize: 13)
        usSwitch.onText = "常用"
        usSwitch.offText = ""
        usSwitch.addTarget(self, action: #selector(AddressViewController.handleSwitchEvent(_:)), for: .valueChanged)
        if editUsing == 1 {
            usSwitch.isOn = true
        }else{
            usSwitch.isOn = false
        }
        switchView.addSubview(usSwitch)
        tableView2.tableHeaderView?.frame = CGRect(x: 0, y: 0, width: screenWidth, height: 184 + 45 + (94 + 200 + 96)*newScale)
        view2.isHidden = !isAdd
        if isAdd {
            titlelbl.text = "新增收货地址"
            addBtn.setTitle("保存", for: UIControlState())
            addBtn.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        }else{
            titlelbl.text = "地址管理"
            addBtn.setTitle(IconFontIconName.icon_add_newaddresss.rawValue, for: UIControlState())
        }
        if !isAdd {
            getAddresslist()
        }

    }
    
    func getAddresslist(){
        RequestManager.RequestData(RequestUrl.Router.getAddressList(id: CommonConfig.UserInfoCache.userId), successCallBack: { (result) in
            print(result)
            self.addrList = result["content"]["addresslist"].arrayValue
            self.tableView.reloadData()
            }) { (fail) in
//                print(fail)
        }
    }
    
    func handleSwitchEvent(_ sender:ZJSwitch){
        if sender.isOn {
            self.editUsing = 1
        }else{
            self.editUsing = 0
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == self.tableView {
            return addrList.count
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return 117
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if  tableView == self.tableView {
            let cell = tableView.dequeueReusableCell(withIdentifier: "AddressViewCell") as! AddressViewCell
            cell.backgroundColor = UIColor.white
            cell.editingClick = editingClick
            cell.deleteClick = deleteClick
            cell.tag = indexPath.row
            var isUS:Bool = false
            if addrList.count != 0 {
                if addrList[indexPath.row]["is_default"].intValue == 1{
                    isUS = true
                }
                cell.setCellInfo(addrList[indexPath.row]["accept_name"].stringValue, addr1: addrList[indexPath.row]["address"].stringValue, addr2: addrList[indexPath.row]["addr"].stringValue, numb: addrList[indexPath.row]["mobile"].stringValue, isUsing: isUS)
            }
            cell.selectionStyle = .none
            return cell
        }else{
            let cell = tableView.dequeueReusableCell(withIdentifier: "cell")! as UITableViewCell
            cell.backgroundColor = UIColor.white
            cell.selectionStyle = .none
            return cell
        }
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if  tableView == self.tableView {
            if indexRow != nil{
                let cell = tableView.cellForRow(at: indexRow!) as! AddressViewCell
                cell.backgroundColor = UIColor.white
                indexRow = nil
            }
            if isGoods {
                let notice = Notification.init(name: Notification.Name(rawValue: "AddressRefresh"), object: ["address":addrList[indexPath.row]["address"].stringValue])
                NotificationCenter.default.post(notice)
                let notice2 = Notification.init(name: Notification.Name(rawValue: "refreshAddress"), object: ["address":addrList[indexPath.row]["address"].stringValue])
                NotificationCenter.default.post(notice2)
                let notice3 = Notification.init(name: Notification.Name(rawValue: "orderAddress"), object: ["address":addrList[indexPath.row]["address"].stringValue,"accept_name":addrList[indexPath.row]["accept_name"].stringValue,"addr":addrList[indexPath.row]["addr"].stringValue,"mobile":addrList[indexPath.row]["mobile"].stringValue,"id":addrList[indexPath.row]["id"].stringValue])
                let notice4 = Notification.init(name: Notification.Name(rawValue: "getAddress"), object: self, userInfo: ["address":addrList[indexPath.row]["address"].stringValue,"accept_name":addrList[indexPath.row]["accept_name"].stringValue,"addr":addrList[indexPath.row]["addr"].stringValue,"mobile":addrList[indexPath.row]["mobile"].stringValue,"id":addrList[indexPath.row]["id"].stringValue])
                NotificationCenter.default.post(notice3)
                NotificationCenter.default.post(notice4)
                
                self.navigationController?.popViewController(animated: true)
            }
//            //返回推广者的地址
//            if isPromoter{
//                
//                
//            }
        }
        
    }
    
    func tableView(_ tableView: UITableView, didHighlightRowAt indexPath: IndexPath) {
        if  tableView == self.tableView {
            let cell = tableView.cellForRow(at: indexPath) as! AddressViewCell
            cell.backgroundColor = UIColor.init(hexCode: "efefef")
            indexRow = indexPath
        }
    }
    
    var indexRow:IndexPath?
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        if !isAdd{
            if indexRow != nil{
                let cell = self.tableView.cellForRow(at: indexRow!) as! AddressViewCell
                cell.backgroundColor = UIColor.white
                indexRow = nil
            }
        }
    }
    
    func deleteClick(_ tag:NSInteger){
        print("delete")
        RequestManager.RequestData(RequestUrl.Router.deleteAddress(id: self.addrList[tag]["id"].stringValue,user_id: CommonConfig.UserInfoCache.userId), successCallBack: { (result) in
            self.noticeOnlyText("删除成功")
            self.addrList.remove(at: tag)
            self.tableView.reloadData()
            }) { (fail) in
                self.noticeOnlyText(fail)
        }
    }
    
    func editingClick(_ tag:NSInteger){
        let info = UIStoryboard(name: "Me", bundle: nil).instantiateViewController(withIdentifier: "AddressViewController") as! AddressViewController
        info.isAdd = true
        info.editName = self.addrList[tag]["accept_name"].stringValue
        info.editAddress = self.addrList[tag]["address"].stringValue
        info.editAddress2 = self.addrList[tag]["addr"].stringValue
        info.editPhone = self.addrList[tag]["mobile"].stringValue
        info.editUsing = self.addrList[tag]["is_default"].intValue
        info.provinceid = self.addrList[tag]["province"].stringValue
        info.cityid = self.addrList[tag]["city"].stringValue
        info.areaid = self.addrList[tag]["county"].stringValue
        info.editZip = self.addrList[tag]["zip"].stringValue
        info.editid = self.addrList[tag]["id"].stringValue
        self.navigationController?.pushViewController(info, animated: true)
    }
    
    @IBAction func addClick(_ sender: UIButton) {
        if isAdd {
            hiddenKeyborad()
            if phoneText.text?.characters.count == 11 {
                if !MySDKHelper.isMobile(phoneText.text!) {
                    self.noticeOnlyText("请输入正确的手机号码！")
                    return
                }
            }
            saveAddress()
        }else{
            let info = UIStoryboard(name: "Me", bundle: nil).instantiateViewController(withIdentifier: "AddressViewController") as! AddressViewController
            info.isAdd = true
            self.navigationController?.pushViewController(info, animated: true)
        }
    }
    
    @IBAction func backClick(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    
    @IBAction func citychoose(_ sender: UIButton) {
        hiddenKeyborad()
        MySDKHelper.getCityName{ (city) in
            print(city)
            let arr = city.components(separatedBy: "+")
            let arr2 = arr[1].components(separatedBy: " ")
            self.provinceid = (arr2[0])
            if (arr2.count) > 2{
                self.cityid = (arr2[1])
                if arr2.count == 3{
                    self.areaid = (arr2[2])
                }
            }
            print(self.provinceid,self.cityid,self.areaid)
            self.editAddress = (arr[0])
            self.addrBtn.setTitle(arr[0], for: UIControlState())
        }
    
    }

    
    @IBAction func saveClick(_ sender: UIButton) {
        hiddenKeyborad()
        if phoneText.text?.characters.count == 11 {
            if !MySDKHelper.isMobile(phoneText.text!) {
                self.noticeOnlyText("请输入正确的手机号码！")
                return
            }
        }
        saveAddress()
    }
    
    func saveAddress(){
        self.editName = name.text!
        self.editPhone = phoneText.text!
        self.editAddress2 = addrText.text!
        self.editZip = "000000";//邮编添加，待完成，province_data.xml文件
        RequestManager.RequestData(RequestUrl.Router.addressSave(accept_name: self.editName, zip: self.editZip, mobile: self.editPhone, user_id: CommonConfig.UserInfoCache.userId, addr: self.editAddress2, address: self.editAddress, province: self.provinceid, city: self.cityid, county: self.areaid, is_default: self.editUsing,id: self.editid), successCallBack: { (result) in
                self.noticeOnlyText("保存成功")
                self.navigationController?.popViewController(animated: true);
            
            }) { (fail) in
                self.noticeOnlyText(fail)
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        if isAdd {
            hiddenKeyborad()
        }
    }
    
    func hiddenKeyborad(){
        name.resignFirstResponder()
        addrText.resignFirstResponder()
        phoneText.resignFirstResponder()
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        //收起键盘
        textField.resignFirstResponder()
        return true
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if !isAdd {
            getAddresslist()
        }
        self.navigationController?.setNavigationBarHidden(true, animated: false)
        UIApplication.shared.setStatusBarStyle(.default, animated: false)
        self.setNeedsStatusBarAppearanceUpdate()
        
    }
    
//    override func viewWillDisappear(animated: Bool) {
//        super.viewWillDisappear(animated)
////        [[NSNotificationCenter defaultCenter] removeObserver:self name:@"getAddress" object:nil];
//        NSNotificationCenter.defaultCenter().removeObserver(self, name: "getAddress", object: nil)
//    }
    
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
