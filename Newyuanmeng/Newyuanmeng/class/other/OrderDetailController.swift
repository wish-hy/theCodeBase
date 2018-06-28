//
//  OrderDetailController.swift
//  huabi
//
//  Created by TeamMac2 on 16/9/12.
//  Copyright © 2016年 ltl. All rights reserved.
//

import UIKit
import SwiftyJSON

class OrderDetailController: UIViewController ,UITableViewDelegate,UITableViewDataSource{

    @IBOutlet weak var titlelbl: UILabel!
    @IBOutlet weak var mainBtn: UIButton!
    @IBOutlet weak var backBtn: UIButton!
    @IBOutlet weak var view1: UIView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var orderNum: UILabel!
    @IBOutlet weak var carIcon: UILabel!
    @IBOutlet weak var orderName: UILabel!
    @IBOutlet weak var orderPhone: UILabel!
    @IBOutlet weak var orderAddress: UILabel!
    @IBOutlet weak var payWay: UILabel!
    @IBOutlet weak var timelbl: UILabel!
    @IBOutlet weak var datelbl: UILabel!
    @IBOutlet weak var invoiceType: UILabel!
    @IBOutlet weak var invoiceTitle: UILabel!
    @IBOutlet weak var invoiceContent: UILabel!
    @IBOutlet weak var sumPrice: UILabel!
    @IBOutlet weak var reducePrice: UILabel!
    @IBOutlet weak var addPrice: UILabel!
    @IBOutlet weak var prices: UILabel!
    @IBOutlet weak var ordertime: UILabel!
    @IBOutlet weak var invoiceView: UIView!

    var detailInfo:JSON!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.tableHeaderView?.frame = CGRect(x:0, y:0, width:screenWidth, height:255)
        self.tableView.tableFooterView?.frame = CGRect(x:0, y:0, width:screenWidth, height:500)
        self.setInfo()
        // Do any additional setup after loading the view.
        
    }
    
    func setInfo(){
        backBtn.setTitle(IconFontIconName.icon_back.rawValue, for: .normal)
        mainBtn.isHidden = true
        titlelbl.text = "订单详情"
        carIcon.text = IconFontIconName.icon_wait_receiving.rawValue
        let numb = self.detailInfo["order"]["mobile"].stringValue
        orderPhone.text = (numb as NSString).substring(to: 3) + "******" + (numb as NSString).substring(from: 9)
        orderNum.text = "订单号：" + self.detailInfo["order"]["order_no"].stringValue
        orderName.text = self.detailInfo["order"]["accept_name"].stringValue
        orderAddress.text = self.detailInfo["order"]["addr"].stringValue
        ordertime.text = self.detailInfo["order"]["create_time"].stringValue
        payWay.text = self.detailInfo["order"]["pay_name"].stringValue
        addPrice.text = "¥"+self.detailInfo["order"]["payable_freight"].stringValue
        reducePrice.text = "¥"+self.detailInfo["order"]["discount_amount"].stringValue
        sumPrice.text = "¥"+self.detailInfo["order"]["order_amount"].stringValue
        prices.text = "¥"+self.detailInfo["order"]["order_amount"].stringValue
        self.tableView.reloadData()
    }

    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.detailInfo["order_goods"].count
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: IndexPath) -> CGFloat {
        return 102
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "OrderDetailCell") as! OrderDetailCell
        cell.backgroundColor = UIColor.white
        cell.tag = indexPath.row
        if self.detailInfo["order_goods"].count != 0 {
            cell.setDetailInfo(self.detailInfo["order_goods"][indexPath.row])
        }
        cell.buychoose = buyChoose
        cell.selectionStyle = .none
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        CommonConfig.getProductDetail(self, goodsID: self.detailInfo["order_goods"][indexPath.row]["id"].stringValue)
    }
    
    func buyChoose(tag:NSInteger){
        CommonConfig.getProductDetail(self, goodsID: self.detailInfo["order_goods"][tag]["id"].stringValue)
    }
    
    @IBAction func orderConfirm(sender: AnyObject) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func backClick(sender: AnyObject) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func mainClick(sender: AnyObject) {
        (UIApplication.shared.delegate as! AppDelegate).showMainPage()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        UIApplication.shared.setStatusBarStyle(.default, animated: false)
        self.navigationController?.setNavigationBarHidden(true, animated: false)
        self.setNeedsStatusBarAppearanceUpdate()
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .default
    }
    
    override var prefersStatusBarHidden: Bool {
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
