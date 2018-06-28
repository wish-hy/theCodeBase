//
//  DrawMoneyViewController.m
//  huabi
//
//  Created by teammac3 on 2017/3/28.
//  Copyright © 2017年 ltl. All rights reserved.
//

#import "DrawMoneyViewController.h"
#import "YZPPickView.h"

#import "SaleViewController.h"

@interface DrawMoneyViewController ()<UITableViewDelegate,UITableViewDataSource,YZPPickViewDelegate>

@property(nonatomic,assign)BOOL isFirst;
@property(nonatomic,weak)UITableView *tableV;
@property(nonatomic,weak)UILabel *addressLabel;
@property(nonatomic,weak)UIButton *submitBtn;
@property(nonatomic,weak)UIView *btnView;
@property(nonatomic,strong)NSArray *titleArr;
@property(nonatomic,strong)NSArray *placeholder;

//地址选择
@property(nonatomic,copy)NSString *addressStr;

//参数字典
@property(nonatomic,strong)NSMutableDictionary *valuesDic;

@end

@implementation DrawMoneyViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor colorWithRed:235/255.0 green:235/255.0 blue:235/255.0 alpha:1];
    
    //创建导航栏
    [self createNavigationView];
    
    //创建视图
    _isFirst = YES;
    _addressStr = nil;
    _valuesDic = [NSMutableDictionary dictionary];
    [self createView];
}

#pragma mark - 创建视图
- (void)createView{

    _titleArr = @[@"姓名",@"卡号",@"银行",@"开户所在地"];
    _placeholder = @[@"收款人姓名",@"收款人储蓄卡号",@"请填写申请提现的银行"];
    
    UITableView *tableV = [[UITableView alloc] initWithFrame:CGRectMake(0, 74, ScreenWidth, 80) style:UITableViewStyleGrouped];
    tableV.delegate = self;
    tableV.dataSource = self;
    tableV.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    tableV.rowHeight = 40;
    [self.view addSubview:tableV];
    self.tableV = tableV;
    
    //确认
    UIButton *nextStepButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth-20, 50)];
    nextStepButton.center = CGPointMake(ScreenWidth/2,tableV.frame.origin.y+tableV.frame.size.height+50);
//    nextStepButton.backgroundColor = [UIColor colorWithRed:118/255.0 green:202/255.0 blue:39/255.0 alpha:1];
    nextStepButton.backgroundColor = [UIColor lightGrayColor];
    [nextStepButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [nextStepButton setTitle:@"提现到可用余额" forState:UIControlStateNormal];
    nextStepButton.layer.cornerRadius = 8;
    nextStepButton.userInteractionEnabled = NO;
    [nextStepButton addTarget:self action:@selector(nextStepButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:nextStepButton];
    self.submitBtn = nextStepButton;

}

#pragma mark - UITableViewDelegate方法
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    if (!self.isFirst) {
        return 2;
    }
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (!self.isFirst) {
        if (section == 0) {
            return 2;
        }else{
            return 4;
        }
    }
    return 2;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cellID"];
    cell = nil;
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"cellID"];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        //第一组
        if (indexPath.section == 0) {
            if (indexPath.row == 0) {
                cell.textLabel.text = @"提款至";
                if (_isFirst) {
                    cell.detailTextLabel.text = @"余额";
                    [_valuesDic setValue:@"0" forKey:@"type"];
                    
                }else{
                    cell.detailTextLabel.text = @"银行卡";
                    [_valuesDic setValue:@"2" forKey:@"type"];
                }
                cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            }else if(indexPath.row == 1){
                cell.textLabel.text = @"提现金额";
                UITextField *inputF = [[UITextField alloc] initWithFrame:CGRectMake(100, 0, ScreenWidth-100, 40)];
                inputF.placeholder = @"请输入提现金额";
                inputF.keyboardType = UIKeyboardTypeNumberPad;
                [inputF addTarget:self action:@selector(amountInputAction:) forControlEvents:UIControlEventEditingChanged];
                [cell.contentView addSubview:inputF];
            }
        }else if(indexPath.section == 1){//第二组
            
            cell.textLabel.text = self.titleArr[indexPath.row];
            if (indexPath.row < self.placeholder.count) {
                UITextField *inputF = [[UITextField alloc] initWithFrame:CGRectMake(100, 0, ScreenWidth-100, 40)];
                inputF.placeholder = self.placeholder[indexPath.row];
                inputF.tag = 1000 + indexPath.row;
                [inputF addTarget:self action:@selector(bankCarAction:) forControlEvents:UIControlEventEditingChanged];
                if (indexPath.row == 1) {
                    inputF.keyboardType = UIKeyboardTypeNumberPad;
                }else{
                    inputF.keyboardType = UIKeyboardTypeDefault;
                }
                [cell.contentView addSubview:inputF];
            }
            if (indexPath.row == 3) {
                UILabel *addressLabel = [[UILabel alloc] initWithFrame:CGRectMake(120, 0, ScreenWidth-120, 40)];
                [cell.contentView addSubview:addressLabel];
                if (_addressStr == nil) {
                    addressLabel.text = @"";
                }else{
                    addressLabel.text = _addressStr;
                }
                self.addressLabel = addressLabel;
            }
            
        }

    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.section == 0 && indexPath.row == 0) {
        if (self.btnView == nil) {
//            [self createButtonView];
        }else{
            [self.btnView removeFromSuperview];
        }
    }else if(indexPath.row == 3){
        
        [[[UIApplication sharedApplication] keyWindow] endEditing:YES];
        //创建地址选择视图
//        [self createAddressView];
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    if (section == 1) {
        UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 30)];
        headerView.backgroundColor = [UIColor colorWithRed:235/255.0 green:235/255.0 blue:235/255.0 alpha:1];
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(20, 0, 100, 30)];
        label.text = @"银行卡信息";
        label.font = [UIFont systemFontOfSize:14];
        [headerView addSubview:label];
        return headerView;
    }
    return nil;
}

