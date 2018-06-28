//
//  NewInfoViewController.swift
//  mibo
//
//  Created by TeamMac on 16/4/21.
//  Copyright © 2016年 TeamMac2. All rights reserved.
//

import UIKit
//import Haneke
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


class InfoViewController: UIViewController ,UITextFieldDelegate, UITableViewDelegate,UITableViewDataSource{
    @IBOutlet weak var pas: UILabel!
    @IBOutlet weak var nickName: UITextField!
    @IBOutlet weak var chooseImage: UIView!
    @IBOutlet weak var nickNameView: UIView!
    @IBOutlet weak var back: UIButton!
    @IBOutlet weak var loginOut: UIButton!
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var showBack: UIView!
    
    var policy = ""
    var signature = ""
    var img:UIImage!
    var imgStr = ""
    @IBAction func backClick(_ sender: AnyObject) {
        let notice = Notification.init(name: Notification.Name(rawValue: "refresh5"), object: nil)
        NotificationCenter.default.post(notice)
        self.navigationController?.popViewController(animated: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.back.setTitle(IconFontIconName.icon_back.rawValue, for: UIControlState())
        pas.layer.borderColor = CommonConfig.MainLightRedColor.cgColor
        pas.layer.borderWidth = 1
        pas.clipsToBounds = true
        loginOut.isHidden = true
        loginOut.layer.cornerRadius = 5
        loginOut.clipsToBounds = true
        let tap1 = UITapGestureRecognizer(target: self, action: #selector(InfoViewController.imageclose(_:)))
        showBack.addGestureRecognizer(tap1)
        showBack.isUserInteractionEnabled = true
        nickName.delegate = self
        nickName.tag = 10000
        nickName.addTarget(self, action: #selector(InfoViewController.textFieldDidChange(_:)), for: UIControlEvents.editingChanged)
        NotificationCenter.default.addObserver(self, selector: #selector(InfoViewController.keyboardShow(_:)), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(InfoViewController.keyboardHide(_:)), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
        chooseImage.isHidden = true
        nickNameView.isHidden = true
        self.showBack.isHidden = true
        self.tableView.reloadData()
        CommonConfig.getPolicy(CommonConfig.UserInfoCache.userId, type: "avatar", successCallBack: { (result) in
            self.signature = result["content"]["signature"].stringValue
            self.policy = result["content"]["policy"].stringValue
        })
        
    }
    
    func imageclose(_ tap:UITapGestureRecognizer){
        self.showBack.isHidden = true
        self.chooseImage.isHidden = true
        self.nickNameView.isHidden = true
    }
    
    @IBAction func loginOutClick(_ sender: AnyObject) {
        let appdelegete:AppDelegate = UIApplication.shared.delegate as! AppDelegate
        appdelegete.logOut()
        
//        (UIApplication.shared.delegate as! AppDelegate).logOut()
        
        self.navigationController?.popViewController(animated: true)
    }
    
    
    @IBAction func choosePic(_ sender: UIButton) {
        self.showTakePhoto()
    }
    
    @IBAction func choosePhoto(_ sender: UIButton) {
        
        self.showTakePic()
    }
    
    deinit{
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
//        let url = URL(string:imgStr)
//        let data = try! Data(contentsOf:url!)
        
//        print("传过来的值为\(url)")
//        if imgStr == ""
//        {
//            let img = UIImage(named:"wode2")
//        }
//        else
//        {
//            let img = UIImage(data:data)
//            print("123\(img)")
//        }
        self.tableView.reloadData()
        self.navigationController?.setNavigationBarHidden(true, animated: false)
        UIApplication.shared.setStatusBarStyle(.default, animated: false)
        self.setNeedsStatusBarAppearanceUpdate()
        
    }
    
    override var preferredStatusBarStyle : UIStatusBarStyle {
        return .default
    }
    
    override var prefersStatusBarHidden : Bool {
        return false
    }
    
    func textFieldDidChange(_ textFeild:UITextField){
        if textFeild == nickName{
            if textFeild.text?.characters.count > 10 {
                let str = textFeild.text! as NSString
                textFeild.text = str.substring(to: 10)
            }
        }
    }
    
    func textViewDidChange(_ textView: UITextView) {
        
        if  textView.text?.characters.count > 30 {
            let str = textView.text! as NSString
            textView.text = str.substring(to: 30)
        }
        
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        //收起键盘
        nickName.resignFirstResponder()
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    //keyboard
    func keyboardShow(_ notification: Notification) {
        let dict = NSDictionary(dictionary: notification.userInfo!)
        let keyboardValue = dict.object(forKey: UIKeyboardFrameEndUserInfoKey) as! NSValue
        let duration = Double(dict.object(forKey: UIKeyboardAnimationDurationUserInfoKey) as! NSNumber)
        UIView.animate(withDuration: duration, animations: {
            self.view.layoutIfNeeded()
            
        }, completion: nil)
        
    }
    
    func keyboardHide(_ notification : Notification) {
        let dict = NSDictionary(dictionary: notification.userInfo!)
        let duration = Double(dict.object(forKey: UIKeyboardAnimationDurationUserInfoKey) as! NSNumber)
        UIView.animate(withDuration: duration, animations: { () -> Void in
            self.view.layoutIfNeeded()
            
        }, completion: nil)
        
    }
    
    @IBAction func closeView(_ sender: AnyObject) {
        self.showBack.isHidden = true
        self.nickNameView.isHidden = true
        self.chooseImage.isHidden = true
    }
    
    @IBAction func sureClick(_ sender: UIButton) {
        let nickname = nickName.text!
        self.showBack.isHidden = true
        self.nickNameView.isHidden = true
        self.chooseImage.isHidden = true
        RequestManager.RequestData(RequestUrl.Router.saveNickName(new: nickname, user_id: CommonConfig.UserInfoCache.userId),showLoading: true, successCallBack: { (result) in
            CommonConfig.UserInfoCache.nickName = nickname
            self.tableView.reloadData()
        }) { (fail) in
            
        }
    }
    
    func showTakePhoto(){
        let cameraViewController = ALCameraViewController(croppingEnabled: true, allowsLibraryAccess: true) { (image, value) -> Void in
            if image != nil {
                self.img = image
                self.tableView.reloadData()
                self.uploadImage(image!,successCallBack: {
                    print("照片上传成功")
                    let notifiction = NotificationCenter.default
                    notifiction.post(name:NSNotification.Name(rawValue: "referHeaderImage"), object: nil)
                }, failCallBack: {
                    
                })
            }
            
            self.dismiss(animated: true, completion: nil)
        }
        
        self.present(cameraViewController, animated: true, completion: nil)
    }
    
    func showTakePic(){
        let libraryViewController = ALCameraViewController.imagePickerViewController(true) { (image, value) -> Void in
            if image != nil {
                self.img = image
                self.tableView.reloadData()
                self.uploadImage(image!,successCallBack: {
                    print("图片上传成功2")
                    
//                    NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:urlString]];
//                    UIImage *image = [UIImage imageWithData:data]; // 取得图片
//
//                    // 本地沙盒目录
//                    NSString *path = NSHomeDirectory();
//                    // 得到本地沙盒中名为"MyImage"的路径，"MyImage"是保存的图片名
//                    NSString *imageFilePath = [path stringByAppendingString:@"/Documents/MyHeader.jpg"];
//                    // 将取得的图片写入本地的沙盒中，其中0.5表示压缩比例，1表示不压缩，数值越小压缩比例越大
//                    BOOL success = [UIImageJPEGRepresentation(image, 0.5) writeToFile:imageFilePath  atomically:YES];
//                    //            BOOL success = [UIImagePNGRepresentation(image) writeToFile:imageFilePath atomically:YES];
//                    if (success){
//                        NSLog(@"图片写入本地成功");
//                    }
                    if let imageData = UIImageJPEGRepresentation(image!, 0.5) as NSData? {
                        let fullPath = NSHomeDirectory().appending("/Documents/").appending("MyHeader.jpg")
                        imageData.write(toFile: fullPath, atomically: true)
                        print("fullPath=\(fullPath)")
                    }
                    let notifiction = NotificationCenter.default
                    notifiction.post(name:NSNotification.Name(rawValue: "referHeaderImage"), object: nil)
                }, failCallBack: {
                    
                })
            }
            
            self.dismiss(animated: true, completion: nil)
            
            if value {
                self.showTakePhoto()
            }
            
        }
        
        self.present(libraryViewController, animated: true, completion: nil)
    }
    
    //上传封面
    func uploadImage(_ images:UIImage, successCallBack: @escaping ()->Void,failCallBack: @escaping()->Void){
        SwiftNotice.wait()
        let imageData = UIImageJPEGRepresentation(images, 0.5)
        RequestManager.UploadFile(imageData!, name: "UserPhoto.jpg",policy: self.policy,signature:self.signature ,
                                  successCallBack: { resultJson in
//                                    print(resultJson)
                                    CommonConfig.UserInfoCache.photoUrl =  CommonConfig.getImageUrl(resultJson["url"].stringValue)
                                    CommonConfig.UserInfoCache.photo = NSURL(string: CommonConfig.getImageUrl(resultJson["url"].stringValue)) as! URL
//                                    print(CommonConfig.UserInfoCache.photoUrl)
                                    SwiftNotice.clear()
                                    CommonConfig.avatarImg = self.img
                                    
                                    successCallBack()
        },
                                  failCallBack: { failStr in
                                    SwiftNotice.clear()
                                    failCallBack()
        }
        )
    }
    
    
    
    func cityChoose(_ tap:UITapGestureRecognizer) {
        let cityVC = CFCityPickerVC()
        //设置热门城市
        cityVC.hotCities = ["北京","上海","广州","成都","杭州","重庆"]
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        //解析字典数据
        let cityModels = cityModelsPrepare()
        cityVC.cityModels = cityModels
        self.navigationController?.pushViewController(cityVC, animated: true)
        //选中了城市
        cityVC.selectedCityModel = { (cityModel: CFCityPickerVC.CityModel) in
            let province = self.getProvince(cityModels, city: cityModel)
            //            let city = province + cityModel.name + "市"
            //            self.city.text = province
            
            
            cityVC.navigationController?.popViewController(animated: true)
            
        }
    }
    
    func getProvince(_ cityModels:[CFCityPickerVC.CityModel] ,city:CFCityPickerVC.CityModel) -> String{
        var province = ""
        for cityModel in cityModels {
            if cityModel.id == city.pid {
                if cityModel.spell.range(of: "shi") == nil {
                    if cityModel.spell.range(of: "qu") != nil {
                        province = cityModel.name
                    }else{
                        province = cityModel.name + "省"
                    }
                }
                if city.spell.range(of: "diqu") != nil {
                    province = province + city.name
                }else{
                    province = province + city.name + "市"
                }
                break
            }
        }
        return province
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 6
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == 0 {
            return 70
        }
        return 48
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "InfoViewCell") as! InfoViewCell
        cell.backgroundColor = UIColor.white
        if indexPath.row == 0 {
            cell.setCellContent("头像", texts: "", images: img, type: 0)
            
        }else if indexPath.row == 1 {
            cell.setCellContent(CommonConfig.UserInfoCache.nickName, texts: "修改", images: img, type: 1)
        }else if indexPath.row == 2 {
            cell.setCellContent("修改账户密码", texts: "", images: img, type: 2)
        }else if indexPath.row == 3 {
            cell.setCellContent("支付密码", texts: "", images: img, type: 2)
        }else if indexPath.row == 4 {
           // print(CommonConfig.UserInfoCache.account)
            cell.setCellContent("已绑定手机", texts: changePhone(CommonConfig.UserInfoCache.phone), images: img, type: 1)
        }else if indexPath.row == 5 {
            cell.setCellContent("实名验证", texts: "", images: img, type: 2)
        }
        cell.selectionStyle = .none
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexRow != nil{
            let cell = tableView.cellForRow(at: indexRow!) as! InfoViewCell
            cell.backgroundColor = UIColor.white
            indexRow = nil
        }
        tableView.deselectRow(at: indexPath, animated: false)
        if indexPath.row == 0 {
            self.showBack.isHidden = false
            self.chooseImage.isHidden = false
            self.nickNameView.isHidden = true
        }else if indexPath.row == 1 {
            self.showBack.isHidden = false
            self.nickNameView.isHidden = false
            self.chooseImage.isHidden = true
        }else if indexPath.row == 2 {
            let register = UIStoryboard(name: "Home", bundle: nil).instantiateViewController(withIdentifier: "RegisterInputPhoneViewController") as! RegisterInputPhoneViewController
            register.isReset = 3
            self.navigationController?.pushViewController(register, animated: true)
        }else if indexPath.row == 3 {///支付密码
            
            let settingPayController = SettingPayPasswordViewController.init();
            self.navigationController?.pushViewController(settingPayController,animated:true)
        }else if indexPath.row == 4 {
            
        }
        else if indexPath.row == 5 {
            
            if CommonConfig.UserInfoCache.verified == "1" {
                let auther = UIStoryboard(name: "Me", bundle: nil).instantiateViewController(withIdentifier: "AuthenticationThroughViewController") as! AuthenticationThroughViewController
                
                self.navigationController?.pushViewController(auther,animated:true)
            }else{
                let auther = UIStoryboard(name: "Me", bundle: nil).instantiateViewController(withIdentifier: "IdentityAuthenticationViewController") as! IdentityAuthenticationViewController
                auther.hidesBottomBarWhenPushed = true;
                self.navigationController?.pushViewController(auther,animated:true)
            }
            
            
        }
    }
    
    func tableView(_ tableView: UITableView, didHighlightRowAt indexPath: IndexPath) {
        
        let cell = tableView.cellForRow(at: indexPath) as! InfoViewCell
        cell.backgroundColor = UIColor.init(hexCode: "efefef")
        indexRow = indexPath
    }
    
    var indexRow:IndexPath?
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        if indexRow != nil{
            let cell = tableView.cellForRow(at: indexRow!) as! InfoViewCell
            cell.backgroundColor = UIColor.white
            indexRow = nil
        }
    }
    
    func changePhone(_ phone:String) ->String{
        let numb = NSString.init(string: phone)
        var new = numb.substring(to: 3)
        new = new + "****"
        new = new + numb.substring(from: 7)
        return new
    }
    
}
extension UIViewController{
    
    /** 解析字典数据，由于swift中字典转模型工具不完善，这里先手动处理 */
    func cityModelsPrepare() -> [CFCityPickerVC.CityModel]{
        //加载plist，你也可以加载网络数据
        let plistUrl = Bundle.main.url(forResource: "City", withExtension: "plist")!
        let cityArray = NSArray(contentsOf: plistUrl) as! [NSDictionary]
        var cityModels: [CFCityPickerVC.CityModel] = []
        for dict in cityArray{
            let cityModel = parse(dict)
            cityModels.append(cityModel)
        }
        return cityModels
    }
    
    func parse(_ dict: NSDictionary) -> CFCityPickerVC.CityModel{
        let id = dict["id"] as! Int
        let pid = dict["pid"] as! Int
        let name = dict["name"] as! String
        let spell = dict["spell"] as! String
        let cityModel = CFCityPickerVC.CityModel(id: id, pid: pid, name: name, spell: spell)
        let children = dict["children"]
        if children != nil { //有子级
            var childrenArr: [CFCityPickerVC.CityModel] = []
            for childDict in children as! NSArray {
                let childrencityModel = parse(childDict as! NSDictionary)
                childrenArr.append(childrencityModel)
            }
            cityModel.children = childrenArr
        }
        return cityModel
    }
    
}
/*
 // MARK: - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
 // Get the new view controller using segue.destinationViewController.
 // Pass the selected object to the new view controller.
 }
 */


