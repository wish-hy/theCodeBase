//
//  HYHomeViewController.m
//  study
//
//  Created by hy on 2018/3/28.
//  Copyright © 2018年 hy. All rights reserved.
//

#import "HYHomeViewController.h"
#import "HYScrollImageView.h"  // 轮播

#import "HYWaterfallFlowCell.h"  // 瀑布流cell

#import "HYImageDetialController.h"

#import "HYLayout.h"

#import "HYHomeMoel.h"

#import "HYActivteModel.h"
#import "HYActivteInfoViewController.h"
#import "HYWebViewController.h"

static NSString *const HYScrollImageViewID = @"HYScrollImageView";
static NSString *const HYRecommendViewCellID = @"HYRecommendViewCell";
static NSString *const HYWaterfallFlowCellID = @"HYWaterfallFlowCell";

@interface HYHomeViewController ()<UICollectionViewDelegate,UICollectionViewDataSource,HYWaterfallLayoutDelegate>

@property (nonatomic, strong) NSMutableArray *dataArray;
@property (nonatomic ,strong) UICollectionView *collectionView;

@property (nonatomic ,strong) HYLayout *hylayout;


@property (nonatomic ,strong) NSDictionary *homeDate;  // 本地数据

/** 是否正在加载--最新--数据... */
@property (nonatomic, assign, getter=isHeaderRefreshing) BOOL headerRefreshing;
/** 是否正在加载--更多--数据... */
@property (nonatomic, assign, getter=isFooterRefreshing) BOOL footerRefreshing;

@property (assign, nonatomic) NSInteger page; //!< 数据页数.表示下次请求第几页的数据.

@end


@implementation HYHomeViewController


- (void)viewDidLoad {
    [super viewDidLoad];
//        self.navigationItem.title = @"首页";
    self.title = @"首页";
    [self setDic];
    
    for (int i = 0 ; i < 6; i++) {
        HYHomeMoel *model = [[HYHomeMoel alloc] init];
        model.imgURL = @"";
        model.imgWidth = 500;
        model.imgHeight = 200;
        model.pictureName = @"";
        [self.dataArray addObject:model];
    }
    
    self.collectionView.backgroundColor = [UIColor whiteColor];

        //设置导航栏的颜色
    //    self.navigationController.navigationBar.barTintColor = [UIColor darkGrayColor];
    // 设置返回按钮字体的颜色
//        self.navigationController.navigationBar.tintColor = [UIColor yellowColor];
    
        // 设置导航栏左右两边的内容
        self.navigationItem.leftBarButtonItem = [HYItemTool itemWithImage:@"MainTagSubIcon" highImage:@"MainTagSubIconClick" target:self action:@selector(CYEssenceClick)];
    
        // 如并排创建两个按钮
//        UIBarButtonItem *moonButton = [CYItemTool itemWithImage:@"mine-moon-icon" highImage:@"mine-moon-icon-click" target:self action:@selector(moonClick)];
//        UIBarButtonItem *settingButton = [CYItemTool itemWithImage:@"mine-setting-icon" highImage:@"mine-setting-icon-click" target:self action:@selector(settingClick)];
//
//        self.navigationItem.rightBarButtonItems = @[settingButton,moonButton];


    
    [self setRefresh];

}

- (void)setRefresh {
    
    self.collectionView.header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [self loadData];
    }];
    
    self.collectionView.footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        //        取消刷新
        [self loadData];
    }];
    
    self.collectionView.footer.hidden = YES;
    
    // 初始化page
    self.page = 1;
    
    // 一进来就开始刷新
    [self.collectionView.header beginRefreshing];
    
}

