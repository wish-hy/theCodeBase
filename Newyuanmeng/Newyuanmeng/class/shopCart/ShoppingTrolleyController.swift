//
//  ShoppingTrolleyController.swift
//  huabi
//
//  Created by TeamMac2 on 16/8/24.
//  Copyright © 2016年 ltl. All rights reserved.
//

import UIKit
import SwiftyJSON

class ShoppingTrolleyController: UIViewController ,DiscountViewDelegate ,UITableViewDelegate,UITableViewDataSource,UIAlertViewDelegate{

    @IBOutlet weak var loginView: UIView!
    @IBOutlet weak var backBtn: UIButton!
    @IBOutlet weak var mainBtn: UIButton!
    @IBOutlet weak var noneView: UIView!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var top1: NSLayoutConstraint!
    @IBOutlet weak var top2: NSLayoutConstraint!
    @IBOutlet weak var top3: NSLayoutConstraint!
    @IBOutlet weak var carH: NSLayoutConstraint!
    @IBOutlet weak var likeW: NSLayoutConstraint!
    @IBOutlet weak var scrollH: NSLayoutConstraint!
    @IBOutlet weak var borderlbl: UILabel!
    @IBOutlet weak var allSelectBtn: UIButton!
    @IBOutlet weak var payBtn: UIButton!
    @IBOutlet weak var pricelbl: UILabel!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var payView: UIView!
    
    
    @IBOutlet weak var payViewH: NSLayoutConstraint!
    
    @IBOutlet weak var payBtnW: NSLayoutConstraint!
    
    @IBOutlet weak var payPriceH: NSLayoutConstraint!
    
    @IBOutlet weak var paypriceTop1: NSLayoutConstraint!
    
    @IBOutlet weak var payPriceTop2: NSLayoutConstraint!
    
    @IBOutlet weak var goodstext: UILabel!
    
    @IBOutlet weak var allselText: UILabel!
    @IBOutlet weak var borderTop2: NSLayoutConstraint!
    
    @IBOutlet weak var allSelH1: NSLayoutConstraint!
    
    @IBOutlet weak var allSelH2: NSLayoutConstraint!
    
