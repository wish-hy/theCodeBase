//
//  RecordViewController.swift
//  huabi
//
//  Created by TeamMac2 on 16/8/31.
//  Copyright © 2016年 ltl. All rights reserved.
//

import UIKit
import SwiftyJSON
import MJRefresh

class RecordViewController: UIViewController ,UITableViewDelegate,UITableViewDataSource,UIScrollViewDelegate,UITextFieldDelegate,CenterButtonDelegate{

    
    @IBOutlet weak var titlelbl: UILabel!
    @IBOutlet weak var top: NSLayoutConstraint!
    @IBOutlet weak var mainBtn: UIButton!
    @IBOutlet weak var backBtn: UIButton!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var btnView: UIView!
    
    @IBOutlet weak var allBtn: UIButton!
    @IBOutlet weak var getBtn: UIButton!
    @IBOutlet weak var outBtn: UIButton!
    @IBOutlet weak var btnW: NSLayoutConstraint!
    @IBOutlet weak var btnViewH: NSLayoutConstraint!
    @IBOutlet weak var btnViewT: NSLayoutConstraint!
    @IBOutlet weak var btnViewB: NSLayoutConstraint!
    
    @IBOutlet weak var payView: UIView!
    @IBOutlet weak var pointView: UIView!
    @IBOutlet weak var view1: UIView!
    @IBOutlet weak var view2: UIView!
    @IBOutlet weak var view3: UIView!
    
    @IBOutlet weak var currencyBtn: UIButton!
    @IBOutlet weak var payField: UITextField!
    @IBOutlet weak var nextBtn: UIButton!
    
    var tableView1:UITableView!
    var tableView2:UITableView!
    var tableView3:UITableView!
    
    var recordList1:Array<JSON> = []
    var recordList2:Array<JSON> = []
    var recordList3:Array<JSON> = []
    var showList1:Array<JSON> = []
    var showList2:Array<JSON> = []
    var showList3:Array<JSON> = []
    let cellIdentify:String = "RecordViewCell"
    
