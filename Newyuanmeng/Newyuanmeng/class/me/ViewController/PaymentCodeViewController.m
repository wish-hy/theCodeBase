//
//  PaymentCodeViewController.m
//  huabi
//
//  Created by huangyang on 2017/12/21.
//  Copyright © 2017年 ltl. All rights reserved.
//

#import "PaymentCodeViewController.h"
#import "Newyuanmeng-Swift.h"
#import "SGQRCode.h"

@interface PaymentCodeViewController ()
@property (weak, nonatomic) IBOutlet UILabel *userName;
@property (weak, nonatomic) IBOutlet UIImageView *userImage;
@property (weak, nonatomic) IBOutlet UIView *BGimage;

@property (nonatomic,strong)UIImage *img;

@end

@implementation PaymentCodeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    NSString *imgStr = [NSString stringWithFormat:@"%@/Documents/%@.jpg",NSHomeDirectory(),@"MyHeader"];
    // 拿到沙盒路径图片
    UIImage *header = [[UIImage alloc] initWithContentsOfFile:imgStr];
    _img = header;
    NSLog(@"-----------------------------%@",imgStr);
    self.userName.text = self.name;
    [self setInfo];
}
- (IBAction)savePhoto:(UIButton *)sender {
    
//    UIGraphicsBeginImageContext(self.BGimage.frame.size);
    // 保存截图为View视图及其子视图
    UIGraphicsBeginImageContextWithOptions(self.BGimage.frame.size, NO, 0);
    CGContextRef context = UIGraphicsGetCurrentContext();
    [self.BGimage.layer renderInContext:context];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
//    UIGraphicsBeginImageContextWithOptions(self.BGimage.bounds.size, YES, 20);
//    [self.view.layer renderInContext:UIGraphicsGetCurrentContext()];           //renderInContext呈现接受者及其子范围到指定的上下文
//    UIImage *viewImage = UIGraphicsGetImageFromCurrentImageContext();         //返回一个基于当前图形上下文的图片
//    UIGraphicsEndImageContext();                                            //移除栈顶的基于当前位图的图形上下文
    UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil);                //然后将该图片保存到图片
    [NoticeView showMessage:@"保存成功"];
}

-(void)setInfo
{
    NSArray *keys = @[@"user_id"];
    NSArray *values = @[@(CommonConfig.UserInfoCache.userId)];
    [SVProgressHUD showWithStatus:@"正在获取二维码信息"];
    [MySDKHelper postAsyncWithURL:@"/v1/pay_qrcode" withParamBodyKey:keys withParamBodyValue:values needToken:CommonConfig.Token postSucceed:^(NSDictionary *result) {
        [SVProgressHUD dismiss];
        NSDictionary *dicInfo = result[@"content"];
        NSLog(@"%@",dicInfo[@"url"]);
        
        
        CGFloat scale = 0.2;
        
        // 2、将最终合得的图片显示在UIImageView上
        self.userImage.image = [SGQRCodeTool SG_generateWithLogoQRCodeData:dicInfo[@"url"] logoImageName:_img logoScaleToSuperView:scale];
        
    } postCancel:^(NSString *error) {
        [SVProgressHUD dismiss];
        [NoticeView showMessage:error];
        
    }];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self.navigationController setNavigationBarHidden:YES animated:NO];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}
- (IBAction)backClick:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}


@end
