//
//  MessageViewController.swift
//  huabi
//
//  Created by TeamMac2 on 16/9/2.
//  Copyright © 2016年 ltl. All rights reserved.
//

import UIKit
import SwiftyJSON
import MJRefresh

class MessageViewController: UIViewController ,UITableViewDelegate,UITableViewDataSource{

    
    @IBOutlet weak var titles: UILabel!
    @IBOutlet weak var backBtn: UIButton!
    @IBOutlet weak var mainBtn: UIButton!
    @IBOutlet weak var view1: UIView!
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var view2: UIView!   //消息
    
    @IBOutlet weak var mess1: UILabel!
    @IBOutlet weak var mess2: UILabel!
    @IBOutlet weak var title1: UILabel!
    @IBOutlet weak var title2: UILabel!
    @IBOutlet weak var content1: UILabel!
    @IBOutlet weak var content2: UILabel!
    @IBOutlet weak var time1: UILabel!
    @IBOutlet weak var time2: UILabel!
    
    @IBOutlet weak var view3: UIView!
    @IBOutlet weak var view4: UIView!
    
    @IBOutlet weak var view5: UIView!
    
    @IBOutlet weak var view6: UIView!
    
    @IBOutlet weak var messicon: UILabel!
    @IBOutlet weak var tableView3: UITableView!
    
