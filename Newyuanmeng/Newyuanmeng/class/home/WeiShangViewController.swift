//
//  WeiShangViewController.swift
//  huabi
//
//  Created by teammac3 on 2017/12/22.
//  Copyright © 2017年 ltl. All rights reserved.
//

import UIKit
import SwiftyJSON
import MJRefresh
import SDWebImage

class WeiShangViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {
    var tableView : UITableView?
    var page = NSInteger()
    var weishangModel:JSON!
    override func viewDidLoad() {
        super.viewDidLoad()
       self.title = "微商专区"
        self.page = 1
        self.view.backgroundColor = UIColor.white
        
        createUI()
        loadData(self.page)
        // Do any additional setup after loading the view.
    }
    func createUI() {
        self.tableView = UITableView.init(frame: CGRect.init(x: 0, y: 0, width: screenWidth, height: screenHeight), style: UITableViewStyle.plain)
        self.tableView?.delegate = self
        self.tableView?.dataSource = self
        self.tableView?.register(UINib(nibName: "WeiShangCell", bundle: nil), forCellReuseIdentifier: "WeiShangCell")
        self.tableView?.mj_header = MJRefreshHeader.init(refreshingBlock: {
            self.page = 1
            self.loadData(1)
        });
        self.tableView?.mj_footer = MJRefreshBackFooter.init(refreshingBlock: {
            self.page += 1
            self.loadData(self.page)
        });
        self.tableView?.separatorStyle = UITableViewCellSeparatorStyle.none
        self.view.addSubview(self.tableView!)
        
        let businessBtn: UIButton = UIButton(frame: CGRect.init(x: 0, y: 0, width: 20, height: 20))
        businessBtn.titleLabel?.font = UIFont.init(name: "iconfont", size: 20)
        businessBtn.setTitle(IconFontIconName.icon_goods_backhome.rawValue, for: .normal)
        businessBtn.setTitleColor(UIColor.init(red: 221/255.0, green: 149/255.0, blue: 127/255.0, alpha: 1), for: UIControlState.normal)
        businessBtn.addTarget(self, action: #selector(WeiShangViewController.homeAction), for: UIControlEvents.touchUpInside)
        let rigthItem: UIBarButtonItem = UIBarButtonItem(customView: businessBtn)
        self.navigationItem.rightBarButtonItem = rigthItem
        
    }
    
    
    
    func loadData(_ page : NSInteger){
        self.tableView?.mj_header.endRefreshing()
        self.tableView?.mj_footer.endRefreshing()
        
        RequestManager.RequestData(RequestUrl.Router.loadWeiShang(page: page), successCallBack: { (result) in
            if result["code"].intValue == 0{
               // self.model = WeiShangModel.mj_object(withKeyValues: result["content"])
               self.weishangModel = result["content"]
               self.tableView?.reloadData()
            }else{
                self.page -= 1
            }
        }) { (fail) in
            
        }
    }
    func homeAction() {
        self.navigationController?.popToRootViewController(animated: true)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        self.tabBarController?.tabBar.isHidden = false
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.isNavigationBarHidden = false
        self.navigationController?.navigationBar.tintColor = UIColor.init(hexCode: "#db8263")
        //去掉返回箭头旁边的文字
        self.tabBarController?.tabBar.isHidden = true
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: self, action: nil)
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if self.weishangModel != nil{
            var arr = self.weishangModel["weishang_data"].arrayValue
            return (arr.count)
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100;
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: "WeiShangCell", for: indexPath) as! WeiShangCell
        if cell == nil {
            cell = Bundle.main.loadNibNamed("WeiShangCell", owner: nil, options: nil)!.last as! WeiShangCell
        }
        
        
        cell.headImageView.sd_setImage(with: URL.init(string: CommonConfig.ImageHost + self.weishangModel["weishang_data"][indexPath.row]["img"].stringValue), placeholderImage:UIImage.init(named: "none"), options: SDWebImageOptions.delayPlaceholder, completed: nil)
        cell.nameLabel.text = self.weishangModel["weishang_data"][indexPath.row]["name"].stringValue
        var dic = self.weishangModel["weishang_data"][indexPath.row]["price_set"][0].dictionaryValue
        cell.priceLabel.text = "￥" + (dic["cash"]?.stringValue)!
        cell.referenceLabel.text = self.weishangModel["weishang_data"][indexPath.row]["sell_price"].stringValue
        cell.addCarButton.titleLabel?.font = UIFont.init(name: "iconfont", size: 20)
        cell.addCarButton.setTitle(IconFontIconName.icon_cart_normal.rawValue, for: .normal)
        //cell.addCarButton.setTitle(IconFontIconName.icon_collected.rawValue, for: .normal)
        cell.callBackBlock{
            print(indexPath.row)
            var controller = UIStoryboard(name: "ShopCart", bundle: nil).instantiateViewController(withIdentifier: "GoodsDetailViewController") as! GoodsDetailViewController
            controller.isOC = true
            controller.goodsID = self.weishangModel["weishang_data"][indexPath.row]["goods_id"].stringValue
            self.navigationController?.pushViewController(controller, animated: true)
        }
        cell.selectionStyle = UITableViewCellSelectionStyle.none
        var line = UIView()
        line.backgroundColor = UIColor.init(white: 0.6, alpha: 0.8)
        line.frame = CGRect.init(x: 0, y: 100, width: screenWidth, height: 1)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        var controller = UIStoryboard(name: "SHopCart", bundle: nil).instantiateViewController(withIdentifier: "GoodsDetailViewController") as! GoodsDetailViewController
        controller.isOC = true
        controller.goodsID = self.weishangModel["weishang_data"][indexPath.row]["goods_id"].stringValue
        self.navigationController?.pushViewController(controller, animated: true)
    }
    
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
