//
//  OrderViewController.swift
//  huabi
//
//  Created by TeamMac2 on 16/9/10.
//  Copyright © 2016年 ltl. All rights reserved.
//

import UIKit
import SwiftyJSON
import MJRefresh

class OrderViewController: UIViewController ,UITableViewDelegate,UITableViewDataSource{

    @IBOutlet weak var titlelbl: UILabel!
    @IBOutlet weak var backBtn: UIButton!
    @IBOutlet weak var mainBtn: UIButton!
    
    @IBOutlet weak var noneView: UIView!
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var view1: UIView!
    
    @IBOutlet weak var view2: UIView!
    
    @IBOutlet weak var tableView2: UITableView!
    
    var status = "all" //all 所有订单  unpay  未支付订单  undelivery  未发货订单  unreceived  未收货订单
    var orderList:Array<JSON> = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationCenter.default.addObserver(self, selector: #selector(self.refreshOrder), name: NSNotification.Name(rawValue: "refreshOrder"), object: nil)   //刷新通知
        self.tableView.mj_header = MJRefreshNormalHeader(refreshingTarget: self, refreshingAction: #selector(self.headRefresh))
        self.tableView.mj_footer = MJRefreshAutoNormalFooter(refreshingTarget: self, refreshingAction: #selector(self.footRefresh))
        self.tableView2.mj_header = MJRefreshNormalHeader(refreshingTarget: self, refreshingAction: #selector(self.headRefresh))
        self.tableView2.mj_footer = MJRefreshAutoNormalFooter(refreshingTarget: self, refreshingAction: #selector(self.footRefresh))
        if status == "all" {
            titlelbl.text = "我的订单"
        }else if status == "unpay"{
            titlelbl.text = "待付款"
        }else if status == "undelivery"{
            titlelbl.text = "待发货"
        }else if status == "unreceived"{
            titlelbl.text = "待收货"
        }else if status == "done"{
            titlelbl.text = "已完成"
        }
        backBtn.setTitle(IconFontIconName.icon_back.rawValue, for: UIControlState())
        mainBtn.setTitle(IconFontIconName.icon_goods_backhome.rawValue, for: UIControlState())
        if status == "comment" || status == "fix"{
            titlelbl.text = "待评价"
            if status == "fix" {
                titlelbl.text = "在线退换货"
            }
            self.tableView.isHidden = true
            self.tableView2.isHidden = false
            self.view2.isHidden = false
        }else{
            self.tableView.isHidden = false
            self.view2.isHidden = true
            self.tableView2.isHidden = true
        }
        getOrderInfo()
        // Do any additional setup after loading the view.
    }
    var page = 1
    var pageCount = 1
    func headRefresh(){
        if status == "comment" || status == "fix"{
            self.tableView2.mj_header.beginRefreshing()
            self.tableView2.reloadData()
            self.tableView2.mj_header.endRefreshing()
        }else{
            self.tableView.mj_header.beginRefreshing()
            self.tableView.reloadData()
            self.tableView.mj_header.endRefreshing()
        }
        
    }
    
    func footRefresh(){
        page += 1
        if status == "comment" || status == "fix"{
            self.tableView2.mj_footer.beginRefreshing()
        }else{
            self.tableView.mj_footer.beginRefreshing()
        }
        getOrderInfo()
    }
    
    func reloadOrderInfo(){
        var url = RequestUrl.Router.getMyOrderList(status: status, page: page, user_id: CommonConfig.UserInfoCache.userId)
        if self.status == "comment" {
            url = RequestUrl.Router.getMyReview(status: "unreview", page: page, userid: CommonConfig.UserInfoCache.userId)
        }else if self.status == "fix" {
            url = RequestUrl.Router.getMyOrderList(status: "all", page: page, user_id: CommonConfig.UserInfoCache.userId)
        }
        RequestManager.RequestData(url,successCallBack: { (result) in
            self.pageCount = result["content"]["page_info"]["page_count"].intValue
            if self.status == "comment"{
                for i in 0..<result["content"]["review"].count{
                    self.orderList.append(result["content"]["review"][i])
                }
                if result["content"]["review"].count < 10{
                    self.tableView2.mj_footer.endRefreshingWithNoMoreData()
                    self.tableView2.mj_footer.isHidden = true
                }else{
                    self.tableView2.mj_footer.endRefreshing()
                }
                self.tableView2.reloadData()
                
            }else{
                for i in 0..<result["content"]["order"].count{
                    self.orderList.append(result["content"]["order"][i])
                }
                if self.status == "fix" {
                    if result["content"]["order"].count < 10{
                        self.tableView2.mj_footer.endRefreshingWithNoMoreData()
                        self.tableView2.mj_footer.isHidden = true
                    }else{
                        self.tableView2.mj_footer.endRefreshing()
                    }
                    self.tableView2.reloadData()
                }else {
                    if result["content"]["order"].count < 10{
                        self.tableView.mj_footer.endRefreshingWithNoMoreData()
                        self.tableView.mj_footer.isHidden = true
                    }else{
                        self.tableView.mj_footer.endRefreshing()
                    }
                    self.tableView.reloadData()
                }
            }
            if self.orderList.count != 0{
                self.noneView.isHidden = true
            }else{
                self.noneView.isHidden = false
            }
        }) { (fail) in
//            print(fail)
        }
    }
    
    func getOrderInfo(){
        var url = RequestUrl.Router.getMyOrderList(status: status, page: page, user_id: CommonConfig.UserInfoCache.userId)
        if self.status == "comment" {
            url = RequestUrl.Router.getMyReview(status: "unreview", page: page, userid: CommonConfig.UserInfoCache.userId)
        }else if self.status == "fix" {
            url = RequestUrl.Router.getMyOrderList(status: "all", page: page, user_id: CommonConfig.UserInfoCache.userId)
        }
        RequestManager.RequestData(url,successCallBack: { (result) in
            self.pageCount = result["content"]["page_info"]["page_count"].intValue
            if self.status == "comment"{
                for i in 0..<result["content"]["review"].count{
                    self.orderList.append(result["content"]["review"][i])
                }
                if result["content"]["review"].count < 10{
                    self.tableView2.mj_footer.endRefreshingWithNoMoreData()
                    self.tableView2.mj_footer.isHidden = true
                }else{
                    self.tableView2.mj_footer.endRefreshing()
                }
                self.tableView2.reloadData()
           
            }else{
                for i in 0..<result["content"]["order"].count{
                    self.orderList.append(result["content"]["order"][i])
                }
                if self.status == "fix" {
                    if result["content"]["order"].count < 10{
                        self.tableView2.mj_footer.endRefreshingWithNoMoreData()
                        self.tableView2.mj_footer.isHidden = true
                    }else{
                        self.tableView2.mj_footer.endRefreshing()
                    }
                    self.tableView2.reloadData()
                }else {
                    if result["content"]["order"].count < 10{
                        self.tableView.mj_footer.endRefreshingWithNoMoreData()
                        self.tableView.mj_footer.isHidden = true
                    }else{
                        self.tableView.mj_footer.endRefreshing()
                    }
                    self.tableView.reloadData()
                }
            }
            if self.orderList.count != 0{
                self.noneView.isHidden = true
            }else{
                self.noneView.isHidden = false
            }
            }) { (fail) in
//                print(fail)
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return self.orderList.count

    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == self.tableView{
            return 1
        }else{
            if self.status == "fix" {
                return self.orderList[section]["imglist"].count
            }else{
//                print("list",self.orderList[section]["list"].count)
                return self.orderList[section]["list"].count
            }
        }
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 50
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if tableView == self.tableView2{
            return 90
        }else {
            return 140*newScale + 20+82
        }
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        if tableView == self.tableView2{
            return 40
        }else {
            return 0.1
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if tableView == tableView2{
            let cell = tableView.dequeueReusableCell(withIdentifier: "OrderCommentCell") as! OrderCommentCell
            cell.tag = indexPath.section
            var list = "list"
            if self.status == "fix" {
                list = "imglist"
            }
            if self.orderList[indexPath.section][list].count != 0 {
                cell.setCellInfo(self.orderList[indexPath.section][list][indexPath.row]["img"].stringValue, titlename: self.orderList[indexPath.section][list][indexPath.row]["name"].stringValue)
                cell.commentBtn.tag = indexPath.row
                if status == "fix" {
                    if self.orderList[indexPath.section][list][indexPath.row]["support_status"].stringValue == "0"{
                        cell.commentBtn.setTitle("在线退换货", for: UIControlState())
                    }else if self.orderList[indexPath.section][list][indexPath.row]["support_status"].stringValue == "1"{
                        cell.commentBtn.setTitle("售后处理中", for: UIControlState())
                    }else if self.orderList[indexPath.section][list][indexPath.row]["support_status"].stringValue == "2"{
                        cell.commentBtn.setTitle("售后已处理", for: UIControlState())
                    }
                }else if status == "comment"{
                    cell.commentBtn.setTitle("发表评论", for: UIControlState())
                }
            }
            cell.imgClick = img2Click
            cell.confirmClick = reviewClick
            cell.selectionStyle = .none
            return cell
        }else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "OrderViewCell") as! OrderViewCell
            cell.tag = indexPath.section
            if self.orderList.count != 0 {
                cell.setInfo(self.orderList[indexPath.section])
            }
            cell.imgClick = imgClick
            cell.confirmClick = confirmClick
            cell.cancelClick = cancelClick
            cell.selectionStyle = .none
            return cell

        }
        
    }

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let views = UIView.init(frame: CGRect(x: 0, y: 0, width: screenWidth, height: 50))
        views.backgroundColor = CommonConfig.MainGrayColor
        if self.orderList.count != 0 {
            let line1 = UIView.init(frame: CGRect(x: 0, y: 0, width: screenWidth, height: 1))
            line1.backgroundColor = CommonConfig.SliderBlackColor
            views.addSubview(line1)
            let line2 = UIView.init(frame: CGRect(x: 0, y: 9, width: screenWidth, height: 1))
            line2.backgroundColor = CommonConfig.SliderBlackColor
            views.addSubview(line2)
            let views2 = UIView.init(frame: CGRect(x: 0, y: 10, width: screenWidth, height: 40))
            views2.backgroundColor = UIColor.white
            views.addSubview(views2)
            let text = "订单编号:" + self.orderList[section]["order_no"].stringValue
            var size = CommonConfig.getTextRectSize(text as NSString, font: UIFont.systemFont(ofSize: 12), size: CGSize(width: screenWidth, height: 0))
            let num = UILabel.init(frame: CGRect(x: 10, y: 0, width: size.width, height: 40))
            num.text = text
            num.textColor = CommonConfig.MainFontBlackColor
            num.font = UIFont.systemFont(ofSize: 12)
            num.textAlignment = .center
            views2.addSubview(num)
            let icon = UILabel.init(frame: CGRect(x: 10+size.width, y: 0, width: 40, height: 40))
            icon.text = ">"
            icon.textColor = CommonConfig.MainFontGrayColor
            icon.font = UIFont.systemFont(ofSize: 16)
            icon.textAlignment = .center
            views2.addSubview(icon)
            var orderStatus = "等待付款"
            if self.orderList[section]["status"].stringValue == "2" && self.orderList[section]["pay_status"].stringValue == "0" && self.orderList[section]["delivery_status"].stringValue == "0"{
                orderStatus = "等待付款"
            }else if self.orderList[section]["status"].stringValue == "3" && self.orderList[section]["pay_status"].stringValue == "1" && self.orderList[section]["delivery_status"].stringValue == "0"{
                orderStatus = "等待发货"
            }else if self.orderList[section]["status"].stringValue == "3" && self.orderList[section]["pay_status"].stringValue == "1" && self.orderList[section]["delivery_status"].stringValue == "1"{
                orderStatus = "等待收货"
            }else if self.orderList[section]["status"].stringValue == "5"{
                orderStatus = "已收货"
            }else if self.orderList[section]["status"].stringValue == "6"{
                orderStatus = "已失效"
            }
            if self.status == "comment" || status == "fix" {
                orderStatus = "待评价"
                if status == "fix" {
                    orderStatus = "在线退换货"
                }
            }
            size = CommonConfig.getTextRectSize(orderStatus as NSString, font: UIFont.systemFont(ofSize: 13), size: CGSize(width: screenWidth, height: 0))
            let statuslbl = UILabel.init(frame: CGRect(x: screenWidth-18-size.width, y: 0, width: size.width, height: 40))
            statuslbl.text = orderStatus
            statuslbl.textColor = CommonConfig.MainRedColor
            statuslbl.font = UIFont.systemFont(ofSize: 13)
            statuslbl.textAlignment = .center
            views2.addSubview(statuslbl)
            let line3 = UIView.init(frame: CGRect(x: 0, y: 49, width: screenWidth, height: 1))
            line3.backgroundColor = CommonConfig.SliderBlackColor
            views.addSubview(line3)
        }else{
            views.frame = CGRect(x: 0, y: 0, width: screenWidth, height: 0)
        }
        return views
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        
        let views = UIView.init(frame: CGRect(x: 0, y: 0, width: screenWidth, height: 40))
        views.backgroundColor = UIColor.white
        if tableView == tableView2 {
            if self.orderList.count != 0 {
                let line1 = UIView.init(frame: CGRect(x: 0, y: 0, width: screenWidth, height: 1))
                line1.backgroundColor = CommonConfig.SliderBlackColor
                views.addSubview(line1)
                var text = "¥"+self.orderList[section]["order_amount"].stringValue
                var size = CommonConfig.getTextRectSize(text as NSString, font: UIFont.systemFont(ofSize: 12), size: CGSize(width: screenWidth, height: 0))
                let statuslbl = UILabel.init(frame: CGRect(x: screenWidth-18-size.width, y: 0, width: size.width, height: 40))
                statuslbl.text = text
                statuslbl.textColor = CommonConfig.MainRedColor
                statuslbl.font = UIFont.systemFont(ofSize: 12)
                statuslbl.textAlignment = .center
                views.addSubview(statuslbl)
                text = "总和:"
                size = CommonConfig.getTextRectSize(text as NSString, font: UIFont.systemFont(ofSize: 12), size: CGSize(width: screenWidth, height: 0))
                let sum = UILabel.init(frame: CGRect(x: statuslbl.frame.origin.x - size.width - 5, y: 0, width: size.width, height: 40))
                sum.text = text
                sum.textColor = CommonConfig.MainFontBlackColor
                sum.font = UIFont.systemFont(ofSize: 12)
                sum.textAlignment = .center
                views.addSubview(sum)
                var count = 0
                for i in 0..<self.orderList[section]["list"].count{
                    count += self.orderList[section]["list"][i]["goods_num"].intValue
                }
                text = "共\(count)件商品"
                size = CommonConfig.getTextRectSize(text as NSString, font: UIFont.systemFont(ofSize: 12), size: CGSize(width: screenWidth, height: 0))
                let num = UILabel.init(frame: CGRect(x: sum.frame.origin.x - size.width - 25, y: 0, width: size.width, height: 40))
                num.text = text
                num.textColor = CommonConfig.MainFontBlackColor
                num.font = UIFont.systemFont(ofSize: 12)
                num.textAlignment = .center
                views.addSubview(num)
                let line3 = UIView.init(frame: CGRect(x: 0, y: 39, width: screenWidth, height: 1))
                line3.backgroundColor = CommonConfig.SliderBlackColor
                views.addSubview(line3)
            }
        }else{
            views.frame = CGRect(x: 0, y: 0, width: screenWidth, height: 0)
        }
        return views
    }
    
    func reviewClick(_ tags:Array<NSInteger>){
        if self.status == "fix" {
            if self.orderList[tags[0]]["imglist"][tags[1]]["support_status"].stringValue == "0"{
                let login = UIStoryboard(name: "Me", bundle: nil).instantiateViewController(withIdentifier: "AfterSalesController") as! AfterSalesController
                login.goodsInfo = self.orderList[tags[0]]
                login.goodsRow = tags[1]
                self.navigationController?.pushViewController(login, animated: true)
            }else if self.orderList[tags[0]]["imglist"][tags[1]]["support_status"].stringValue == "1"{
            
            }else if self.orderList[tags[0]]["imglist"][tags[1]]["support_status"].stringValue == "2"{
        
            }
        }else {
            let login = UIStoryboard(name: "ShopCart", bundle: nil).instantiateViewController(withIdentifier: "ReviewController") as! ReviewController
            login.reviewJSON = self.orderList[tags[0]]["list"][tags[1]]
            self.navigationController?.pushViewController(login, animated: true)
        }
    }
    
    func img2Click(_ tags:Array<NSInteger>){
        
    }
    
    func imgClick(_ tag:NSInteger){
        CommonConfig.getDetailData(self, orderID: self.orderList[tag]["id"].stringValue)
    }
    
    func confirmClick(_ tag:NSInteger){
        if self.orderList[tag]["status"].stringValue == "2" && self.orderList[tag]["pay_status"].stringValue == "0" && self.orderList[tag]["delivery_status"].stringValue == "0"{
            dopayRequest(self.orderList[tag]["id"].stringValue,order_amount: self.orderList[tag]["order_amount"].stringValue)
        }else if self.orderList[tag]["status"].stringValue == "3" && self.orderList[tag]["pay_status"].stringValue == "1" && self.orderList[tag]["delivery_status"].stringValue == "0"{
            
        }else if self.orderList[tag]["status"].stringValue == "3" && self.orderList[tag]["pay_status"].stringValue == "1" && self.orderList[tag]["delivery_status"].stringValue == "1"{
           RequestManager.RequestData(RequestUrl.Router.orderSign(id: self.orderList[tag]["id"].stringValue, user_id: CommonConfig.UserInfoCache.userId), showLoading: false, successCallBack: { (result) in
//            print(result)
            self.orderList.remove(at: tag)
            self.tableView.reloadData()
            }, failCallBack: { (fail) in
//                print(fail)
           })
        }
    }
    
    func cancelClick(_ tag:NSInteger){
//        print(self.orderList[tag]["status"].stringValue,self.orderList[tag]["pay_status"].stringValue,self.orderList[tag]["delivery_status"].stringValue)
        if self.orderList[tag]["status"].stringValue == "2" && self.orderList[tag]["pay_status"].stringValue == "0" && self.orderList[tag]["delivery_status"].stringValue == "0"{


        }else if self.orderList[tag]["status"].stringValue == "3" && self.orderList[tag]["pay_status"].stringValue == "1" && self.orderList[tag]["delivery_status"].stringValue == "0"{
         
        }else if self.orderList[tag]["status"].stringValue == "3" && self.orderList[tag]["pay_status"].stringValue == "1" && self.orderList[tag]["delivery_status"].stringValue == "1"{
            let express = UIStoryboard(name: "ShopCart", bundle: nil).instantiateViewController(withIdentifier: "ExpressViewController") as! ExpressViewController
            express.info = self.orderList[tag]
            self.navigationController?.pushViewController(express, animated: true)
        }
    }
    
    func dopayRequest(_ order_id:String,order_amount:String){
  
        CommonConfig.getDoPay(self, order_id: order_id, order_amount: order_amount)
    }
    
    @IBAction func mainClick(_ sender: UIButton) {
        (UIApplication.shared.delegate as! AppDelegate).showMainPage()
    }
    
    @IBAction func backClick(_ sender: UIButton) {
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
    
    @IBAction func noneClick(_ sender: UIButton) {
        (UIApplication.shared.delegate as! AppDelegate).showMainPage()
    }

    func refreshOrder(){
//        print("refreshOrder")
        getOrderInfo()
        
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