-(void)loadData
{
    if (self.isHeaderRefreshing) return;
    self.page = 1;
    self.headerRefreshing = YES;
    // 请求首页数据
    [HYHttpTool POST:BaseUrl(photoLive) parameters:nil success:^(id responseObject) {
        HYLog(@"请求成功%@",responseObject);
        //        NSArray *arr = responseObject[@""];
        //        NSLog(@"第一条数据%@",arr[0]);
        if ([responseObject[@"code"] intValue] == 0 ) {
            NSArray *info = responseObject[@"pictures"];
            NSMutableArray *dataArr = [NSMutableArray array];
            for (NSDictionary *dict in info) {
                HYHomeMoel *model = [[HYHomeMoel alloc] init];
                model.imgURL = dict[@"picturePhoto"][0];
                NSLog(@"----%@",model.imgURL);
                NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:model.imgURL]];
                UIImage *image = [UIImage imageWithData:data];
                model.imgWidth = image.size.width;
                model.imgHeight = image.size.height;
                model.pictureName = dict[@"pictureName"];
                model.userHeadimg = dict[@"userHeadimg"];
                model.userName = dict[@"userName"];
                model.picturePhoto = dict[@"picturePhoto"];
                model.pictureId = dict[@"pictureId"];
                model.userId = dict[@"userId"];
                
                [dataArr addObject:model];
            }
            self.dataArray = dataArr;
            [_collectionView reloadData];
            [self.collectionView.header endRefreshing];
            self.headerRefreshing = NO;
        }else{
            [ToastManage showCenterToastWith:responseObject[@"msg"] starY:500];
        }
    } failure:^(NSError *error) {
        HYLog(@"请求失败 加载本地数据 = %@",error);
        if ([_homeDate[@"code"] intValue] == 0 ) {
            NSArray *info = _homeDate[@"pictures"];
            NSMutableArray *dataArr = [NSMutableArray array];
            for (NSDictionary *dict in info) {
                HYHomeMoel *model = [[HYHomeMoel alloc] init];
                model.imgURL = dict[@"picturePhoto"][0];
                NSLog(@"本地数据----%@",model.imgURL);
                NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:model.imgURL]];
                UIImage *image = [UIImage imageWithData:data];
                model.imgWidth = image.size.width;
                model.imgHeight = image.size.height;
                model.pictureName = dict[@"pictureName"];
                model.userHeadimg = dict[@"userHeadimg"];
                model.userName = dict[@"userName"];
                model.picturePhoto = dict[@"picturePhoto"];
                model.pictureId = dict[@"pictureId"];
                model.userId = dict[@"userId"];
                
                [dataArr addObject:model];
            }
            self.dataArray = dataArr;
            [_collectionView reloadData];
            [self.collectionView.header endRefreshing];
            self.headerRefreshing = NO;
        }
        
    }];
}

-(void)storeChatLogWithFile
{
    NSString *urlStr = [@"http://image.baidu.com/channel/listjson?pn=0&rn=50&tag1=美女&tag2=全部&ie=utf8" stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];

    [HYHttpTool POST:urlStr parameters:nil success:^(id responseObject) {
        NSMutableArray *array = [responseObject[@"data"] mutableCopy];
        [array removeLastObject];
        
        for (NSDictionary *dic in array) {
            NSLog(@"...%@",dic[@"image_url"]);
        }
            
    } failure:^(NSError *error) {
        HYLog(@"请求错误--%@",error);
    }];
    
}



#pragma mark -- system collectionViewDelegate

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
        return self.dataArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
        HYWaterfallFlowCell *cell = (HYWaterfallFlowCell *)[collectionView dequeueReusableCellWithReuseIdentifier:HYWaterfallFlowCellID forIndexPath:indexPath];
        cell.backgroundColor = [UIColor colorWithHexString:@"eeeeee"];
        cell.model = self.dataArray[indexPath.row];

        return cell;
}


- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    HYHomeMoel *modes = self.dataArray[indexPath.row];
    HYLog(@"选中了第%ld个item",indexPath.row);
    HYImageDetialController *detial = [[HYImageDetialController alloc] init];
    detial.model = modes;
    [self.navigationController pushViewController:detial animated:YES];
}

-(UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    UICollectionReusableView *reusableview = nil;
    HYScrollImageView *scrollImg = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:HYScrollImageViewID forIndexPath:indexPath];

    scrollImg.imageGroupArray = @[
                                  @"http://cmscdn.xitek.com/thumb/69/245482-424-286.jpg",
                                      @"https://cms.qn.img-space.com/290_module_images/240/5afa3a2b5ec8a.jpg",
                                      @"https://pp.qn.img-space.com/201805/11/7ccb2484f7d908cb6815269328db8dcb.jpg"
                                      ];
    scrollImg.banner = ^(NSInteger i) {
        if (i == 2) {
            HYActivteInfoViewController *activte = storyboardWith(@"Activte", @"HYActivteInfoViewController");
            HYActivteModel *model = [[HYActivteModel alloc] init];
            model.activityName = @"夏末小时光";
            model.activityInfo = @"【活动主题】：夏末小时光\n【活动时间】：5月27日（下午）\n【集合时间】：13：30\n【拍摄时间】：14:00—16:30\n【活动结束时间】：16:30分\n【活动人数】：8名\n【模特人数】：一名\n大树分割线\n【集合地点】：漫茶时光\n【活动地点】：北京石景山雕塑公园南街北口远洋山水12号楼底商6号（兴业银行南行60米）\n【乘车路线】：地铁1号线（八宝山地铁站下） 具体再导航{漫茶时光店}\n大树分割线\n【化妆造型】由北京I DU化妆造型\n【报名方式】微信316360485\n【咨询电话】18518712468\n【联系人】邢氏客服\n【活动费用】：320元（邢氏会员八折）\n《精品小班教学活动名额有限.报名的影友请联系客服，确定报名后交付活动经费》";
            activte.model = model;
            activte.urlStr = @"http://huodong.qn.img-space.com/201805/23/6f6b3414fdacd78d0b17f63fa731f37c.jpg?imageView2/2/w/570/h/380/q/90/ignore-error/1/";
            [self.navigationController pushViewController:activte animated:YES];
        }else if (i == 1){
            HYWebViewController *webView = [[HYWebViewController alloc] init];
            webView.urls = @"http://p7mm0t0oh.bkt.clouddn.com/234242.html";
            webView.webTitle = @"wish_hy";
            [self.navigationController pushViewController:webView animated:YES];
        }else{
            
        }
//    [ToastManage showCenterToastWith:[NSString stringWithFormat:@"点击了轮播图%ld",i] starY:500];
        };

    reusableview = scrollImg;

    return reusableview;
}


