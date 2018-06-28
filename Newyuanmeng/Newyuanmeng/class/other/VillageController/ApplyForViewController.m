//
//  ApplyForViewController.m
//  huabi
//
//  Created by teammac3 on 2017/3/27.
//  Copyright © 2017年 ltl. All rights reserved.
//

#import "ApplyForViewController.h"
//#import "ApplyPayViewController.h"
#import "VillageIcon.h"

@interface ApplyForViewController ()<UITableViewDelegate,UITableViewDataSource>

//标题
@property(nonatomic,strong)NSArray *titleArr;
@property(nonatomic,strong)NSArray *placeholderArr;

@property(nonatomic,strong)NSMutableDictionary *inputDic;
@property(nonatomic,weak)UIButton *submitButton;

@end

@implementation ApplyForViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    
    //创建导航栏
    [self createNavigationView];
    
    //创建列表
    _titleArr = @[@"专区名称",@"具体位置",@"联系人",@"联系电话"];
    _placeholderArr = @[@"请输入专区名称",@"请输入具体的位置信息",@"请输入联系人",@"请输入联系电话"];
    _inputDic = [NSMutableDictionary dictionary];
    [self createListView];
    
    
}

#pragma mark - 创建列表
- (void)createListView{
    
    UITableView *tableV = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, ScreenWidth, self.titleArr.count*45) style:UITableViewStylePlain];
    tableV.delegate = self;
    tableV.dataSource = self;
    tableV.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    tableV.rowHeight = 45;
    tableV.scrollEnabled = NO;
    [self.view addSubview:tableV];
    
//    //checkbox
//    UIButton *checkBox = [[UIButton alloc] initWithFrame:CGRectMake(20, tableV.frame.origin.y+tableV.frame.size.height+20, 20, 20)];
//    [checkBox setBackgroundImage:[UIImage iconWithInfo:TBCityIconInfoMake(icon_village_square, 20, [UIColor blackColor])] forState:UIControlStateNormal];
//    [checkBox setBackgroundImage:[UIImage iconWithInfo:TBCityIconInfoMake(icon_village_tick, 20, [UIColor greenColor])] forState:UIControlStateSelected];
//    checkBox.selected = YES;
//    [checkBox addTarget:self action:@selector(checkBoxAction:) forControlEvents:UIControlEventTouchUpInside];
//    [self.view addSubview:checkBox];
    
//    //label
//    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(checkBox.frame.origin.x+checkBox.frame.size.width, checkBox.frame.origin.y-5,70, 35)];
//    label.font = [UIFont systemFontOfSize:14];
//    label.text = @"阅读并同意";
//    [self.view addSubview:label];
//    
//    //服务条款
//    UIButton *userDe = [[UIButton alloc] initWithFrame:CGRectMake(label.frame.origin.x+label.frame.size.width, label.frame.origin.y, 85, 35)];
//    [userDe setTitle:@"《服务条款》" forState:UIControlStateNormal];
//    userDe.titleLabel.font = [UIFont systemFontOfSize:14];
//    [userDe setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
//    [self.view addSubview:userDe];
    
    //确认
    UIButton *confirmButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth-20, 50)];
    confirmButton.center = CGPointMake(ScreenWidth/2,tableV.frame.origin.y+self.titleArr.count*45+50);
    confirmButton.backgroundColor = [UIColor lightGrayColor];
    [confirmButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [confirmButton setTitle:@"确定" forState:UIControlStateNormal];
    confirmButton.layer.cornerRadius = 8;
    [confirmButton addTarget:self action:@selector(confirmButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:confirmButton];
    self.submitButton = confirmButton;
    
    if (_inputDic.count == 4) {
        
        confirmButton.userInteractionEnabled = YES;
    }else{
        confirmButton.userInteractionEnabled = NO;
    }
    
}

#pragma mark - UITableVIewDelegate方法
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.titleArr.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cellID"];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cellID"];
        cell.textLabel.text = self.titleArr[indexPath.row];
        //输入
        UITextField *inputF = [[UITextField alloc] initWithFrame:CGRectMake(100, 0, ScreenHeight-100, 45)];
        inputF.placeholder = self.placeholderArr[indexPath.row];
        inputF.tag = 1000 + indexPath.row;
        inputF.keyboardType = UIKeyboardTypeDefault;
        [inputF addTarget:self action:@selector(textFieldChange:) forControlEvents:UIControlEventEditingChanged];
        if (indexPath.row == self.titleArr.count-1) {
            inputF.keyboardType = UIKeyboardTypeNumberPad;
        }
        [cell.contentView addSubview:inputF];
    }
    return cell;
}

