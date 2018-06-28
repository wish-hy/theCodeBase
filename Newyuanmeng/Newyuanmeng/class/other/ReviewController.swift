//
//  ReviewController.swift
//  huabi
//
//  Created by TeamMac2 on 16/9/13.
//  Copyright © 2016年 ltl. All rights reserved.
//

import UIKit
import SwiftyJSON
// FIXME: comparison operators with optionals were removed from the Swift Standard Libary.
// Consider refactoring the code to use the non-optional operators.
fileprivate func < <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
  switch (lhs, rhs) {
  case let (l?, r?):
    return l < r
  case (nil, _?):
    return true
  default:
    return false
  }
}

// FIXME: comparison operators with optionals were removed from the Swift Standard Libary.
// Consider refactoring the code to use the non-optional operators.
fileprivate func > <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
  switch (lhs, rhs) {
  case let (l?, r?):
    return l > r
  default:
    return rhs < lhs
  }
}


class ReviewController: UIViewController ,UITextViewDelegate,UITableViewDelegate,UITableViewDataSource{

    @IBOutlet weak var mainBtn: UIButton!
    @IBOutlet weak var backBtn: UIButton!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var img: UIImageView!
    
    @IBOutlet weak var star11: UIButton!
    @IBOutlet weak var star12: UIButton!
    @IBOutlet weak var star13: UIButton!
    @IBOutlet weak var star14: UIButton!
    @IBOutlet weak var star15: UIButton!
    
    @IBOutlet weak var star21: UIButton!
    @IBOutlet weak var star22: UIButton!
    @IBOutlet weak var star23: UIButton!
    @IBOutlet weak var star24: UIButton!
    @IBOutlet weak var star25: UIButton!
    
    @IBOutlet weak var star31: UIButton!
    @IBOutlet weak var star32: UIButton!
    @IBOutlet weak var star33: UIButton!
    @IBOutlet weak var star34: UIButton!
    @IBOutlet weak var star35: UIButton!
    
    @IBOutlet weak var star41: UIButton!
    @IBOutlet weak var star42: UIButton!
    @IBOutlet weak var star43: UIButton!
    @IBOutlet weak var star44: UIButton!
    @IBOutlet weak var star45: UIButton!

    @IBOutlet weak var iconlbl: UILabel!
    @IBOutlet weak var nonameBtn: UIButton!
    @IBOutlet weak var textCount: UILabel!
    @IBOutlet weak var reviewText: UITextView!
    
    @IBOutlet weak var review: UIView!

    var list1:Array<UIButton> = []
    var list2:Array<UIButton> = []
    var list3:Array<UIButton> = []
    var list4:Array<UIButton> = []
    
    var point1 = 5
    var point2 = 0
    var point3 = 0
    var point4 = 0
    var suggest = ""
    let placeholders = "写下购买体会和使用感受来帮助其他小伙伴～"
    var reviewJSON:JSON!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let tapGesturer = UITapGestureRecognizer(target: self, action: #selector(self.hiddenkeyborad))
        review.isUserInteractionEnabled = true
        review.addGestureRecognizer(tapGesturer)
        self.tableView.tableHeaderView?.frame = CGRect(x: 0, y: 0, width: screenWidth, height: 560)
        list1 = [self.star11,self.star12,self.star13,self.star14,self.star15]
        list2 = [self.star21,self.star22,self.star23,self.star24,self.star25]
        list3 = [self.star31,self.star32,self.star33,self.star34,self.star35]
        list4 = [self.star41,self.star42,self.star43,self.star44,self.star45]
        backBtn.setTitle(IconFontIconName.icon_back.rawValue, for: UIControlState())
        iconlbl.text = IconFontIconName.icon_wait_receiving.rawValue
//        nonameBtn.setTitle(IconFontIconName.icon_circle.rawValue, forState: .Normal)
        nonameBtn.layer.cornerRadius = 21.0/2.0;
        nonameBtn.layer.masksToBounds = true
        nonameBtn.layer.borderColor = CommonConfig.MainFontGrayColor.cgColor
        nonameBtn.layer.borderWidth = 1
        img.hnk_setImageFromURL(URL: URL(string: CommonConfig.getImageUrl(reviewJSON["img"].stringValue))! as NSURL, placeholder: UIImage(named: CommonConfig.imageDefaultName))
        initSetting()
        
        // Do any additional setup after loading the view.
    }

