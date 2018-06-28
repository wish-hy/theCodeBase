//
//  ApplyForSpreaderController.m
//  huabi
//
//  Created by teammac3 on 2017/4/10.
//  Copyright © 2017年 ltl. All rights reserved.
//

#import "ApplyForSpreaderController.h"
#import "VillageIcon.h"
#import "VillageInfoModel.h"
#import "Newyuanmeng-Swift.h"
//子视图
#import "GiftViews.h"

@interface ApplyForSpreaderController ()<UITableViewDelegate,UITableViewDataSource>

@property(nonatomic,strong)NSArray *titleArr;
@property(nonatomic,strong)VillageInfoModel *model;

//地址视图
@property(nonatomic,weak)UILabel *nameL;
@property(nonatomic,weak)UILabel *iphoneL;
@property(nonatomic,weak)UILabel *addressL;

@property(nonatomic,copy)NSString *addrID;
@property(nonatomic,copy)NSString *giftID;

@end

@implementation ApplyForSpreaderController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor colorWithRed:235/255.0 green:235/255.0 blue:235/255.0 alpha:1];
    
    //创建导航栏
    [self createNavigationView];
    _addrID = @"";
    _giftID = @"";
    //地址
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(orderAddress:) name:@"getAddress" object:nil];
    //创建视图
//    [self createView];
    //加载数据
//    [self loadInfo];
}

#pragma mark - 加载数据
- (void)setInvitor_role:(NSString *)invitor_role{
    _invitor_role = invitor_role;
    [self loadInfo];
}
- (void) loadInfo {
    
//    NSLog(@"user_id=%ld,token=%@,destrict_id=%@",_user_id,_token,_destrict_id);
    NSArray *keys = [[NSArray alloc]init];
    NSArray *values = [[NSArray alloc]init];
    keys = @[@"user_id",@"token",@"reference",@"invitor_role"];
    values = @[@(_user_id),_token,_reference_id,_invitor_role];
//    NSLog(@"**************2");
    [MySDKHelper postAsyncWithURL:@"/v1/become_promoter" withParamBodyKey:keys withParamBodyValue:values needToken:_token postSucceed:^(NSDictionary *result) {
        //        NSLog(@"我是数据%@",result);
        VillageInfoModel *model = [[VillageInfoModel alloc] initWithDictionary:result[@"content"] error:nil];
        _model = model;
//        NSLog(@"**************3");
        //创建视图
        [self createView];
    } postCancel:^(NSString *error) {
        NSLog(@"我是错误%@",error);
        
    }];
}

#pragma mark -  创建顶部视图
- (void)createView{
    
    UIImageView *imageV = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 80, 80)];
    imageV.center = CGPointMake(ScreenWidth/2, 64+imageV.frame.size.height/2);
    imageV.image = [UIImage iconWithInfo:TBCityIconInfoMake(icon_village_information, imageV.frame.size.width/2, [UIColor whiteColor])];
    imageV.backgroundColor = [UIColor colorWithHexString:@"#3399cc"];
    imageV.layer.cornerRadius = imageV.frame.size.width/2;
    [self.view addSubview:imageV];
    
    //label
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, imageV.frame.origin.y+imageV.frame.size.height, ScreenWidth, 40)];
    label.textAlignment = NSTextAlignmentCenter;
    label.font = [UIFont systemFontOfSize:14];
    label.textColor = [UIColor blackColor];
    label.text = @"请您确认信息";
    [self.view addSubview:label];
    
     _titleArr = @[@"专区名称",@"具体位置",@"入驻费用"];
    //信息部分
    CGFloat tableVY = label.frame.origin.y + label.frame.size.height;
    UITableView *tableV = [[UITableView alloc] initWithFrame:CGRectMake(0, tableVY, ScreenWidth, ScreenHeight-tableVY-55) style:UITableViewStylePlain];
    tableV.delegate = self;
    tableV.dataSource = self;
    tableV.scrollEnabled = NO;
    tableV.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    [self.view addSubview:tableV];

    //确认按钮
    UIButton *confirmButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth-20, 35)];
    confirmButton.center = CGPointMake(ScreenWidth/2,tableV.frame.origin.y+tableV.frame.size.height+10+confirmButton.frame.size.height/2);
    confirmButton.backgroundColor = [UIColor colorWithRed:118/255.0 green:202/255.0 blue:39/255.0 alpha:1];
    [confirmButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [confirmButton setTitle:@"确认加入" forState:UIControlStateNormal];
    confirmButton.layer.cornerRadius = 8;
    [confirmButton addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:confirmButton];
    

}