//组间距
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section == 0) {
        return 0.1;
    }else{
        return 30;
    }
    return 0.1;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.1;
}

#pragma mark - 监听输入
- (void)amountInputAction:(UITextField *)textF{
    
    if ([textF.text integerValue] > [_money integerValue]) {
        
        //提示
        NSString *str = [NSString stringWithFormat:@"输入金额大于可提取金额：%@,请重新输入",_money];
        UIAlertController *alertC = [UIAlertController alertControllerWithTitle:@"提示" message:str preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *ok = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:nil];
        [alertC addAction:ok];
        [self presentViewController:alertC animated:YES completion:nil];
        
    }else {
            [_valuesDic setValue:textF.text forKey:@"amount"];
    }
    if (_isFirst) {
        if (_valuesDic.count >= 2) {
            self.submitBtn.userInteractionEnabled = YES;
            self.submitBtn.backgroundColor = [UIColor colorWithRed:118/255.0 green:202/255.0 blue:39/255.0 alpha:1];
        }
    }else{
        if (_valuesDic.count == 7) {
            self.submitBtn.userInteractionEnabled = YES;
            self.submitBtn.backgroundColor = [UIColor colorWithRed:118/255.0 green:202/255.0 blue:39/255.0 alpha:1];
        }

    }
    
}

- (void)bankCarAction:(UITextField *)textF{
    
    if (textF.tag-1000 == 0) {
        [_valuesDic setValue:textF.text forKey:@"bank_account_name"];
    }else if (textF.tag-1000 == 1){
        if ([self isPureInt:textF.text]&&[textF.text length] == 16) {
            [_valuesDic setValue:textF.text forKey:@"card_number"];
        }else{
            [_valuesDic setValue:@" " forKey:@"card_number"];
        }
        
    }else{
        [_valuesDic setValue:textF.text forKey:@"bank_name"];
    }

    if (_valuesDic.count == 7&&![_valuesDic[@"card_number"] isEqualToString:@" "]) {
        self.submitBtn.userInteractionEnabled = YES;
        self.submitBtn.backgroundColor = [UIColor colorWithRed:118/255.0 green:202/255.0 blue:39/255.0 alpha:1];
    }

}

//判断输入的字符串是否都是数字
- (BOOL)isPureInt:(NSString *)string{
    NSScanner* scan = [NSScanner scannerWithString:string];
    int val;
    return [scan scanInt:&val] && [scan isAtEnd];
}

#pragma mark - 弹出视图
//- (void)createButtonView{
//
//    UIView *btnView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 150, 80)];
//    btnView.center = CGPointMake(ScreenWidth/2, ScreenHeight/2-50);
//    [self.view addSubview:btnView];
//    self.btnView = btnView;
//
//    NSArray *titleArr = @[@"余额",@"银行卡"];
//    for (int i = 0; i < titleArr.count; i++) {
//
//        UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(0, i*40, btnView.frame.size.width, 40)];
//        btn.layer.borderWidth = 1;
//        btn.layer.borderColor = [UIColor blackColor].CGColor;
//        [btn setTitle:titleArr[i] forState:UIControlStateNormal];
//        [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
//        [btn setBackgroundColor:[UIColor whiteColor]];
//        btn.tag = 1000 + i;
//        [btn addTarget:self action:@selector(selectBtnAction:) forControlEvents:UIControlEventTouchUpInside];
//        [btnView addSubview:btn];
//    }
//
//
//}

