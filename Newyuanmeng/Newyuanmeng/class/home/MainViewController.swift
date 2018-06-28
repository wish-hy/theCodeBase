//
//  MainViewController.swift
//  huabi
//
//  Created by TeamMac2 on 16/8/24.
//  Copyright © 2016年 ltl. All rights reserved.
//

import UIKit
import SwiftyJSON
import CoreTelephony
import AFNetworking
import MJRefresh

class MainViewController: UIViewController,UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout{

    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var messBtn: UIButton!

    @IBOutlet weak var qrcode: UIButton!
    @IBOutlet weak var search: UIView!
    
    @IBOutlet weak var refreshViews: UIView!
    
    @IBOutlet weak var refreshBtn: UIButton!
    
    @IBOutlet weak var showtop: UILabel!
    
    @IBOutlet weak var toptext: UILabel!
    
    @IBOutlet weak var questionView: UIView!
    var listData:Array<GoodsModel> = []
    var showList:Array<GoodsModel> = []
    var columnWidth:CGFloat = 0
    var timer: Timer!
    var page = 1
    var pageCount = 1
    
    @IBAction func refreshClick(_ sender: UIButton) {
        if showtop.isHidden {
            refreshOne()
        }else{
            self.collectionView.setContentOffset(CGPoint(x: 0, y: 0), animated: true)
         
        }
    }
    
