//
//  VIPGoodsDetailController.swift
//  huabi
//
//  Created by teammac3 on 2017/6/2.
//  Copyright © 2017年 ltl. All rights reserved.
//

import UIKit
import SwiftyJSON
import MJRefresh

class VIPGoodsDetailController: UIViewController,UIWebViewDelegate,CirCleViewDelegate,GoodsDetailViewDelegate ,UITableViewDelegate,UITableViewDataSource,UIAlertViewDelegate{
    
    @IBOutlet weak var mainBtn: UIButton!
    @IBOutlet weak var backBtn: UIButton!
    @IBOutlet weak var scrollveiw: UIScrollView!
    @IBOutlet weak var detailView: UIView!
    @IBOutlet weak var btn1: UIButton!
    @IBOutlet weak var btn2: UIButton!
    @IBOutlet weak var btn3: UIButton!
    @IBOutlet weak var sliderX: NSLayoutConstraint!
    
    
    @IBOutlet weak var buyBtn: UIButton!
    
    @IBOutlet weak var wid3: NSLayoutConstraint!

    
    var shareView:UIView!
    var bgView:UIView!
    var shareImg:UIImageView!
    var imgShow:UIView!
    var scroll:UIScrollView!
    var scroll2:UIScrollView!
    var goodsInfo:JSON!
    var goodsView:VIPGoodsView!
    var detailViews:GoodsDetailTwo!
    var animaView:UIView!
    var goodsid = ""
    var goodnum = 1
    var goodsAddress = ""
    var specsList:Array<Array<String>> = []
    var specsTitles:Array<String> = []
    var chooseDic:Dictionary = [String : String]()
    var chooseSizeDic:Dictionary = [String : String]()
    var isconfirmPay:Bool = false
    var commmentList:Array<JSON> = []
    var isFlash:Bool = false
    var isOC = false
    var goodsID = ""
    var showQRcodeBtn:Bool = false//是否显示二维码图标
    
