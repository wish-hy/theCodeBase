//
//  ShareViewController.m
//  huabi
//
//  Created by hy on 2018/1/30.
//  Copyright © 2018年 ltl. All rights reserved.
//

#import "ShareViewController.h"
#import "Newyuanmeng-Swift.h"
#import <UShareUI/UShareUI.h>

@interface ShareViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *imageV;
@property (weak, nonatomic) IBOutlet UIImageView *code;
@property (weak, nonatomic) IBOutlet UILabel *titile;
@property (weak, nonatomic) IBOutlet UIButton *share;

@property (weak, nonatomic) IBOutlet UIView *BG;
@end

@implementation ShareViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.titile.text = _header;
    [_imageV sd_setImageWithURL:[NSURL URLWithString:[CommonConfig getImageUrl:_imageUrl]]];
    [_share setImage:[UIImage iconWithInfo:TBCityIconInfoMake(@"\U0000e609", 30, [UIColor whiteColor])] forState:UIControlStateNormal];
    [self setInfo];
}

-(void)setInfo
{
    
    NSArray *keyArr = @[@"user_id",@"token",@"goods_id"];
    NSArray *valueArr = @[@(CommonConfig.UserInfoCache.userId),CommonConfig.Token,_goodsId];
    [MySDKHelper postAsyncWithURL:@"/v1/get_qrcode_flag_by_goods_id" withParamBodyKey:keyArr withParamBodyValue:valueArr needToken:@"" postSucceed:^(NSDictionary *result) {
        NSLog(@"%@",result);
        NSDictionary *dic = result[@"content"];
        NSString *urlString = dic[@"url"];
        NSLog(@"url = %@",urlString);
//        [_code sd_setImageWithURL:[NSURL URLWithString:urlString]];
        _code.image = [SGQRCodeTool SG_generateWithDefaultQRCodeData:urlString imageViewWidth:100];
        
//        self.userImage.image = [SGQRCodeTool SG_generateWithLogoQRCodeData:dicInfo[@"url"] logoImageName:_img logoScaleToSuperView:scale];
        
    } postCancel:^(NSString *error) {
        [NoticeView showMessage:error];
        NSLog(@"我是错误------%@",error);
    }];
}

    
//    for i in 0..<3 {
//        let btn = UIButton.init(frame: CGRect(x: screenWidth/3.0*CGFloat(i)+(screenWidth/3.0-90*newScale)/2.0, y: 30*newScale, width: 90*newScale, height: 90*newScale))
//        btn.titleLabel?.font = UIFont.init(name: "iconfont", size: 42)
//        if i == 0 {
//            btn.setImage(UIImage.init(named: "weibo"), for: UIControlState())
//        }else if i == 1{
//            btn.setImage(UIImage.init(named: "qq"), for: UIControlState())
//        }else if i == 2{
//            btn.setImage(UIImage.init(named: "weixin"), for: UIControlState())
//        }
//        btn.tag = i
//        btn.addTarget(self, action: #selector(GoodsDetailViewController.shareBtnClick(_:)), for: .touchUpInside)
//        shareBack.addSubview(btn)
//
//override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
//    if shareView.isHidden == false {
//        shareView.isHidden = true
//    }
//}
//
//func shareBtnClick(_ sender:UIButton){
//    var type = UMSocialPlatformType.sina
//    if sender.tag == 0 {
//        type = UMSocialPlatformType.sina
//    }else if  sender.tag == 1{
//        type = UMSocialPlatformType.QQ
//    }else if  sender.tag == 2{
//        type = UMSocialPlatformType.wechatSession
//    }
//    [UMengHelper .shareWebPage(to: self, platformType: type, url: goodsInfo["goods"]["shareurl"].stringValue, title: "圆梦", descr: goodsInfo["goods"]["name"].stringValue, thumbImage: shareImg.image!, onShareSucceed: {
//        //                print("分享成功")
//    }, onShareCancel: {
//
//    })]
//}


- (IBAction)back:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}
- (IBAction)share:(id)sender {
    __weak typeof(self) weakSelf = self;
    [UMSocialUIManager setPreDefinePlatforms:@[@(UMSocialPlatformType_Sina),@(UMSocialPlatformType_QQ),@(UMSocialPlatformType_WechatSession),@(UMSocialPlatformType_WechatTimeLine)]];
    [UMSocialUIManager showShareMenuViewInWindowWithPlatformSelectionBlock:^(UMSocialPlatformType platformType, NSDictionary *userInfo) {
        if (platformType == UMSocialPlatformType_WechatSession) {
            [weakSelf shareImageToPlatformType:UMSocialPlatformType_WechatSession];
            
        } else if (platformType == UMSocialPlatformType_Sina) {
            [weakSelf shareImageToPlatformType:UMSocialPlatformType_Sina];
        }
        else if (platformType == UMSocialPlatformType_QQ)
        {
            [weakSelf shareImageToPlatformType:UMSocialPlatformType_QQ];
        }else if (platformType == UMSocialPlatformType_WechatTimeLine){
            [weakSelf shareImageToPlatformType:UMSocialPlatformType_WechatTimeLine];
        }
        
    }];
}
- (void)shareImageToPlatformType:(UMSocialPlatformType)platformType
{
    UIGraphicsBeginImageContextWithOptions(self.BG.frame.size, NO, 0.0);
    CGContextRef context = UIGraphicsGetCurrentContext();
    [self.BG.layer renderInContext:context];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();

    //创建分享消息对象
    UMSocialMessageObject *messageObject = [UMSocialMessageObject messageObject];
    
    //创建图片内容对象
    UMShareImageObject *shareObject = [[UMShareImageObject alloc] init];
    //如果有缩略图，则设置缩略图
//    shareObject.thumbImage = [UIImage imageNamed:@"icon"];
    [shareObject setShareImage:image];
    
    //分享消息对象设置分享内容对象
    messageObject.shareObject = shareObject;
    
    //调用分享接口
    [[UMSocialManager defaultManager] shareToPlatform:platformType messageObject:messageObject currentViewController:self completion:^(id data, NSError *error) {
        if (error) {
            NSLog(@"************Share fail with error %@*********",error);
        }else{
            NSLog(@"response data is %@",data);
        }
    }];
}

@end
