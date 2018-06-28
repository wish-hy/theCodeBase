//
//  PaySuccessViewController.m
//  huabi
//
//  Created by hy on 2018/1/3.
//  Copyright © 2018年 ltl. All rights reserved.
//

#import "PaySuccessViewController.h"
#import "Newyuanmeng-Swift.h"

@interface PaySuccessViewController ()
@property (weak, nonatomic) IBOutlet UILabel *priceText;
@property (weak, nonatomic) IBOutlet UILabel *name;
@property (weak, nonatomic) IBOutlet UILabel *time;
@property (weak, nonatomic) IBOutlet UILabel *order_no;

@end

@implementation PaySuccessViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setInfo];
}

-(void)setInfo
{
    
    NSArray *keys = @[@"user_id",@"order_id"];
    NSMutableArray *values = [NSMutableArray array];
    [values addObject:@(CommonConfig.UserInfoCache.userId)];
    [values addObject:_order_id];
//    NSArray *values = @[@(CommonConfig.UserInfoCache.userId),_order_id];
    [MySDKHelper postAsyncWithURL:@"/v1/pay_success" withParamBodyKey:keys withParamBodyValue:values needToken:CommonConfig.Token postSucceed:^(NSDictionary *result) {
        NSDictionary *info = result[@"content"];
        NSString *order_no = info[@"order_no"];
        NSString *shop_name = info[@"shop_name"];
        NSString *date = info[@"date"];
        
        self.priceText.text = [NSString stringWithFormat:@"￥%@",_price];
        self.name.text = shop_name;
        self.time.text = date;
        self.order_no.text = order_no;
      
    } postCancel:^(NSString *error) {
        NSLog(@"%@",error);
        [NoticeView showMessage:error];
    }];
}
- (IBAction)backClick:(id)sender {
    [(AppDelegate *)[[UIApplication sharedApplication] delegate] showMainPage];
}

@end
