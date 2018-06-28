//
//  GoodsDetailViewController.swift
//  huabi
//
//  Created by TeamMac2 on 16/9/5.
//  Copyright © 2016年 ltl. All rights reserved.
//

import UIKit
import SwiftyJSON
import MJRefresh
class GoodsDetailViewController: UIViewController,UIWebViewDelegate,CirCleViewDelegate,GoodsDetailViewDelegate ,UITableViewDelegate,UITableViewDataSource,UIAlertViewDelegate{

    
    @IBOutlet weak var collectBtn: UIButton!
    @IBOutlet weak var shareBtn: UIButton!
    
    @IBOutlet weak var qrcodeBtn: UIButton!
    
    @IBOutlet weak var mainBtn: UIButton!
    @IBOutlet weak var backBtn: UIButton!
    @IBOutlet weak var scrollveiw: UIScrollView!
    @IBOutlet weak var detailView: UIView!
    @IBOutlet weak var btn1: UIButton!
    @IBOutlet weak var btn2: UIButton!
    @IBOutlet weak var btn3: UIButton!
    @IBOutlet weak var sliderX: NSLayoutConstraint!
    
    @IBOutlet weak var shopCart: UIButton!
    
    @IBOutlet weak var buyBtn: UIButton!
    
    @IBOutlet weak var wid1: NSLayoutConstraint!
    @IBOutlet weak var wid2: NSLayoutConstraint!
    @IBOutlet weak var wid3: NSLayoutConstraint!
    @IBOutlet weak var chooseView: UIView!
    @IBOutlet weak var chooseImg: UIImageView!
    @IBOutlet weak var closeBtn: UIButton!
    @IBOutlet weak var choosetitle: UILabel!
    @IBOutlet weak var choosePrice: UILabel!
    @IBOutlet weak var chooseTableView: UITableView!
    @IBOutlet weak var delBtn: UIButton!
    @IBOutlet weak var addBtn: UIButton!
    @IBOutlet weak var chooseNum: UILabel!
    @IBOutlet weak var confirmBtn: UIButton!
    @IBOutlet weak var commentView: UIView!
    @IBOutlet weak var commentScroll: UIScrollView!
    @IBOutlet weak var commentTable: UITableView!
    @IBOutlet weak var commentBack: UIButton!
    
    @IBOutlet weak var commentTop: NSLayoutConstraint!
    @IBOutlet weak var chooseImgH: NSLayoutConstraint!
    
    var shareView:UIView!
    var bgView:UIView!
    var shareImg:UIImageView!
    var imgShow:UIView!
    var scroll:UIScrollView!
    var scroll2:UIScrollView!
    var goodsInfo:JSON!
    var goodsView:GoodsDetailView!
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
    var isFlash:Bool = false   // 普通抢购
    var isOC = false  //  是否oc跳转过来
    var goodsID = ""
    var showQRcodeBtn:Bool = false//是否显示二维码图标
    var isIntegral:Bool = false//是否是积分商品
    
    func getGoodsData(){
        RequestManager.RequestData(RequestUrl.Router.getProduct(id: goodsID),showLoading: true, successCallBack: { (result) in
            self.goodsInfo = result["content"]
            print("重新请求的数据",result["content"])
            self.initSetting()
            self.addShareView()
        }) { (fail) in
//            print(fail)
            self.noticeOnlyText("找不到商品")
            self.navigationController?.popViewController(animated: true)
        }
    }
    