    var messLisi:Array<JSON> = []
    var sysMessList:Array<JSON> = []
    var collectList:Array<JSON> = []
    var isCollect:Bool = false
    var isShow:Bool = false     //是否显示消息
    var isSystem:Bool = false
    var isFirst:Bool = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.automaticallyAdjustsScrollViewInsets = false
        messicon.text = IconFontIconName.icon_system_message_1.rawValue
        backBtn.setTitle(IconFontIconName.icon_back.rawValue, for: UIControlState())
        mess1.text = IconFontIconName.icon_system_message.rawValue
        mess2.text = IconFontIconName.icon_system_message_1.rawValue
        mess1.layer.cornerRadius = 96/4
        mess1.clipsToBounds = true
        mess2.layer.cornerRadius = 96/4
        mess2.clipsToBounds = true
        // Do any additional setup after loading the view.
        view2.isHidden = isShow
        view3.isHidden = !isCollect
        view5.isHidden = true
        view4.isHidden = true
        self.tableView3.mj_header = MJRefreshNormalHeader(refreshingTarget: self, refreshingAction: #selector(self.headRefresh))
        self.tableView3.mj_footer = MJRefreshAutoNormalFooter(refreshingTarget: self, refreshingAction: #selector(self.footRefresh))
        self.tableView.mj_header = MJRefreshNormalHeader(refreshingTarget: self, refreshingAction: #selector(self.headRefresh))
        self.tableView.mj_footer = MJRefreshAutoNormalFooter(refreshingTarget: self, refreshingAction: #selector(self.footRefresh))
        if isShow {
            getMessageData()
            if isSystem {
                titles.text = "系统消息"
            }else{
                titles.text = "客服消息"
            }
        }else {
            status = "unread"
            getMessageData()
            titles.text = "我的消息"
        }
        if isCollect {
            
            titles.text = "我的收藏"
            mainBtn.setTitle(IconFontIconName.icon_goods_backhome.rawValue, for: UIControlState())
            getCollectData()
            
        }
        view6.isHidden = !isFirst
        if isFirst {
            titles.text = "客服中心"
        }
    }
    
    func headRefresh(){
        if isCollect{
            self.tableView3.mj_header.beginRefreshing()
            self.tableView3.reloadData()
            self.tableView3.mj_header.endRefreshing()
        }else if isShow{
            self.tableView.mj_header.beginRefreshing()
            self.tableView.reloadData()
            self.tableView.mj_header.endRefreshing()
        }
    }
    
    func footRefresh(){
        page += 1
        if isCollect{
            self.tableView3.mj_footer.beginRefreshing()
            getCollectData()
        }else if isShow{
            self.tableView.mj_footer.beginRefreshing()
            getMessageData()
        }
    }

    var type = "system"
    var status = "all"
    var page = 1
    
    func getMessageData(){
        RequestManager.RequestData(RequestUrl.Router.getMessage(type: type, status: status, user_id: CommonConfig.UserInfoCache.userId, page: page), successCallBack: { (result) in
//            print(result)
            if self.isShow {
                
                for i in 0..<result["content"].count{
                    self.sysMessList.append(result["content"][i])
                }
                if result["content"].count < 10{
                    self.tableView.mj_footer.endRefreshingWithNoMoreData()
//                    self.tableView.mj_footer.hidden = true
                    self.tableView.mj_footer.isHidden = true
                }else{
                    self.tableView.mj_footer.endRefreshing()
                }
                if self.sysMessList.count == 0{
//                    self.view5.hidden = false
                    self.view5.isHidden = false
                }else{
//                    self.view5.hidden = true
                    self.view5.isHidden = true
                }
                self.tableView.reloadData()
            }else{
                if result["content"].count == 0{
                    self.content2.text = "暂无新的消息"
                }else{
                    self.content2.text = "您有新的消息"
                }
            }
            }) { (fail) in
//                print(fail)
        }
    }
    
    func getCollectData(){
        RequestManager.RequestData(RequestUrl.Router.getCollect(user_id: CommonConfig.UserInfoCache.userId, page: page), successCallBack: { (result) in
//            print(result)
            for i in 0..<result["content"].count{
                self.collectList.append(result["content"][i])
            }
            if result["content"].count < 10{
                self.tableView3.mj_footer.endRefreshingWithNoMoreData()
//                self.tableView3.mj_footer.hidden = true
                self.tableView3.mj_footer.isHidden = true
            }else{
                self.tableView3.mj_footer.endRefreshing()
            }
            if self.collectList.count == 0{
//                self.view4.hidden = false
                self.view4.isHidden = false
            }else{
//                self.view4.hidden = true
                self.view4.isHidden = true
            }
            self.tableView3.reloadData()
            }) { (fail) in
                
//                print(fail)
        }
        
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == self.tableView3 {
            return self.collectList.count
        }
        return self.sysMessList.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if tableView == self.tableView3 {
            return 110
        }
        let size = CommonConfig.getTextRectSize(self.sysMessList[indexPath.row]["content"].stringValue as NSString, font: UIFont.systemFont(ofSize: 12), size: CGSize(width: screenWidth - 40, height: 0))
        return 10 + 30 + 13 + 13 + 12 + 8 + size.height
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if tableView == self.tableView3 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "CollectViewCell") as! CollectViewCell
            cell.addClick = addClick
            cell.deleteClick = delClick
            cell.tag = indexPath.row
            if collectList.count != 0 {
                cell.setCollectInfo(self.collectList[indexPath.row]["name"].stringValue, price: self.collectList[indexPath.row]["sell_price"].stringValue, imgs: self.collectList[indexPath.row]["img"].stringValue)
            }
            cell.selectionStyle = .none
            return cell
        }else{
            let cell = tableView.dequeueReusableCell(withIdentifier: "MessageViewCell") as! MessageViewCell
            if self.sysMessList.count != 0{
                cell.setMessageInfo(self.sysMessList[indexPath.row]["title"].stringValue, content: self.sysMessList[indexPath.row]["content"].stringValue, times: self.sysMessList[indexPath.row]["time"].stringValue)
            }
            cell.selectionStyle = .none
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if tableView == self.tableView3 {
            CommonConfig.getProductDetail(self, goodsID: self.collectList[indexPath.row]["goods_id"].stringValue)
            print("\(self.collectList)")
        }
    }
    
    func delClick(_ tag:NSInteger){
        RequestManager.RequestData(RequestUrl.Router.delCollect(id: self.collectList[tag]["goods_id"].stringValue, user_id: CommonConfig.UserInfoCache.userId), successCallBack: { (result) in
//                print(result)
                self.collectList.remove(at: tag)
                self.tableView3.reloadData()
            }) { (fail) in
//                print(fail)
        }
    }
    
    func addClick(_ tag:NSInteger){
        RequestManager.RequestData(RequestUrl.Router.addGoods(id: self.collectList[tag]["goods_id"].stringValue, num: 1),showLoading: true, successCallBack: { (result) in
            let alert = UIAlertView.init(title: "", message: "已添加到购物车", delegate: self, cancelButtonTitle: "确定")
            alert.show()
            CommonConfig.shopBadge += 1
            CommonConfig.setCartBadge("\(CommonConfig.shopBadge)")
            let notice = NSNotification.init(name: NSNotification.Name(rawValue: "refresh3"), object: nil)
            NotificationCenter.default.post(notice as Notification)
//            print(result)
        }) { (fail) in
//            print(fail)
            self.noticeOnlyText("添加失败")
        }

    }
    
    @IBAction func mainClick(_ sender: AnyObject) {
        if isCollect {
            (UIApplication.shared.delegate as! AppDelegate).showMainPage()
        }
    }
    
    @IBAction func backClick(_ sender: AnyObject) {
        self.navigationController?.popViewController(animated: true)
    }
    
    
    @IBAction func messClick(_ sender: AnyObject) {
        let info = UIStoryboard(name: "Me", bundle: nil).instantiateViewController(withIdentifier: "MessageViewController") as! MessageViewController
        info.isShow = true
        info.isSystem = false
        info.isFirst = false
        info.type = "only"
        info.status = "all"
        self.navigationController?.pushViewController(info, animated: true)

    }
    
    @IBAction func sysMessClick(_ sender: AnyObject) {
        let info = UIStoryboard(name: "Me", bundle: nil).instantiateViewController(withIdentifier: "MessageViewController") as! MessageViewController
        info.isShow = true
        info.isSystem = true
        info.isFirst = false
        info.type = "system"
        info.status = "all"
        self.navigationController?.pushViewController(info, animated: true)

    }
    
    
    @IBAction func toMainClick(_ sender: AnyObject) {
        (UIApplication.shared.delegate as! AppDelegate).showMainPage()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tableView.reloadData()
        self.navigationController?.setNavigationBarHidden(true, animated: false)
        UIApplication.shared.setStatusBarStyle(.default, animated: false)
        self.setNeedsStatusBarAppearanceUpdate()
        
    }
    
    @IBAction func tuihuoClick(_ sender: AnyObject) {
        let login = UIStoryboard(name: "Me", bundle: nil).instantiateViewController(withIdentifier: "OrderViewController") as! OrderViewController
        login.status = "fix"
        self.navigationController?.pushViewController(login, animated: true)
    }
    
    @IBAction func tousuClick(_ sender: AnyObject) {
        let login = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "FeedBackController") as! FeedBackController
        self.navigationController?.pushViewController(login, animated: true)
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