    @IBOutlet weak var questionBtn: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        search.layer.cornerRadius = 5
        search.layer.borderColor = CommonConfig.SliderBlackColor.cgColor
        search.layer.borderWidth = 1
        search.clipsToBounds = true
        let tapGesturer1 = UITapGestureRecognizer(target: self, action: #selector(MainViewController.toSearch(_:)))
        search.isUserInteractionEnabled = true
        search.addGestureRecognizer(tapGesturer1)
        refreshViews.layer.cornerRadius = 22
        refreshViews.clipsToBounds = true
        showtop.text = IconFontIconName.icon_goods_showmore.rawValue
        showtop.isHidden = true
        toptext.isHidden = true
        //添加刷新
        self.collectionView.mj_header = MJRefreshNormalHeader(refreshingTarget: self, refreshingAction: #selector(MainViewController.headRefresh))
        self.collectionView.mj_footer = MJRefreshAutoNormalFooter(refreshingTarget: self, refreshingAction: #selector(MainViewController.footRefresh))
        self.collectionView.mj_footer.isHidden = false
//        messBtn.setTitle(IconFontIconName.icon_msg.rawValue, for: UIControlState())
//        qrcode.setTitle(IconFontIconName.icon_qrcode.rawValue, for: UIControlState())
        getHomePage()
        self.hidesBottomBarWhenPushed = false
        
        var version = UIDevice.current.systemVersion
        // 判断是否具有网络请求状态
//        ConnectManager.request()
        var cellularData = CTCellularData()
        
        /*
         此函数会在网络权限改变时再次调用
         */
        cellularData.cellularDataRestrictionDidUpdateNotifier = {(_ state: CTCellularDataRestrictedState) -> Void in
            switch state {
            case .restricted:
                print("权限关闭")
                //2.1权限关闭的情况下 再次请求网络数据会弹出设置网络提示
                //                [self getAppInfo];
                
                self.questionView.isHidden = false
            case .notRestricted:
                print("已开启授权")
                //2.2已经开启网络权限 监听网络状态
                //                [self addReachabilityManager:application didFinishLaunchingWithOptions:launchOptions];
                //                [self getInfo_application:application didFinishLaunchingWithOptions:launchOptions];
                self.questionView.isHidden = true
            case .restrictedStateUnknown:
                print("授权不详")
                //2.3未知情况 （还没有遇到推测是有网络但是连接不正常的情况下）
                //                [self getAppInfo];
                self.questionView.isHidden = false
            default:
                break
            }
        }
        
//        //2.根据权限执行相应的交互
//        CTCellularData *cellularData = [[CTCellularData alloc] init];
//
//        /*
//         此函数会在网络权限改变时再次调用
//         */
//
//        cellularData.cellularDataRestrictionDidUpdateNotifier = ^(CTCellularDataRestrictedState state) {
//            switch (state) {
//            case kCTCellularDataRestricted:
//
//                NSLog(@"权限关闭");
//                //2.1权限关闭的情况下 再次请求网络数据会弹出设置网络提示
//                //                [self getAppInfo];
//
//                break;
//            case kCTCellularDataNotRestricted:
//
//                NSLog(@"已开启授权");
//                //2.2已经开启网络权限 监听网络状态
//                //                [self addReachabilityManager:application didFinishLaunchingWithOptions:launchOptions];
//                //                [self getInfo_application:application didFinishLaunchingWithOptions:launchOptions];
//
//                break;
//            case kCTCellularDataRestrictedStateUnknown:
//
//                NSLog(@"授权不详");
//                //2.3未知情况 （还没有遇到推测是有网络但是连接不正常的情况下）
//                //                [self getAppInfo];
//
//                break;
//
//            default:
//                break;
//            }
//        };
        
        if #available(iOS 10.0, *) {
            let url = URL.init(string: "https://www.baidu.com")
            let sessionManager = AFHTTPSessionManager.init(baseURL: url)
            
            sessionManager.reachabilityManager.setReachabilityStatusChange({ (status) in
                switch (status){
                case .unknown:
                    self.questionView.isHidden = false
                case .notReachable:
                    self.questionView.isHidden = true
                case .reachableViaWWAN:
                    self.questionView.isHidden = true
                case .reachableViaWiFi:
                    self.questionView.isHidden = false
                }
            })
            
        }
        
        
        let alert = MyCenterViewController()
        alert.referAPP()
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.refreshOne), name: NSNotification.Name(rawValue: "refresh1"), object: nil)   //刷新通知
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.getGoodsID(_:)), name: NSNotification.Name(rawValue: "getGoodsID"), object: nil)   //刷新通知
        NotificationCenter.default.addObserver(self, selector: #selector(self.integralPage(_:)), name:NSNotification.Name(rawValue: "integralBuy"), object: nil)   //积分购物跳转通知
        
        
    }
    
    
    // 刷新通知
    func getGoodsID(_ notification:Notification){
        
        let userInfo = notification.userInfo as! [String:AnyObject]
        let goodID = userInfo["goods_id"] as! String
        CommonConfig.getProductDetail(self, goodsID: goodID)
    }
    
    
    //  积分购跳转通知
    func integralPage(_ notification:Notification){
        
        let userInfo = notification.userInfo as! [String:AnyObject]
        let goodsID = userInfo["goods_id"] as! String
        jumpIntegralDetailPage(goodsID: goodsID)
    }
    
    
    //跳转积分详情页面
    func jumpIntegralDetailPage(goodsID:String){
        
        RequestManager.RequestData(RequestUrl.Router.getIntegralDetail(id: goodsID),showLoading: true, successCallBack: { (result) in
            
            let goods = UIStoryboard(name: "Me", bundle: nil).instantiateViewController(withIdentifier: "GoodsDetailViewController") as! GoodsDetailViewController
//            print(result["content"])
            
            goods.goodsInfo = result["content"]
            goods.goodsID = goodsID
            goods.showQRcodeBtn = false
            goods.isIntegral = true
            self.navigationController?.pushViewController(goods, animated: true)
            
            
        },failCallBack: { (fail) in
//            print(fail)
        })
        
    }

    
    func normalState() {
        SwiftNotice.clear()
        if self.showList.count ==  self.listData.count && page == pageCount{
            self.collectionView.mj_footer.endRefreshingWithNoMoreData()
            self.collectionView.mj_footer.isHidden = true
        }else{
            self.collectionView.mj_footer.endRefreshing()
        }
        if self.timer == nil {
            return
        }
        self.timer.invalidate()
        self.timer = nil
    }
    
    func headRefresh(){
        self.collectionView.mj_header.beginRefreshing()
        self.collectionView.reloadData()
        self.collectionView.mj_header.endRefreshing()
        if self.collectionView.mj_footer.isHidden {
            self.collectionView.mj_footer.isHidden = false
        }
        if self.listData.count == self.showList.count && self.page == self.pageCount{
            self.collectionView.mj_footer.isHidden = true
        }
    }
    
    func footRefresh(){
        self.collectionView.mj_footer.beginRefreshing()
        if self.showList.count < self.listData.count {
            SwiftNotice.wait()
            self.timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(MainViewController.normalState), userInfo: nil, repeats: false)
            let count = self.showList.count
            var numb = self.listData.count - self.showList.count
            if numb > 9 {
                numb = 9
            }
            for i in 0..<numb {
                self.showList.append(self.listData[count + i])
            }
            self.collectionView.reloadData()
        }else{
            page += 1
            getHomePage(1)
        }
    }
    
    //  首页搜索跳转
    func toSearch(_ tap:UITapGestureRecognizer){
        let searchController = UIStoryboard(name: "ShopCart", bundle: nil).instantiateViewController(withIdentifier: "SearchViewController") as! SearchViewController
        self.navigationController?.pushViewController(searchController, animated: true)
    }
    
    //  获取首页数据
    func getHomePage(_ type:NSInteger = 0){
        RequestManager.RequestData(RequestUrl.Router.getReferGoods(page: page), showLoading: true, successCallBack: { (result) in
            let count = self.listData.count
            self.pageCount = result["content"]["page_info"]["page_count"].intValue
            for arr in result["content"]["goods"].arrayValue{
                self.listData.append(GoodsModel(goodsInfo: arr))
            }
            if result["content"]["goods"].count > 9 {
                for i in 0..<9 {
                    self.showList.append(self.listData[count + i])
                }
            }else{
                for arr in result["content"]["goods"].arrayValue{
                    self.showList.append(GoodsModel(goodsInfo: arr))
                }
            }
            if type == 1{
                self.collectionView.mj_footer.endRefreshing()
            }
            if self.listData.count == self.showList.count && self.page == self.pageCount{
                self.collectionView.mj_footer.endRefreshingWithNoMoreData()
                self.collectionView.mj_footer.isHidden = true
            }
            self.collectionView.reloadData()
        }) { (failstr) in
//            print(failstr)
        }
    }
    
    // 抢购
    func disViewClick(){
        let flash = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "FlashViewController") as! FlashViewController
        self.navigationController?.pushViewController(flash, animated: true)
    }
    
    // 积分，优惠精选
    func integralListClick(){
        let list = IntegralListViewController()
        self.navigationController?.pushViewController(list, animated: true)
        list.tabBarController?.tabBar.isHidden = false;
    }
    
    
    func bannerClick(_ bannerInfo:JSON){
        let type = bannerInfo["url"]["type"].stringValue
        let type_value = bannerInfo["url"]["type_value"].stringValue
        if type == "goods" {
            CommonConfig.getProductDetail(self, goodsID: type_value)
        }else{
            let searchview = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "SearchViewController") as! SearchViewController
            searchview.isResult = true
            if type == "search" {
                searchview.searchKey = type_value
            }else if type == "category" {
                searchview.cid = type_value
            }
            self.navigationController?.pushViewController(searchview, animated: true)
        }
    }
    
    func selectClick(_ tag:NSInteger){
        if tag == 10001 {
            let weishangController = WeiShangViewController()
            self.navigationController?.pushViewController(weishangController, animated: true)
        }else if tag == 10002 {
            let searchview = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "SearchViewController") as! SearchViewController
            searchview.isResult = true
            searchview.cid = "161"
            //let controller =  JewelryViewController()
            self.navigationController?.pushViewController(searchview, animated: true)
        }else if tag == 10003 {
            let searchview = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "SearchViewController") as! SearchViewController
            searchview.isResult = true
            searchview.cid = "162"
            self.navigationController?.pushViewController(searchview, animated: true)
        }else if tag == 10004 {
//            let flash = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("FlashViewController") as! FlashViewController
//            self.navigationController?.pushViewController(flash, animated: true)
//            let vip = VIPViewController()
//            self.hidesBottomBarWhenPushed = true;
//            self.navigationController?.pushViewController(vip, animated: true)
//            self.hidesBottomBarWhenPushed = false;
            let searchview = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "SearchViewController") as! SearchViewController
            searchview.isResult = true
            searchview.cid = "4"
            self.navigationController?.pushViewController(searchview, animated: true)
        }else if tag == 10005{
            if CommonConfig.isLogin {
//                let searchview = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "RecordViewController") as! RecordViewController
//                searchview.isPay = true
             /**   let purseRecharge = PurseRecharge()
                purseRecharge.userID = CommonConfig.UserInfoCache.userId
                purseRecharge.token = CommonConfig.Token
                self.navigationController?.pushViewController(purseRecharge, animated: true)
**/
//                self.navigationController?.pushViewController(searchview, animated: true)
            }else
            {
                let login = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "LoginViewController") as! LoginViewController
                login.isGoods = true
                self.navigationController?.pushViewController(login, animated: true)
            }
        }
    }
    
    func goodsClick(_ goodsid:String){
        
        RequestManager.RequestData(RequestUrl.Router.flashDetail(id: goodsid),showLoading: true, successCallBack: { (result) in
            let goods = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "GoodsDetailViewController") as! GoodsDetailViewController
            goods.goodsInfo = result["content"]
            goods.isFlash = true
            self.navigationController?.pushViewController(goods, animated: true)
        }) { (fail) in
//            print(fail)
            RequestManager.RequestData(RequestUrl.Router.pointDetail(id: goodsid),showLoading: true, successCallBack: { (result) in
                
                let goods = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "GoodsDetailViewController") as! GoodsDetailViewController
                goods.goodsInfo = result["content"]
//                goods.isIntegral = true
                goods.isFlash = true
                self.navigationController?.pushViewController(goods, animated: true)
            }) { (fail) in
                //            print(fail)
                
            }
        }
        
    }
    @IBAction func questionBtn(_ sender: UIButton) {
        let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "QuestionViewController") as! QuestionViewController
        self.present(vc, animated:true, completion: nil)
        
    }
    //  扫描二维码  需求更改   方法名与内容不符
    @IBAction func messClick(_ sender: UIButton) {
                if CommonConfig.isLogin {
                    let device = AVCaptureDevice.defaultDevice(withMediaType: AVMediaTypeVideo)
                    if device != nil {
                        let status = AVCaptureDevice.authorizationStatus(forMediaType: AVMediaTypeVideo)
                        if status == .notDetermined {
                            AVCaptureDevice.requestAccess(forMediaType: AVMediaTypeVideo, completionHandler: {(granted:Bool) -> Void in
                                if granted {
                                    DispatchQueue.main.async(execute: {() -> Void in
                                        let vc = QRCodeScanningVC()
                                        vc.token = CommonConfig.Token
                                        vc.user_id = CommonConfig.UserInfoCache.userId
                                        self.hidesBottomBarWhenPushed = true;
                                        self.navigationController!.pushViewController(vc, animated: true)
                                        self.hidesBottomBarWhenPushed = false;
                                    })
                                    print("当前线程--%s",[Thread.current])
                                }else{
        //                            print("用户第一次拒绝了访问权限")
                                }
                            })
                        }else if status == .authorized {
        
                            let vc = QRCodeScanningVC()
                            vc.token = CommonConfig.Token
                            vc.user_id = CommonConfig.UserInfoCache.userId
                            self.hidesBottomBarWhenPushed = true;
                            self.navigationController!.pushViewController(vc, animated: true)
                            self.hidesBottomBarWhenPushed = false;
                        }else if status == .denied{
                            let alertC = UIAlertController(title: "⚠️警告", message: "请打开相机权限", preferredStyle: .alert)
                            let alertA = UIAlertAction(title: "确定", style: UIAlertActionStyle.default, handler: { (action:UIAlertAction) -> Void in
        
                            })
                            alertC.addAction(alertA)
                            self.present(alertC, animated: true, completion: {_ in})
        
                        }else if status == .restricted{
        
                            print("因为系统原因，无法访问相册")
                        }
                    }else {
        
                        let alertC = UIAlertController(title: "温馨提示", message: "未检测到您的摄像头", preferredStyle: (.alert))
                        let alertA = UIAlertAction(title: "确定", style: UIAlertActionStyle.default, handler: { (action:UIAlertAction) -> Void in
        
                        })
                        alertC.addAction(alertA)
                        self.present(alertC, animated: true, completion: {
        
                        })
        
                    }
        
                }else{
                    let login = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "LoginViewController") as! LoginViewController
                    login.isGoods = true
                    self.navigationController?.pushViewController(login, animated: true)
                }
 
