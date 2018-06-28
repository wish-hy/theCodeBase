//
//  AfterSalesController.swift
//  huabi
//
//  Created by TeamMac2 on 16/9/14.
//  Copyright © 2016年 ltl. All rights reserved.
//

import UIKit
import SwiftyJSON

class AfterSalesController: UIViewController,UITableViewDelegate,UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout,UIAlertViewDelegate,UITextViewDelegate,UITextFieldDelegate,UITableViewDataSource{
    @available(iOS 2.0, *)
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 0;
    }


    @IBOutlet weak var backBtn: UIButton!
    @IBOutlet weak var mainBtn: UIButton!
    @IBOutlet weak var titlelbl: UILabel!
    @IBOutlet weak var view1: UIView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var img: UIImageView!
    @IBOutlet weak var goodsName: UILabel!
    @IBOutlet weak var goodsPrice: UILabel!
    @IBOutlet weak var goodsNum: UILabel!
    @IBOutlet weak var tuiBtn: UIButton!
    @IBOutlet weak var huanBtn: UIButton!
    @IBOutlet weak var fixBtn: UIButton!
    @IBOutlet weak var numlbl: UILabel!
    @IBOutlet weak var numtext: UILabel!
    @IBOutlet weak var havelbl: UILabel!
    @IBOutlet weak var unhavelbl: UILabel!
    @IBOutlet weak var questiontext: UITextView!
    @IBOutlet weak var imgCollection: UICollectionView!
    @IBOutlet weak var nextBtn: UIButton!
    
    @IBOutlet weak var collectionH: NSLayoutConstraint!
    
    @IBOutlet weak var view2: UIView!
    @IBOutlet weak var tableView2: UITableView!
    @IBOutlet weak var backWayBtn: UIButton!
    @IBOutlet weak var nametext: UITextField!
    @IBOutlet weak var mobiletext: UITextField!
    @IBOutlet weak var addressBtn: UIButton!
    @IBOutlet weak var addresstext: UITextField!
    @IBOutlet weak var submitBtn: UIButton!
    
    @IBOutlet weak var view11: UIView!
    
    @IBOutlet weak var view22: UIView!
    @IBOutlet weak var view2W: NSLayoutConstraint!
    
    var suggest = ""
    let placeholders = "请您在此描述详细问题"
    var goodsInfo:JSON!
    var goodsRow = 0
    var imgList:Array<UIImage> = []
    var btnList:Array<UIButton> = []
    var fixType = 1
    var proof = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setting()
        // Do any additional setup after loading the view.
    }
    
    func setting(){
        CommonConfig.getPolicy(CommonConfig.UserInfoCache.userId, type: "support", successCallBack: { (result) in
            self.signature = result["content"]["signature"].stringValue
            self.policy = result["content"]["policy"].stringValue
        })
        let tapGesturer = UITapGestureRecognizer(target: self, action: #selector(self.hiddenkeyborad))
        view11.isUserInteractionEnabled = true
        view11.addGestureRecognizer(tapGesturer)
        let tapGesturer2 = UITapGestureRecognizer(target: self, action: #selector(self.hiddenkeyborad))
        view22.isUserInteractionEnabled = true
        view22.addGestureRecognizer(tapGesturer2)
        tableView.tableHeaderView?.frame = CGRect(x: 0, y: 0, width: screenWidth, height: 900)
        tableView2.tableHeaderView?.frame = CGRect(x: 0, y: 0, width: screenWidth, height: 500)
        backBtn.setTitle(IconFontIconName.icon_back.rawValue, for: UIControlState())
        mainBtn.setTitle(IconFontIconName.icon_goods_backhome.rawValue, for: UIControlState())
        btnList = [tuiBtn,huanBtn,fixBtn]
        setBtnColor(0)
        numlbl.layer.borderWidth = 1
        numlbl.layer.borderColor = CommonConfig.MainFontGrayColor.cgColor
        havelbl.layer.borderColor = CommonConfig.MainFontGrayColor.cgColor
        havelbl.layer.borderWidth = 1
        havelbl.layer.cornerRadius = 19.0/2.0
        havelbl.clipsToBounds = true
        unhavelbl.layer.borderColor = CommonConfig.MainFontGrayColor.cgColor
        unhavelbl.layer.borderWidth = 1
        unhavelbl.layer.cornerRadius = 19.0/2.0
        unhavelbl.clipsToBounds = true
        backWayBtn.layer.borderColor = CommonConfig.MainRedColor.cgColor
        backWayBtn.layer.borderWidth = 1
        backWayBtn.clipsToBounds = true
        addressBtn.layer.borderColor = CommonConfig.MainFontGrayColor.cgColor
        addressBtn.layer.borderWidth = 1
        addressBtn.layer.cornerRadius = 2
        addressBtn.clipsToBounds = true
        submitBtn.layer.borderColor = CommonConfig.MainFontGrayColor.cgColor
        submitBtn.layer.borderWidth = 1
        submitBtn.layer.cornerRadius = 5
        submitBtn.clipsToBounds = true
        questiontext.text = placeholders
        questiontext.textColor = UIColor.init(hexCode: "8a8a8a")
        questiontext.font = UIFont.systemFont(ofSize: 12)
        setlblColor(0)
        img.hnk_setImageFromURL(URL: URL(string: CommonConfig.getImageUrl(goodsInfo["imglist"][goodsRow]["img"].stringValue))! as NSURL, placeholder: UIImage(named: CommonConfig.imageDefaultName))
        goodsNum.text = "x" + goodsInfo["imglist"][goodsRow]["goods_nums"].stringValue
        goodsName.text = goodsInfo["imglist"][goodsRow]["name"].stringValue
        goodsPrice.text = "¥" + goodsInfo["imglist"][goodsRow]["goods_price"].stringValue
        numtext.text = "您最多可提交数量为\(goodsInfo["imglist"][goodsRow]["goods_nums"].intValue)个"
        addresstext.text = goodsInfo["addr"].stringValue
        view2W.constant = screenWidth + 16
        self.view.layoutIfNeeded()
        getAddressText()
        self.view2.isHidden = true
//        print(goodsInfo)
//        let url = URL(string: "http://domain.com/image.png")!
//        img.kf.setImage(with: url,
//                                              placeholder: nil,
//                                              options: [.transition(.fade(1))],
//                                              progressBlock: nil,
//                                              completionHandler: nil)
    }
    
    func getAddressText(){
        let data = UserDefaults.standard.array(forKey: "citydata")
        let json = JSON.init(data!)
        var text = ""
        for i in 0..<json.count {
            let dic = json[i]
            if dic["id"].stringValue == goodsInfo["province"].stringValue{
                for j in 0..<dic["cities"].count {
                    let dic2 = dic["cities"][i]
                    if dic2["id"].stringValue == goodsInfo["city"].stringValue {
                        for k in 0..<dic2["areas"].count {
                            if dic2["areas"][k]["id"].stringValue == goodsInfo["county"].stringValue {
                                text = dic2["areas"][k]["name"].stringValue
                                break
                            }
                        }
                        text = dic2["name"].stringValue + " " + text
                        break
                    }
                }
                text = dic["name"].stringValue + " " + text
                break
            }
        }
        self.addressBtn.setTitle(text, for: UIControlState())
        
    }
    
    func setlblColor(_ tag:NSInteger){
        proof = tag
        if tag == 1 {
            havelbl.backgroundColor = CommonConfig.MainRedColor
            unhavelbl.backgroundColor = UIColor.white
        }else{
            unhavelbl.backgroundColor = CommonConfig.MainRedColor
            havelbl.backgroundColor = UIColor.white
        }
    
    }
    
    func setBtnColor(_ tag:NSInteger){
        fixType = tag + 1
        for i in 0..<btnList.count {
            let btn = btnList[i]
            if i == tag {
                btn.setTitleColor(CommonConfig.MainRedColor, for: UIControlState())
                btn.layer.borderColor = CommonConfig.MainRedColor.cgColor
                btn.layer.borderWidth = 1
            }else{
                btn.setTitleColor(CommonConfig.MainFontGrayColor, for: UIControlState())
                btn.layer.borderColor = CommonConfig.MainFontGrayColor.cgColor
                btn.layer.borderWidth = 1
            }
        }
    }
    
    func hiddenkeyborad(){
        questiontext.resignFirstResponder()
        nametext.resignFirstResponder()
        mobiletext.resignFirstResponder()
        addresstext.resignFirstResponder()
    }
    //MARK: -UITextViewDelegate
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        let text = textView.text
        if text == placeholders {
            questiontext.text = ""
            questiontext.textColor = CommonConfig.MainFontBlackColor
            questiontext.font = UIFont.systemFont(ofSize: 12)
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView == questiontext {
            let text = textView.text
            if text?.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines) .characters.count == 0 {
                questiontext.text = placeholders
                questiontext.textColor = UIColor.init(hexCode: "8a8a8a")
                questiontext.font = UIFont.systemFont(ofSize: 12)
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
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func  tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 0
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell")! as UITableViewCell
        cell.backgroundColor = UIColor.white
        cell.selectionStyle = .none
        return cell
    }
    
    func numberOfSectionsInTableView(collectionView: UICollectionView) -> Int {
        return 1
    }
    
    //实现UICollectionViewDataSource
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int
    {
        //返回记录数
        return imgList.count + 1
    }
    
    //实现UICollectionViewDataSource
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell
    {
        //返回Cell内容，这里我们使用刚刚建立的defaultCell作为显示内容
        let cell  = collectionView.dequeueReusableCell(withReuseIdentifier: "ImageCollectionCell", for: indexPath) as! ImageCollectionCell
        cell.backgroundColor = UIColor.white
        if indexPath.row == imgList.count {
            cell.img.isHidden = true
        }else{
            cell.img.isHidden = false
            if imgList.count > 0 {
                cell.img.image = imgList[indexPath.row]
            }
        }
        return cell
    }
    
    //实现UICollectionViewDataSource
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath)
    {
        //某个Cell被选择的事件处理
//        print(indexPath.row)
        if indexPath.row == imgList.count{
            let alert = UIAlertView.init(title: "提示", message: "添加图片", delegate: self, cancelButtonTitle: "取消", otherButtonTitles: "相机", "相册")
            alert.show()
        }else{
            imgList.remove(at: indexPath.row)
            self.imgCollection.reloadData()
        }
        
    }
    //#pragma mark --UICollectionViewDelegateFlowLayout
    //定义每个UICollectionView 的大小
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 66, height: 66)
    }
    //定义每个UICollectionView 的 margin
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsetsMake(0, 0, 0, 10)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 1
    }

    func showTakePhoto(){
        let cameraViewController = ALCameraViewController(croppingEnabled: true, allowsLibraryAccess: true) { (image, value) -> Void in
            if image != nil {
                self.imgList.append(image!)
                if CGFloat(self.imgList.count) * 76 > screenWidth - 20 {
                    self.collectionH.constant = 132
                }else{
                    self.collectionH.constant = 66
                }
                self.view.layoutIfNeeded()
                self.imgCollection.reloadData()
            }
            
            self.dismiss(animated: true, completion: nil)
        }
        
        self.present(cameraViewController, animated: true, completion: nil)
    }
    
    func showTakePic(){
        let libraryViewController = ALCameraViewController.imagePickerViewController(true) { (image, value) -> Void in
            if image != nil {
                self.imgList.append(image!)
                if CGFloat(self.imgList.count) * 76 > screenWidth - 20 {
                    self.collectionH.constant = 132
                }else{
                    self.collectionH.constant = 66
                }
                self.view.layoutIfNeeded()
                self.imgCollection.reloadData()
            }
            
            self.dismiss(animated: true, completion: nil)
            if value {
                self.showTakePhoto()
            }
            
        }
        
        self.present(libraryViewController, animated: true, completion: nil)
    }
    
    func alertView(_ alertView: UIAlertView, clickedButtonAt buttonIndex: Int) {
        if alertView.cancelButtonIndex != buttonIndex {
            if buttonIndex == 0 {
                showTakePic()
            }else{
                showTakePhoto()
            }
        }
    }
    
    var policy = ""
    var signature = ""
    //上传封面
    func uploadImage(_ images:UIImage, successCallBack: @escaping ()->Void,failCallBack: @escaping ()->Void){
        let imageData = UIImageJPEGRepresentation(images, 0.5)
        RequestManager.UploadFile(imageData!, name: "SalePhoto.jpg",policy: self.policy,signature: self.signature ,
                                  successCallBack: { resultJson in
                                    
                                    successCallBack()
            },
                                  failCallBack: { failStr in
                                    failCallBack()
            }
        )
    }
    
    func unhaveClick(_ sender: UIButton) {
        setlblColor(0)
    }
    
    func haveClick(_ sender: UIButton) {
        setlblColor(1)
    }
    
    func addClick(_ sender: UIButton) {
        if numlbl.text == goodsInfo["imglist"][goodsRow]["goods_nums"].stringValue {
            return
        }else{
            numlbl.text = "\(Int(numlbl.text!)! + 1)"
        }
    }
    
    func reduceClick(_ sender: UIButton) {
        if numlbl.text == "1" {
            return
        }else{
            numlbl.text = "\(Int(numlbl.text!)! - 1)"
        }
    }
    
    func fixClick(_ sender: UIButton) {
        setBtnColor(2)
    }
    
    func huanClick(_ sender: UIButton) {
        setBtnColor(1)
    }
    
    func tuiClick(_ sender: UIButton) {
        setBtnColor(0)
    }
    
    func nextClick(_ sender: AnyObject) {
        
        viewanimation()
    }
    
    func backWayClick(_ sender: UIButton) {
        
    }
    
    func chooseAddress(_ sender: UIButton) {
    
        MySDKHelper.getCityName{ (city) in
//            print(city)
            let arr = city.components(separatedBy: "+")
            let arr2 = arr[1].components(separatedBy: " ")
            self.goodsInfo["province"].stringValue = (arr2[0])
            if (arr2.count) > 2{
                self.goodsInfo["city"].stringValue = (arr2[1])
                if arr2.count == 3{
                   self.goodsInfo["county"].stringValue = (arr2[2])
                }
            }
            self.addressBtn.setTitle(arr[0], for: UIControlState())
        }
        
    }
    
    func submitClick(_ sender: UIButton) {
        if suggest == "" || nametext.text == "" || mobiletext.text == "" || addresstext.text == "" {
            self.noticeOnlyText("信息不能为空")
            return
        }
        submitData()
    }
    
    func backClick(_ sender: AnyObject) {
        if self.view2W.constant == -16 {
            viewanimation()
            return
        }
        self.navigationController?.popViewController(animated: true)
    }
    
    func mainclick(_ sender: AnyObject) {
        (UIApplication.shared.delegate as! AppDelegate).showMainPage()
    }
    
    func viewanimation(){
        UIView.animate(withDuration: 1, animations: { 
            if self.view2W.constant == -16 {
                self.view2W.constant = screenWidth + 16
            }else{
                self.view2W.constant = -16
            }
            self.view.layoutIfNeeded()
        }) 
    }
    
    func submitData(){
        RequestManager.RequestData(RequestUrl.Router.saleSupport(user_id: CommonConfig.UserInfoCache.userId, type: fixType, num: goodsInfo["imglist"][goodsRow]["goods_nums"].intValue, desc: suggest, proof: proof, province: self.goodsInfo["province"].stringValue, city: self.goodsInfo["city"].stringValue, county: self.goodsInfo["county"].stringValue, receiver: nametext.text!, addr: addresstext.text!, mobile: mobiletext.text!, id: goodsInfo["imglist"][goodsRow]["id"].stringValue), showLoading: true, successCallBack: { (result) in
//            print(result)
            self.noticeOnlyText("提交成功")
        
            }) { (fail) in
//                print(fail)
                self.noticeOnlyText("提交失败")
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
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
