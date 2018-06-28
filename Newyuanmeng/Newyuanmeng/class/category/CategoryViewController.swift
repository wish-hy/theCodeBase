//
//  ClassViewController.swift
//  huabi
//
//  Created by TeamMac2 on 16/8/24.
//  Copyright © 2016年 ltl. All rights reserved.
//

import UIKit
import SwiftyJSON


class CategoryViewController: UIViewController ,UITableViewDelegate,UITableViewDataSource{


    @IBOutlet weak var search: UIView!
    @IBOutlet weak var messbtn: UIButton!
    @IBOutlet weak var qrcodebtn: UIButton!
    
    @IBOutlet weak var tableviewWid: NSLayoutConstraint!

    @IBOutlet weak var tabelView1: UITableView!
    @IBOutlet weak var tableView2: UITableView!
    
    var cateList1:Array<JSON> = []
    var cateList2:Array<JSON> = []
  
    
    override func viewDidLoad() {
        super.viewDidLoad()
        search.layer.cornerRadius = 5
        search.layer.borderColor = CommonConfig.SliderBlackColor.cgColor
        search.layer.borderWidth = 1
        search.clipsToBounds = true
        let tapGesturer1 = UITapGestureRecognizer(target: self, action: #selector(CategoryViewController.toSearch(_:)))
        search.isUserInteractionEnabled = true
        search.addGestureRecognizer(tapGesturer1)
        
//        messbtn.setTitle(IconFontIconName.icon_msg.rawValue, for: UIControlState())
//        qrcodebtn.setTitle(IconFontIconName.icon_qrcode.rawValue, for: UIControlState())
        tableviewWid.constant = 160*newScale
        getCategory()
        
         NotificationCenter.default.addObserver(self, selector: #selector(self.refreshTwo), name: NSNotification.Name(rawValue: "refresh2"), object: nil)   //刷新通知
        // Do any additional setup after loading the view.
    }
    
    func toSearch(_ tap:UITapGestureRecognizer){
        let searchController = UIStoryboard(name: "ShopCart", bundle: nil).instantiateViewController(withIdentifier: "SearchViewController") as! SearchViewController
        self.navigationController?.pushViewController(searchController, animated: true)
    }
    
    func getCategory(){
       RequestManager.RequestData(RequestUrl.Router.getCategory(), successCallBack: { (result) in
        
            self.cateList1 = result["content"].arrayValue
            self.cateList2 = result["content"][0]["child"].arrayValue
    
            self.tabelView1.reloadData()
            self.tabelView1.reloadRows(at: [IndexPath.init(row: 0, section: 0)], with: .fade)
            self.tableView2.reloadData()
        }) { (failstr) in
            self.noticeOnlyText(failstr)
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == self.tabelView1 {
            return self.cateList1.count
        }else{
            return self.cateList2.count
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if tableView == self.tabelView1 {
            return 126*newScale
        }else{
            var arr:Array<String> = []
            for i in 0..<self.cateList2[indexPath.row]["child"].count {
                arr.append(self.cateList2[indexPath.row]["child"][i]["title"].stringValue)
            }
            return CommonConfig.getCellHeight(arr) + 80
        }
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if tableView == self.tabelView1 {
            return 0.01
        }else{
            return 180*newScale
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if tableView == self.tabelView1 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "CategoryViewCell") as! CategoryViewCell
            cell.backgroundColor = UIColor.white
            cell.isUserInteractionEnabled = true
            cell.textlbl.textColor = CommonConfig.MainFontBlackColor
           
            if indexPath.row == 0 {
                index = indexPath
                cell.backgroundColor = CommonConfig.MainLightRedColor
                cell.textlbl.textColor = UIColor.white
                cell.img.image = CommonConfig.changeImageWithColor(UIImage.init(named: CommonConfig.imageDefaultName)!, color: UIColor.white)
              
            }
            
            if self.cateList1.count != 0{
                                cell.setCenterView(cateList1[indexPath.row]["apptitle"].stringValue, icons: cateList1[indexPath.row]["img"].stringValue)
                if indexPath.row == 0 {
                    cell.img.image = CommonConfig.changeImageWithColor(cell.img.image!, color: UIColor.green)
                }
                
            }
            cell.selectionStyle = .none
            return cell
        }else{
            let cell = tableView.dequeueReusableCell(withIdentifier: "CategoryTwoCell") as! CategoryTwoCell
            cell.backgroundColor = UIColor.white
            if self.cateList2.count != 0{
                cell.setTagView(self.cateList2[indexPath.row])
                cell.selectClick = selectClick
            }
            cell.selectionStyle = .none
            return cell
        }
    }
    var index:IndexPath?
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if tableView == self.tabelView1 {
            if index == indexPath {
                return
            }
            let cell = tableView.cellForRow(at: indexPath) as! CategoryViewCell
            let oldcell = tableView.cellForRow(at: index!) as! CategoryViewCell
            oldcell.contentView.backgroundColor = UIColor.white
            oldcell.textlbl.textColor = CommonConfig.MainFontBlackColor
            oldcell.img.image = CommonConfig.changeImageWithColor(oldcell.img.image!, color: CommonConfig.MainFontBlackColor)
            cell.contentView.backgroundColor = CommonConfig.MainLightRedColor
            cell.textlbl.textColor = UIColor.white
            cell.img.image = CommonConfig.changeImageWithColor(cell.img.image!, color: UIColor.white)
            index = indexPath
            self.cateList2 = self.cateList1[indexPath.row]["child"].arrayValue
            self.tableView2.reloadData()
        }else{
            
        }
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
       
        let views = UIView.init(frame: CGRect(x: 0, y: 0, width: screenWidth - 160*newScale, height: 180*newScale))
        views.backgroundColor = UIColor.white
        if tableView == self.tableView2 {
            let img = UIImageView.init(frame: CGRect(x: 20*newScale, y: 20*newScale, width: screenWidth - 200*newScale, height: (180-40)*newScale))
            img.backgroundColor = UIColor.clear
            //img.contentMode = UIViewContentMode.scaleAspectFill
            if self.cateList1.count != 0 {
                var imgString = ""
                if index == nil {
                    imgString = self.cateList1[0]["adimg"].stringValue
                }else{
                    imgString = CommonConfig.getImageUrl(self.cateList1[index!.row]["adimg"].stringValue)
                }
//                img.hnk_setImageFromURL(URL: URL(string: CommonConfig.getImageUrl(imgString))! as NSURL, placeholder: UIImage(named: CommonConfig.imageDefaultName))
                
                img.hnk_setImageFromURL(URL: URL(string:imgString)! as NSURL)
                
                print(imgString)
                

                
                if imgString != "" {
                    views.addSubview(img)
                }else{
                    views.frame = CGRect(x: 0, y: 0, width: 0, height: 0.1)
                }
            }
            
        }else{
            views.frame = CGRect(x: 0, y: 0, width: 0, height: 0.1)
        }
        return views
    
    }
    
  
    
    
    
    func selectClick(_ key:String){
        let searchview = UIStoryboard(name: "ShopCart", bundle: nil).instantiateViewController(withIdentifier: "SearchViewController") as! SearchViewController
        searchview.isResult = true
        searchview.cid = key
        self.navigationController?.pushViewController(searchview, animated: true)

    }
    
    @IBAction func messClick(_ sender: UIButton) {
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
                                print("用户第一次拒绝了访问权限")
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
    
    @IBAction func qrcodeClick(_ sender: UIButton) {
        
        let vc = UIStoryboard(name: "Home", bundle: nil).instantiateViewController(withIdentifier: "NearViewController") as! NearViewController
        self.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(vc,animated:true)
        vc.tabBarController?.tabBar.isHidden = false
        self.hidesBottomBarWhenPushed = false
        
//        let device = AVCaptureDevice.defaultDevice(withMediaType: AVMediaTypeVideo)
//        if device != nil {
//            let status = AVCaptureDevice.authorizationStatus(forMediaType: AVMediaTypeVideo)
//            if status == .notDetermined {
//                AVCaptureDevice.requestAccess(forMediaType: AVMediaTypeVideo, completionHandler: {(granted:Bool) -> Void in
//                    if granted {
//                        DispatchQueue.main.async(execute: {() -> Void in
//                            let vc = QRCodeScanningVC()
//                            vc.token = CommonConfig.Token
//                            vc.user_id = CommonConfig.UserInfoCache.userId
//                            self.hidesBottomBarWhenPushed = true;
//                            self.navigationController!.pushViewController(vc, animated: true)
//                            self.hidesBottomBarWhenPushed = false;
//                        })
//                        print("当前线程--%s",[Thread.current])
//                    }else{
//                        print("用户第一次拒绝了访问权限")
//                    }
//                })
//            }else if status == .authorized {
//
//                let vc = QRCodeScanningVC()
//                vc.token = CommonConfig.Token
//                vc.user_id = CommonConfig.UserInfoCache.userId
//                self.hidesBottomBarWhenPushed = true;
//                self.navigationController!.pushViewController(vc, animated: true)
//                self.hidesBottomBarWhenPushed = false;
//            }else if status == .denied{
//                let alertC = UIAlertController(title: "⚠️警告", message: "请打开相机权限", preferredStyle: .alert)
//                let alertA = UIAlertAction(title: "确定", style: UIAlertActionStyle.default, handler: { (action:UIAlertAction) -> Void in
//
//                })
//                alertC.addAction(alertA)
//                self.present(alertC, animated: true, completion: {_ in})
//
//            }else if status == .restricted{
//
//                print("因为系统原因，无法访问相册")
//            }
//        }else {
//
//            let alertC = UIAlertController(title: "温馨提示", message: "未检测到您的摄像头", preferredStyle: (.alert))
//            let alertA = UIAlertAction(title: "确定", style: UIAlertActionStyle.default, handler: { (action:UIAlertAction) -> Void in
//
//            })
//            alertC.addAction(alertA)
//            self.present(alertC, animated: true, completion: {
//
//            })
//
//        }

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
    
    func refreshTwo(){
        print("refresh2")
        self.tabelView1.reloadRows(at: [IndexPath.init(row: 0, section: 0)], with: .fade)
        index = IndexPath.init(row: 0, section: 0)
        self.cateList2 = self.cateList1[0]["child"].arrayValue
        self.tableView2.reloadData()
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