    func initSetting(){
        nonameBtn.tag = -1
        point1 = 5
        setstarColor(list1, num: 5)
        setstarColor(list2, num: 0)
        setstarColor(list3, num: 0)
        setstarColor(list4, num: 0)
        self.suggest = ""
        reviewText.text = placeholders
        reviewText.textColor = UIColor.init(hexCode: "8a8a8a")
        reviewText.font = UIFont.systemFont(ofSize: 12)
        textCount.text = "0/300"
    }
    
    func hiddenkeyborad(){
        reviewText.resignFirstResponder()
    }
    
    func setstarColor(_ arr:Array<UIButton>,num:NSInteger){
        for i in 0..<5 {
            let star = arr[i]
            if i < num {
                star.setTitle(IconFontIconName.icon_star_yes.rawValue, for: UIControlState())
                star.setTitleColor(CommonConfig.MainRedColor, for: UIControlState())
            }else{
                star.setTitle(IconFontIconName.icon_star_no.rawValue, for: UIControlState())
                star.setTitleColor(CommonConfig.MainFontBlackColor, for: UIControlState())
            }
        }
    }
    
    func submitComment(){
        RequestManager.RequestData(RequestUrl.Router.postReview(id: reviewJSON["id"].stringValue, good_id: reviewJSON["goods_id"].stringValue, point: point1, content: suggest, userid: CommonConfig.UserInfoCache.userId), successCallBack: { (result) in
//            print(result)
            self.noticeOnlyText("评价成功!")
            self.initSetting()
            
            }) { (fail) in
//                print(fail)
                self.noticeOnlyText("评价失败!")
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 0
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell")! as UITableViewCell
        cell.backgroundColor = UIColor.white
        cell.selectionStyle = .none
        return cell
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    //MARK: -UITextViewDelegate
    func textViewDidChange(_ textView: UITextView) {
        
        if  textView.text?.characters.count > 300 {
            let str = textView.text! as NSString
            reviewText.text = str.substring(to: 300)
        }
        let text = textView.text
        if text?.characters.count > 0  && text != placeholders{
            textCount.text = "\(text?.characters.count)/300"
        }else{
            textCount.text = "0/300"
        }
        suggest = text!
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        let text = textView.text
        if text == placeholders {
            reviewText.text = ""
            reviewText.textColor = CommonConfig.MainFontBlackColor
            reviewText.font = UIFont.systemFont(ofSize: 12)
            textCount.text = "0/300"
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        let text = textView.text
        if text?.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines) .characters.count == 0 {
            reviewText.text = placeholders
            reviewText.textColor = UIColor.init(hexCode: "8a8a8a")
            reviewText.font = UIFont.systemFont(ofSize: 12)
            textCount.text = "0/300"
        }
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if text == "\n" {
            textView.resignFirstResponder()
            return false
        }
        return true
    }
    
    @IBAction func starClick1(_ sender: UIButton) {
        setstarColor(list1, num: sender.tag)
        point1 = sender.tag
    }
    
    @IBAction func starClick2(_ sender: UIButton) {
        setstarColor(list2, num: sender.tag)
        point2 = sender.tag
    }
    
    @IBAction func starClick3(_ sender: UIButton) {
        setstarColor(list3, num: sender.tag)
        point3 = sender.tag
    }
    
    @IBAction func starClick4(_ sender: UIButton) {
        setstarColor(list4, num: sender.tag)
        point4 = sender.tag
    }
    
    @IBAction func nonameClick(_ sender: UIButton) {
        sender.tag = -sender.tag
        if sender.tag > 0 {
            sender.backgroundColor = CommonConfig.MainRedColor
        }else{
            sender.backgroundColor = UIColor.clear
        }
    }
    
    @IBAction func submitClick(_ sender: UIButton) {
        if suggest == "" {
            self.noticeOnlyText("您还没有评价哦～")
            return
        }
        submitComment()
    }
    
    @IBAction func backBtn(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
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
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
