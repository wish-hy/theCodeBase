//
//  QRCodeView.m
//  huabi
//
//  Created by teammac3 on 2017/4/10.
//  Copyright © 2017年 ltl. All rights reserved.
//

#import "QRCodeView.h"
#import "SGQRCode.h"
#import "Newyuanmeng-Swift.h"

@implementation QRCodeView

- (instancetype)initWithFrame:(CGRect)frame withLinkStr:(NSString *)str{
    
    if ([super initWithFrame:frame]) {
        
        self.backgroundColor = [UIColor whiteColor];
        
//        //绘制渐变色(蓝色、绿色、黄色）
//        CAGradientLayer *gradient = [CAGradientLayer layer];
//        gradient.frame = frame;
//        gradient.colors = [NSArray arrayWithObjects:(id)[UIColor colorWithRed:9/255.0 green:154/255.0 blue:238/255.0 alpha:1.0].CGColor,(id)[UIColor colorWithRed:1 green:228/255.0 blue:9/255.0 alpha:1.0].CGColor, nil];
////        gradient.colors = [NSArray arrayWithObjects:(id)[UIColor colorWithHexString:@"#099AEE"].CGColor,(id)[UIColor colorWithHexString:@"#"], nil]
//        //设置颜色范围
////        gradient.locations = @[@0.3,@0.3,@0.2];
//        [self.layer addSublayer:gradient];
        [self setInfo:str];
       
    }
    return self;
}

-(void)setInfo:(NSString *)str
{
    NSArray *keys = @[@"user_id"];
    NSArray *values = @[@(CommonConfig.UserInfoCache.userId)];
    [MySDKHelper postAsyncWithURL:@"/v1/userinfo" withParamBodyKey:keys withParamBodyValue:values needToken:CommonConfig.Token postSucceed:^(NSDictionary *result) {
        self.userInfo = result[@"content"][@"userinfo"];
        //创建二维码
        [self createQRcode:str];
        
    } postCancel:^(NSString *error) {
        NSLog(@"%@",error);
        [NoticeView showMessage:error];
        
    }];
}

#pragma mark - 创建二维码
- (void)createQRcode:(NSString *)str{
    
    NSString *imgStr = [NSString stringWithFormat:@"%@/Documents/%@.jpg",NSHomeDirectory(),@"MyHeader"];
    // 拿到沙盒路径图片
    UIImage *header = [[UIImage alloc] initWithContentsOfFile:imgStr];
    
    UIImageView *image = [[UIImageView alloc] initWithFrame:CGRectMake(20, 20, 40, 40)];
    image.clipsToBounds = YES;
    [image.layer setCornerRadius:8];
    image.image = header;
//    if ([self.userInfo[@"avatar"] rangeOfString:@"http"].location != NSNotFound) {
//        [image sd_setImageWithURL:[NSURL URLWithString:self.userInfo[@"avatar"]] placeholderImage:[UIImage imageNamed:@"wode2"] options:SDWebImageAllowInvalidSSLCertificates];
//
//    }else{
//        [image sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",imgHost,self.userInfo[@"avatar"]]] placeholderImage:[UIImage imageNamed:@"wode2"] options:SDWebImageAllowInvalidSSLCertificates];
//    }
//    image.image = [UIImage imageNamed:@"fahuo"];
    [self addSubview:image];
    
    UILabel *titleL = [[UILabel alloc] initWithFrame:CGRectMake(70, 25, 100, 20)];
    titleL.text = self.userInfo[@"nickname"];
    NSLog(@"昵称     %@",self.userInfo);
//    titleL.text = @"圆梦购销网";
    titleL.textAlignment = NSTextAlignmentLeft;
    titleL.font = [UIFont systemFontOfSize:18];
    titleL.textColor = [UIColor blackColor];
    [self addSubview:titleL];
    
    
    // 1、借助UIImageView显示二维码
    UIImageView *imageView = [[UIImageView alloc] init];
    CGFloat imageViewW = 230;
    CGFloat imageViewH = imageViewW;
    //    CGFloat imageViewX = (150 - imageViewW) / 2;
    //    CGFloat imageViewY = 80;
    imageView.frame =CGRectMake(0, 0, imageViewW, imageViewH);
    imageView.center = CGPointMake(self.width/2, self.height/2);
    [self addSubview:imageView];
    
    // 2、将CIImage转换成UIImage，并放大显示
    //普通二维码
    //    imageView.image = [SGQRCodeTool SG_generateWithDefaultQRCodeData:str imageViewWidth:imageViewW];

//    _img = header;
    
    //带图标二维码
    CGFloat scale = 0.2;
    imageView.image = [SGQRCodeTool SG_generateWithLogoQRCodeData:str logoImageName:header logoScaleToSuperView:scale];
    
    
    UILabel *lab = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 230, 20)];
    lab.center = CGPointMake(self.width/2, self.height/2 +125);
    lab.textAlignment = NSTextAlignmentCenter;
    lab.font = [UIFont systemFontOfSize:12];
    lab.text = @"扫一扫上面的二维码图案，进行绑定";
    [self addSubview:lab];

//
//    UILabel *titleL2 = [[UILabel alloc] initWithFrame:CGRectMake(0, titleL.frame.origin.y+titleL.frame.size.height, self.frame.size.width, 30)];
//    if ([str rangeOfString:@"becomepromoter"].location != NSNotFound) {
//        titleL2.text = @"成为专区推广员，享受专区销售业绩提现\n";
//    }else if ([str rangeOfString:@"apply_for_district"].location != NSNotFound){
//        titleL2.text = @"申请入驻专区，即可获得商城赠送商品，尊享专区销售提成，更可获得专区升值空间";
//    }
//    titleL2.textAlignment = NSTextAlignmentCenter;
//    titleL2.font = [UIFont systemFontOfSize:10];
//    titleL2.numberOfLines = 0;
//    titleL2.textColor = [UIColor whiteColor];
//    [self addSubview:titleL2];
//

//
//    UILabel *titleL3 = [[UILabel alloc] initWithFrame:CGRectMake(0, imageView.frame.origin.y+imageView.frame.size.height, self.frame.size.width, 20)];
//    if ([str rangeOfString:@"becomepromoter"].location != NSNotFound) {
//        titleL3.text = @"扫描二维码，马上成为专区推广者";
//    }else if ([str rangeOfString:@"apply_for_district"].location != NSNotFound){
//        titleL3.text = @"扫描二维码，马上创建专区";
//    }
//    titleL3.textAlignment = NSTextAlignmentCenter;
//    titleL3.font = [UIFont systemFontOfSize:10];
//    titleL3.numberOfLines = 0;
//    titleL3.textColor = [UIColor whiteColor];
//    [self addSubview:titleL3];
    

}

@end
