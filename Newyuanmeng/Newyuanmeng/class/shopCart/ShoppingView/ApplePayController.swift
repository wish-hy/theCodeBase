//
//  ApplePayController.swift
//  huabi
//
//  Created by TeamMac2 on 16/9/29.
//  Copyright © 2016年 ltl. All rights reserved.
//

import UIKit

class ApplePayController: UIViewController ,UITableViewDelegate,UITableViewDataSource{

    
    @IBOutlet weak var priceOld: UILabel!
    @IBOutlet weak var priceNew: UILabel!
    @IBOutlet weak var showPrice: UILabel!
    @IBOutlet weak var showView: UIView!
    
    @IBOutlet weak var resultTable: UITableView!
    
    var isShow = false
    var priceShow = ""
    var newPrice = ""
    var oldPrice = ""
    var orderNo = ""
    var orderTime = ""
    var orderName = "商城"
    var pricecurrency = ""
    
    @IBAction func doneClick(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if isShow {
            resultTable.tableHeaderView?.frame = CGRect(x: 0, y: 0, width: screenWidth, height: 250)
            showPrice.text = "-" + pricecurrency + priceShow
        }else{
            resultTable.tableHeaderView?.frame = CGRect(x: 0, y: 0, width: screenWidth, height: 200)
            showView.isHidden = true
        }
        priceOld.text = pricecurrency + oldPrice
        priceNew.text = pricecurrency + newPrice
        // Do any additional setup after loading the view.
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 40
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ApplePayCell") as! ApplePayCell
        if indexPath.row == 0 {
            cell.titlelbl.text = "商户名称"
            cell.textlbl.text = orderName
        }else if indexPath.row == 1 {
            cell.titlelbl.text = "交易时间"
            cell.textlbl.text = orderTime
        }else if indexPath.row == 2 {
            cell.titlelbl.text = "交易单号"
            cell.textlbl.text = orderNo
        }
        cell.selectionStyle = .none
        return cell
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        UIApplication.shared.setStatusBarStyle(.lightContent, animated: false)
        self.navigationController?.setNavigationBarHidden(true, animated: false)
        self.setNeedsStatusBarAppearanceUpdate()
    }
    
    override var preferredStatusBarStyle : UIStatusBarStyle {
        return .lightContent
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
