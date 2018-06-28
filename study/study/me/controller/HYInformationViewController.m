//
//  HYInformationViewController.m
//  study
//
//  Created by hy on 2018/5/11.
//  Copyright © 2018年 hy. All rights reserved.
//

#import "HYInformationViewController.h"

@interface HYInformationViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic ,strong)UITableView *tableView;

@end

@implementation HYInformationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"个人设置";
    self.view.backgroundColor = [UIColor whiteColor];
    UIImage *imgs = [HYToolsKit createImageWithColor:[UIColor colorWithWhite:1 alpha:0]];
    [self.navigationController.navigationBar setBackgroundImage:imgs forBarMetrics:UIBarMetricsDefault];
    
    
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight) style:UITableViewStyleGrouped];
    
    _tableView.sectionHeaderHeight = 5;
    _tableView.sectionFooterHeight = 0;
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.contentInset = UIEdgeInsetsMake(-25, 0, 0, 0);
    [self.view addSubview:_tableView];
    
    UIView *nav = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, NAV_SaferHeight)];
    nav.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:nav];
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 5;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0) {
        return 3;
    }else if (section == 1){
        return 2;
    }else if (section == 2){
        return 2;
    }else{
        return 1;
    }
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *identify = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identify];
    cell.selectionStyle = UITableViewRowActionStyleNormal;
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identify];
    }
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            cell.textLabel.text = @"个人设置";
        }else if (indexPath.row == 1){
            cell.textLabel.text = @"隐私设置";
        }else if (indexPath.row == 2){
            cell.textLabel.text = @"屏蔽设置";
        }
    }else if (indexPath.section == 1) {
        if (indexPath.row == 0) {
            cell.textLabel.text = @"偏好设置";
        }else if (indexPath.row == 1){
            cell.textLabel.text = @"夜间模式";
        }
    }else if (indexPath.section == 2) {
        if (indexPath.row == 0) {
            cell.textLabel.text = @"关于";
        }else if (indexPath.row == 1){
            cell.textLabel.text = @"意见反馈";
        }
    }else if (indexPath.section == 3) {
        if (indexPath.row == 0) {
            cell.textLabel.text = @"清除缓存";
        }
    }else{
        if (indexPath.row == 0) {
            cell.textLabel.text = @"退出登录";
        }
    }
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            
        }else if (indexPath.row == 1){
            
        }else if (indexPath.row == 2){
            
        }
    }else if (indexPath.section == 1) {
        if (indexPath.row == 0) {
            
        }else if (indexPath.row == 1){
            
        }
    }else if (indexPath.section == 2) {
        if (indexPath.row == 0) {
            
        }else if (indexPath.row == 1){
            
        }
    }else if (indexPath.section == 3) {
        if (indexPath.row == 0) {
            
        }
    }else{
        if (indexPath.row == 0) {
            [self loginOut];
            [self.navigationController popViewControllerAnimated:YES];
        }
    }
}

// 退出登录
-(void)loginOut
{
    [UserDefaults setObject:@"NO" forKey:isLogin];
    [UserDefaults setObject:@"" forKey:userAge];
    [UserDefaults setObject:@"" forKey:userAttention];
    [UserDefaults setObject:@"" forKey:userAuthentication];
    [UserDefaults setObject:@"" forKey:userBirthday];
    [UserDefaults setObject:@"" forKey:userCollect];
    [UserDefaults setObject:@"" forKey:userCreateDate];
    [UserDefaults setObject:@"" forKey:userEmail];
    [UserDefaults setObject:@"" forKey:userFans];
    [UserDefaults setObject:@"" forKey:userHeadimg];
    [UserDefaults setObject:@"" forKey:userId];
    [UserDefaults setObject:@"" forKey:userIntegral];
    [UserDefaults setObject:@"" forKey:userInfo];
    [UserDefaults setObject:@"" forKey:userLocation];
    [UserDefaults setObject:@"" forKey:userName];
    [UserDefaults setObject:@"" forKey:userNikename];
    [UserDefaults setObject:@"" forKey:userPassword];
    [UserDefaults setObject:@"" forKey:userPhone];
    [UserDefaults setObject:@"" forKey:userQq];
    [UserDefaults setObject:@"" forKey:userSex];
    [UserDefaults setObject:@"" forKey:userWeixin];
}

@end