#pragma mark -- hylayout
// 计算item高度的代理方法，将item的高度与indexPath传递给外界
-(CGFloat)collectionView:(UICollectionView *)collectionView layout:(HYLayout *)collectionViewLayout heightForWidth:(CGFloat)width atIndexPath:(NSIndexPath *)indexPath
{
    HYHomeMoel *model = self.dataArray[indexPath.item];
//    return model.imgHeight / model.imgWidth * width;
    return (model.imgHeight + 400) / model.imgWidth * width;
}

// 区列数
-(NSInteger)collectionView:(UICollectionView *)collectionView layout:(HYLayout *)collectionViewLayout colCountForSectionAtIndex:(NSInteger)section
{
    return 2;
}

//区内边距
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(HYLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    return UIEdgeInsetsMake(0, 5, 5, 5);
}

//行间距
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(HYLayout *)collectionViewLayout lineSpacingForSectionAtIndex:(NSInteger)section {
    return 5;
}

//垂直间距
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(HYLayout *)collectionViewLayout interitemSpacingForSectionAtIndex:(NSInteger)section
{
        return 5;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(HYLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section
{
    return CGSizeMake(CGRectGetWidth(collectionView.frame), 360);
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(HYLayout *)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section
{
    return CGSizeMake(CGRectGetWidth(collectionView.frame), 80);
}


#pragma mark -- lazy load
-(UICollectionView *)collectionView
{
    if (!_collectionView) {
        
        self.hylayout = [[HYLayout alloc] init];
        self.hylayout.delegate = self;
        
       self.collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight) collectionViewLayout:self.hylayout];
        self.collectionView.delegate = self;
        self.collectionView.dataSource = self;
//        self.collectionView.showsVerticalScrollIndicator = NO;
        // 注册cell
       
        [self.collectionView registerClass:[HYScrollImageView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:HYScrollImageViewID];
        
        [self.collectionView registerClass:[HYWaterfallFlowCell class] forCellWithReuseIdentifier:HYWaterfallFlowCellID];
        [self.view addSubview:_collectionView];

    }
    return _collectionView;
}

- (NSMutableArray *)dataArray{
    if (_dataArray == nil) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}

- (void)CYEssenceClick
{
    HYLog(@"%s",__func__);
}

// 拼接json字符串
- (NSString *)UIUtilsFomateJsonWithDictionary:(NSDictionary *)dic {
    
    NSError *error;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dic options:NSJSONWritingPrettyPrinted error:&error];
    NSString *jsonString;
    if (!jsonData) {
        NSLog(@"%@",error);
    }else{
        jsonString = [[NSString alloc]initWithData:jsonData encoding:NSUTF8StringEncoding];
    }
    NSMutableString *mutStr = [NSMutableString stringWithString:jsonString];
    NSRange range = {0,jsonString.length};
    //去掉字符串中的空格
    [mutStr replaceOccurrencesOfString:@" " withString:@"" options:NSLiteralSearch range:range];
    
    NSRange range2 = {0,mutStr.length};
    
    //去掉字符串中的换行符
    [mutStr replaceOccurrencesOfString:@"\n" withString:@"" options:NSLiteralSearch range:range2];
    HYLog(@"===%@",mutStr);
    return mutStr;
}

-(void)setDic
{
    _homeDate = @{
        @"code": @0,
        @"msg": @"success",
        @"pictures": @[
                     @{
                         @"pictureId": @41,
                         @"picturePhoto": @[
                                           @"http://p7mm0t0oh.bkt.clouddn.com/6fd80a2768.jpg",
                                           @"http://p7mm0t0oh.bkt.clouddn.com/defaultHeader.jpeg"
                                           ],
                         @"pictureName": @"biu",
                         @"userId": @51,
                         @"userName": @"hahaha",
                         @"userHeadimg": @"http://p7mm0t0oh.bkt.clouddn.com/zhizhu.png"
                     },
                     @{
                         @"pictureId": @35,
                         @"picturePhoto": @[
                                          @"http://p7mm0t0oh.bkt.clouddn.com/6fd80a2768.jpg",
                                          @"http://p7mm0t0oh.bkt.clouddn.com/defaultHeader.jpeg"
                                          ],
                         @"pictureName": @"影集的名字",
                         @"userId": @51,
                         @"userName": @"hahaha",
                         @"userHeadimg": @"http://p7mm0t0oh.bkt.clouddn.com/zhizhu.png"
                     },
                     @{
                         @"pictureId": @33,
                         @"picturePhoto": @[
                                          @"http://p7mm0t0oh.bkt.clouddn.com/wdy4.jpeg",
                                          @"http://p7mm0t0oh.bkt.clouddn.com/zhuti2.png"
                                          ],
                         @"pictureName": @"名字嘛，随便来一点",
                         @"userId": @31,
                         @"userName": @"云淡风轻",
                         @"userHeadimg": @"http://p7mm0t0oh.bkt.clouddn.com/zhuti3.png"
                     },
                     @{
                         @"pictureId": @17,
                         @"picturePhoto": @[
                                          @"http://p7mm0t0oh.bkt.clouddn.com/44bdc7706.jpg"
                                          ],
                         @"pictureName": @"来一次测试",
                         @"userId": @51,
                         @"userName": @"hahaha",
                         @"userHeadimg": @"http://p7mm0t0oh.bkt.clouddn.com/zhizhu.png"
                     },
                     @{
                         @"pictureId": @1,
                         @"picturePhoto": @[
                                          @"http://p7mm0t0oh.bkt.clouddn.com/1bfb7ee4bd4.jpg",
                                          @"http://p7mm0t0oh.bkt.clouddn.com/31baabd373.jpg",
                                          @"http://p7mm0t0oh.bkt.clouddn.com/44bdc7706.jpg"
                                          ],
                         @"pictureName": @"不知道",
                         @"userId": @41,
                         @"userName": @"所噶",
                         @"userHeadimg": @"http://p7mm0t0oh.bkt.clouddn.com/wdy4.jpeg"
                         },@{
                         @"pictureId": @41,
                         @"picturePhoto": @[
                                 @"http://p7mm0t0oh.bkt.clouddn.com/6fd80a2768.jpg",
                                 @"http://p7mm0t0oh.bkt.clouddn.com/defaultHeader.jpeg"
                                 ],
                         @"pictureName": @"biu",
                         @"userId": @51,
                         @"userName": @"hahaha",
                         @"userHeadimg": @"http://p7mm0t0oh.bkt.clouddn.com/zhizhu.png"
                         },
                     @{
                         @"pictureId": @35,
                         @"picturePhoto": @[
                                 @"http://p7mm0t0oh.bkt.clouddn.com/6fd80a2768.jpg",
                                 @"http://p7mm0t0oh.bkt.clouddn.com/defaultHeader.jpeg"
                                 ],
                         @"pictureName": @"影集的名字",
                         @"userId": @51,
                         @"userName": @"hahaha",
                         @"userHeadimg": @"http://p7mm0t0oh.bkt.clouddn.com/zhizhu.png"
                         },
                     @{
                         @"pictureId": @33,
                         @"picturePhoto": @[
                                 @"http://p7mm0t0oh.bkt.clouddn.com/wdy4.jpeg",
                                 @"http://p7mm0t0oh.bkt.clouddn.com/zhuti2.png"
                                 ],
                         @"pictureName": @"名字嘛，随便来一点",
                         @"userId": @31,
                         @"userName": @"云淡风轻",
                         @"userHeadimg": @"http://p7mm0t0oh.bkt.clouddn.com/zhuti3.png"
                         },
                     @{
                         @"pictureId": @17,
                         @"picturePhoto": @[
                                 @"http://p7mm0t0oh.bkt.clouddn.com/44bdc7706.jpg"
                                 ],
                         @"pictureName": @"来一次测试",
                         @"userId": @51,
                         @"userName": @"hahaha",
                         @"userHeadimg": @"http://p7mm0t0oh.bkt.clouddn.com/zhizhu.png"
                         },
                     @{
                         @"pictureId": @1,
                         @"picturePhoto": @[
                                 @"http://p7mm0t0oh.bkt.clouddn.com/1bfb7ee4bd4.jpg",
                                 @"http://p7mm0t0oh.bkt.clouddn.com/31baabd373.jpg",
                                 @"http://p7mm0t0oh.bkt.clouddn.com/44bdc7706.jpg"
                                 ],
                         @"pictureName": @"不知道",
                         @"userId": @41,
                         @"userName": @"所噶",
                         @"userHeadimg": @"http://p7mm0t0oh.bkt.clouddn.com/wdy4.jpeg"
                         }
                     ]
    };
}

@end