    func getNewData(goodsID:String){
        
        if isIntegral
        {
            RequestManager.RequestData(RequestUrl.Router.getIntegralDetail(id: goodsID),showLoading: true, successCallBack: { (result) in
                self.goodsInfo = result["content"]
                print(result["content"])
                self.initSetting()
                self.addShareView()
            },failCallBack: { (fail) in
//                print(fail)
                self.noticeOnlyText("找不到商品")
                self.navigationController?.popViewController(animated: true)
            })
        }
        
        if isFlash {
            RequestManager.RequestData(RequestUrl.Router.flashDetail(id: goodsID),showLoading: true, successCallBack: { (result) in
                self.goodsInfo = result["content"]
                print(result["content"])
                self.initSetting()
                self.addShareView()
            }) { (fail) in
                //            print(fail)
                print("积分抢购")
                RequestManager.RequestData(RequestUrl.Router.pointDetail(id: goodsID),showLoading: true, successCallBack: { (result) in
                    self.goodsInfo = result["content"]
                    print(result["content"])
                    self.initSetting()
                    self.addShareView()
                }) { (fail) in
//                    print(fail)
                    self.noticeOnlyText("找不到商品")
                    self.navigationController?.popViewController(animated: true)
                }
            }
        }
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let tapGesturer = UITapGestureRecognizer(target: self, action: #selector(GoodsDetailViewController.hiddenChooseView))
        self.chooseView.isUserInteractionEnabled = true
        self.chooseView.addGestureRecognizer(tapGesturer)

        NotificationCenter.default.addObserver(self, selector: #selector(self.AddressRefresh(_:)), name: NSNotification.Name(rawValue: "AddressRefresh"), object: nil)   //刷新通知
        self.automaticallyAdjustsScrollViewInsets = false
        self.commentTable.mj_header = MJRefreshNormalHeader(refreshingTarget: self, refreshingAction: #selector(SearchViewController.headRefresh))
        self.commentTable.mj_footer = MJRefreshAutoNormalFooter(refreshingTarget: self, refreshingAction: #selector(SearchViewController.footRefresh))
        if isOC {
            getGoodsData()
        }else{
            if isIntegral
            {
                getNewData(goodsID: goodsID)
            }else if isFlash {
                getNewData(goodsID: goodsID)
            }else{
            initSetting()
            addShareView()
            }
        }
        // Do any additional setup after loading the view.
    }
    
    func addShareView(){
        shareImg = UIImageView.init(frame: CGRect(x: 0, y: 0, width: screenWidth, height: screenHeight))
        shareImg.hnk_setImageFromURL(URL: URL(string: CommonConfig.getImageUrl(self.goodsInfo["goods"]["img"].stringValue))! as NSURL, placeholder: UIImage(named: CommonConfig.imageDefaultName))
        shareView = UIView.init(frame: CGRect(x: 0, y: 0, width: screenWidth, height: screenHeight))
        shareView.backgroundColor = UIColor.clear;
        shareView.layer.masksToBounds = true
        self.view.addSubview(shareView)
        
        let shareBack = UIView.init(frame: CGRect(x: 0, y: screenHeight-150*newScale, width: screenWidth, height: 150*newScale))
        shareBack.backgroundColor = UIColor.white
        shareView.addSubview(shareBack)
        
        for i in 0..<3 {
            let btn = UIButton.init(frame: CGRect(x: screenWidth/3.0*CGFloat(i)+(screenWidth/3.0-90*newScale)/2.0, y: 30*newScale, width: 90*newScale, height: 90*newScale))
            btn.titleLabel?.font = UIFont.init(name: "iconfont", size: 42)
            if i == 0 {
                btn.setImage(UIImage.init(named: "weibo"), for: UIControlState())
            }else if i == 1{
                btn.setImage(UIImage.init(named: "qq"), for: UIControlState())
            }else if i == 2{
                btn.setImage(UIImage.init(named: "weixin"), for: UIControlState())
            }
            btn.tag = i
            btn.addTarget(self, action: #selector(GoodsDetailViewController.shareBtnClick(_:)), for: .touchUpInside)
            shareBack.addSubview(btn)
        }
        shareView.isHidden = true
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        if shareView.isHidden == false {
            shareView.isHidden = true
        }
    }
    
    func shareBtnClick(_ sender:UIButton){
        var type = UMSocialPlatformType.sina
        if sender.tag == 0 {
            type = UMSocialPlatformType.sina
        }else if  sender.tag == 1{
            type = UMSocialPlatformType.QQ
        }else if  sender.tag == 2{
            type = UMSocialPlatformType.wechatSession
        }
        [UMengHelper .shareWebPage(to: self, platformType: type, url: goodsInfo["goods"]["shareurl"].stringValue, title: "圆梦", descr: goodsInfo["goods"]["name"].stringValue, thumbImage: shareImg.image!, onShareSucceed: {
//                print("分享成功")
            }, onShareCancel: { 
                
        })]
    }

    func hiddenChooseView(){
        self.chooseView.isHidden = true
    }
    
    func initSetting(){

        self.commentBack.setTitle(IconFontIconName.icon_back.rawValue, for: UIControlState())
        getCommentInfo()
        setCommentScrollView()
        self.commentView.isHidden = true
        chooseDic = [:]
        shareBtn.setTitle(IconFontIconName.icon_share.rawValue, for: UIControlState())
        collectBtn.setTitle(IconFontIconName.icon_collect.rawValue, for: UIControlState())
        qrcodeBtn.setTitle(IconFontIconName.icon_qrcode2.rawValue, for: UIControlState())
        
//        var ss = self.goodsInfo["id"]
        
        if self.goodsInfo["id"].int != nil {
            qrcodeBtn.isHidden = true
            print("不显示")
        }
        else{
            qrcodeBtn.isHidden = false
            print("显示")
        }
        
//        if self.showQRcodeBtn {
//            qrcodeBtn.isHidden = false
//        }else {
//            qrcodeBtn.isHidden = true
//        }
        goodsAddress = self.goodsInfo["address"].stringValue
        wid1.constant = 136*newScale
        wid2.constant = (screenWidth - 136*newScale)/2
        wid3.constant = (screenWidth - 136*newScale)/2
        buyBtn.setTitle("立即购买", for: UIControlState())
        buyBtn.isUserInteractionEnabled = true
        buyBtn.backgroundColor = CommonConfig.MainRedColor
        if goodsInfo["goods"]["store_nums"].intValue == 0 {
            wid1.constant = screenWidth/2
            wid2.constant = 0
            wid3.constant = screenWidth/2
            buyBtn.setTitle("卖完了", for: UIControlState())
            buyBtn.isUserInteractionEnabled = false
            buyBtn.backgroundColor = CommonConfig.SliderBlackColor
            buyBtn.setTitleColor(CommonConfig.MainFontBlackColor, for: UIControlState())
            buyBtn.tag = -1
        }
        if isFlash {
            wid1.constant = screenWidth/2
            wid2.constant = 0
            wid3.constant = screenWidth/2
            if ((goodsInfo["goods"]["max_num"].intValue) - (goodsInfo["goods"]["goods_num"].intValue) == 0) || (goodsInfo["goods"]["is_end"].stringValue == "1")
                {
                buyBtn.setTitle("卖完了", for: UIControlState())
//                    buyBtn.setTitle("立即购买", for: UIControlState())
                buyBtn.isUserInteractionEnabled = false
                buyBtn.backgroundColor = CommonConfig.MainBackGrouneGrayColor
                buyBtn.setTitleColor(CommonConfig.MainWhiteColor, for: UIControlState())
            }
        }
        if isIntegral {
            wid1.constant = screenWidth/2
            wid2.constant = 0
            wid3.constant = screenWidth/2
            self.confirmBtn.setTitle("立即购买", for: UIControlState())
            buyBtn.isUserInteractionEnabled = true
        }
        shopCart.setTitle(IconFontIconName.icon_cart_normal.rawValue, for: UIControlState())
        backBtn.setTitle(IconFontIconName.icon_back.rawValue, for: UIControlState())
        mainBtn.setTitle(IconFontIconName.icon_goods_backhome.rawValue, for: UIControlState())
        scrollveiw.isScrollEnabled = false;
        scrollveiw.backgroundColor = CommonConfig.MainGrayColor
        scrollveiw.contentSize = CGSize(width: screenWidth, height: (screenHeight-64)*2)
        setChooseView()
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
        
        //  是否收藏商品
        RequestManager.RequestData(RequestUrl.Router.checkCollect(goods_id:self.goodsInfo["goods"]["id"].stringValue), successCallBack: { (result) in
            if result["code"].intValue == 0{
                self.isCollect = true
            }else{
                self.isCollect = false
            }
            self.checkCollection()
        }) { (fail) in
//            print(fail)
        }
        
    }
    
    func setChooseView(){
        self.chooseNum.text = "\(goodnum)"
        let specs = self.goodsInfo["goods"]["specs"]
        for i in 0..<specs.count {
            let value = specs[i]["value"]
            var valueArr:Array<String> = []
            for j in 0..<value.count {
                valueArr.append(value[j]["name"].stringValue)
            }
            specsTitles.append(specs[i]["name"].stringValue)
            specsList.append(valueArr)
        }
        self.closeBtn.layer.cornerRadius = 32/2
        self.closeBtn.clipsToBounds = true
        self.closeBtn.setTitle(IconFontIconName.icon_goods_cart_dismiss.rawValue, for: UIControlState())
        self.delBtn.layer.cornerRadius = 2
        self.delBtn.layer.borderWidth = 1
        self.delBtn.layer.borderColor = CommonConfig.SliderBlackColor.cgColor
        self.delBtn.clipsToBounds = true
        self.addBtn.layer.cornerRadius = 2
        self.addBtn.layer.borderWidth = 1
        self.addBtn.layer.borderColor = CommonConfig.SliderBlackColor.cgColor
        self.addBtn.clipsToBounds = true
        self.chooseImgH.constant = 204*newScale
        self.chooseTableView.tableHeaderView?.frame = CGRect(x: 0, y: 0, width: screenWidth, height: 13+204*newScale)
        self.chooseImg.hnk_setImageFromURL(URL: URL(string: CommonConfig.getImageUrl(self.goodsInfo["goods"]["img"].stringValue))! as NSURL, placeholder: UIImage(named: CommonConfig.imageDefaultName))
        self.choosetitle.text = self.goodsInfo["goods"]["name"].stringValue
        self.choosePrice.text = "¥" + self.goodsInfo["goods"]["sell_price"].stringValue
//        self.choosePrice.text = "¥" + self.goodsInfo["skumap"][0]["sell_price"].stringValue
        print("商品价格----------\(self.goodsInfo["skumap"][0]["sell_price"])")
        print("商品价格----------\(self.goodsInfo["goods"]["sell_price"])")
        self.chooseTableView.reloadData()
        self.chooseTableView.separatorStyle = .none
        self.chooseView.isHidden = true
        
    }
    
    func setScrollView(){
        var size = CommonConfig.getTextRectSize(self.goodsInfo["comment"]["last"]["content"].stringValue as NSString, font: UIFont.systemFont(ofSize: 11), size: CGSize(width: screenWidth-20, height: 0))
        var hei = 16+12+15+11+18+15+size.height+15
        size = CommonConfig.getTextRectSize(self.goodsInfo["goods"]["name"].stringValue as NSString, font: UIFont.systemFont(ofSize: 13), size: CGSize(width: screenWidth-22, height: 0))
        hei = hei + screenWidth + size.height + 70 + 44 + 94 - 31 + 47
        scroll = UIScrollView.init(frame: CGRect(x: 0, y: 0, width: screenWidth, height: screenHeight-64))
        scroll.contentSize = CGSize(width: screenWidth, height: hei)
        scroll.isScrollEnabled = true
        scroll.backgroundColor = CommonConfig.MainGrayColor
        scrollveiw.addSubview(scroll)
        goodsView = Bundle.main.loadNibNamed("GoodsDetailView", owner: nil, options: nil)?.first as? GoodsDetailView
        goodsView.frame = CGRect(x: 0, y: 0, width: screenWidth, height: hei)
        goodsView.addDelegate(self)
        goodsView.setInfo(self.goodsInfo,istime: isFlash,isIntegral: isIntegral)
        if goodsView != nil {
            scroll.addSubview(goodsView)
        }
    }
    var titlesArr:Array<UILabel> = []
    var countsArr:Array<UILabel> = []
    var sliderArr:Array<UILabel> = []

    func setCommentScrollView(){
        self.commentScroll.contentSize = CGSize(width: screenWidth, height: 0)
        self.commentScroll.isPagingEnabled = false
        let titleArr = ["全部","好评","中评","差评","晒图"]
        let countssArr = [self.goodsInfo["comment"]["total"].intValue,self.goodsInfo["comment"]["a"]["num"].intValue,self.goodsInfo["comment"]["b"]["num"].intValue,self.goodsInfo["comment"]["c"]["num"].intValue,0]
        for i in 0..<titleArr.count {
            let wid = (screenWidth-CGFloat(titleArr.count)-1)/CGFloat(titleArr.count)
            let title = UILabel.init(frame: CGRect(x: CGFloat(i)*wid+CGFloat(i), y: 9, width: wid, height: 12))
            title.text = titleArr[i]
            title.font = UIFont.systemFont(ofSize: 12)
            title.textColor = CommonConfig.MainFontGrayColor
            title.textAlignment = .center
            self.commentScroll.addSubview(title)
            let counts = UILabel.init(frame: CGRect(x: CGFloat(i)*wid+CGFloat(i), y: 25, width: wid, height: 12))
            counts.text = "(\(countssArr[i]))"
            counts.font = UIFont.systemFont(ofSize: 12)
            counts.textColor = CommonConfig.MainFontGrayColor
            counts.textAlignment = .center
            self.commentScroll.addSubview(counts)
            let slider = UILabel.init(frame: CGRect(x: CGFloat(i)*wid, y: 47-5, width: (screenWidth-4)/5, height: 5))
            slider.text = ""
            slider.backgroundColor = CommonConfig.MainRedColor
            slider.isHidden = true
            self.commentScroll.addSubview(slider)
            if i != 0 {
                let line = UILabel.init(frame: CGRect(x: CGFloat(i)*wid, y: 11, width: 1, height: 20))
                line.text = ""
                line.font = UIFont.systemFont(ofSize: 12)
                line.backgroundColor = CommonConfig.MainFontGrayColor
                self.commentScroll.addSubview(line)
            }
            let btn = UIButton.init(frame: CGRect(x: CGFloat(i)*wid+CGFloat(i), y: 0, width: wid, height: 47))
            btn.setTitle("", for: UIControlState())
            btn.backgroundColor = UIColor.clear
            btn.tag = i
            btn .addTarget(self, action: #selector(GoodsDetailViewController.commentSelect(_:)), for: .touchUpInside)
            self.commentScroll.addSubview(btn)
            titlesArr.append(title)
            countsArr.append(counts)
            sliderArr.append(slider)
        }
  
        setCommentTitleColor(0)
    }
    
    func commentSelect(_ sender:UIButton){
        setCommentTitleColor(sender.tag)
        self.commentTable.mj_header.isHidden = false
        self.commentTable.mj_footer.isHidden = false
        let list:Array<JSON> = []
        self.commmentList = list
        page = 1
        if sender.tag == 0 {
            score = ""
        }else if sender.tag == 1{
            score = "a"
        }else if sender.tag == 2{
            score = "b"
        }else if sender.tag == 3{
            score = "c"
        }else if sender.tag == 4{
            self.commentTable.reloadData()
            self.commentTable.mj_header.isHidden = true
            self.commentTable.mj_footer.isHidden = true
            return
        }
        getCommentInfo(sender.tag)
    }
    
    func setCommentTitleColor(_ tag:NSInteger = 0){
        for i in 0..<titlesArr.count {
            let title = titlesArr[i]
            let count = countsArr[i]
            let slider = sliderArr[i]
            if i == tag {
                title.textColor = CommonConfig.MainRedColor
                count.textColor = CommonConfig.MainRedColor
                slider.isHidden = false
            }else{
                title.textColor = CommonConfig.MainFontGrayColor
                count.textColor = CommonConfig.MainFontGrayColor
                slider.isHidden = true
            }
        }
    }
    
    var score = ""
    var page = 1
    func getCommentInfo(_ tag:NSInteger = 0){
        RequestManager.RequestData(RequestUrl.Router.getCommentReview(id: self.goodsInfo["goods"]["id"].stringValue, score: score, page: page, pagetype: 1), successCallBack: { (result) in
//            print(result)
            for i in 0..<result["content"]["reviewlist"].count{
                self.commmentList.append(result["content"]["reviewlist"][i])
            }
            if result["content"]["reviewlist"].count < 10 {
                self.commentTable.mj_footer.endRefreshingWithNoMoreData()
                self.commentTable.mj_footer.isHidden = true
            }else{
                self.commentTable.mj_footer.endRefreshing()
            }
            self.commentTable.reloadData()
            }) { (fail) in
//                print(fail)
        }
    }
    
    func headRefresh(){
        self.commentTable.mj_header.beginRefreshing()
        self.commentTable.reloadData()
        self.commentTable.mj_header.endRefreshing()
    }
    
    func footRefresh(){
        self.commentTable.mj_footer.beginRefreshing()
        page += 1
        getCommentInfo()
    }
    
    func selectGoodsDetailImage(_ tag: NSInteger) {
        self.imgShow.isHidden = false
        
    }
    //评论
    func selectGoodsDetailButton(_ tag: NSInteger) {
        self.commentView.isHidden = false
        score = ""
        page = 1
        setCommentTitleColor(0)
        getCommentInfo()
        commentAnimation(true)
    }
    
    func selectGoodsDetailAddress(_ tag: NSInteger) {
        if CommonConfig.isLogin  {
            let info = UIStoryboard(name: "Me", bundle: nil).instantiateViewController(withIdentifier: "AddressViewController") as! AddressViewController
            info.isGoods = true
            self.navigationController?.pushViewController(info, animated: true)
        }else{
            let login = UIStoryboard(name: "Home", bundle: nil).instantiateViewController(withIdentifier: "LoginViewController") as! LoginViewController
            login.isGoods = true
            self.navigationController?.pushViewController(login, animated: true)
        }
    }
    
    func selectGoodsDetailcolor(_ tag: NSInteger) {
        self.chooseView.isHidden = false
    }
    
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
    
    
    @IBAction func commentClose(_ sender: AnyObject) {
        if self.commentView.isHidden == false{
            commentAnimation(false)
        }
    }
    
    func commentAnimation(_ type:Bool){
        UIView.animate(withDuration: 0.5, animations: {
            if type{
                self.commentTop.constant = 0
            }else{
                self.commentTop.constant = screenHeight - 64
            }
            self.view.layoutIfNeeded()
            
        }) 
    }

    @IBAction func backClick(_ sender: AnyObject) {
        
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func mainClick(_ sender: AnyObject) {
        (UIApplication.shared.delegate as! AppDelegate).showMainPage()
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
    
    @IBAction func toShoppingCart(_ sender: AnyObject) {
      //  if !CommonConfig.isLogin {
      //      let login = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("LoginViewController") as! LoginViewController
        //    self.navigationController?.pushViewController(login, animated: true)
        //}else{
            let pay = UIStoryboard(name: "ShopCart", bundle: nil).instantiateViewController(withIdentifier: "ShoppingTrolleyController") as! ShoppingTrolleyController
            pay.isPush = true
            self.navigationController?.pushViewController(pay, animated: true)
        //}
    }
    //  添加到购物车
    @IBAction func addGoods(_ sender: AnyObject)
    {
        if goodsInfo["goods"]["store_nums"].intValue == 0
        {
            self.noticeOnlyText("卖完了!")
            return
        }
        
        //  积分购商品
        if isIntegral
        {
            if goodsid == ""
            {
                if self.goodsInfo["goods"]["specs"].count == 0 && self.goodsInfo["skumap"].count == 1
                {
                    goodsid = self.goodsInfo["skumap"][0]["id"].stringValue
                }
                else
                {
                    self.chooseView.isHidden = false
                    self.isconfirmPay = true
                    self.confirmBtn.setTitle("确定", for: UIControlState())
                    self.confirmBtn.backgroundColor = CommonConfig.MainRedColor
                    return
                }
                
            }
            if buyBtn.tag < 0
            {
                return
            }
            if !CommonConfig.isLogin
            {
                let login = UIStoryboard(name: "Home", bundle: nil).instantiateViewController(withIdentifier: "LoginViewController") as! LoginViewController
                login.isGoods = true
                self.navigationController?.pushViewController(login, animated: true)
            }
            else
            {
                RequestManager.RequestData(RequestUrl.Router.addGoodsTwo(id: goodsid, num: goodnum),showLoading: true, successCallBack: { (result) in
                    let newpay = NewPayViewController()
                    newpay.goodsID = self.goodsid;
                    newpay.orderids = []
                    newpay.userID = CommonConfig.UserInfoCache.userId;
                    newpay.isGoods = true
                    newpay.accessToken = CommonConfig.Token
                    //积分
                    if self.isIntegral{
                        let arr = self.goodsInfo["skumap"][0]
                        newpay.cash = arr["cash"].floatValue
                        newpay.point = arr["point"].floatValue
                        newpay.isIntegral = "YES"
                    }
                    self.navigationController?.pushViewController(newpay, animated: true)
                }) { (fail) in
                    print(fail)
                    self.noticeOnlyText(fail)
                }
            }
        }
        else
        {

                if !self.chooseView.isHidden
                {
                    if checkChoose()
                    {
                        return
                    }
                    let notice = Notification.init(name: Notification.Name(rawValue: "chooseSize"), object: ["chooseSize":chooseSize])
                    NotificationCenter.default.post(notice)
                }
            if isconfirmPay
            {
                self.chooseView.isHidden = true
            }
            else
            {
                if goodsid == ""
                {
                    if self.goodsInfo["goods"]["specs"].count == 0 && self.goodsInfo["skumap"].count == 1
                    {
                        goodsid = self.goodsInfo["skumap"][0]["id"].stringValue
                    }
                    else
                    {
                        self.chooseView.isHidden = false
                        self.isconfirmPay = true
                        self.confirmBtn.setTitle("加入购物车", for: UIControlState())
                        self.confirmBtn.backgroundColor = CommonConfig.MainYellowColor
                        return
                    }
                    
                }
                    RequestManager.RequestData(RequestUrl.Router.addGoods(id: goodsid, num: goodnum),showLoading: true, successCallBack: { (result) in
                        let alert = UIAlertView.init(title: "", message: "已添加到购物车", delegate: self, cancelButtonTitle: "确定")
                        alert.show()
                        CommonConfig.shopBadge += 1
                        CommonConfig.setCartBadge("\(CommonConfig.shopBadge)")
                        let notice = NSNotification.init(name: NSNotification.Name(rawValue: "refresh3"), object: nil)
                        NotificationCenter.default.post(notice as Notification)
//                        print(result)
                        }) { (fail) in
//                            print(fail)
                            self.noticeOnlyText("添加失败")
                            }
            }
        }
    }
    
    @IBAction func buyGoods(_ sender: AnyObject)
    {
        if goodsid == ""
        {
            if self.goodsInfo["goods"]["specs"].count == 0 && self.goodsInfo["skumap"].count == 1
            {
                goodsid = self.goodsInfo["skumap"][0]["id"].stringValue
                print("1")
            }
            else
            {
                self.chooseView.isHidden = false
                self.isconfirmPay = true
                self.confirmBtn.setTitle("确定", for: UIControlState())
                self.confirmBtn.backgroundColor = CommonConfig.MainRedColor
                print("2")
                return
            }
            
        }
        if buyBtn.tag < 0 { return }
        if !CommonConfig.isLogin
        {
            let login = UIStoryboard(name: "Home", bundle: nil).instantiateViewController(withIdentifier: "LoginViewController") as! LoginViewController
            login.isGoods = true
            print("3")
            self.navigationController?.pushViewController(login, animated: true)
        }
        else
        {
            RequestManager.RequestData(RequestUrl.Router.addGoodsTwo(id: goodsid, num: goodnum),showLoading: true, successCallBack:
                {
                (result) in
                    print("4")
                    let newpay = NewPayViewController()
                    newpay.goodsID = self.goodsid;
                    newpay.orderids = []
                    newpay.userID = CommonConfig.UserInfoCache.userId;
                    newpay.isGoods = true
                    newpay.accessToken = CommonConfig.Token
                    
                    if let number = self.goodsInfo["goods"]["start_time"].string {
                        newpay.cash = self.goodsInfo["price"].floatValue
                        newpay.point = self.goodsInfo["cost_point"].floatValue
                        print("积分抢购所需现金1",newpay.cash)
                        newpay.shoppingID = self.goodsInfo["id"].stringValue
                        newpay.isIntegral = "NO"
                        newpay.isQiangGou = true
                    }
                    //积分
                    if self.isIntegral
                    {
                        let arr = self.goodsInfo["skumap"][0]
                        newpay.cash = arr["cash"].floatValue
                        newpay.point = arr["point"].floatValue
    //                    newpay.shoppingID = arr["type"]["id"].stringValue
                        newpay.shoppingID = self.goodsInfo["id"].stringValue
                        print("积分购所需现金2",newpay.cash)
                        newpay.isQiangGou = false
                        newpay.isIntegral = "YES"
    //                    print(newpay.shoppingID)
                        self.navigationController?.pushViewController(newpay, animated: true)
                    }
                    else
                    {
                        self.navigationController?.pushViewController(newpay, animated: true)
                    }
                })
            {
                (fail) in
                print(fail)
                self.noticeOnlyText(fail)
            }
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
    
    @IBAction func closeClick(_ sender: AnyObject) {
        self.chooseView.isHidden = true
    }
    @IBAction func delClick(_ sender: AnyObject) {
        if goodnum == 1 {
            return
        }
        goodnum -= 1
        self.chooseNum.text = "\(goodnum)"
    }
    
    @IBAction func addClick(_ sender: AnyObject) {
        goodnum += 1
        self.chooseNum.text = "\(goodnum)"
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == self.commentTable {
            return self.commmentList.count
        }
        return self.specsList.count

    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        if tableView == self.commentTable {
            let size = CommonConfig.getTextRectSize(self.commmentList[indexPath.row]["content"].stringValue as NSString, font: UIFont.systemFont(ofSize: 12), size: CGSize(width: screenWidth-34, height: 0))
            var hei = 27+9+9+12+16+12+12+12+size.height
            if self.commmentList[indexPath.row]["spec"].stringValue != ""{
                hei += 10+10
            }
            return hei
        }
        return CommonConfig.getCellHeight(self.specsList[indexPath.row]) + 50*newScale + 15

    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if tableView == self.commentTable {
            let cell = tableView.dequeueReusableCell(withIdentifier: "CommentViewCell") as! CommentViewCell
            cell.backgroundColor = UIColor.white
            if self.commmentList.count != 0{
                cell.setCommentInfo(self.commmentList[indexPath.row])
            }
            cell.selectionStyle = .none
            return cell
        }else{
            let cell = tableView.dequeueReusableCell(withIdentifier: "SearchNormalCell") as! SearchNormalCell
            cell.backgroundColor = UIColor.white
            cell.titles.text = self.specsTitles[indexPath.row]
            if self.specsList.count != 0{
                cell.setSearchInfo(self.specsList[indexPath.row],types: 3,flag: indexPath.row)
                cell.line.isHidden = true
                cell.chooseClick = viewTagClick
            }
            cell.selectionStyle = .none
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if tableView == self.commentTable {
            
        }
    }
    
    var chooseArr:Array<String> = []
    func viewTagClick(_ str:NSString){
        let arr = str.components(separatedBy: "-")
        let section = (arr[0] as NSString).integerValue
        let row = (arr[1] as NSString).integerValue
        let imgs = self.goodsInfo["goods"]["specs"][section]["value"][row]["img"].stringValue
        let id1 = self.goodsInfo["goods"]["specs"][section]["id"].stringValue
        let id2 = self.goodsInfo["goods"]["specs"][section]["value"][row]["id"].stringValue
        let name = self.goodsInfo["goods"]["specs"][section]["value"][row]["name"].stringValue
        if imgs != "" {
            if !imgs.hasSuffix(".gif") {
                self.chooseImg.hnk_setImageFromURL(URL: URL(string: CommonConfig.getImageUrl(imgs))! as NSURL, placeholder: UIImage(named: CommonConfig.imageDefaultName))
            }
        }
        chooseDic["\(id1)"] = id2
        chooseSizeDic["\(id1)"] = name
        chooseArr.append(self.specsTitles[section])
//        print(str,section,row,chooseDic)
        
    }
    var chooseSize = ""
    func checkChoose() -> Bool{
        var text = ""
        for i in 0..<self.specsTitles.count {
            var falg = 0
            for j in 0..<self.chooseArr.count {
                if self.specsTitles[i] == self.chooseArr[j] {
                    falg = 1
                    break
                }
            }
            if falg == 0 {
                text = text + self.specsTitles[i] + " "
            }
        }
        if text != "" {
            self.noticeOnlyText("请选择 "+text)
            return true
        }else{
            text = ";"
            for m in 0..<self.specsTitles.count {
                let key = self.goodsInfo["goods"]["specs"][m]["id"].stringValue
                let value = self.chooseDic[key]
                chooseSize = chooseSize + self.chooseSizeDic[key]! + " "
                text = text + key + ":" + value! + ";"
            }
            for k in 0..<self.goodsInfo["skumap"].count {
                if self.goodsInfo["skumap"][k]["specs_key"].stringValue == text {
                    self.goodsid = self.goodsInfo["skumap"][k]["id"].stringValue
                    break
                }
            }
            return false
        }
    }
    
    
    @IBAction func shareClick(_ sender: UIButton) {
         shareView.isHidden = !shareView.isHidden
     
    }
    
    @IBAction func qrcodeClick(_ sender: UIButton) {
        
//        //请求专区列表
//        RequestManager.RequestData(RequestUrl.Router.getQRCode(userid: CommonConfig.UserInfoCache.userId, token: CommonConfig.Token,goodsID: self.goodsInfo["goods"]["id"].stringValue), successCallBack: { (result) in
//            print("二维码")
////            print(result)
////            print(result["content"]["url"])
//            self.bgView = UIView(frame: CGRect(x:0,y:0,width:screenWidth,height:screenHeight))
//            self.bgView.backgroundColor = UIColor.clear
//            let tap = UITapGestureRecognizer(target: self, action:#selector(self.tapAction))
//            self.bgView.addGestureRecognizer(tap)
//            self.view!.addSubview(self.bgView)
//
////            let str = "goods_id:" + result["content"]["goods_id"].string!
//            let qrV = QRCodeView(frame: CGRect(x:0, y:0,width: 230,height: 230),withLinkStr:result["content"]["url"].string)
//            qrV?.center = CGPoint(x: CGFloat(screenWidth / 2), y: CGFloat(screenHeight / 2))
//            self.bgView.addSubview(qrV!)
//
//            }, failCallBack: { (falseStr) in
//
//        })
        if CommonConfig.isLogin {
            let vc = UIStoryboard(name: "New", bundle: nil).instantiateViewController(withIdentifier: "ShareViewController") as! ShareViewController
            vc.header = self.goodsInfo["goods"]["name"].stringValue
            vc.imageUrl = self.goodsInfo["goods"]["img"].stringValue
            vc.goodsId = self.goodsInfo["goods"]["id"].stringValue
            self.navigationController?.pushViewController(vc, animated: true)
            
        }
        else
        {
            let vc = UIStoryboard(name: "Home", bundle: nil).instantiateViewController(withIdentifier: "LoginViewController") as! LoginViewController
            vc.isGoods = true
            self.navigationController?.pushViewController(vc, animated: true)
            
        }
        
        
    }
    func tapAction() -> Void {
        
        self.bgView.removeFromSuperview()
    }
    
    @IBAction func collectClick(_ sender: UIButton) {
        if CommonConfig.isLogin {
            if isCollect {
                RequestManager.RequestData(RequestUrl.Router.delCollect(id: self.goodsInfo["goods"]["id"].stringValue, user_id: CommonConfig.UserInfoCache.userId), successCallBack: { (result) in
//                    print(result)
                    self.isCollect = false
                    self.checkCollection()
                    self.noticeOnlyText("取消收藏成功")
                }) { (fail) in
                    self.noticeOnlyText(fail)
                }
            }else{
                RequestManager.RequestData(RequestUrl.Router.addCollect(id: self.goodsInfo["goods"]["id"].stringValue, user_id: CommonConfig.UserInfoCache.userId), successCallBack: { (result) in
//                    print(result)
                    self.isCollect = true
                    self.checkCollection()
                    self.noticeOnlyText("收藏成功")
                }) { (fail) in
                    self.noticeOnlyText(fail)
                }
            }
        }else{
            let login = UIStoryboard(name: "Home", bundle: nil).instantiateViewController(withIdentifier: "LoginViewController") as! LoginViewController
            login.isGoods = true
            self.navigationController?.pushViewController(login, animated: true)
        }
    }
    var isCollect:Bool = false
    func checkCollection(){
        if isCollect {
            self.collectBtn.setTitle(IconFontIconName.icon_collected.rawValue, for: UIControlState())
            self.collectBtn.titleLabel?.font = UIFont.init(name: "iconfont", size: 25)
        }else{
            self.collectBtn.setTitle(IconFontIconName.icon_collect.rawValue, for: UIControlState())
            self.collectBtn.titleLabel?.font = UIFont.init(name: "iconfont", size: 25)
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
    
    func AddressRefresh(_ notification:Notification){
        let info = notification.object as! NSDictionary
        let address = info.value(forKey: "address") as! String
        self.goodsAddress = address
        //        NSNotificationCenter.defaultCenter().removeObserver(self, name: "refreshAddress", object: nil)
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