    func getGoodsData(){
        RequestManager.RequestData(RequestUrl.Router.getVIPProduct(id: goodsID),showLoading: true, successCallBack: { (result) in
            self.goodsInfo = result["content"]
            self.initSetting()

        }) { (fail) in
//            print(fail)
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.automaticallyAdjustsScrollViewInsets = false
        if isOC {
            getGoodsData()
        }else{
            initSetting()

        }
        // Do any additional setup after loading the view.
    }
    
    func initSetting(){
        
        chooseDic = [:]

        goodsAddress = self.goodsInfo["address"].stringValue
        wid3.constant = screenWidth
        buyBtn.setTitle("马上充值", for: UIControlState())
        buyBtn.backgroundColor = CommonConfig.MainRedColor
       
        backBtn.setTitle(IconFontIconName.icon_back.rawValue, for: UIControlState())
        mainBtn.setTitle(IconFontIconName.icon_goods_backhome.rawValue, for: UIControlState())
        scrollveiw.isScrollEnabled = false;
        scrollveiw.backgroundColor = CommonConfig.MainGreenColor
        scrollveiw.contentSize = CGSize(width: screenWidth, height: (screenHeight-64)*2)
        setScrollView()
        setScroll2View()
        setScroll1RefreshFooter()
        setScroll2RefreshHeader()
        lastBtn = btn1
        setBtnType(0)
        detailView.isHidden = true
        setImgShow()
        animaView = UIView.init(frame: CGRect(x: screenWidth/2, y: screenHeight, width: 20, height: 20))
        animaView.backgroundColor = CommonConfig.MainRedColor
        animaView.layer.cornerRadius = 10
        animaView.clipsToBounds = true
        self.view.addSubview(animaView)
        RequestManager.RequestData(RequestUrl.Router.checkCollect(goods_id:self.goodsInfo["goods"]["id"].stringValue), successCallBack: { (result) in
            if result["code"].intValue == 0{
                self.isCollect = true
            }else{
                self.isCollect = false
            }
        }) { (fail) in
//            print(fail)
        }
        
    }
    
    func setScrollView(){
        var size = CommonConfig.getTextRectSize(self.goodsInfo["comment"]["last"]["content"].stringValue as NSString, font: UIFont.systemFont(ofSize: 11), size: CGSize(width: screenWidth-20, height: 0))
        let hei = 16+12+15+11+18+15+size.height+15
        size = CommonConfig.getTextRectSize(self.goodsInfo["goods"]["name"].stringValue as NSString, font: UIFont.systemFont(ofSize: 13), size: CGSize(width: screenWidth-22, height: 0))
//        hei = hei + screenWidth + size.height + 70 + 44 + 94 - 31 + 47
        scroll = UIScrollView.init(frame: CGRect(x: 0, y: 0, width: screenWidth, height: screenHeight-64))
        scroll.contentSize = CGSize(width: screenWidth, height: hei)
        scroll.isScrollEnabled = true
        scroll.backgroundColor = CommonConfig.MainGrayColor
        scrollveiw.addSubview(scroll)
        goodsView = Bundle.main.loadNibNamed("VIPGoodsView", owner: nil, options: nil)?.first as? VIPGoodsView
        goodsView.frame = CGRect(x: 0, y: 0, width: screenWidth, height: screenHeight-64-50)
        goodsView.addDelegate(self)
        goodsView.setInfo(self.goodsInfo,istime: isFlash)
        if goodsView != nil {
            scroll.addSubview(goodsView)
        }
    }
    var titlesArr:Array<UILabel> = []
    var countsArr:Array<UILabel> = []
    var sliderArr:Array<UILabel> = []
    
    func setScroll2View(){
        scroll2 = UIScrollView.init(frame: CGRect(x: 0, y: screenHeight-64, width: screenWidth, height: screenHeight-64))
        scroll2.backgroundColor = CommonConfig.MainGrayColor
        scroll2.contentSize = CGSize(width: screenWidth, height: screenHeight-64)
        scroll2.isScrollEnabled = true
        scrollveiw.addSubview(scroll2)
        detailViews = Bundle.main.loadNibNamed("GoodsDetailTwo", owner: nil, options: nil)?.first as? GoodsDetailTwo
        detailViews.frame = CGRect(x: 0, y: 0, width: screenWidth, height: screenHeight-64)
        detailViews.setScroll1(self.goodsInfo)
        detailViews.setScroll2()
        detailViews.setWebView(self.goodsInfo)
        if detailViews != nil {
            scroll2.addSubview(detailViews)
        }
        
    }
    
    func setImgShow(){
        imgShow = UIView.init(frame: CGRect(x: 0, y: 20, width: screenWidth, height: screenHeight-20))
        imgShow.backgroundColor = CommonConfig.MainFontBlackColor
        let tapGesturer = UITapGestureRecognizer(target: self, action: #selector(GoodsDetailViewController.closeShow))
        imgShow.isUserInteractionEnabled = true
        imgShow.addGestureRecognizer(tapGesturer)
        self.view.addSubview(imgShow)
        var imageArray: [String] = []
        let circleView = CirCleView(frame: CGRect(x: 0, y: (screenHeight - 20 - screenWidth)/2, width: screenWidth, height: screenWidth),resouceType: 2)
        circleView.delegate = self
        let count = self.goodsInfo["goods"]["imgs"].count
        for index in 0..<count {
            imageArray.append(CommonConfig.getImageUrl(self.goodsInfo["goods"]["imgs"][index].stringValue))
        }
        circleView.urlImageArray = imageArray
        circleView.currentImageView.isUserInteractionEnabled = false
        circleView.pageIndicator.isHidden = true
        imgShow.addSubview(circleView)
        imgShow.isHidden = true
    }
    
    func closeShow(){
        imgShow.isHidden = true
    }
    
    func setScroll1RefreshFooter(){
        let footer = MJRefreshBackNormalFooter.init {
            self.scrollveiw .scrollRectToVisible(CGRect(x: 0, y: self.scroll2.frame.origin.y, width: screenWidth, height: screenHeight-64), animated: true)
            self.scroll.mj_footer.endRefreshing()
            
            self.backBtn.isHidden = true
            self.mainBtn.isHidden = true
            self.detailView.isHidden = false
        }
        footer?.arrowView.image = nil
        footer?.setTitle("", for: .idle)
        footer?.setTitle("松开查看详情", for: .pulling)
        footer?.setTitle("松开查看详情", for: .refreshing)
        footer?.setTitle("松开查看详情", for: .willRefresh)
        footer?.setTitle("", for: .noMoreData)
        self.scroll.mj_footer = footer
    }
    
    func setScroll2RefreshHeader(){
        var header = MJRefreshNormalHeader.init {
            self.scrollveiw .scrollRectToVisible(CGRect(x: 0, y: 0, width: screenWidth, height: screenHeight-64), animated: true)
            self.detailViews.webView.scrollView.mj_header.endRefreshing()
            self.scroll.contentOffset = CGPoint(x: 0, y: 0)
            self.backBtn.isHidden = false
            self.mainBtn.isHidden = false
            self.detailView.isHidden = true
            //views 加载数据
        }
        header?.arrowView.image = nil
        header?.setTitle("下拉返回首页", for: .idle)
        header?.setTitle("松开返回首页", for: .pulling)
        header?.setTitle("松开返回首页", for: .refreshing)
        header?.setTitle("松开返回首页", for: .willRefresh)
        header?.setTitle("下拉返回首页", for: .noMoreData)
        self.detailViews.webView.scrollView.mj_header = header
        header = MJRefreshNormalHeader.init {
            self.scrollveiw .scrollRectToVisible(CGRect(x: 0, y: 0, width: screenWidth, height: screenHeight-64), animated: true)
            self.detailViews.scroll1.mj_header.endRefreshing()
            self.scroll.contentOffset = CGPoint(x: 0, y: 0)
            self.backBtn.isHidden = false
            self.mainBtn.isHidden = false
            self.detailView.isHidden = true
            //views 加载数据
        }
        self.detailViews.scroll1.mj_header = header
        header = MJRefreshNormalHeader.init {
            self.scrollveiw .scrollRectToVisible(CGRect(x: 0, y: 0, width: screenWidth, height: screenHeight-64), animated: true)
            self.detailViews.scroll2.mj_header.endRefreshing()
            self.scroll.contentOffset = CGPoint(x: 0, y: 0)
            self.backBtn.isHidden = false
            self.mainBtn.isHidden = false
            self.detailView.isHidden = true
            //views 加载数据
        }
        self.detailViews.scroll2.mj_header = header
    }
    
    @IBAction func backClick(_ sender: AnyObject) {
        
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func mainClick(_ sender: AnyObject) {
//        (UIApplication.shared.delegate as! AppDelegate).showMainPage()
    }
    var lastBtn:UIButton!
    
    @IBAction func btnClick(_ sender: UIButton) {
        if sender == lastBtn {
            return
        }
        lastBtn = sender
        setBtnType(sender.tag)
    }
    
    func setBtnType(_ type:NSInteger){
        var btnArr = [self.btn1,self.btn2,self.btn3]
        for i in 0..<3 {
            let btn = btnArr[i]
            if type == i {
                btn?.setTitleColor(CommonConfig.MainFontBlackColor, for: UIControlState())
            }else{
                btn?.setTitleColor(CommonConfig.MainFontGrayColor, for: UIControlState())
            }
        }
        self.detailViews.webView.isHidden = false
        self.detailViews.scroll1.isHidden = false
        self.detailViews.scroll2.isHidden = false
        if type == 0{
            self.detailViews.scroll1.isHidden = true
            self.detailViews.scroll2.isHidden = true
        }else if type == 1 {
            self.detailViews.webView.isHidden = true
            self.detailViews.scroll2.isHidden = true
        }else if type == 2 {
            self.detailViews.webView.isHidden = true
            self.detailViews.scroll1.isHidden = true
        }
        sliderAnimation(type)
    }
    
    func sliderAnimation(_ type:NSInteger){
        UIView.animate(withDuration: 0.5, animations: {
            self.sliderX.constant = (screenWidth - 2)/3*CGFloat(type)
        })
    }
    
       @IBAction func buyGoods(_ sender: AnyObject) {
        if !CommonConfig.isLogin {
            let login = UIStoryboard(name: "Home", bundle: nil).instantiateViewController(withIdentifier: "LoginViewController") as! LoginViewController
            login.isGoods = true
            self.navigationController?.pushViewController(login, animated: true)
        }else{
//            print("测试马上充值")
//            let searchview = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "RecordViewController") as! RecordViewController
//            searchview.isPay = true
            //  问题
//            let purseRecharge = PurseRecharge()
//            purseRecharge.userID = CommonConfig.UserInfoCache.userId
//            purseRecharge.token = CommonConfig.Token
//            //价格和商品ID
//            purseRecharge.sellPrice = self.goodsInfo["goods"]["sell_price"].stringValue
//            purseRecharge.goodid = self.goodsInfo["pid"].stringValue
//            purseRecharge.isVIPPage = true
//            self.navigationController?.pushViewController(purseRecharge, animated: true)
        }
    }
    
    func buyAnimation(){
        UIView.animate(withDuration: 0.5, animations: {
            let frame1 = CGRect(x: screenWidth/2, y: screenHeight-80, width: 20, height: 20)
            self.animaView.frame = frame1
        }, completion: { (result) in
            if result{
                UIView.animate(withDuration: 0.5, animations: {
                    let frame2 = CGRect(x: screenWidth, y: screenHeight-44, width: 20, height: 20)
                    self.animaView.frame = frame2
                }, completion: { (result) in
                    if result{
                        let frame3 = CGRect(x: screenWidth/2, y: screenHeight, width: 20, height: 20)
                        self.animaView.frame = frame3
                    }
                })
            }
        })
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

        return 2
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return CommonConfig.getCellHeight(self.specsList[indexPath.row]) + 50*newScale + 15
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

            let cell = tableView.dequeueReusableCell(withIdentifier: "cellID") as! UITableViewCell
        cell.backgroundColor = UIColor.cyan
//            cell.titles.text = self.specsTitles[indexPath.row]
//        cell..text = "哈哈哈"
//            if self.specsList.count != 0{
//                cell.setSearchInfo(self.specsList[indexPath.row],types: 3,flag: indexPath.row)
//                cell.line.isHidden = true
//            }
            cell.selectionStyle = .none
            return cell

    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        print("测试")
    }
    
    func tapAction() -> Void {
        
        self.bgView.removeFromSuperview()
    }
    var isCollect:Bool = false
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        UIApplication.shared.setStatusBarStyle(.default, animated: false)
        self.navigationController?.setNavigationBarHidden(true, animated: false)
        self.tabBarController?.tabBar.isHidden = true;
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
