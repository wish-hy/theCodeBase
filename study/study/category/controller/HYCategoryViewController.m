//
//  HYCategoryViewController.m
//  study
//
//  Created by hy on 2018/3/28.
//  Copyright © 2018年 hy. All rights reserved.
//

#import "HYCategoryViewController.h"
#import "HYActivteCell.h"
#import "HYActivteModel.h"
#import "HYActivteInfoViewController.h"

@interface HYCategoryViewController ()<UITabBarDelegate,UITableViewDataSource,UITableViewDelegate>

@property (nonatomic ,strong)UITableView *tableView;

@property (nonatomic ,strong)NSMutableArray *dataArr;


@property (nonatomic ,strong)NSDictionary *localDate;
@end

@implementation HYCategoryViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"活动";
    
    self.tableView.backgroundColor = [UIColor whiteColor];
    
    [self loadHeader];
    
    [self getActivte];
    [self getLocadate];
    
}

-(void)getActivte
{
    _dataArr = [NSMutableArray array];
    for (int i = 0; i < 2; i++) {
        HYActivteModel *mode = [[HYActivteModel alloc] init];
        mode.activityName = @"";
        mode.activityInfo = @"";
        [_dataArr addObject:mode];
        
    }
    [_tableView reloadData];
    
    [HYHttpTool POST:BaseUrl(addPic) parameters:nil success:^(id responseObject) {
        HYLog(@"请求成功%@",responseObject);
        //        NSArray *arr = responseObject[@""];
        //        NSLog(@"第一条数据%@",arr[0]);
//        if ([responseObject[@"code"] intValue] == 0 ) {
            NSArray *info = responseObject[@"activity"];
            self.dataArr = [HYActivteModel mj_objectArrayWithKeyValuesArray:info];
            [self.tableView reloadData];
           
//        }else{
//            [ToastManage showCenterToastWith:responseObject[@"msg"] starY:500];
//        }
    } failure:^(NSError *error) {
        HYLog(@"请求失败 加载本地数据 = %@",error);
        NSArray *arr = self.localDate[@"activity"];
        self.dataArr = [HYActivteModel mj_objectArrayWithKeyValuesArray:arr];
        [self.tableView reloadData];
    }];
}

-(void)act1
{
     HYActivteInfoViewController *activte = storyboardWith(@"Activte", @"HYActivteInfoViewController");
    HYActivteModel *model = [[HYActivteModel alloc] init];
    model.activityName = @"#索尼微单5月众测# 记录城市的光阴";
    model.activityInfo = @"在城市里，每天见证着钢筋混凝土的巨兽不断刷新天际线；在城市里，喧嚣的车流簇拥在宽敞的柏油路上；在城市里，夕阳总能洒下金灿灿的光，让夜幕下的街道熠熠生辉……\n这个月，希望你能拿着索尼相机，为我们带来你城市的独特风光……\n★活动流程★\n名单公布：试用名单将在活动页公布\n试用通知：名单公布后客服将以短信的方式通知申请成功者，2天不回复算弃权\n押金收取：工作人员将统一通知大家收取产品押金并签订试用合同\n产品寄送：收到押金后第一时间将产品快递给大家\n试用报告：收到货的10天内，在论坛以“#索尼微单5月众测#+标题名”为题发布主帖完成众测试用报告,众测报告帖不得低于15张照片,帖子测评文字不得低于800字,要符合主题,不要求高端大气上档次,但也要低调奢华有内涵。\n产品回收及押金退回：活动结束机器寄回公司后押金返还，人为损坏须赔偿";
    activte.model = model;
    activte.urlStr = @"http://p7mm0t0oh.bkt.clouddn.com/activte1.jpg";
    [self.navigationController pushViewController:activte animated:YES];
}

