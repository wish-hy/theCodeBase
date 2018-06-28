////
////  MallViewController.swift
////  huabi
////
////  Created by TeamMac2 on 16/8/31.
////  Copyright © 2016年 ltl. All rights reserved.
////
//
//import UIKit
//import SwiftyJSON
//
//class MallViewController: UIViewController ,UITableViewDelegate,UITableViewDataSource{
//
//
//    @IBOutlet weak var backBtn: UIButton!
//    @IBOutlet weak var titles: UILabel!
//    @IBOutlet weak var bannerImg: UIImageView!
//    @IBOutlet weak var points: UILabel!
//    @IBOutlet weak var img1: UIImageView!
//    @IBOutlet weak var img2: UIImageView!
//    @IBOutlet weak var img3: UIImageView!
//    @IBOutlet weak var tableView: UITableView!
//
//    @IBOutlet weak var bannerH: NSLayoutConstraint!
//    @IBOutlet weak var imgH: NSLayoutConstraint!
//    
//    var showList:Array<JSON> = []
//
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        bannerH.constant = 230*newScale
//        imgH.constant = 288*newScale
//        backBtn.setTitle(IconFontIconName.icon_back.rawValue, for: UIControlState())
//        tableView.tableHeaderView?.frame = CGRect(x: 0, y: 0, width: screenWidth, height: 85+(230+288)*newScale)
//        // Do any additional setup after loading the view.
//    }
//
//    func numberOfSections(in tableView: UITableView) -> Int {
//        return 1
//    }
//
//    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//
//        return 1
//    }
//
//    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
//
//        return 123
//    }
//
//    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        let cell = tableView.dequeueReusableCell(withIdentifier: "MallChangeCell") as! MallChangeCell
//            cell.backgroundColor = UIColor.white
//            cell.selectionStyle = .none
//            return cell
//
//    }
//
//    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//
//        if indexRow != nil{
//            let cell = tableView.cellForRow(at: indexRow!) as! SearchResultCell
//            cell.backgroundColor = UIColor.white
//            indexRow = nil
//        }
//
//    }
//
//    func tableView(_ tableView: UITableView, didHighlightRowAt indexPath: IndexPath) {
//
//        let cell = tableView.cellForRow(at: indexPath) as! SearchResultCell
//        cell.backgroundColor = UIColor.init(hexCode: "efefef")
//        indexRow = indexPath
//
//    }
//
//    var indexRow:IndexPath?
//    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
//
//        if indexRow != nil{
//            let cell = self.tableView.cellForRow(at: indexRow!) as! SearchResultCell
//            cell.backgroundColor = UIColor.white
//            indexRow = nil
//        }
//    }
//
//    @IBAction func backClick(_ sender: AnyObject) {
//        self.navigationController?.popViewController(animated: true)
//    }
//
//    override func didReceiveMemoryWarning() {
//        super.didReceiveMemoryWarning()
//        // Dispose of any resources that can be recreated.
//    }
//
//
//    /*
//    // MARK: - Navigation
//
//    // In a storyboard-based application, you will often want to do a little preparation before navigation
//    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
//        // Get the new view controller using segue.destinationViewController.
//        // Pass the selected object to the new view controller.
//    }
//    */
//
//}

