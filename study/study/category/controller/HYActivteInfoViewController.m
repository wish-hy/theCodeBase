//
//  HYActivteInfoViewController.m
//  study
//
//  Created by hy on 2018/5/23.
//  Copyright © 2018年 hy. All rights reserved.
//

#import "HYActivteInfoViewController.h"

@interface HYActivteInfoViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *activteImg;
@property (weak, nonatomic) IBOutlet UILabel *activteName;
@property (weak, nonatomic) IBOutlet UILabel *activteInfo;

@end

@implementation HYActivteInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [_activteImg sd_setImageWithURL:[NSURL URLWithString:_urlStr] placeholderImage:[HYToolsKit createImageWithColor:RandomColor]];
    _activteName.text = _model.activityName;
    _activteInfo.text = _model.activityInfo;
}


- (IBAction)addActivte:(id)sender {
    [ToastManage showCenterToastWith:@"参加活动" starY:500];
}
- (IBAction)back:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}


-(void)viewWillAppear:(BOOL)animated
{
       self.navigationController.navigationBar.alpha = 0;
//    [self.navigationController setNavigationBarHidden:YES];
//    UIImage *imgs = [HYToolsKit createImageWithColor:[UIColor colorWithWhite:1 alpha:0]];
//    [self.navigationController.navigationBar setBackgroundImage:imgs forBarMetrics:UIBarMetricsDefault];
}

-(void)viewWillDisappear:(BOOL)animated
{
    self.navigationController.navigationBar.alpha = 1;
}

@end
