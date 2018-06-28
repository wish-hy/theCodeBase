//
//  WebViewController.swift
//  mibo
//
//  Created by TeamMac2 on 16/1/29.
//  Copyright © 2016年 TeamMac2. All rights reserved.
//

import UIKit
import Kingfisher
extension UIImageView{
    
    public func hnk_setImageFromURL(URL: NSURL, placeholder : UIImage? = nil, format : UIImage? = nil, failure fail : ((NSError?) -> ())? = nil, success succeed : ((UIImage) -> ())? = nil) {
        let resour = ImageResource(downloadURL: URL.absoluteURL!,cacheKey: URL.absoluteString)
        self.kf.setImage(with: resour, placeholder: placeholder, options: nil, progressBlock: nil, completionHandler: nil);
    }
}
extension UIButton{
    
    public func hnk_setImageFromURL(URL: NSURL, placeholder : UIImage? = nil, format : UIImage? = nil, failure fail : ((NSError?) -> ())? = nil, success succeed : ((UIImage) -> ())? = nil) {
        let resour = ImageResource(downloadURL: URL.absoluteURL!,cacheKey: URL.absoluteString)
        self.kf.setImage(with: resour, for: .normal, placeholder: placeholder, options: nil, progressBlock: nil, completionHandler: nil)
    }
}

class WebViewController: UIViewController {

    
    
    var pageType:PageType = .userAgreement()
    
    enum PageType{
        case userAgreement()
        case gold()
        case html(url:String)
    }
    
    var requestUrl:URL!
    var urlTitle:String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        switch pageType{
        case .userAgreement():
            let path = Bundle.main.path(forResource: "user_agreement", ofType: "html")
            self.requestUrl = URL(fileURLWithPath: path!)
        case .gold():
            let path = Bundle.main.path(forResource: "gold", ofType: "html")
            self.requestUrl = URL(fileURLWithPath: path!)
        case .html(let url):
            self.requestUrl = URL(string: url)
        }

//        print(requestUrl)
        let webView = UIWebView(frame: CGRect(x: 0, y: 0, width: screenWidth, height: screenHeight - 64))
        
        self.view.addSubview(webView)
        
        webView.loadRequest(URLRequest(url: requestUrl))
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        switch pageType {
        case .userAgreement():
            self.navigationItem.title = "用户协议"
        case .html(let url):
            self.navigationItem.title = urlTitle
        default:
            self.navigationItem.title = "米币使用说明"
        }
        
        self.navigationController?.setNavigationBarHidden(false, animated: false)
    }
    
    //返回按钮点击响应
    func backToPrevious(){
        self.navigationController?.popViewController(animated: true)
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