//#pragma mark - 创建地址选择视图
//- (void)createAddressView{
//
//    [MySDKHelper getCityName:^(NSString *city) {
//
//        //分割字符串
//        NSArray *arr = [city componentsSeparatedByString:@"+"];
//        self.addressLabel.text = arr[0];
//        _addressStr = arr[0];
//        NSArray *arr2 = [_addressStr componentsSeparatedByString:@" "];
//        [_valuesDic setValue:arr2[0] forKey:@"province"];
//        [_valuesDic setValue:arr2[1] forKey:@"city"];
//    }];
//
//
//}

#pragma mark - 导航栏
- (void)createNavigationView{
    
    UIView *navView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 64)];
    navView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:navView];
    
    //返回按钮
    UIButton *backBtn = [[UIButton alloc] initWithFrame:CGRectMake(5, 30, 25, 25)];
    //    [backBtn setImage:[UIImage iconWithInfo:TBCityIconInfoMake(@"\U0000e61e", 50, [UIColor redColor])] forState:UIControlStateNormal];
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
    title.text = @"提现申请";
    [navView addSubview:title];
    
}

#pragma mark - 按钮事件
//导航栏按钮事件
- (void)backBtnAction:(UIButton *)btn{
    
    [self.navigationController popViewControllerAnimated:YES];
}

//提交申请
- (void)nextStepButtonAction:(UIButton *)btn{
    
    NSArray *keys = [[NSArray alloc]init];
    NSArray *values = [[NSArray alloc]init];
    //判断是推广者提现还是专区提现
    if ([_district_id isEqualToString:@"1"]) {
        if (_isFirst) {
            keys = @[@"user_id",@"token",@"amount",@"type"];
            values = @[@(_user_id),_token,_valuesDic[@"amount"],_valuesDic[@"type"]];
        }else{
//            keys = @[@"user_id",@"token",@"district_id",@"type",@"amount",@"bank_name",@"bank_account_name",@"card_number",@"province",@"city"];
//            values = @[@(_user_id),_token,_district_id,_valuesDic[@"type"],_valuesDic[@"amount"],_valuesDic[@"bank_name"],_valuesDic[@"bank_account_name"],_valuesDic[@"card_number"],_valuesDic[@"province"],_valuesDic[@"city"]];
        }
        [MySDKHelper postAsyncWithURL:@"/v1/apply_do_settle" withParamBodyKey:keys withParamBodyValue:values needToken:_token postSucceed:^(NSDictionary *result) {
            //                NSLog(@"我是数据%@",result);
            [self.navigationController popViewControllerAnimated:YES];
        } postCancel:^(NSString *error) {
//            [NSLog(@"我是错误%@",error);
             [NoticeView showMessage:error];
        }];
    }else{
        if (_isFirst) {
            keys = @[@"user_id",@"token",@"type",@"amount"];
            values = @[@(_user_id),_token,_valuesDic[@"type"],_valuesDic[@"amount"]];
        }else{
//            keys = @[@"user_id",@"token",@"type",@"amount",@"bank_name",@"bank_account_name",@"card_number",@"province",@"city"];
//            values = @[@(_user_id),_token,_valuesDic[@"type"],_valuesDic[@"amount"],_valuesDic[@"bank_name"],_valuesDic[@"bank_account_name"],_valuesDic[@"card_number"],_valuesDic[@"province"],_valuesDic[@"city"]];
        }
        [MySDKHelper postAsyncWithURL:@"/v1/promoter_do_settle" withParamBodyKey:keys withParamBodyValue:values needToken:_token postSucceed:^(NSDictionary *result) {
            //                NSLog(@"我是数据%@",result);
            
        } postCancel:^(NSString *error) {
//            NSLog(@"我是错误%@",error);
            [NoticeView showMessage:error];
        }];

    }
    
}

////选择余额/银行卡
//- (void)selectBtnAction:(UIButton *)btn{
//
//    if (btn.tag-1000) {
//         _isFirst = NO;
//    }else{
//        _isFirst = YES;
//    }
//    self.submitBtn.userInteractionEnabled = NO;
//    self.submitBtn.backgroundColor = [UIColor lightGrayColor];
//    CGRect frame1 = CGRectMake(0, 74, ScreenWidth, 80);
//    CGRect frame2 = CGRectMake(0, 74, ScreenWidth, 80+self.titleArr.count*40+30);
//    self.tableV.frame = _isFirst?frame1:frame2;
//    self.submitBtn.center = CGPointMake(ScreenWidth/2,_tableV.frame.origin.y+_tableV.frame.size.height+50);
//    [self.tableV reloadData];
//    [self.btnView removeFromSuperview];
//
//}

//收起键盘
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    
    [[[UIApplication sharedApplication] keyWindow] endEditing:YES];
    [self.btnView removeFromSuperview];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
