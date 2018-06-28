//
//  DetailsOfRedViewController.m
//  huabi
//
//  Created by hy on 2018/1/17.
//  Copyright © 2018年 ltl. All rights reserved.
//

#import "DetailsOfRedViewController.h"
#import "MyRedBagViewCell.h"
#import "Newyuanmeng-Swift.h"
#import "MapPaperRedModel.h"
#import "RedList.h"
#import "RedPacketViewController.h"

@interface DetailsOfRedViewController ()<UITableViewDelegate,UITableViewDataSource>
@property(nonatomic,strong)UILabel *name;
@property(nonatomic,strong)UILabel *info;
@property(nonatomic,strong)UIImageView *image;
@property(nonatomic,strong)UILabel *money;

@property (nonatomic,strong)UITableView *table;

@property (nonatomic,strong)NSMutableArray *list;
@property (nonatomic,strong)NSDictionary *redBag;

@property (nonatomic,strong)NSString *get_money;

@end

@implementation DetailsOfRedViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    UIView *header = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 370)];
    header.backgroundColor = [UIColor colorWithHexString:@"eaeaea"];
    
    UIImageView *bg = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 150)];
    self.image = bg;
    bg.image = [UIImage imageNamed:@"beijing"];
    [header addSubview:bg];
    
    UIImageView *headerImage = [[UIImageView alloc] initWithFrame:CGRectMake(ScreenWidth/2-30, 120, 60, 60)];
    self.image = headerImage;
    headerImage.image = [UIImage imageNamed:@"pay-successful"];
    [header addSubview:headerImage];
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(ScreenWidth/2-50, 200, 100, 20)];
    label.text = @"圆梦共享网";
    self.name = label;
    label.textAlignment = NSTextAlignmentCenter;
    [header addSubview:label];
    
    UILabel *infoLabel = [[UILabel alloc] initWithFrame:CGRectMake(ScreenWidth/2 - 100, 230, 200, 20)];
    infoLabel.text = @"恭喜发财，大吉大利";
    self.info = infoLabel;
    infoLabel.textAlignment = NSTextAlignmentCenter;
    [header addSubview:infoLabel];
    
    UILabel *money = [[UILabel alloc] initWithFrame:CGRectMake(ScreenWidth/2 - 50, 280, 100, 30)];
    money.textAlignment = NSTextAlignmentCenter;
    self.money = money;
    money.font = [UIFont systemFontOfSize:30];
//    NSMutableAttributedString *AttributedStr = [[NSMutableAttributedString alloc]initWithString:@"0.03元"];
//
//    [AttributedStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:40] range:NSMakeRange(2, 2)];
//    money.attributedText = AttributedStr;

    [header addSubview:money];
    
    UILabel *info = [[UILabel alloc] initWithFrame:CGRectMake(ScreenWidth/2-150, 340, 300, 20)];
    info.text = @"已存入零钱，可用于发红包";
    info.font = [UIFont systemFontOfSize:14];
    info.textColor = [UIColor colorWithRed:2/255.f green:85/255.f blue:235/255.f alpha:1];
    info.textAlignment = NSTextAlignmentCenter;
    [header addSubview:info];
    
    self.table = [[UITableView alloc] initWithFrame:CGRectMake(0, -20, ScreenWidth, ScreenHeight- 20) style:UITableViewStylePlain];
    self.table.delegate = self;
    self.table.dataSource = self;
    self.table.tableHeaderView = header;
    [self.view addSubview:self.table];
    
    
    UIView *nav = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 64)];
    nav.backgroundColor = [UIColor colorWithHexString:@"#D75940"];
    UIButton *back = [UIButton buttonWithType:UIButtonTypeCustom];
    back.frame = CGRectMake(5, 25, 50, 30);
    [back setTitle:@"关闭" forState:UIControlStateNormal];
    [back setTitleColor:[UIColor colorWithHexString:@"#FDE4B4"] forState:UIControlStateNormal];
    [back addTarget:self action:@selector(backClick) forControlEvents:UIControlEventTouchUpInside];
    UILabel *titles = [[UILabel alloc] initWithFrame:CGRectMake(ScreenWidth/2 -100, 25, 200, 30)];
    titles.text = @"红包";
    titles.textAlignment = NSTextAlignmentCenter;
    titles.font = [UIFont systemFontOfSize:24];
    titles.textColor = [UIColor colorWithHexString:@"#FDE4B4"];
    [nav addSubview:titles];
    [nav addSubview:back];
    [self.view addSubview:nav];
    
    
    UIButton *seeMore = [UIButton buttonWithType:UIButtonTypeCustom];
    [seeMore setTitle:@"查看我的红包记录" forState:UIControlStateNormal];
    [seeMore setTitleColor:[UIColor colorWithRed:2/255.f green:85/255.f blue:235/255.f alpha:1] forState:UIControlStateNormal];
    [seeMore addTarget:self action:@selector(redBagDetail) forControlEvents:UIControlEventTouchUpInside];
    seeMore.titleLabel.textAlignment = NSTextAlignmentCenter;
    seeMore.frame = CGRectMake(ScreenWidth/2-75, ScreenHeight - 40, 150, 30);
    [self.view addSubview:seeMore];
    
    [self setInfo];
}

-(void)redBagDetail
{
    RedPacketViewController *redPacket = [[UIStoryboard storyboardWithName:@"Me" bundle:nil] instantiateViewControllerWithIdentifier:@"RedPacketViewController"];
    redPacket.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:redPacket animated:YES];
}

-(void)setInfo
{
    [MySDKHelper postAsyncWithURL:@"/v1/redbag_open" withParamBodyKey:@[@"user_id",@"redbag_id",@"type"] withParamBodyValue:@[@(CommonConfig.UserInfoCache.userId),_id,@"2"] needToken:CommonConfig.Token postSucceed:^(NSDictionary *result) {
        NSLog(@"%@",result);
        NSDictionary *redBag = result[@"content"][@"redbag"];
        self.get_money = result[@"content"][@"get_money"];
        NSArray *list = result[@"content"][@"list"];
        NSMutableArray *lists = [RedList mj_keyValuesArrayWithObjectArray:list];
        self.list = lists;
        self.redBag = redBag;
        self.name.text = redBag[@"shop_name"];
        self.info.text = redBag[@"info"];
        self.money.text = result[@"content"][@"get_money"];
        [self.image sd_setImageWithURL:[NSURL URLWithString:[CommonConfig getImageUrl:redBag[@"picture"]]] placeholderImage:[UIImage imageNamed:@"none"]];
        [self.table reloadData];
    } postCancel:^(NSString *error) {
        [NoticeView showMessage:error];
    }];
}


-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    NSString *title = [NSString stringWithFormat:@"已领取%@/%@个,共%@/%@元",self.redBag[@"open_num"],self.redBag[@"num"],self.redBag[@"total_get_money"],self.redBag[@"total_money"]];
    return title;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 50;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.list.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    MyRedBagViewCell *cell = [MyRedBagViewCell creatCell:tableView];
    NSDictionary *paper = self.list[indexPath.row];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    [cell.userImage sd_setImageWithURL:[NSURL URLWithString:[CommonConfig getImageUrl:paper[@"avatar"]]] placeholderImage:[UIImage imageNamed:@"none"]];
    cell.redBagType.text = paper[@"real_nam"];;
    cell.redBagFrom.text = paper[@"get_date"];
    cell.redBagStatus.text = self.get_money;
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 80;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self.navigationController setNavigationBarHidden:YES animated:NO];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}
-(void)backClick
{
    self.close();
    [self.navigationController popViewControllerAnimated:YES];
}
@end