    var btn1:CenterButton!
    var btn2:CenterButton!
    var btn3:CenterButton!
    var page = 1
    var pageCount = 1
    var isMore:Bool = true
    var types = "all"
    var isPay:Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initSet()
        // Do any additional setup after loading the view.
    }

    func initSet(){
        nextBtn.layer.cornerRadius = 5
        nextBtn.clipsToBounds = true
        top.constant = 0
        btnW.constant = 216*newScale
        btnViewH.constant = 128*newScale
        btnViewB.constant = 36*newScale
        btnViewT.constant = 36*newScale
        btnView.layer.cornerRadius = 5
        btnView.layer.borderColor = CommonConfig.MainYellowColor.cgColor
        btnView.layer.borderWidth = 1
        btnView.clipsToBounds = true
        backBtn.setTitle(IconFontIconName.icon_back.rawValue, for: UIControlState())
        mainBtn.setTitle(IconFontIconName.icon_goods_backhome.rawValue, for: UIControlState())
        setBtnBackColor(0)
        scrollView.contentSize = CGSize(width: screenWidth * 3, height: screenHeight - 128*newScale - 64)
        scrollView.isPagingEnabled = true
//        scrollView.userInteractionEnabled = false
        scrollView.isScrollEnabled = false
        scrollView.delegate = self
//        scrollView.backgroundColor = CommonConfig.MainLightRedColor
        for i in 0..<3 {
            let tableview = UITableView.init(frame: CGRect(x: CGFloat(i) * screenWidth, y: 0, width: screenWidth, height: screenHeight - 128*newScale - 64))
            tableview.tag = i
            tableview.backgroundColor = CommonConfig.MainGrayColor
            tableview.delegate = self
            tableview.dataSource = self
            scrollView.addSubview(tableview)
            if i == 0 {
                tableView1 = tableview
//                tableview.backgroundColor = CommonConfig.MainRedColor
            }else if i == 1 {
                tableView2 = tableview
//                tableview.backgroundColor = CommonConfig.MainYellowColor
            }else if i == 2{
                tableView3 = tableview
//                tableview.backgroundColor = CommonConfig.MainGreenColor
            }
        }
        self.tableView1.register(UINib.init(nibName: cellIdentify, bundle: nil), forCellReuseIdentifier: cellIdentify)
        self.tableView2.register(UINib.init(nibName: cellIdentify, bundle: nil), forCellReuseIdentifier: cellIdentify)
        self.tableView3.register(UINib.init(nibName: cellIdentify, bundle: nil), forCellReuseIdentifier: cellIdentify)
        self.tableView1.mj_header = MJRefreshNormalHeader(refreshingTarget: self, refreshingAction: #selector(RecordViewController.headRefresh))
        self.tableView1.mj_footer = MJRefreshAutoNormalFooter(refreshingTarget: self, refreshingAction: #selector(SearchViewController.footRefresh))
        
        self.tableView2.mj_header = MJRefreshNormalHeader(refreshingTarget: self, refreshingAction: #selector(RecordViewController.headRefresh))
        self.tableView2.mj_footer = MJRefreshAutoNormalFooter(refreshingTarget: self, refreshingAction: #selector(SearchViewController.footRefresh))
        
        self.tableView3.mj_header = MJRefreshNormalHeader(refreshingTarget: self, refreshingAction: #selector(RecordViewController.headRefresh))
        self.tableView3.mj_footer = MJRefreshAutoNormalFooter(refreshingTarget: self, refreshingAction: #selector(SearchViewController.footRefresh))
        
        self.tableView1.separatorStyle = .none
        self.tableView2.separatorStyle = .none
        self.tableView3.separatorStyle = .none
        if CommonConfig.isLogin {
            if showList1.count != 0 {
                self.tableView1.mj_footer.isHidden = false
            }else{
                self.tableView1.mj_footer.isHidden = true
            }
            if showList2.count != 0 {
                self.tableView2.mj_footer.isHidden = false
            }else{
                self.tableView2.mj_footer.isHidden = true
            }
            if showList3.count != 0 {
                self.tableView3.mj_footer.isHidden = false
            }else{
                self.tableView3.mj_footer.isHidden = true
            }

            getRecord(types)
        }else{
            self.tableView1.mj_header.isHidden = true
            self.tableView1.mj_footer.isHidden = true
            self.tableView2.mj_header.isHidden = true
            self.tableView2.mj_footer.isHidden = true
            self.tableView3.mj_header.isHidden = true
            self.tableView3.mj_footer.isHidden = true
        }
        if isPay {
            titlelbl.text = "金点充值"
            self.payView.isHidden = false
        }else{
            titlelbl.text = "金点纪录"
            self.payView.isHidden = true
        }
        setTitleIcons()
    }
    
    func setTitleIcons(){
        btn1 = CenterButton.init(frame: CGRect(x: 0, y: 0, width: (screenWidth - 2)/3, height: self.view1.frame.size.height), title: "今日消费", icon: "0.00", type: 1, delegate: self)
        btn2 = CenterButton.init(frame: CGRect(x: 0, y: 0, width: (screenWidth - 2)/3, height: self.view2.frame.size.height), title: "剩余金点", icon: "0.00", type: 1, delegate: self)
        btn3 = CenterButton.init(frame: CGRect(x: 0, y: 0, width: (screenWidth - 2)/3, height: self.view3.frame.size.height), title: "总消费", icon: "0.00", type: 1, delegate: self)
        btn1.tag = 101
        btn2.tag = 102
        btn3.tag = 103
        btn1.img.textColor = CommonConfig.MainRedColor
        btn2.img.textColor = CommonConfig.MainRedColor
        btn3.img.textColor = CommonConfig.MainRedColor
        self.view1.addSubview(btn1)
        self.view2.addSubview(btn2)
        self.view3.addSubview(btn3)
        setInfo()
    }
    
    func setInfo(){
        if CommonConfig.isLogin {
            RequestManager.RequestData(RequestUrl.Router.getHuabi(user_id: CommonConfig.UserInfoCache.userId), successCallBack: { (result) in
//                print(result)
                self.btn1.setTitleIcon("今日消费", icon: String.init(format: "%.2f", result["content"]["order"]["todayamount"].floatValue))
                self.btn2.setTitleIcon("剩余金点", icon: String.init(format: "%.2f", result["content"]["customer"]["balance"].floatValue))
                self.btn3.setTitleIcon("总消费", icon: String.init(format: "%.2f", result["content"]["order"]["amount"].floatValue))
            }) { (fail) in
                
            }
        }else{
            btn1.setTitleIcon("今日消费", icon: "0.00")
            btn2.setTitleIcon("剩余金点", icon: "0.00")
            btn3.setTitleIcon("总消费", icon: "0.00")
        }
    }
    
    func selectCenterButton(_ tag: NSInteger) {
        
    }

    @objc  func headRefresh(){
        if types == "all" {
            self.tableView1.mj_header.beginRefreshing()
            self.tableView1.reloadData()
            self.tableView1.mj_header.endRefreshing()
            if self.tableView1.mj_footer.isHidden {
                self.tableView1.mj_footer.isHidden = false
            }
            if !isMore{
                self.tableView1.mj_footer.isHidden = true
            }
        }else if types == "in" {
            self.tableView2.mj_header.beginRefreshing()
            self.tableView2.reloadData()
            self.tableView2.mj_header.endRefreshing()
            if self.tableView2.mj_footer.isHidden {
                self.tableView2.mj_footer.isHidden = false
            }
            if !isMore{
                self.tableView2.mj_footer.isHidden = true
            }
        }else if types == "out" {
            self.tableView3.mj_header.beginRefreshing()
            self.tableView3.reloadData()
            self.tableView3.mj_header.endRefreshing()
            if self.tableView3.mj_footer.isHidden {
                self.tableView3.mj_footer.isHidden = false
            }
            if !isMore{
                self.tableView3.mj_footer.isHidden = true
            }
        }
    }
    
    @objc func footRefresh(){
        if types == "all" {
            self.tableView1.mj_footer.beginRefreshing()
        }else if types == "in" {
            self.tableView2.mj_footer.beginRefreshing()
        }else if types == "out" {
            self.tableView3.mj_footer.beginRefreshing()
        }
        page += 1
        getRecord(types)
    }
    
    func getRecord(_ type:String){
        var id = 0
        if CommonConfig.isLogin {
            id = CommonConfig.UserInfoCache.userId
        }
        RequestManager.RequestData(RequestUrl.Router.getHuabiLog(page: page, type: type, user_id: id), successCallBack: { (result) in
//            print(result["content"].arrayValue.count)
            self.isMore = true
            if type == "all" {
                if result["content"].arrayValue.count == 0 {
                    self.tableView1.mj_footer.endRefreshingWithNoMoreData()
                    self.tableView1.mj_footer.isHidden = true
                    self.isMore = false
                }else{
                    for i in 0..<result["content"].arrayValue.count {
                        self.showList1.append(result["content"][i])
                    }
                    self.tableView1.mj_footer.endRefreshing()
                    if result["content"].arrayValue.count < 10 {
                        self.tableView1.mj_footer.isHidden = true
                        self.isMore = false
                    }
                }
                self.tableView1.reloadData()
            }else if type == "in" {
                if result["content"].arrayValue.count == 0 {
                    self.tableView2.mj_footer.endRefreshingWithNoMoreData()
                    self.tableView2.mj_footer.isHidden = true
                    self.isMore = false
                }else{
                    for i in 0..<result["content"].arrayValue.count {
                        self.showList2.append(result["content"][i])
                    }
                    self.tableView2.mj_footer.endRefreshing()
                    if result["content"].arrayValue.count < 10 {
                        self.tableView2.mj_footer.isHidden = true
                        self.isMore = false
                    }
                }
                self.tableView2.reloadData()
            }else if type == "out" {
                if result["content"].arrayValue.count == 0 {
                    self.tableView3.mj_footer.endRefreshingWithNoMoreData()
                    self.tableView3.mj_footer.isHidden = true
                    self.isMore = false
                }else{
                    for i in 0..<result["content"].arrayValue.count {
                        self.showList3.append(result["content"][i])
                    }
                    self.tableView3.mj_footer.endRefreshing()
                    if result["content"].arrayValue.count < 10 {
                        self.tableView3.mj_footer.isHidden = true
                        self.isMore = false
                    }
                }
                self.tableView3.reloadData()
            }
            }) { (fail) in
//                print(fail)
        }
    }
    
    @IBAction func allClick(_ sender: UIButton) {
         self.scrollView.contentOffset = CGPoint(x: 0, y: 0)
        setBtnBackColor(0)
        
    }
    
    @IBAction func getClick(_ sender: UIButton) {
        self.scrollView.contentOffset = CGPoint(x: screenWidth, y: 0)
        setBtnBackColor(1)
        
    }
    
    @IBAction func outClick(_ sender: UIButton) {
         self.scrollView.contentOffset = CGPoint(x: screenWidth*2, y: 0)
        setBtnBackColor(2)
        
    }
    
    func setBtnBackColor(_ type:NSInteger){
        allBtn.backgroundColor = UIColor.white
        allBtn.setTitleColor(CommonConfig.MainYellowColor, for: UIControlState())
        getBtn.backgroundColor = UIColor.white
        getBtn.setTitleColor(CommonConfig.MainYellowColor, for: UIControlState())
        outBtn.backgroundColor = UIColor.white
        outBtn.setTitleColor(CommonConfig.MainYellowColor, for: UIControlState())
        let arr:Array<JSON> = []
        page = 1
        self.isMore = true
        if type == 0 {
            allBtn.backgroundColor = CommonConfig.MainYellowColor
            allBtn.setTitleColor(UIColor.white, for: UIControlState())
            self.recordList1 = arr
            self.showList1 = arr
            types = "all"
           
        }else if type == 1{
            getBtn.backgroundColor = CommonConfig.MainYellowColor
            getBtn.setTitleColor(UIColor.white, for: UIControlState())
            self.recordList2 = arr
            self.showList2 = arr
            types = "in"
            
        }else if type == 2{
            outBtn.backgroundColor = CommonConfig.MainYellowColor
            outBtn.setTitleColor(UIColor.white, for: UIControlState())
            self.recordList3 = arr
            self.showList3 = arr
            types = "out"
           
        }
        getRecord(types)
    }
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == tableView1 {
            return showList1.count
        }else if tableView == tableView2 {
            return showList2.count
        }else {
            return showList3.count
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 65
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentify) as! RecordViewCell
        cell.backgroundColor = UIColor.white
        if tableView == tableView1 {
            if showList1.count != 0 {
                cell.setInfo(showList1[indexPath.row])
            }
        }else if tableView == tableView2 {
            if showList2.count != 0 {
                cell.setInfo(showList2[indexPath.row])
            }
        }else if tableView == tableView3 {
            if showList3.count != 0 {
                cell.setInfo(showList3[indexPath.row])
            }
        }
        cell.selectionStyle = .none
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexRow != nil{
            let cell = tableView.cellForRow(at: indexRow!) as! CenterViewCell
            cell.backgroundColor = UIColor.white
            indexRow = nil
        }
        tableView.deselectRow(at: indexPath, animated: false)
        if tableView == tableView1 {
            
        }else if tableView == tableView2 {
           
        }else if tableView == tableView3 {
           
        }
    }
    var indexRow:IndexPath?
//    func tableView(tableView: UITableView, didHighlightRowAtIndexPath indexPath: NSIndexPath) {
//        
//        let cell = tableView.cellForRowAtIndexPath(indexPath) as! CenterViewCell
//        cell.backgroundColor = UIColor.init(hexCode: "efefef")
//        indexRow = indexPath
//    }
    
    
    func tableView(_ tableView: UITableView, didUnhighlightRowAt indexPath: IndexPath) {
        
        if indexRow != nil{
            let cell = tableView.cellForRow(at: indexRow!) as! CenterViewCell
            cell.backgroundColor = UIColor.white
            indexRow = nil
        }
    }
    var dragX:CGFloat = 0
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        if scrollView == self.scrollView {
            dragX = scrollView.contentOffset.x
        }
    }

    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        if scrollView == self.scrollView {
            let x = scrollView.contentOffset.x
//            print(screenWidth, dragX - x,dragX)
            if dragX - x > 0 {
                if dragX == screenWidth {
                    setBtnBackColor(0)
                }else if dragX == screenWidth * 2{
                    setBtnBackColor(1)
                }
            }else if dragX - x < 0{
                if dragX == 0 {
                    setBtnBackColor(1)
                }else if dragX == screenWidth {
                    setBtnBackColor(2)
                }
            }
        }

    }
    
    @IBAction func backClick(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func mainClick(_ sender: AnyObject) {
        let appdelegete:AppDelegate = UIApplication.shared.delegate as! AppDelegate
        appdelegete.showMainPage()
//        (UIApplication.shared.delegate) as! AppDelegate).showMainPage()
//        (UIApplication.shared.delegate as! AppDelegate).showMainPage()
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        payField.resignFirstResponder()
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    //币种选择
    @IBAction func currencyClick(_ sender: UIButton) {
        
    }
    
    @IBAction func nextClick(_ sender: UIButton) {
        if payField.text != "" {
            if !CommonConfig.checkPrice(payField.text!){
                noticeOnlyText("请输入正确的数量")
                return
            }
        }else{
            return
        }
        let pay = UPAPayViewController()
        pay.userID = String(CommonConfig.UserInfoCache.userId)
        pay.token = CommonConfig.Token
        pay.chongzhi = true
        pay.price = payField.text
        self.navigationController?.pushViewController(pay, animated: true)
        
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