-(void)act2
{
    HYActivteInfoViewController *activte = storyboardWith(@"Activte", @"HYActivteInfoViewController");
    HYActivteModel *model = [[HYActivteModel alloc] init];
    model.activityName = @"佳能专区人像色彩篇";
    model.activityInfo = @"\n佳能专区人像色彩篇，\n4月19日（周四）摄影师小宇，莅临798蔓空间，现场讲解人像构图知识，好机会不容错过。\n届时活动现场更有蜂鸟二手鉴定平台工作人员在现场为现场网友提供以下服务:\n1.蜂鸟鉴定平台免费为网友提供旧机鉴定服务；\n2.蜂鸟回收平台现场高价回收旧机；\n3.佳能经销商进驻活动现场，供网友了解、体验佳能新品.\n4.经销商提供网上购买地址，支持网友随时购买新器材。\n讲座主题：人像构图\n活动时间：2018年4月19日 13：30-16:30\n活动地点：798艺术区东区D085蔓空间（地点不熟悉的老师，详情见蜂鸟活动微信群）\n活动环节：\n13:30-13:40  现场签到\n13:40-14:30  现场讲座\n14:30-14:45  现场互动\n14:45-16:15  模特拍摄环节\n16：15       活动结束\n讲师资料：\n蜂鸟先锋摄影师，北京顶峰影艺文化传媒有限公司签约摄影师，搜狐时尚栏目特约美女摄影师，美妆摄影达人，知名COS主播";
    activte.model = model;
    activte.urlStr = @"http://huodong.qn.img-space.com/201804/13/c01b8d0ef718699dbeea85111983a9b8.jpg?imageView2/2/w/570/h/380/q/90/ignore-error/1/";
    [self.navigationController pushViewController:activte animated:YES];
}

-(void)act3
{
    HYActivteInfoViewController *activte = storyboardWith(@"Activte", @"HYActivteInfoViewController");
    HYActivteModel *model = [[HYActivteModel alloc] init];
    model.activityName = @"夏末小时光";
    model.activityInfo = @"【活动主题】：夏末小时光\n【活动时间】：5月27日（下午）\n【集合时间】：13：30\n【拍摄时间】：14:00—16:30\n【活动结束时间】：16:30分\n【活动人数】：8名\n【模特人数】：一名\n大树分割线\n【集合地点】：漫茶时光\n【活动地点】：北京石景山雕塑公园南街北口远洋山水12号楼底商6号（兴业银行南行60米）\n【乘车路线】：地铁1号线（八宝山地铁站下） 具体再导航{漫茶时光店}\n大树分割线\n【化妆造型】由北京I DU化妆造型\n【报名方式】微信316360485\n【咨询电话】18518712468\n【联系人】邢氏客服\n【活动费用】：320元（邢氏会员八折）\n《精品小班教学活动名额有限.报名的影友请联系客服，确定报名后交付活动经费》";
    activte.model = model;
    activte.urlStr = @"http://huodong.qn.img-space.com/201805/23/6f6b3414fdacd78d0b17f63fa731f37c.jpg?imageView2/2/w/570/h/380/q/90/ignore-error/1/";
    [self.navigationController pushViewController:activte animated:YES];
}

-(void)loadHeader
{
    UIView *headerView = [[UIView alloc] init];
    headerView.frame = CGRectMake(0, 0, ScreenWidth, 300);
    [self.tableView addSubview:headerView];
    self.tableView.tableHeaderView = headerView;
    
    
    UIView *scroll = [[UIView alloc] init];
    scroll.backgroundColor = [UIColor greenColor];
    UIImageView *images = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"activte1"]];
