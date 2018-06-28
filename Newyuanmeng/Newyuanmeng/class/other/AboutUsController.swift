//
//  AboutUsController.swift
//  huabi
//
//  Created by TeamMac2 on 16/9/18.
//  Copyright © 2016年 ltl. All rights reserved.
//

import UIKit

class AboutUsController: UIViewController ,UITableViewDelegate,UITableViewDataSource{

    @IBOutlet weak var titlelbl: UILabel!
    @IBOutlet weak var backBtn: UIButton!
    @IBOutlet weak var mainBtn: UIButton!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var versionlbl: UILabel!
    @IBOutlet weak var img: UIImageView!
    @IBOutlet weak var buildlbl: UILabel!

    @IBOutlet weak var phonelbl: TTTAttributedLabel!
    @IBOutlet weak var leftW: NSLayoutConstraint!
    
    @IBOutlet weak var top: NSLayoutConstraint!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        top.constant = (screenHeight-64)/2 - 120
        leftW.constant = screenWidth
        titlelbl.text = "关于"
        phonelbl.attributedText = CommonConfig.setNSMutableAttributedTextColor("客服电话:4008715988", target: ["4008715988"], textColor: [CommonConfig.MainRedColor], size: [13], firstSize: 13)
        backBtn.setTitle(IconFontIconName.icon_back.rawValue, for: UIControlState())
        mainBtn.setTitle(IconFontIconName.icon_goods_backhome.rawValue, for: UIControlState())
        self.tableView.tableHeaderView?.frame = CGRect(x: 0, y: 0, width: screenWidth, height: 500)
        let infoDictionary = Bundle.main.infoDictionary
        if let infoDictionary = infoDictionary {
            let appVersion = infoDictionary["CFBundleShortVersionString"] as! String
            
            
               versionlbl.text = "For IOS \(appVersion)"
            buildlbl.text = "版本号:\(appVersion)"
        }
//        img.image = createQRForString("https://www.buy-d.cn", qrImageName: "")
//        img.image = createQRForString("https://ymlypt.b0.upaiyun.com", qrImageName: "")
        // Do any additional setup after loading the view.
    }

    //创建二维码图片
    func createQRForString(_ qrString: String?, qrImageName: String?) -> UIImage?{
        if let sureQRString = qrString {
            let stringData = sureQRString.data(using: String.Encoding.utf8,
                                                            allowLossyConversion: false)
            // 创建一个二维码的滤镜
            let qrFilter = CIFilter(name: "CIQRCodeGenerator")!
            qrFilter.setValue(stringData, forKey: "inputMessage")
            qrFilter.setValue("H", forKey: "inputCorrectionLevel")
            let qrCIImage = qrFilter.outputImage
            // 创建一个颜色滤镜,黑白色
            let colorFilter = CIFilter(name: "CIFalseColor")!
            colorFilter.setDefaults()
            colorFilter.setValue(qrCIImage, forKey: "inputImage")
            colorFilter.setValue(CIColor(red: 0, green: 0, blue: 0), forKey: "inputColor0")
            colorFilter.setValue(CIColor(red: 1, green: 1, blue: 1), forKey: "inputColor1")
            // 返回二维码image
            let codeImage = UIImage(ciImage: colorFilter.outputImage!
                .applying(CGAffineTransform(scaleX: 5, y: 5)))
            // 通常,二维码都是定制的,中间都会放想要表达意思的图片
            if let iconImage = UIImage(named: qrImageName!) {
                let rect = CGRect(x: 0, y: 0, width: codeImage.size.width, height: codeImage.size.height)
                UIGraphicsBeginImageContext(rect.size)
                
                codeImage.draw(in: rect)
                let avatarSize = CGSize(width: rect.size.width * 0.25, height: rect.size.height * 0.25)
                let x = (rect.width - avatarSize.width) * 0.5
                let y = (rect.height - avatarSize.height) * 0.5
                iconImage.draw(in: CGRect(x: x, y: y, width: avatarSize.width, height: avatarSize.height))
                let resultImage = UIGraphicsGetImageFromCurrentImageContext()
                
                UIGraphicsEndImageContext()
                return resultImage
            }
            return codeImage
        }
        return nil
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

    func setleft(_ type:Bool){
        UIView.animate(withDuration: 0.5, animations: {
            if type {
                self.leftW.constant = screenWidth
              
            }else{
                self.leftW.constant = -32*newScale
            }
            self.view.layoutIfNeeded()
        }) 
    }
    
    @IBAction func versionClick(_ sender: UIButton) {
        setleft(false)
        self.titlelbl.text = "版本信息"

    }
    
    @IBAction func showBack(_ sender: AnyObject) {
        if self.leftW.constant == -32*newScale {
            
            setleft(true)
            self.titlelbl.text = "关于"
            return
        }
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func showMain(_ sender: AnyObject) {
        (UIApplication.shared.delegate as! AppDelegate).showMainPage()
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