    var goodsPrice:CGFloat = 0
    var likeList:Array<JSON> = []
    var discList:Array<DiscountView> = []
    var goodsList:Array<JSON> = []
    var isPush:Bool = false
    var selectList:Array<String> = []
    
    
    func setLayout(){
        payViewH.constant = 82*newScale
        payBtnW.constant = 176*newScale
        payPriceH.constant = 20*newScale
        pricelbl.font = UIFont.systemFont(ofSize: 20*newScale)
        paypriceTop1.constant = 18*newScale
        payPriceTop2.constant = 14*newScale
        goodstext.font = UIFont.systemFont(ofSize: 20*newScale)
        borderTop2.constant = 24*newScale
        allselText.font = UIFont.systemFont(ofSize: 24*newScale)
        allSelH1.constant = 44*newScale
        allSelH2.constant = 40*newScale
        allSelectBtn.titleLabel?.font = UIFont.init(name: "iconfont", size: 42*newScale)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setLayout()
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.refreshFour), name: NSNotification.Name(rawValue: "refresh4"), object: nil)   //刷新通知
        NotificationCenter.default.addObserver(self, selector: #selector(self.deleteGoods(_:)), name: NSNotification.Name(rawValue: "deleteGoods"), object: nil)   //刷新通知
        NotificationCenter.default.addObserver(self, selector: #selector(self.GoodsNum(_:)), name: NSNotification.Name(rawValue: "GoodsNum"), object: nil)   //刷新通知
        setInfo()
        
        // Do any additional setup after loading the view.
    }
    
    func setInfo(){
        top1.constant = 72*newScale
        top2.constant = 276*newScale
        top3.constant = 32*newScale
        carH.constant = 180*newScale
        likeW.constant = 248*newScale
        scrollH.constant = 338*newScale
        borderlbl.layer.borderWidth = 1
        borderlbl.layer.borderColor = CommonConfig.MainFontBlackColor.cgColor
        backBtn.setTitle(IconFontIconName.icon_back.rawValue, for: UIControlState())
        mainBtn.setTitle(IconFontIconName.icon_goods_backhome.rawValue, for: UIControlState())
        self.payView.isHidden = true
        getScrollViewData()
        refreshData()
        
    }
    
    func refreshData(){
//        if !CommonConfig.isLogin {
//            loginView.hidden = false
//        }else{
            loginView.isHidden = true
//        }
        getCartNum()
         if allSelectBtn.tag < 0 {
            changeSelectBtn()
        }
        self.delPrice = 0
        self.goodsPrice = 0
        self.pricelbl.text = "¥\(self.goodsPrice)"
        payBtn.setTitle("去结算", for: UIControlState())
        if isPush {
            self.backBtn.isHidden = false
            self.mainBtn.isHidden = false
        }else{
            self.backBtn.isHidden = true
            self.mainBtn.isHidden = true
        }
        
//        self.tabBarController?.tabBar.hidden = false
    }
    
    func setScrollView(){
        scrollView.contentSize = CGSize(width: (214*newScale + 1)*CGFloat(likeList.count)-1, height: 338*newScale)
        scrollView.isPagingEnabled = false
        for i in 0..<self.likeList.count {
            let likeview = DiscountView.init(frame: CGRect(x:214*newScale*CGFloat(i) + CGFloat(i),y: 1,width: 214*newScale,height: 338*newScale-2), title: self.likeList[i]["name"].stringValue, icon: self.likeList[i]["img"].stringValue, price: self.likeList[i]["sell_price"].stringValue, oldprice: "", type: 1, delegate: self)
            likeview.tag = i
            scrollView.addSubview(likeview)
            discList.append(likeview)
        }
    }
    
    func selectDiscountView(_ tag: NSInteger) {
//        print(self.likeList[tag])
        let id = self.likeList[tag]["id"].stringValue
        CommonConfig.getProductDetail(self, goodsID: id)
    }
    
    func getScrollViewData(){
        RequestManager.RequestData(RequestUrl.Router.getGuess(num: 50), successCallBack: { (result) in
            self.likeList = result["content"].arrayValue
            self.setScrollView()
            }) { (fail) in
//                print(fail)
        }
    }
    
    func getCartNum(){
        RequestManager.RequestData(RequestUrl.Router.getCartNum(), successCallBack: { (result) in
//            print(result)
            self.goodsList = result["content"]["productlist"].arrayValue
            if self.goodsList.count == 0 {
                self.payView.isHidden = true
            }else{
                self.payView.isHidden = false
            }
            self.tableView.reloadData()
        }) { (fail) in
//            print(fail)
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

        return self.goodsList.count
      
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
  
        return 170*newScale
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
  
        let cell = tableView.dequeueReusableCell(withIdentifier: "ShoppingCartCell") as! ShoppingCartCell
        cell.backgroundColor = UIColor.white
        cell.delClick = delClick
        cell.addClick = addClick
        cell.reduceClick = reduceClick
        cell.selectClick = selectClick
        cell.unSelectClick = unSelectClick
        cell.imageClick = imageClick
        if self.goodsList.count > 0 {
            cell.setInfo(self.goodsList[indexPath.row],tags: indexPath.row)
            if indexPath.row == self.goodsList.count - 1 {
                cell.bottomline.isHidden = false
            }else{
                cell.bottomline.isHidden = true
            }
        }
        cell.tag = indexPath.row
        cell.selectionStyle = .none
        return cell
  
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
//        if indexRow != nil{
//            let cell = tableView.cellForRowAtIndexPath(indexRow!) as! ShoppingCartCell
//            cell.backgroundColor = UIColor.whiteColor()
//            indexRow = nil
//        }
//        CommonConfig.getProductDetail(self, goodsID: self.goodsList[indexPath.row]["id"].stringValue)
    }
    
//    func tableView(tableView: UITableView, didHighlightRowAtIndexPath indexPath: NSIndexPath) {
//
//        let cell = tableView.cellForRowAtIndexPath(indexPath) as! ShoppingCartCell
//        cell.backgroundColor = UIColor.init(hexCode: "efefef")
//        indexRow = indexPath
//        
//    }
//    
//    var indexRow:NSIndexPath?
//    func scrollViewWillBeginDragging(scrollView: UIScrollView) {
//        if indexRow != nil{
//            let cell = self.tableView.cellForRowAtIndexPath(indexRow!) as! ShoppingCartCell
//            cell.backgroundColor = UIColor.whiteColor()
//            indexRow = nil
//        }
//    }
    var delPrice:CGFloat = 0
    func alertView(_ alertView: UIAlertView, clickedButtonAt buttonIndex: Int) {
        if alertView.cancelButtonIndex != buttonIndex {
            RequestManager.RequestData(RequestUrl.Router.deleteGoods(id: self.goodsList[deltag]["id"].stringValue), successCallBack: { (result) in
//                print(result)
                self.goodsList.remove(at: self.deltag)
                self.goodsPrice += self.delPrice
                self.pricelbl.text = "¥\(self.goodsPrice)"
                self.delPrice = 0
                self.tableView.reloadData()
                if self.goodsList.count == 0 {
                    self.payView.isHidden = true
                }else{
                    self.payView.isHidden = false
                }
                }, failCallBack: { (fail) in
                    
            })
        }
    }
    
    func imageClick(_ tag:NSInteger){
//        print(tag)
        CommonConfig.getProductDetail(self, goodsID: self.goodsList[tag]["goods_id"].stringValue)
    }
    
    var deltag = 0
    func delClick(_ tag:String){
        let clickArr = tag.components(separatedBy: "-")
        deltag = (clickArr[0] as NSString).integerValue
        let alert = UIAlertView.init(title: "温馨提示", message: "是否删除该商品", delegate: self, cancelButtonTitle: "取消", otherButtonTitles: "删除")
        alert.show()
    }
    
    func reduceClick(_ tag:String){
        changeNumGoods(tag)
    }
    
    func addClick(_ tag:String){
        changeNumGoods(tag)
    }
    
    func changeNumGoods(_ tag:String){
        let clickArr = tag.components(separatedBy: "-")
        let index = (clickArr[0] as NSString).integerValue
        let num = (clickArr[1] as NSString).integerValue
//        print(clickArr)
        var userid = 0
        if CommonConfig.isLogin {
            userid = CommonConfig.UserInfoCache.userId
        }
        RequestManager.RequestData(RequestUrl.Router.changeGoodsNum(id: self.goodsList[index]["id"].stringValue, num: num,user_id:userid ), successCallBack: { (result) in
            self.goodsPrice += self.delPrice
            self.delPrice = 0
            self.pricelbl.text = "¥\(self.goodsPrice)"
            }, failCallBack: { (fail) in
                self.noticeOnlyText(fail)
        })
    }
    
    func selectClick(_ tag:String){
        changeNumGoods(tag)
        let clickArr = tag.components(separatedBy: "-")
        let index = (clickArr[0] as NSString).integerValue
        if self.goodsList.count > 0 {
            self.selectList.append(self.goodsList[index]["id"].stringValue)
            if self.selectList.count == self.goodsList.count {
                if allSelectBtn.tag > 0 {
                    changeSelectBtn()
                }
            }
        }
    }
    
    func unSelectClick(_ tag:String){
        let clickArr = tag.components(separatedBy: "-")
        let index = (clickArr[0] as NSString).integerValue
        self.goodsPrice += self.delPrice
        self.delPrice = 0
        self.pricelbl.text = "¥\(self.goodsPrice)"
        if goodsPrice < 0 {
            self.pricelbl.text = "¥0"
        }
        if self.goodsList.count > 0 {
            for i in 0..<self.selectList.count {
                if self.selectList[i] == self.goodsList[index]["id"].stringValue {
                    self.selectList.remove(at: i)
                    break
                }
            }
            if self.selectList.count == 0 {
                if allSelectBtn.tag < 0 {
                    changeSelectBtn()
                }
            }
        }
    }
    
    @IBAction func toMainClick(_ sender: AnyObject) {
        (UIApplication.shared.delegate as! AppDelegate).showMainPage()
    }
    
    @IBAction func backClick(_ sender: AnyObject) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func mainClick(_ sender: AnyObject) {
        (UIApplication.shared.delegate as! AppDelegate).showMainPage()
    }
    
    @IBAction func allSelectClick(_ sender: UIButton) {
        changeSelectBtn()

    }
    
    @IBAction func payClick(_ sender: UIButton) {
        if selectList.count == 0 {
            self.noticeOnlyText("请选择商品")
            return
        }
        if !CommonConfig.isLogin {
            let login = UIStoryboard(name: "Home", bundle: nil).instantiateViewController(withIdentifier: "LoginViewController") as! LoginViewController
            login.isGoods = true
            self.navigationController?.pushViewController(login, animated: true)
            
        }else{
//            let pay = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("PayViewController") as! PayViewController
//            pay.isConfirm = true
//            pay.price = "\(goodsPrice)"
//            pay.orderIds = self.selectList
//            self.navigationController?.pushViewController(pay, animated: true)
            let newpay = NewPayViewController()
            newpay.goodsID = "";
            newpay.orderids = NSMutableArray.init(array: self.selectList);
            newpay.userID = CommonConfig.UserInfoCache.userId;
            newpay.isGoods = false
            newpay.accessToken = CommonConfig.Token
            self.navigationController?.pushViewController(newpay, animated: true)
        }
    }
    
    func changeSelectBtn(){
        allSelectBtn.tag = -allSelectBtn.tag
        if allSelectBtn.tag < 0 {
            allSelectBtn.setTitle(IconFontIconName.icon_cart_seletallgoods.rawValue, for: UIControlState())
        }else{
            allSelectBtn.setTitle("", for: UIControlState())
        }
        let badgeinfo = NSDictionary.init(dictionary: ["shopping":allSelectBtn.tag])
        let notice = Notification.init(name: Notification.Name(rawValue: "selectBtn"), object: badgeinfo)
        NotificationCenter.default.post(notice)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        CommonConfig.shopBadge = 0
        CommonConfig.shopBadgeRead = true
        CommonConfig.setCartBadge("\(CommonConfig.shopBadge)")
        refreshData()
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
    
    func refreshFour(){
//        print("refresh4")
        refreshData()
    }
    
    func deleteGoods(_ notification:Notification){
        let info = notification.object as! NSDictionary
        let price = info.value(forKey: "price") as! CGFloat
        self.delPrice = price
//        print(self.delPrice)
    }
    var goodsNum = 0
    func GoodsNum(_ notification:Notification){
        let info = notification.object as! NSDictionary
        let num = info.value(forKey: "num") as! NSInteger
        goodsNum += num
        if goodsNum == 0 {
            payBtn.setTitle("去结算", for: UIControlState())
        }else{
            payBtn.setTitle("去结算(\(goodsNum))", for: UIControlState())
        }
//        print(self.delPrice)
    }
    
    @IBAction func loginClick(_ sender: AnyObject) {
        let login = UIStoryboard(name: "Me", bundle: nil).instantiateViewController(withIdentifier: "LoginViewController") as! LoginViewController
        login.isGoods = true
        self.navigationController?.pushViewController(login, animated: true)
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
