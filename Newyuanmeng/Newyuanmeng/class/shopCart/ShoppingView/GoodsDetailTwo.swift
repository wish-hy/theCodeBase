//
//  GoodsDetailTwo.swift
//  huabi
//
//  Created by TeamMac2 on 16/9/6.
//  Copyright © 2016年 ltl. All rights reserved.
//

import UIKit
import SwiftyJSON

class GoodsDetailTwo: UIView {

    
    @IBOutlet weak var icons: UILabel!
    @IBOutlet weak var scroll1: UIScrollView!
    @IBOutlet weak var scroll2: UIScrollView!
    @IBOutlet weak var webView: UIWebView!
    
    func setScroll1(_ infos:JSON){
        var height:CGFloat = 30
//        for i in 0..<infos["goods_attrs"].count{
//            let text = infos["goods_attrs"][i]["name"].stringValue + " : " + infos["goods_attrs"][i]["vname"].stringValue
//            let size = CommonConfig.getTextRectSize(text as NSString, font: UIFont.systemFont(ofSize: 12), size: CGSize(width: CGFloat(screenWidth - 40), height: CGFloat(0)))
//            let textlbl = UILabel.init(frame: CGRect(x:20,y: height,width: screenWidth-40,height: size.height))
//            height += size.height + 12
//            textlbl.text = text
//            textlbl.numberOfLines = 0
//            textlbl.textColor = CommonConfig.MainFontBlackColor
//            textlbl.font = UIFont.systemFont(ofSize: 12)
//            textlbl.backgroundColor = UIColor.white
//            scroll1.addSubview(textlbl)
//        }
        let text = "商品名称" + " : " + infos["goods"]["name"].stringValue
        let size = CommonConfig.getTextRectSize(text as NSString, font: UIFont.systemFont(ofSize: 12), size: CGSize(width: CGFloat(screenWidth - 40), height: CGFloat(0)))
        let textlbl = UILabel.init(frame: CGRect(x:20,y: height,width: screenWidth-40,height: size.height))
        height += size.height + 12
        textlbl.text = text
        textlbl.numberOfLines = 0
        textlbl.textColor = CommonConfig.MainFontBlackColor
        textlbl.font = UIFont.systemFont(ofSize: 12)
        textlbl.backgroundColor = UIColor.white
        scroll1.addSubview(textlbl)
        
        let text2 = "商品编号" + " : " + infos["goods"]["goods_no"].stringValue
        let size2 = CommonConfig.getTextRectSize(text2 as NSString, font: UIFont.systemFont(ofSize: 12), size: CGSize(width: CGFloat(screenWidth - 40), height: CGFloat(0)))
        let textlbl2 = UILabel.init(frame: CGRect(x:20,y: height,width: screenWidth-40,height: size2.height))
        height += size2.height + 12
        textlbl2.text = text2
        textlbl2.numberOfLines = 0
        textlbl2.textColor = CommonConfig.MainFontBlackColor
        textlbl2.font = UIFont.systemFont(ofSize: 12)
        textlbl2.backgroundColor = UIColor.white
        scroll1.addSubview(textlbl2)
        
        let text3 = "商品重量" + " : " + infos["goods"]["weight"].stringValue
        let size3 = CommonConfig.getTextRectSize(text3 as NSString, font: UIFont.systemFont(ofSize: 12), size: CGSize(width: CGFloat(screenWidth - 40), height: CGFloat(0)))
        let textlbl3 = UILabel.init(frame: CGRect(x:20,y: height,width: screenWidth-40,height: size3.height))
        height += size3.height + 12
        textlbl3.text = text3
        textlbl3.numberOfLines = 0
        textlbl3.textColor = CommonConfig.MainFontBlackColor
        textlbl3.font = UIFont.systemFont(ofSize: 12)
        textlbl3.backgroundColor = UIColor.white
        scroll1.addSubview(textlbl3)
        
        let text4 = "上架时间" + " : " + infos["goods"]["create_time"].stringValue
        let size4 = CommonConfig.getTextRectSize(text4 as NSString, font: UIFont.systemFont(ofSize: 12), size: CGSize(width: CGFloat(screenWidth - 40), height: CGFloat(0)))
        let textlbl4 = UILabel.init(frame: CGRect(x:20,y: height,width: screenWidth-40,height: size4.height))
        height += size4.height + 12
        textlbl4.text = text4
        textlbl4.numberOfLines = 0
        textlbl4.textColor = CommonConfig.MainFontBlackColor
        textlbl4.font = UIFont.systemFont(ofSize: 12)
        textlbl4.backgroundColor = UIColor.white
        scroll1.addSubview(textlbl4)
        
        scroll1.contentSize = CGSize(width: screenWidth, height: height)
    }
    
    func setScroll2(){
        let textArr = ["服务承诺：","商城向您保证所售商品均为正品行货，自营商品开具机打发票或电子发票。凭质保证书及商城发票，可享受全国联保服务（奢侈品、钟表除外；奢侈品、钟表由联系保修，享受法定三包售后服务），与您亲临商场选购的商品享受相同的质量保证。商城还为您提供具有竞争力的商品价格和运费政策，请您放心购买！","\n","注：因厂家会在没有任何提前通知的情况下更改产品包装、产地或者一些附件，本司不能确保客户收到的货物与商城图片、产地、附件说明完全一致。只能确保为原厂正货！并且保证与当时市场上同样主流新品一致。若本商城没有及时更新，请大家谅解！","\n","权利声明：","商城上的所有商品信息、客户评价、商品咨询、网友讨论等内容，是商城重要的经营资源，未经许可，禁止非法转载使用。","\n","\n", "注：本站商品信息均来自于厂商，其真实性、准确性和合法性由信息拥有者（厂商）负责。本站不提供任何保证，并不承担任何法律责任。"]
        var height:CGFloat = 30
        for i in 0..<textArr.count{
            let text = textArr[i]
            if text == "\n" {
                height += 12 + 3
            }else{
                let size = CommonConfig.getTextRectSize(text as NSString, font: UIFont.systemFont(ofSize: 12), size: CGSize(width: screenWidth-40, height: 0))
                let textlbl = UILabel.init(frame: CGRect(x: 20, y: height, width: screenWidth-40, height: size.height))
                height += size.height + 3
                textlbl.text = text
                textlbl.numberOfLines = 0
                textlbl.textColor = CommonConfig.MainFontBlackColor
                textlbl.font = UIFont.systemFont(ofSize: 12)
                textlbl.backgroundColor = UIColor.white
                scroll2.addSubview(textlbl)
            }
        }
        scroll2.contentSize = CGSize(width: screenWidth, height: height)
    }
    
    func setWebView(_ infos:JSON){
        webView.backgroundColor = UIColor.white
//        webView.scalesPageToFit = true
        var content = infos["goods"]["content"].stringValue
        content = content.replacingOccurrences(of: "initial-scale=1.0", with: ", minimum-scale=0.5, maximum-scale=1.0, user-scalable=yes")
        content = String.init(MySDKHelper.insetString(content, size: Int(screenWidth-20)))
        webView.loadHTMLString(content, baseURL: nil)
    }
    
//    func webViewDidFinishLoad(webView: UIWebView) {
//        
//        webView.stringByEvaluatingJavaScriptFromString("document.getElementsByTagName('body')[0].style.webkitTextSizeAdjust= '200%'")
//    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
    }
    /*
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
        // Drawing code
    }
    */

}
