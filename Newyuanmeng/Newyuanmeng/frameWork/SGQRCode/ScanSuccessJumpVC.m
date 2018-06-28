//
//  ScanSuccessJumpVC.m
//  SGQRCodeExample
//
//  Created by Sorgle on 16/8/29.
//  Copyright © 2016年 Sorgle. All rights reserved.
//

#import "ScanSuccessJumpVC.h"
#import "SGWebView.h"
#import "SGQRCodeConst.h"
#import "ErrorPageController.h"
#import "Newyuanmeng-Swift.h"
//跳转页面
#import "ApplyForSpreaderController.h"
#import "ApplyForViewController.h"
#import "OffLinPayMentViewController.h"

@interface ScanSuccessJumpVC () <SGWebViewDelegate>
@property (nonatomic , strong) SGWebView *webView;
@end

@implementation ScanSuccessJumpVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self setupNavigationItem];
   
    if (self.jump_bar_code) {
        [self setupLabel];
    } else {
        [self setupWebView];
    }
}

- (void)setupNavigationItem {
    UIButton *left_Button = [[UIButton alloc] init];
    [left_Button setTitle:@"back" forState:UIControlStateNormal];
    [left_Button setTitleColor:[UIColor colorWithRed: 21/ 255.0f green: 126/ 255.0f blue: 251/ 255.0f alpha:1.0] forState:(UIControlStateNormal)];
    [left_Button sizeToFit];
    [left_Button addTarget:self action:@selector(left_BarButtonItemAction) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *left_BarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:left_Button];
    self.navigationItem.leftBarButtonItem = left_BarButtonItem;
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:(UIBarButtonSystemItemRefresh) target:self action:@selector(right_BarButtonItemAction)];
}
- (void)left_BarButtonItemAction {
    [self.navigationController popToRootViewControllerAnimated:YES];
}
- (void)right_BarButtonItemAction {
    [self.webView reloadData];
}

// 添加Label，加载扫描过来的内容
- (void)setupLabel {
    // 提示文字
    UILabel *prompt_message = [[UILabel alloc] init];
    prompt_message.frame = CGRectMake(0, 200, self.view.frame.size.width, 30);
    prompt_message.text = @"您扫描的条形码结果如下： ";
    prompt_message.textColor = [UIColor redColor];
    prompt_message.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:prompt_message];
    
    // 扫描结果
    CGFloat label_Y = CGRectGetMaxY(prompt_message.frame);
    UILabel *label = [[UILabel alloc] init];
    label.frame = CGRectMake(0, label_Y, self.view.frame.size.width, 30);
    label.text = self.jump_bar_code;
    label.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:label];
}

// 添加webView，加载扫描过来的内容
- (void)setupWebView {
    
    //邀请推广员
    if ([_jump_URL rangeOfString:@"invitor_role"].location != NSNotFound) {
        
        //截取推广者id
        NSArray *arr = [_jump_URL componentsSeparatedByString:@"/invitor_role"];
        NSString *str = arr[0];
        ApplyForSpreaderController *applyForSVC = [[ApplyForSpreaderController alloc] init];
        applyForSVC.token = _token;
        applyForSVC.user_id = _user_id;
        applyForSVC.reference_id = [str substringFromIndex:str.length-1];
        applyForSVC.invitor_role = @"promoter";
        self.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:applyForSVC animated:YES];
        
    }else if ([_jump_URL rangeOfString:@"apply_for_district"].location != NSNotFound){//邀请专区
        
        ApplyForViewController *applyForVC = [[ApplyForViewController alloc] init];
        applyForVC.isFromHomePage = YES;
        applyForVC.token = _token;
        applyForVC.user_id = _user_id;
        self.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:applyForVC animated:YES];
    }else if ([_jump_URL rangeOfString:@"flag"].location != NSNotFound){//邀请专区
        
        //解析
        NSArray *arr = [_jump_URL componentsSeparatedByString:@"id/"];
        NSArray *arr2 = [arr[1] componentsSeparatedByString:@"/"];
        NSDictionary *dic = @{@"goods_id":arr2[0]};
        [[NSNotificationCenter defaultCenter] postNotificationName:@"getGoodsID" object:nil userInfo:dic];
        [self.navigationController popToRootViewControllerAnimated:NO];
        
    }else if([_jump_URL rangeOfString:@"becomepromoter"].location != NSNotFound){
        //截取专区id
        NSString *destrict_id = [_jump_URL substringFromIndex:_jump_URL.length-1];
//        NSLog(@"destrict_id = %@",destrict_id);
        ApplyForSpreaderController *applyForSVC = [[ApplyForSpreaderController alloc] init];
        applyForSVC.token = _token;
        applyForSVC.user_id = _user_id;
        applyForSVC.reference_id = destrict_id;
        applyForSVC.invitor_role = @"shop";
        self.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:applyForSVC animated:YES];

    }
    else if ([_jump_URL rangeOfString:@"/index/invite"].location != NSNotFound)
    {
        NSLog(@"邀请成为推广者");
        NSInteger i =  mainUrl.length + 25;
        NSLog(@"%ld",(long)i);
        NSString *reference = [_jump_URL substringFromIndex:i];
        NSArray *keys = @[@"user_id",@"reference",@"invitor_role"];
        NSArray *values = @[@(CommonConfig.UserInfoCache.userId),reference,@"shop/promoter"];
        [MySDKHelper postAsyncWithURL:@"/v1/become_promoter" withParamBodyKey:keys withParamBodyValue:values needToken:CommonConfig.Token postSucceed:^(NSDictionary *result) {


        } postCancel:^(NSString *error) {
            NSLog(@"%@",error);
            [NoticeView showMessage:error];

        }];
        [self.navigationController popToRootViewControllerAnimated:YES];
    }
    else if ([_jump_URL rangeOfString:@"/demo/inviter_id"].location != NSNotFound)
    {
        NSLog(@"支付二维码");
        NSRange range = [_jump_URL rangeOfString:@"inviter_id"];
        NSString *string = [_jump_URL substringFromIndex:range.location + 11];

        OffLinPayMentViewController *offLine = [[UIStoryboard storyboardWithName:@"Me" bundle:nil] instantiateViewControllerWithIdentifier:@"OffLinPayMentViewController"];
        offLine.seller_id = string;
        [self.navigationController pushViewController:offLine animated:YES];

    }
    else
    {
        UIAlertController *alertC = [UIAlertController alertControllerWithTitle:@"提示" message:@"请扫描本商城二维码" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *ok = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {

            [self.navigationController popToRootViewControllerAnimated:NO];
        }];
        [alertC addAction:ok];
        [self presentViewController:alertC animated:YES completion:nil];
    
    }
}

//- (void)webView:(SGWebView *)webView didFinishLoadWithURL:(NSURL *)url {
//    SGQRCodeLog(@"didFinishLoad");
//    self.title = webView.navigationItemTitle;
//}

@end