#pragma mark - UITableViewDelegate方法
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 5;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cellID"];
    if (cell == nil) {
        
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"cellID"];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        if (indexPath.row < _titleArr.count) {
            
            cell.textLabel.text = _titleArr[indexPath.row];
            cell.textLabel.font = [UIFont systemFontOfSize:16];
            //内容
            UILabel *contentL = [[UILabel alloc] initWithFrame:CGRectMake(100, 0, ScreenWidth-100, 35)];
            if (indexPath.row == 0) {
                contentL.text = _model.district_info[@"name"];
            }else if(indexPath.row == 1){
                contentL.text = _model.district_info[@"location"];

            }else{
                 cell.detailTextLabel.text = _model.promoter_fee;
            }
            contentL.font = [UIFont systemFontOfSize:14];
            [cell.contentView addSubview:contentL];
        }else if(indexPath.row == 3){
            
            //创建视图
            GiftViews *view = [[GiftViews alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 80)];
            view.backgroundColor = [UIColor whiteColor];
            view.modelArr = _model.gift_list;
            view.block = ^(NSString *giftID){
                self.giftID = giftID;
            };
            [cell.contentView addSubview:view];
        }else{
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            //创建地址
            [self createAddress:cell];
        }

        
    }
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 3 ) {
        return 80;
    }else if(indexPath.row == 4){
        return 50;
    }else{
        return 35;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.row == 4) {//跳转到地址页面
        
        UIStoryboard *story = [UIStoryboard storyboardWithName:@"Me" bundle:nil];
        AddressViewController *controller = [story instantiateViewControllerWithIdentifier:@"AddressViewController"];
        controller.isGoods = YES;
        
        [self.navigationController pushViewController:controller animated:YES];
        
    }
}

#pragma mark - 创建地址
- (void)createAddress:(UITableViewCell *)cell{
    
    UILabel *titleL = [UILabel new];
    titleL.text = @"收货人：";
    titleL.font = [UIFont systemFontOfSize:11];
    titleL.textColor = [UIColor grayColor];
    [cell.contentView addSubview:titleL];
    [titleL mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.mas_equalTo(cell.mas_top).mas_offset(0);
        make.width.mas_equalTo(50);
        make.left.mas_equalTo(cell).mas_offset(10);
        make.height.mas_equalTo(20);
        
    }];
    
    UILabel  *nameL = [UILabel new];
    nameL.text = @"";
    nameL.font = [UIFont systemFontOfSize:11];
    nameL.textColor = [UIColor grayColor];
    [cell.contentView addSubview:nameL];
    [nameL mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.mas_equalTo(cell.mas_top).mas_offset(0);
        make.width.mas_equalTo(150);
        make.left.mas_equalTo(titleL.mas_right).mas_offset(0);
        make.height.mas_equalTo(20);
        
    }];
    self.nameL = nameL;
    
    UILabel *mobileL = [UILabel new];
    mobileL.text = @"";
    mobileL.font = [UIFont systemFontOfSize:11];
    mobileL.textColor = [UIColor grayColor];
    [cell.contentView addSubview:mobileL];
    [mobileL mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.mas_equalTo(cell.mas_top).mas_offset(0);
        make.width.mas_equalTo(80);
        make.left.mas_equalTo(nameL.mas_right).mas_offset(0);
        make.right.mas_equalTo(cell).mas_offset(-30);
        make.height.mas_equalTo(20);
        
    }];
    self.iphoneL = mobileL;
    
    UILabel *addressL = [UILabel new];
    addressL.text = @"";
    addressL.font = [UIFont systemFontOfSize:11];
    addressL.textColor = [UIColor grayColor];
    [addressL sizeToFit];
    [cell.contentView addSubview:addressL];
    [addressL mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.mas_equalTo(titleL.mas_bottom).mas_offset(0);
        make.width.mas_equalTo(ScreenWidth-20);
        make.left.mas_equalTo(cell).mas_offset(10);
        make.height.mas_equalTo(30);
        
    }];
    self.addressL = addressL;
}