//    images.contentMode = UIViewContentModeScaleToFill;
    images.clipsToBounds = YES;
    UITapGestureRecognizer *tap1 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(act1)];
    [scroll addGestureRecognizer:tap1];
    [scroll addSubview:images];
    [headerView addSubview:scroll];
    
    
    UIView *activite1 = [[UIView alloc] init];
    activite1.backgroundColor = [UIColor blueColor];
    UIImageView *images1 = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"activte2"]];
    images1.contentMode = UIViewContentModeScaleToFill;
    images1.clipsToBounds = YES;
    UITapGestureRecognizer *tap2 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(act2)];
    [activite1 addGestureRecognizer:tap2];
    [activite1 addSubview:images1];
    [headerView addSubview:activite1];
    
    
    UIView *activite2 = [[UIView alloc] init];
    activite2.backgroundColor = [UIColor orangeColor];
    UIImageView *images2 = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"activte3"]];
    images2.contentMode = UIViewContentModeScaleToFill;
    images2.clipsToBounds = YES;
    UITapGestureRecognizer *tap3 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(act3)];
    [activite2 addGestureRecognizer:tap3];
    [activite2 addSubview:images2];
    [headerView addSubview:activite2];
    
    UILabel *lab = [[UILabel alloc] init];
    lab.text = @"热门活动";
    [headerView addSubview:lab];
    
    UIImageView *img = [[UIImageView alloc] init];
    img.image = [UIImage imageNamed:@"hot"];
    [headerView addSubview:img];
    
    [scroll mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo((ScreenWidth - 30)/3*2);
        make.height.mas_equalTo((ScreenWidth - 30)/3*2);
        make.top.mas_equalTo(headerView).mas_offset(10);
        make.left.mas_equalTo(headerView).mas_offset(10);
    }];
    
    [images mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(scroll.mas_top);
        make.left.mas_equalTo(scroll.mas_left);
        make.right.mas_equalTo(scroll.mas_right);
        make.bottom.mas_equalTo(scroll.mas_bottom);
    }];
    
    [activite1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo((ScreenWidth - 30)/3 - 1);
        make.height.mas_equalTo((ScreenWidth - 30)/3 - 1);
        make.left.mas_equalTo(scroll.mas_right).offset(10);
        make.top.mas_equalTo(scroll.mas_top);
    }];
    [images1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(activite1.mas_top);
        make.left.mas_equalTo(activite1.mas_left);
        make.right.mas_equalTo(activite1.mas_right);
        make.bottom.mas_equalTo(activite1.mas_bottom);
    }];
    
    [activite2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(activite1.mas_width);
        make.height.mas_equalTo(activite1.mas_height);
        make.bottom.mas_equalTo(scroll.mas_bottom);
        make.left.mas_equalTo(scroll.mas_right).offset(10);

    }];
    
    [images2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(activite2.mas_top);
        make.left.mas_equalTo(activite2.mas_left);
        make.right.mas_equalTo(activite2.mas_right);
        make.bottom.mas_equalTo(activite2.mas_bottom);
    }];
    
    [lab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(headerView.mas_bottom).offset(-10);
        make.centerX.mas_equalTo(headerView.mas_centerX).offset(20);
        make.width.mas_equalTo(100);
        make.height.mas_equalTo(20);
    }];
    
    [img mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(lab.mas_centerY);
        make.height.mas_equalTo(24);
        make.width.mas_equalTo(24);
        make.right.mas_equalTo(lab.mas_left).offset(-5);
    }];
    
}

#pragma mark --- tableViewDelegate
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _dataArr.count;
}


-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    HYActivteModel *model = self.dataArr[indexPath.row];
    HYActivteCell *cell = [HYActivteCell creatCellInTableView:tableView];
    NSLog(@"%@",model.activityInfo);
    cell.activteName.text = model.activityName;
    cell.activteInfo.text = model.activityInfo;
    if (indexPath.row == 0) {
        [cell.imageV sd_setImageWithURL:[NSURL URLWithString:@"http://p7mm0t0oh.bkt.clouddn.com/fcf024186868.jpg"] placeholderImage:[HYToolsKit createImageWithColor:RandomColor]];
    }else if (indexPath.row == 1){
        [cell.imageV sd_setImageWithURL:[NSURL URLWithString:@"http://p7mm0t0oh.bkt.clouddn.com/d69cd3511b3.jpg"] placeholderImage:[HYToolsKit createImageWithColor:RandomColor]];
    }
    
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
     HYActivteModel *model = self.dataArr[indexPath.row];
    HYActivteInfoViewController *activte = storyboardWith(@"Activte", @"HYActivteInfoViewController");
    activte.model = model;
    if (indexPath.row == 0) {
        activte.urlStr = @"http://p7mm0t0oh.bkt.clouddn.com/fcf024186868.jpg";
    }else if (indexPath.row == 1){
        activte.urlStr = @"http://p7mm0t0oh.bkt.clouddn.com/d69cd3511b3.jpg";
    }
    [self.navigationController pushViewController:activte animated:YES];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 300;
}

-(NSMutableArray *)dataArr
{
    if (!_dataArr) {
        _dataArr = [NSMutableArray array];
    }
    return _dataArr;
}

-(UITableView *)tableView
{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight) style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        [self.view addSubview:_tableView];
    }
    return _tableView;
}

-(void)getLocadate
{
    self.localDate = @{
                       @"activity": @[
                               @{
                                   @"activityAward": @"",
                                   @"activityCheck": @0,
                                   @"activityEndDate": @"",
                                   @"activityId": @1,
                                   @"activityInfo": @"去岘山采风",
                                   @"activityName": @"最新活动",
                                   @"activityPublictyDate": @"",
                                   @"activitySponsor": @"",
                                   @"activityStartDate": @""
                                   },
                               @{
                                   @"activityAward": @"",
                                   @"activityCheck": @0,
                                   @"activityEndDate": @"",
                                   @"activityId": @2,
                                   @"activityInfo": @"校内风光摄影采集",
                                   @"activityName": @"第二次活动",
                                   @"activityPublictyDate": @"",
                                   @"activitySponsor": @"",
                                   @"activityStartDate": @""
                                   }
                               ]
                       };
}

@end