#pragma mark - 导航栏
- (void)createNavigationView{
    
    UIView *navView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 64)];
    //    navView.backgroundColor = [UIColor greenColor];
    [self.view addSubview:navView];
    
    //返回按钮
    UIButton *backBtn = [[UIButton alloc] initWithFrame:CGRectMake(5, 30, 25, 25)];
    UIFont *iconfont = [UIFont fontWithName:@"iconfont" size:30];
    backBtn.titleLabel.font = iconfont;
    [backBtn setTitle:@"\U0000e61e" forState:UIControlStateNormal];
    [backBtn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    [backBtn addTarget:self action:@selector(backBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    [navView addSubview:backBtn];
    
    //标题
    UILabel *title = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 100, 40)];
    title.center = CGPointMake(ScreenWidth/2, 40);
    title.textAlignment = NSTextAlignmentCenter;
    title.text = @"申请入驻";
    [navView addSubview:title];
    
    
}

//导航栏按钮事件
- (void)backBtnAction:(UIButton *)btn{
    
    if (_isFromHomePage) {
        [self.navigationController popToRootViewControllerAnimated:YES];
    }else{
        
        [self.navigationController popViewControllerAnimated:YES];
    }
    
}

//#pragma mark - chexBox按钮处理
//- (void)checkBoxAction:(UIButton *)btn{
//    
//    btn.selected = !btn.selected;
//}
//确定
- (void)confirmButtonAction:(UIButton *)btn{
    
    [[[UIApplication sharedApplication] keyWindow] endEditing:YES];
    //提交数据
    [self postData];
//    ApplyPayViewController *applyPVC = [[ApplyPayViewController alloc] init];
//    self.hidesBottomBarWhenPushed = YES;
//    applyPVC.name = _inputDic[@"name"];
//    [self.navigationController pushViewController:applyPVC animated:YES];
}

- (void)postData{
    
    NSArray *keys = [[NSArray alloc]init];
    NSArray *values = [[NSArray alloc]init];
    keys = @[@"user_id",@"token",@"name",@"location",@"linkman",@"linkmobile"];
//    NSLog(@"信息——————%@,%@,%@",@(_user_id),_token,_inputDic);
    values = @[@(_user_id),_token,_inputDic[@"name"],_inputDic[@"location"],_inputDic[@"linkman"],_inputDic[@"linkmobile"]];
    __weak typeof (self)weakSelf = self;
    [MySDKHelper postAsyncWithURL:@"/v1/apply_for_district" withParamBodyKey:keys withParamBodyValue:values needToken:_token postSucceed:^(NSDictionary *result) {
//        NSLog(@"%@",result);
        //线下交易
        UIAlertController *alertC = [UIAlertController alertControllerWithTitle:@"提示" message:@"申请成功，请与客服联系！" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *ok = [UIAlertAction actionWithTitle:@"确定" style:(UIAlertActionStyleDefault) handler:^(UIAlertAction * _Nonnull action) {
            
            [weakSelf.navigationController popViewControllerAnimated:NO];
        }];
        [alertC addAction:ok];
        [weakSelf presentViewController:alertC animated:YES completion:nil];
    } postCancel:^(NSString *error) {
//        NSLog(@"我是错误%@",error);
        UIAlertController *alertC = [UIAlertController alertControllerWithTitle:@"提示" message:error preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *ok = [UIAlertAction actionWithTitle:@"确定" style:(UIAlertActionStyleDefault) handler:^(UIAlertAction * _Nonnull action) {
            
        }];
        [alertC addAction:ok];
//        [weakSelf presentViewController:alertC animated:YES completion:nil];
    }];
}

//监听输入
- (void)textFieldChange:(UITextField *)textF{
    
    if (textF.tag-1000 == 0) {
        [_inputDic setValue:textF.text forKey:@"name"];
//        NSLog(@"%@",textF.text);
    }else if (textF.tag-1000 == 1){
        [_inputDic setValue:textF.text forKey:@"location"];
//        NSLog(@"%@",textF.text);
    }else if (textF.tag-1000 == 2){
        [_inputDic setValue:textF.text forKey:@"linkman"];
//        NSLog(@"%@",textF.text);
    }else{
        [_inputDic setValue:textF.text forKey:@"linkmobile"];
//        NSLog(@"%@",textF.text);
    }
    
    if (_inputDic.count == 4) {
        
        self.submitButton.userInteractionEnabled = YES;
        self.submitButton.backgroundColor = [UIColor colorWithRed:238/255.0 green:105/255.0 blue:47/255.0 alpha:1];
    }else{
        self.submitButton.userInteractionEnabled = NO;
        self.submitButton.backgroundColor = [UIColor lightGrayColor];
    }
}

//收起键盘
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    
    [[[UIApplication sharedApplication] keyWindow] endEditing:YES];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self.navigationController setNavigationBarHidden:YES animated:NO];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}

@end