#pragma mark 获得地址
-(void)orderAddress:(NSNotification *)noti
{
    NSDictionary *dic = noti.userInfo;
    self.nameL.text = dic[@"accept_name"];
    self.iphoneL.text = dic[@"mobile"];
    self.addressL.text = [NSString stringWithFormat:@"地 址：%@",dic[@"addr"]];
    self.addrID = dic[@"id"];
}

#pragma mark - 确认按钮点击
- (void)buttonAction:(UIButton *)btn{
    
//    NSArray *keys = [[NSArray alloc]init];
//    NSArray *values = [[NSArray alloc]init];
//    keys = @[@"user_id",@"token",@"reference"];
//    values = @[@(_user_id),_token,_reference_id];
//    [MySDKHelper postAsyncWithURL:@"/v1/pay_district" withParamBodyKey:keys withParamBodyValue:values needToken:_token postSucceed:^(NSDictionary *result) {
//        //        NSLog(@"我是数据%@",result);
//        [self promptMessage:result[@"message"]];
//    } postCancel:^(NSString *error) {
//        NSLog(@"我是错误%@",error);
//        [self promptMessage:error];
//    }];
    if (![_addrID isEqualToString:@""]&&![_giftID isEqualToString:@""]) {
        UPAPayViewController *payControl = [UPAPayViewController alloc];
        payControl.price = _model.promoter_fee;
        payControl.userID = [NSString stringWithFormat:@"%ld",(long)_user_id];
        payControl.token = _token;
        NSDictionary *dic = @{@"gift":_giftID,@"address_id":_addrID,@"reference":_reference_id,@"invitor_role":_invitor_role};
        payControl.pInfo = dic;
        payControl.bePromoter = YES ;
        [self.navigationController pushViewController:payControl animated:YES];
    }else{
        UIAlertController *alertC = [UIAlertController alertControllerWithTitle:@"提示" message:@"请将信息填写完整！" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *ok = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:nil];
        [alertC addAction:ok];
        [self presentViewController:alertC animated:YES completion:nil];

    }
   
}

//提示视图
- (void)promptMessage:(NSString *)prompt{
    
    UILabel *promptM = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 300, 30)];
    promptM.center = CGPointMake(ScreenWidth/2, ScreenHeight-ScreenHeight/4);
    promptM.text = prompt;
    promptM.font = [UIFont systemFontOfSize:12];
    promptM.layer.borderWidth = 1;
    promptM.layer.borderColor = [UIColor darkGrayColor].CGColor;
    promptM.layer.cornerRadius = 5;
    promptM.textAlignment = NSTextAlignmentCenter;
    promptM.textColor = [UIColor blackColor];
    [self.view addSubview:promptM];
    [UIView animateWithDuration:3 animations:^{
        promptM.alpha = 0;
    } completion:^(BOOL finished) {
        [promptM removeFromSuperview];
    }];
    
}

#pragma mark - 导航栏
- (void)createNavigationView{
    
    UIView *navView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 64)];
    navView.backgroundColor = [UIColor whiteColor];
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
    title.text = @"成为推广者";
    [navView addSubview:title];
    
}
//导航栏按钮事件
- (void)backBtnAction:(UIButton *)btn{
    
    [self.navigationController popToRootViewControllerAnimated:YES];
}


@end