//        if CommonConfig.isLogin  {
//            let info = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "MessageViewController") as! MessageViewController
//            info.isShow = false
//            info.isSystem = false
//            info.isFirst = false
//            info.isCollect = false
//            self.navigationController?.pushViewController(info, animated: true)
//        }else{
//            let login = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "LoginViewController") as! LoginViewController
//            login.isGoods = true
//            self.navigationController?.pushViewController(login, animated: true)
//        }
    }
    
    //地图
    @IBAction func qrcodeClick(_ sender: UIButton) {
        
//        let vc = MapViewController()
//        self.hidesBottomBarWhenPushed = true;
//        self.navigationController?.pushViewController(vc, animated: true)
//        vc.tabBarController?.tabBar.isHidden = false;
//        self.hidesBottomBarWhenPushed = false;

        
        let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "NearViewController") as! NearViewController
        self.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(vc,animated:true)
        vc.tabBarController?.tabBar.isHidden = false
        self.hidesBottomBarWhenPushed = false
        
    }
    
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView.contentOffset.y > screenHeight {
            showtop.isHidden = false
            toptext.isHidden = false
            refreshBtn.setTitle("", for: UIControlState())
        }else{
            showtop.isHidden = true
            toptext.isHidden = true
            refreshBtn.setTitle("刷新", for: UIControlState())
        }
    }
    
    //实现UICollectionViewDataSource
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int
    {
        //返回记录数
        return showList.count
    }
    
    //实现UICollectionViewDataSource
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell
    {
        //返回Cell内容，这里我们使用刚刚建立的defaultCell作为显示内容
        let cell  = collectionView.dequeueReusableCell(withReuseIdentifier: "CollectionCell", for: indexPath) as! RecommendCollectionCell
            cell.backgroundColor = UIColor.white
        if showList.count > 0 {
            cell.setInfo(showList[indexPath.row])

        }
        return cell
    }
    
    //实现UICollectionViewDataSource
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath)
    {
        //某个Cell被选择的事件处理
//        print(indexPath.row)
//        print("哈哈哈")
        CommonConfig.getProductDetail(self, goodsID: showList[indexPath.row].id)
        print("商品详情id\(showList[indexPath.row].id)")

    }
    
    //分组头部、尾部
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        
        let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "MainCollectionHeadView", for: indexPath) as! MainCollectionHeadView
        header.initSet()
        header.bannerClick = bannerClick
        header.selectClick = selectClick
        header.DiscounClick = goodsClick
        header.disClick = disViewClick
        header.inteClick = integralListClick
        header.jumpIClick = jumpIntegralDetailPage;
        return header

    }
    //返回分组的头部视图的尺寸，在这里控制分组头部视图的高度
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        let Scale = String(format: "%.2f", newScale)
        
        print("\(newScale)")
        if Scale == "0.50" {
            return CGSize(width: UIScreen.main.bounds.size.width, height:170 + (300+272+330+302+330+290*3)*newScale)
        }else if Scale == "0.43"{
            return CGSize(width: UIScreen.main.bounds.size.width, height:300 + (300+272+330+302+330+290*3)*newScale)
        }else if Scale == "0.55"{
            return CGSize(width: UIScreen.main.bounds.size.width, height:0 + (300+272+330+302+330+290*3)*newScale)
        }else{
            return CGSize(width: UIScreen.main.bounds.size.width, height:0 + (300+272+330+302+330+290*3)*newScale)
        }
        
        // 0.55    8p  6sp
        // 0.43    se   5s
        // 0.5     8    6
    }

    //#pragma mark --UICollectionViewDelegateFlowLayout
    //定义每个UICollectionView 的大小
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: (screenWidth - 2)/3, height: 382*newScale)
        
       
    }
    //定义每个UICollectionView 的 margin
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsetsMake(0, 0, 0, 0)
    }
   
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 1
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.hidesBottomBarWhenPushed = false;
        UIApplication.shared.setStatusBarStyle(.default, animated: false)
        self.navigationController?.setNavigationBarHidden(true, animated: false)
	self.tabBarController?.tabBar.isHidden = false;
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
    
    func refreshOne(){
//         print("refresh")
        let notice = Notification.init(name: Notification.Name(rawValue: "refreshmain"), object: nil)
        NotificationCenter.default.post(notice)
        self.collectionView.reloadData()
    }
    

}

