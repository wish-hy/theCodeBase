//
//  SearchViewController.swift
//  huabi
//
//  Created by TeamMac2 on 16/8/30.
//  Copyright © 2016年 ltl. All rights reserved.
//

import UIKit
import SwiftyJSON
import MJRefresh

class SearchViewController: UIViewController ,UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate,SearchButtonDelegate{

    @IBOutlet weak var back: UIButton!
    @IBOutlet weak var views: UIView!
    @IBOutlet weak var search: UITextField!
    @IBOutlet weak var view1: UIView!
    @IBOutlet weak var view2: UIView!
    @IBOutlet weak var view3: UIView!
    @IBOutlet weak var tableView1: UITableView!
    @IBOutlet weak var tableView2: UITableView!
    @IBOutlet weak var tableView3: UITableView!
    @IBOutlet weak var messBtn: UIButton!
    @IBOutlet weak var chooseView: UIScrollView!
    @IBOutlet weak var pricemin: UITextField!
    @IBOutlet weak var pricemax: UITextField!
    
    @IBOutlet weak var resetBtn: UIButton!
    @IBOutlet weak var confirmBtn: UIButton!
    

    var searchKey = ""
    var isResult:Bool = false
    var searchList1:Array<String> = []
    var searchList2:Array<GoodsModel> = []
    var showList:Array<GoodsModel> = []
    var searchList3:Array<JSON> = []
    var searchArr:Array<String> = []
    var btnArr:Array<SearchButton> = []
    var timer: Timer!
    var sort = 0
    var cid = ""
    var page = 1
    var price = ""
    var brand = ""
    var total = 0
    var pageSize = 36
    var pageCount = 1
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tabBarController?.tabBar.isHidden = true
        NotificationCenter.default.addObserver(self, selector: #selector(SearchViewController.keyboardShow(_:)), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(SearchViewController.keyboardHide(_:)), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
        self.tableView2.mj_header = MJRefreshNormalHeader(refreshingTarget: self, refreshingAction: #selector(SearchViewController.headRefresh))
        self.tableView2.mj_footer = MJRefreshAutoNormalFooter(refreshingTarget: self, refreshingAction: #selector(SearchViewController.footRefresh))
        self.tableView2.mj_footer.isHidden = false
        let tapGesturer1 = UITapGestureRecognizer(target: self, action: #selector(SearchViewController.tap1))
        self.view1.isUserInteractionEnabled = true
        self.view1.addGestureRecognizer(tapGesturer1)
        let tapGesturer2 = UITapGestureRecognizer(target: self, action: #selector(SearchViewController.tap2))
        self.view3.isUserInteractionEnabled = true
        self.view3.addGestureRecognizer(tapGesturer2)
        
        initSetting()
       
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.isNavigationBarHidden = true
        self.navigationController?.navigationBar.barTintColor = UIColor.init(hexCode: "#db8263")
    }
    
    func tap1(){
        hiddenKeyborad()
    }
    
    func tap2(){
        hiddenKeyborad()
    }
    
    func hiddenKeyborad(){
        self.search.resignFirstResponder()
        if !self.view3.isHidden {
            self.pricemin.resignFirstResponder()
            self.pricemax.resignFirstResponder()
        }
    }
    
    func initSetting(){
        let searchArrsss = UserDefaults.standard.array(forKey: "SearchList")
        
        if searchArrsss == nil {
            let arr:Array<String> = []
            UserDefaults.standard.set(arr, forKey: "SearchList")
        }
        
        search.text = searchKey
        search.returnKeyType = UIReturnKeyType.search
        back.setTitle(IconFontIconName.icon_back.rawValue, for: UIControlState())
        views.layer.cornerRadius = 5
        views.layer.borderColor = CommonConfig.SliderBlackColor.cgColor
        views.layer.borderWidth = 1
        views.clipsToBounds = true
        resetBtn.layer.cornerRadius = 5
        resetBtn.layer.borderColor = CommonConfig.MainRedColor.cgColor
        resetBtn.layer.borderWidth = 1
        resetBtn.clipsToBounds = true
        confirmBtn.layer.cornerRadius = 5
        confirmBtn.layer.borderColor = CommonConfig.MainRedColor.cgColor
        confirmBtn.layer.borderWidth = 1
        confirmBtn.clipsToBounds = true
//        messBtn.setTitle(IconFontIconName.icon_msg.rawValue, forState: .Normal)
        messBtn.setTitle("搜索", for: UIControlState());
        pricemin.clearsOnBeginEditing = true
        pricemax.clearsOnBeginEditing = true
        searchArr = UserDefaults.standard.array(forKey: "SearchList") as! Array<String>
        let titleArr = ["综合排序","价格","销量","筛选"]
        chooseView.contentSize = CGSize(width: screenWidth, height: 0)
        for i in 0..<titleArr.count {
            var type = 1
            if i == 1{
                type = 0
            }else if i == 3{
                type = 3
            }
            let btn = SearchButton.init(frame: CGRect(x: CGFloat(i)*screenWidth/CGFloat(titleArr.count), y: 0, width: screenWidth/CGFloat(titleArr.count), height: chooseView.frame.size.height), titles: titleArr[i], type: type, delegate: self)
            btn.tag = i
            chooseView.addSubview(btn)
            btn.setDefultImageTitle()
            if i == 0 {
                lastTag = i
                btn.setImageWithClick()
            }
            btnArr.append(btn)
        }
        
        if isResult {
            view1.isHidden = true
            view2.isHidden = false
            view3.isHidden = true
            getSearchResult(false)
        }else{
            view1.isHidden = false
            view2.isHidden = true
            view3.isHidden = true
            getSearch()
        }
    }

    func getSearch(){
       RequestManager.RequestData(RequestUrl.Router.getHotSearch(), showLoading: false, successCallBack: { (resultJson) in
        
            for i in 0..<resultJson["content"].count {
                self.searchList1.append(resultJson["content"][i].stringValue)
            }
            self.tableView1.reloadData()
        }) { (failstr) in
            self.noticeOnlyText(failstr)
        }
    }
    
    //sort 0.默认 1. 销量降序  2.评论降序   4.价格升序  3.价格降序  5.时间排序
    func getSearchResult(_ isShow:Bool ,type:NSInteger = 0){
        var cat = String()
        var cidnum = String()
        
        if searchKey == "" {
            cat = "category"
            cidnum = cid
        }else{
            cat = "search"
            cidnum = ""
        }
        RequestManager.RequestData(RequestUrl.Router.search(cid:cidnum, sort: sort, p: page, price: price, keyword: searchKey, brand: brand, cat: cat), showLoading: isShow, successCallBack: { (resultJson) in
//            print(resultJson)
            print(resultJson)
            let data = resultJson["content"]["goods"]["data"].arrayValue
            let page = resultJson["content"]["goods"]["page"]
            self.searchList3 = resultJson["content"]["has_brand"].arrayValue
            self.total = page["total"].intValue
            self.pageSize = page["pageSize"].intValue
            self.pageCount = page["totalPage"].intValue
            let count = self.searchList2.count
            for i in 0..<data.count{
                self.searchList2.append(GoodsModel.init(goodsInfo: data[i]))
            }
            if data.count > 9 {
                for i in 0..<9 {
                    self.showList.append(self.searchList2[count + i])
                }
            }else{
                for arr in data{
                    self.showList.append(GoodsModel(goodsInfo: arr))
                }
            }
            if type == 1{
                self.tableView2.mj_footer.endRefreshing()
            }
            if self.searchList2.count == self.showList.count && self.page == self.pageCount{
                self.tableView2.mj_footer.endRefreshingWithNoMoreData()
                self.tableView2.mj_footer.isHidden = true
            }
            self.tableView2.reloadData()
        }) { (failstr) in
            self.noticeOnlyText(failstr)
        }
    }

    @objc func normalState() {
        SwiftNotice.clear()
        if page == pageCount && self.showList.count == self.searchList2.count{
            self.tableView2.mj_footer.endRefreshingWithNoMoreData()
            self.tableView2.mj_footer.isHidden = true
        }else{
            self.tableView2.mj_footer.endRefreshing()
        }
        if self.timer == nil {
            return
        }
        self.timer.invalidate()
        self.timer = nil
    }
    
    func headRefresh(){
        self.tableView2.mj_header.beginRefreshing()
        self.tableView2.reloadData()
        self.tableView2.mj_header.endRefreshing()
        if self.tableView2.mj_footer.isHidden {
            self.tableView2.mj_footer.isHidden = false
        }
        if self.searchList2.count == self.showList.count && self.page == self.pageCount{
            self.tableView2.mj_footer.isHidden = true
        }
    }
    
    @objc func footRefresh(){
        self.tableView2.mj_footer.beginRefreshing()
        if self.showList.count < self.searchList2.count {
            SwiftNotice.wait()
            self.timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(MainViewController.normalState), userInfo: nil, repeats: false)
            
            let count = self.showList.count
            var numb = self.searchList2.count - self.showList.count
            if numb > 9 {
                numb = 9
            }
            for i in 0..<numb {
                self.showList.append(self.searchList2[count + i])
            }
            self.tableView2.reloadData()
        }else{
            page += 1
            getSearchResult(false,type: 1)
        }
    }
    
    var lastTag = 0
    func selectSearchButton(_ tag: NSInteger, clickType: NSInteger) {
        if tag != lastTag{
            let btn = btnArr[lastTag]
            btn.setDefultImageTitle()
            lastTag = tag
        }
        if tag == 3 {
            self.view3.isHidden = !self.view3.isHidden
            if !self.view3.isHidden {
                var arr:Array<String> = []
                for i in 0..<self.searchList3.count {
                    arr.append(self.searchList3[i]["name"].stringValue)
                }
                let hei = CommonConfig.getCellHeight(arr) + 70*newScale + 15
                self.tableView3.tableFooterView?.frame = CGRect(x: 0, y: 64 + hei, width: screenWidth, height: 57)
                 self.tableView3.reloadData()
            }
           
        }else {
            if !self.view3.isHidden {
                self.view3.isHidden = true
            }
            if tag == 0 {
                sort = 0
            }else if tag == 1 {
                sort = 3
                if clickType == 2 {
                    sort = 4
                }
            }else if tag == 2 {
                sort = 1
            }
        }
        if tag != 3 {
            let arr:Array<GoodsModel> = []
            self.searchList2 = arr
            self.showList = arr
            getSearchResult(true)
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == self.tableView1 {
            return 2
        }else if tableView == self.tableView3{
            return 1
        }else{
            return self.showList.count
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if tableView == self.tableView1 {
            if indexPath.row == 0 {
                return CommonConfig.getCellHeight(searchArr) + 50*newScale + 15
            }
            return CommonConfig.getCellHeight(searchList1) + 50*newScale + 15
        }else if tableView == self.tableView3{
            var arr:Array<String> = []
            for i in 0..<self.searchList3.count {
                arr.append(self.searchList3[i]["name"].stringValue)
            }
            let hei = CommonConfig.getCellHeight(arr) + 70*newScale + 15
            return hei
        }else{
            return 91
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if tableView == self.tableView1 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "SearchNormalCell") as! SearchNormalCell
            cell.backgroundColor = UIColor.white
            if indexPath.row == 0 {
                cell.titles.text = "最近搜索"
                if searchArr.count != 0 {
                    cell.setSearchInfo(searchArr,types: 0)
                    cell.tagClick = viewTagClick1
                }
                cell.line.isHidden = false
            }else{
                cell.titles.text = "热门搜索"
                if self.searchList1.count != 0{
                    cell.setSearchInfo(self.searchList1,types: 2)
                    cell.line.isHidden = true
                    cell.tagClick = viewTagClick2
                }
            }
            cell.selectionStyle = .none
            return cell
        }else if tableView == self.tableView3{
            let cell = tableView.dequeueReusableCell(withIdentifier: "SearchNormalCell") as! SearchNormalCell
            cell.backgroundColor = UIColor.white
            cell.titles.text = "品牌"
            cell.line.isHidden = false
            if self.searchList1.count != 0{
                var arr:Array<String> = []
                for i in 0..<self.searchList3.count {
                    arr.append(self.searchList3[i]["name"].stringValue)
                }
                cell.setSearchInfo(arr,types: 0)
                cell.tagClick = viewTagClick3
            }
            cell.selectionStyle = .none
            return cell
        }else{
            let cell = tableView.dequeueReusableCell(withIdentifier: "SearchResultCell") as! SearchResultCell
            cell.backgroundColor = UIColor.white
            if self.showList.count != 0 {
                cell.setInfo(self.showList[indexPath.row])
            }
            cell.selectionStyle = .none
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if canClick {
            hiddenKeyborad()
            return
        }
        if tableView == self.tableView2 {
            if indexRow != nil{
                let cell = tableView.cellForRow(at: indexRow!) as! SearchResultCell
                cell.backgroundColor = UIColor.white
                indexRow = nil
            }
            CommonConfig.getProductDetail(self, goodsID: self.showList[indexPath.row].id)
        }
        
    }
    
    func tableView(_ tableView: UITableView, didHighlightRowAt indexPath: IndexPath) {
        if canClick {
            return
        }
        if tableView == self.tableView2 {
            let cell = tableView.cellForRow(at: indexPath) as! SearchResultCell
            cell.backgroundColor = UIColor.init(hexCode: "efefef")
            indexRow = indexPath
        }
    }
    
    var indexRow:IndexPath?
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        if canClick {
            hiddenKeyborad()
        }
        if indexRow != nil{
            let cell = self.tableView2.cellForRow(at: indexRow!) as! SearchResultCell
            cell.backgroundColor = UIColor.white
            indexRow = nil
        }
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
      
        if string == "\n" {
            textField.resignFirstResponder()
            return false
        }
        return true
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        //收起键盘
//        if textField == self.search {
//            if isResult{
//                if self.search.text != "" {
//                                    }
//            }
//        }
//        searchKey = self.search.text!
//        page = 1
//        let arr:Array<GoodsModel> = []
//        self.searchList2 = arr
//        self.showList = arr
//        getSearchResult(false)
        searchKey = self.search.text!
        isResult = true
        let arr:Array<GoodsModel> = []
        self.searchList2 = arr
        self.showList = arr
        getSearchResult(true)
        self.view2.isHidden = false
        self.view1.isHidden = true
        
        self.tableView3.reloadData()
        
        textField.resignFirstResponder()
        return true
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
       hiddenKeyborad()
        if !self.view3.isHidden {
            pricemin.text = ""
            pricemax.text = ""
            brand = ""
            self.tableView3.reloadData()
            self.view3.isHidden = true
        }
    }
    
    func viewTagClick1(_ tag:NSInteger){
        searchKey = self.searchArr[tag]
        isResult = true
        let arr:Array<GoodsModel> = []
        self.searchList2 = arr
        self.showList = arr
        getSearchResult(true)
        self.view2.isHidden = false
        self.view1.isHidden = true
    }
    
    func viewTagClick2(_ tag:NSInteger){
        searchKey = self.searchList1[tag]
        isResult = true
        let arr:Array<GoodsModel> = []
        self.searchList2 = arr
        self.showList = arr
        getSearchResult(true)
        self.view2.isHidden = false
        self.view1.isHidden = true
    }
    
    func viewTagClick3(_ tag:NSInteger){
        brand = self.searchList3[tag]["id"].stringValue
        
    }
    
    @IBAction func backClick(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func messClick(_ sender: UIButton) {
//        pricemin.text = ""
//        pricemax.text = ""
//        brand = ""
//        page = 1
        if self.search.text! == "" {
            
        }else{
            searchKey = self.search.text!
            isResult = true
            let arr:Array<GoodsModel> = []
            self.searchList2 = arr
            self.showList = arr
            getSearchResult(true)
            self.view2.isHidden = false
            self.view1.isHidden = true
        }
        
        
        self.search.resignFirstResponder()
        self.tableView3.reloadData()
    }
    
    @IBAction func resetClick(_ sender: UIButton) {
        hiddenKeyborad()
        pricemin.text = ""
        pricemax.text = ""
        brand = ""
        page = 1
        self.tableView3.reloadData()
    }
    
    @IBAction func confirmClick(_ sender: UIButton) {
        if pricemin.text != ""{
            if !CommonConfig.checkPrice(pricemin.text!){
                noticeOnlyText("请输入正确的价格")
                return
            }
            price = pricemin.text!
            if pricemax.text != "" {
                if !CommonConfig.checkPrice(pricemax.text!) {
                    noticeOnlyText("请输入正确的价格")
                    return
                }
                price = price + "-" + pricemax.text!
            }
        }else{
            if pricemax.text != "" {
                if !CommonConfig.checkPrice(pricemax.text!) {
                    noticeOnlyText("请输入正确的价格")
                    return
                }
                price = pricemax.text!
            }
        }
        self.view3.isHidden = true
        let arr:Array<GoodsModel> = []
        self.searchList2 = arr
        self.showList = arr
        getSearchResult(false)
    }
    
    //keyboard
    var canClick:Bool = false
    func keyboardShow(_ notification: Notification) {
        let dict = NSDictionary(dictionary: notification.userInfo!)
        let duration = Double(dict.object(forKey: UIKeyboardAnimationDurationUserInfoKey) as! NSNumber)
        UIView.animate(withDuration: duration, animations: {
            self.canClick = true
            self.view.layoutIfNeeded()

            }, completion: nil)
        
    }
    
    func keyboardHide(_ notification : Notification) {
        let dict = NSDictionary(dictionary: notification.userInfo!)
        let duration = Double(dict.object(forKey: UIKeyboardAnimationDurationUserInfoKey) as! NSNumber)
        UIView.animate(withDuration: duration, animations: { () -> Void in
            self.canClick = false
            self.view.layoutIfNeeded()

            }, completion: nil)
        
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
