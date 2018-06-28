//
//  FlashViewController.swift
//  huabi
//
//  Created by TeamMac2 on 16/9/9.
//  Copyright © 2016年 ltl. All rights reserved.
//
// 抢购页面    今日特价？
import UIKit
import SwiftyJSON
import MJRefresh

class FlashViewController: UIViewController ,UITableViewDelegate,UITableViewDataSource{

    @IBOutlet weak var backBtn: UIButton!
    @IBOutlet weak var mainBtn: UIButton!
    @IBOutlet weak var flashBtn1: UIButton!
    @IBOutlet weak var flashBtn2: UIButton!
    @IBOutlet weak var slider: UILabel!
    @IBOutlet weak var slider2: UILabel!
    @IBOutlet weak var timeTitle: UILabel!
    @IBOutlet weak var time1: UILabel!
    @IBOutlet weak var time2: UILabel!
    @IBOutlet weak var time3: UILabel!
    @IBOutlet weak var tableView: UITableView!
    
    var timer: Timer!
    var nowtime:Int64 = 34000
    var flashList:Array<JSON> = []
    var lastBtn:UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()
        setInfo()
        // Do any additional setup after loading the view.
    }

    func setInfo(){
        backBtn.setTitle(IconFontIconName.icon_back.rawValue, for: UIControlState())
        mainBtn.setTitle(IconFontIconName.icon_goods_backhome.rawValue, for: UIControlState())
        slider.center = flashBtn1.center
        time1.layer.cornerRadius = 5
        time1.clipsToBounds = true
        time2.layer.cornerRadius = 5
        time2.clipsToBounds = true
        time3.layer.cornerRadius = 5
        time3.clipsToBounds = true
        self.tableView.mj_header = MJRefreshNormalHeader(refreshingTarget: self, refreshingAction: #selector(self.headRefresh))
        self.tableView.mj_footer = MJRefreshAutoNormalFooter(refreshingTarget: self, refreshingAction: #selector(self.footRefresh))
        lastBtn = flashBtn1
        setFlashTitleColor()
        getFlashData(true)
        
    }
    
    func setFlashTitleColor(_ tag:NSInteger = 0){
        if tag == 0 {
            flashBtn1.setTitleColor(CommonConfig.MainRedColor, for: UIControlState())
            flashBtn2.setTitleColor(CommonConfig.MainFontGrayColor, for: UIControlState())
            slider.isHidden = false
            slider2.isHidden = true
        }else{
            flashBtn1.setTitleColor(CommonConfig.MainFontGrayColor, for: UIControlState())
            flashBtn2.setTitleColor(CommonConfig.MainRedColor, for: UIControlState())
            slider.isHidden = true
            slider2.isHidden = false
        }
        
    }

    
    var isWant:Bool = false
    var gones:Bool = false   // 抢光
    var page = 1
    var totalPage = 1
    
    func headRefresh(){
        self.tableView.mj_header.beginRefreshing()
        self.tableView.reloadData()
        self.tableView.mj_header.endRefreshing()
 
    }
    
    func footRefresh(){
        self.tableView.mj_footer.beginRefreshing()
        page += 1
        getFlashData()
    }
    
    func getFlashData(_ isFirst:Bool = false){
        var url = RequestUrl.Router.getFlashLeft(page: page)
        if isWant{
            url = RequestUrl.Router.getFlashRight(page: page)
        }
        RequestManager.RequestData(url, successCallBack: { (result) in
//            print(result)
            if isFirst{
                let endtime = CommonConfig.stringToTimeStamp(result["content"]["end_time"].stringValue, dateFormat: "yyyy-MM-dd HH:mm:ss", isNeed: false)
                let now = CommonConfig.stringToTimeStamp(result["content"]["now"].stringValue, dateFormat: "yyyy-MM-dd HH:mm:ss", isNeed: false)
                self.nowtime = endtime - now
                self.nowtime = 12306
//                self.getTime()
            }
            self.totalPage = result["content"]["flashlist"]["page"]["totalPage"].intValue
            for i in 0..<result["content"]["flashlist"]["data"].count{
                self.flashList.append(result["content"]["flashlist"]["data"][i])
            }
            if result["content"]["flashlist"]["data"].count < 10{
                self.tableView.mj_footer.endRefreshingWithNoMoreData()
                self.tableView.mj_footer.isHidden = true
            }else{
                self.tableView.mj_footer.endRefreshing()
            }
            print("抢购商品",self.flashList)
            self.tableView.reloadData()
            }) { (fail) in
//                print(fail)
        }
    }
    
//    func getTime(){
//        self.timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(MainCollectionHeadView.heartbeat), userInfo: nil, repeats: false)
//    }
    
    func heartbeat() {
        nowtime -= 1
        if self.nowtime <= 0{
            time1.text = "00"
            time2.text = "00"
            time3.text = "00"
            self.normalState()
            return
        }
        exchangeTime()
    }
    
    func exchangeTime(){
        var a = nowtime/3600
        var b = nowtime - nowtime/3600 * 3600
        time1.text = "\(a)"
        if a < 10 {
            time1.text = "0\(a)"
        }
        
        a = b/60
        b = b - a * 60
        time2.text = "\(a)"
        if a < 10 {
            time2.text = "0\(a)"
        }
        
        a = b % 60
        time3.text = "\(a)"
        if a < 10 {
            time3.text = "0\(a)"
        }
        
        self.normalState()
//        getTime()
    }
    
    func normalState() {
        if self.timer == nil {
            return
        }
        self.timer.invalidate()
        self.timer = nil
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.flashList.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 110
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "FlashViewCell") as! FlashViewCell
        cell.backgroundColor = UIColor.white
        cell.tag = indexPath.row
        if self.flashList.count != 0 {
            if self.flashList[indexPath.row]["max_num"].intValue - self.flashList[indexPath.row]["order_num"].intValue == 0 || self.flashList[indexPath.row]["is_end"].stringValue == "1"
            {
                gones = false
            }else{
                gones = true
            }
            cell.setInfo(self.flashList[indexPath.row], type: isWant ,gone:gones)
        }
        cell.imgChoose = imgChoose
        cell.buyChoose = buyChoose
        cell.wantChoose = wantChoose
        cell.selectionStyle = .none
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexRow != nil{
            let cell = tableView.cellForRow(at: indexRow!) as! FlashViewCell
            cell.backgroundColor = UIColor.white
            indexRow = nil
        }
        flashDetail(indexPath.row)
    }
    
    func tableView(_ tableView: UITableView, didHighlightRowAt indexPath: IndexPath) {

        let cell = tableView.cellForRow(at: indexPath) as! FlashViewCell
        cell.backgroundColor = UIColor.init(hexCode: "efefef")
        indexRow = indexPath
        
    }
    
    var indexRow:IndexPath?
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        if indexRow != nil{
            let cell = self.tableView.cellForRow(at: indexRow!) as! FlashViewCell
            cell.backgroundColor = UIColor.white
            indexRow = nil
        }
    }
    
    func imgChoose(_ tag:NSInteger){
        flashDetail(tag)
    }
    
    func buyChoose(_ tag:NSInteger){
        flashDetail(tag)
    }
    
    func flashDetail(_ tag:NSInteger){
        RequestManager.RequestData(RequestUrl.Router.flashDetail(id: self.flashList[tag]["id"].stringValue),showLoading: true, successCallBack: { (result) in
            let goods = UIStoryboard(name: "ShopCart", bundle: nil).instantiateViewController(withIdentifier: "GoodsDetailViewController") as! GoodsDetailViewController
            goods.goodsInfo = result["content"]
            goods.isFlash = true
            self.navigationController?.pushViewController(goods, animated: true)
        }) { (fail) in
//            print(fail)
            RequestManager.RequestData(RequestUrl.Router.pointDetail(id: self.flashList[tag]["id"].stringValue),showLoading: true, successCallBack: { (result) in
                
                let goods = UIStoryboard(name: "ShopCart", bundle: nil).instantiateViewController(withIdentifier: "GoodsDetailViewController") as! GoodsDetailViewController
                goods.goodsInfo = result["content"]
                //                goods.isIntegral = true
                goods.isFlash = true
                self.navigationController?.pushViewController(goods, animated: true)
            }) { (fail) in
                //            print(fail)
                
            }
        }
    }
    
    func wantChoose(_ tag:NSInteger){
        if CommonConfig.isLogin  {
            let info = UIStoryboard(name: "Me", bundle: nil).instantiateViewController(withIdentifier: "AddressViewController") as! AddressViewController
            info.isGoods = true
            self.navigationController?.pushViewController(info, animated: true)
        }else{
            RequestManager.RequestData(RequestUrl.Router.wantFlash(id: self.flashList[tag]["id"].stringValue, user_id: CommonConfig.UserInfoCache.userId), successCallBack: { (result) in
//                print(result)
                self.noticeOnlyText("已添加提醒!")
                }) { (fail) in
//                    print(fail)
            }
        }
    }
    
    
    @IBAction func flashClick(_ sender: UIButton) {
        if sender == lastBtn {
            return
        }
        lastBtn = sender
        page = 1
        let list:Array<JSON> = []
        self.flashList = list
        setFlashTitleColor(sender.tag)
        if sender.tag == 0 {
            isWant = false
        }else{
            isWant = true
        }
        self.tableView.mj_footer.isHidden = false
        getFlashData()
        
    }
    
    
    @IBAction func backClick(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func mainClick(_ sender: UIButton) {
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
    

}
