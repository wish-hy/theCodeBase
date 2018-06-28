//
//  ExpressViewController.swift
//  huabi
//
//  Created by TeamMac2 on 16/10/10.
//  Copyright © 2016年 ltl. All rights reserved.
//

import UIKit
import SwiftyJSON

class ExpressViewController: UIViewController ,UITableViewDelegate,UITableViewDataSource{

    
    
    @IBOutlet weak var backBtn: UIButton!
    
    @IBOutlet weak var mainBtn: UIButton!
    
    @IBOutlet weak var orderNo: UILabel!
    
    @IBOutlet weak var tableView: UITableView!
    
    var showArr:Array<Array<JSON>> = []
    var info:JSON!
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        print(info)
        
        initSetting()
//        for i in 0..<info["imglist"].count {
            getexpressInfo()
//        }
        
        // Do any additional setup after loading the view.
    }
    
    
    func getexpressInfo(_ row:NSInteger = 0){
        let orderid = info["imglist"][row]["order_id"].stringValue
        RequestManager.RequestData(RequestUrl.Router.getexpressDetail(userid: CommonConfig.UserInfoCache.userId, orderid: info["id"].stringValue as NSString), showLoading: true, successCallBack: { (result) in
//            print("express",result)
            var detail = result["content"]["order"]["package"]
            for i in 0..<detail.count{
                self.getexpressDetail(detail[i]["express_info"]["alias"].stringValue as NSString
                    , expreNo: detail[i]["express_info"]["express_no"].stringValue
                )
            }
            
            }) { (fail) in
                
        }
    }
    
    func getexpressDetail(_ type:NSString,expreNo:String){
        RequestManager.RequestData(RequestUrl.Router.getOrderexpress(userid: CommonConfig.UserInfoCache.userId, type: type, orderNo: expreNo as NSString), showLoading: true, successCallBack: { (result) in
//            print("express detail",result)
            self.showArr.append(result["content"]["expressdata"].arrayValue)
            self.tableView.reloadData()
            }) { (fail) in
                self.noticeOnlyText(fail)
        }
    }
    
    func initSetting(){
        showArr = []
        backBtn.setTitle(IconFontIconName.icon_back.rawValue, for: UIControlState())
        mainBtn.setTitle(IconFontIconName.icon_goods_backhome.rawValue, for: UIControlState())
        orderNo.text = "订单编号:" + info["order_no"].stringValue
        tableView.delegate = self
        tableView.dataSource = self
        tableView.reloadData()
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return info["imglist"].count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if showTag == section {
            if showArr.count == 0 {
                return 0
            }
            return showArr[section].count
        }else{
            return 0
        }
    }

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 85
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.1
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if showArr[indexPath.section].count != 0 {
            let size = CommonConfig.getTextRectSize(showArr[indexPath.section][indexPath.row]["context"].stringValue as NSString, font: UIFont.systemFont(ofSize: 13), size: CGSize(width: screenWidth - 100, height: 0))
            return size.height + 50
        }else{
            return 0
        }

    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ExpressCell") as! ExpressCell
        cell.tag = indexPath.row
        if showArr[indexPath.section].count != 0{
            var color = UIColor.init(hexCode: "8a8a8a")
            if indexPath.row == 0 {
                cell.top.isHidden = true
                cell.img.isHidden = false
                color = CommonConfig.MainFontBlackColor
            }else if indexPath.row == showArr[indexPath.section].count - 1{
                cell.bottom.isHidden = true
                cell.img.isHidden = true
            }else{
                cell.top.isHidden = false
                cell.bottom.isHidden = false
                cell.img.isHidden = true
            }
            cell.initSetting(showArr[indexPath.section][indexPath.row]["context"].stringValue, time: showArr[indexPath.section][indexPath.row]["time"].stringValue, phone: "",colors: color)
            
        }
        
        cell.phoneClick = phoneClick
        cell.selectionStyle = .none
        return cell
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let head = Bundle.main.loadNibNamed("ExpressDetailView", owner: nil, options: nil)?.first as? ExpressDetailView
        head?.frame = CGRect(x: 0, y: 0, width: screenWidth, height: 85)
        head?.img1.hnk_setImageFromURL(URL: URL(string: CommonConfig.getImageUrl(info["imglist"][section]["img"].stringValue))! as NSURL, placeholder: UIImage(named: CommonConfig.imageDefaultName))
        head?.titlelbl.text = info["imglist"][section]["name"].stringValue
        head?.imgsClick = imgClick
        head?.btnClick = showClick
        head?.tag = section
        if showTag == section {
            head?.btnSelect(1)
        }
        return head
    }
    
    var lastTag:NSInteger = -1
    var showTag:NSInteger = -1
    func showClick(_ tags:Array<NSInteger>){
        if tags[1] > 0{
            showTag = tags[0]
        }else{
            showTag = -1
        }
        lastTag = tags[0]
        tableView.reloadData()
        
    }

    
    func imgClick(_ tag:NSInteger){
//        print(info["imglist"][tag]["goods_id"].stringValue)
       CommonConfig.getProductDetail(self, goodsID: info["imglist"][tag]["goods_id"].stringValue)
    }
    
    func phoneClick(_ phone:String){
//        print(phone)
        let numb = "tel:" + phone
        //拨打电话
        let callview = UIWebView.init()
        callview.loadRequest(URLRequest.init(url: URL.init(string: numb)!))
        self.view.addSubview(callview)
    }
    
    @IBAction func backClick(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func mainClick(_ sender: UIButton) {
        (UIApplication.shared.delegate as! AppDelegate).showMainPage()
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
    
    override var preferredStatusBarStyle : UIStatusBarStyle {
        return .default
    }
    
    override var prefersStatusBarHidden : Bool {
        return false
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
