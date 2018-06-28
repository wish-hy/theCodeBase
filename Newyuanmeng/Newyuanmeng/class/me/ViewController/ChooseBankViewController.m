//
//  ChooseBankViewController.m
//  huabi
//
//  Created by huangyang on 2017/12/27.
//  Copyright © 2017年 ltl. All rights reserved.
//

#import "ChooseBankViewController.h"
#import "BankCardCell.h"
#import "BankInfo.h"
#import "AddNewBankViewController.h"
#import "Newyuanmeng-Swift.h"

@interface ChooseBankViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *chooseBankTableView;
@property (weak, nonatomic) IBOutlet UIButton *addButton;

@end

@implementation ChooseBankViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.chooseBankTableView.delegate = self;
    self.chooseBankTableView.dataSource = self;
    [self.addButton setImage:[UIImage iconWithInfo:TBCityIconInfoMake(@"\U0000e6b7", 30, [UIColor colorWithHexString:@"333333"])] forState:UIControlStateNormal];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getBankInfo) name:@"refershBank" object:nil];
}

-(void)getBankInfo
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getBankInfo) name:@"refershBank" object:nil];
    //  加载银行卡信息
    NSArray *keys = @[@"user_id"];
    NSArray *values = @[@(CommonConfig.UserInfoCache.userId)];

    [MySDKHelper postAsyncWithURL:@"/v1/bankcard_list" withParamBodyKey:keys withParamBodyValue:values needToken:CommonConfig.Token postSucceed:^(NSDictionary *result) {
        //        NSLog(@"%@",result);
        NSMutableArray *bankInfo = [BankInfo mj_objectArrayWithKeyValuesArray:result[@"content"]];
      
            self.bankInfo = bankInfo;
        [self.chooseBankTableView reloadData];
    } postCancel:^(NSString *error) {
        NSLog(@"%@",error);
        [NoticeView showMessage:error];
    }];
}



-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.bankInfo.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    BankInfo *bankInfo = self.bankInfo[indexPath.row];
    
    BankCardCell *cell = [BankCardCell creatCell:tableView];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    [cell.bankImage sd_setImageWithURL:[NSURL URLWithString:bankInfo.logo]];
    cell.bankName.text = bankInfo.name;
    
    if ([bankInfo.id isEqualToString:_ID])
    {
        cell.isSelect.selected = YES;
    }
    
    self.chooseBankTableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    return cell;
}
    
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
    {
        BankInfo *bankInfo = self.bankInfo[indexPath.row];
        BankCardCell *cell = [tableView cellForRowAtIndexPath:indexPath];
        cell.isSelect.selected = YES;
        NSDictionary *bank = @{
                               @"bank_id":bankInfo.id,
                               @"bank_name":bankInfo.name,
                               @"bank_img":bankInfo.logo
                               };
        
        //发送通知
        [[NSNotificationCenter defaultCenter] postNotificationName:@"bankID" object:nil userInfo:@{@"bank":bank}];
        
        [self.navigationController popViewControllerAnimated:YES];
    }

-(NSArray<UITableViewRowAction *> *)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewRowAction *deleteAction = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDestructive title:@"删除" handler:^(UITableViewRowAction * _Nonnull action, NSIndexPath * _Nonnull indexPath) {
         BankInfo *bankInfo = self.bankInfo[indexPath.row];
        
        NSArray *keys = @[@"user_id",@"list_id"];
        NSArray *values = @[@(CommonConfig.UserInfoCache.userId),bankInfo.id];
        [MySDKHelper postAsyncWithURL:@"/v1/unbind_card_temp" withParamBodyKey:keys withParamBodyValue:values needToken:CommonConfig.Token postSucceed:^(NSDictionary *result) {
            NSString *verified = result[@"content"];
            NSLog(@"解绑成功%@",verified);
            [self.bankInfo removeObjectAtIndex:indexPath.row];
            [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
            //发送通知
            [[NSNotificationCenter defaultCenter] postNotificationName:@"unbundling" object:nil userInfo:nil];
            
        } postCancel:^(NSString *error) {
            NSLog(@"%@",error);
            [NoticeView showMessage:error];
        }];
        
    }];
    return @[deleteAction];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 72;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self.navigationController setNavigationBarHidden:YES animated:NO];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}

- (IBAction)addButton:(id)sender {
    AddNewBankViewController *addNewBank = [[UIStoryboard storyboardWithName:@"Me" bundle:nil] instantiateViewControllerWithIdentifier:@"AddNewBankViewController"];
    addNewBank.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:addNewBank animated:YES];
}


- (IBAction)backButton:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}


#pragma 设置tableView线条画满
//- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
//
//    if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
//
//        [cell setSeparatorInset:UIEdgeInsetsZero];
//    }
//    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
//
//        [cell setLayoutMargins:UIEdgeInsetsZero];
//    }
//}

@end
