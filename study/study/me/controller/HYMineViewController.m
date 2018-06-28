//
//  HYMineViewController.m
//  study
//
//  Created by hy on 2018/3/28.
//  Copyright © 2018年 hy. All rights reserved.
//

#import "HYMineViewController.h"
#import "HYCustomButton.h"
#import "HYInformationViewController.h"
#import "LMWordViewController.h"
#import "HYCardViewController.h"
#import "BaseNavigationController.h"
#import "HYInfoModel.h"
#import "HYInfoPicCell.h"

#define kScreenHeight CGRectGetHeight([UIScreen mainScreen].bounds)

static NSInteger const cols = 3;
static CGFloat const minSpace = 5;
#define cellWH  (ScreenWidth - (cols-1)*minSpace)/cols

@interface HYMineViewController ()<UICollectionViewDelegateFlowLayout,UICollectionViewDataSource,UICollectionViewDelegate>

@property (nonatomic ,strong) UICollectionView *collectionView;

@property (nonatomic) CGFloat halfHeight;

@property (nonatomic ,strong) NSMutableArray *infoArr;

@property (nonatomic ,strong) UIImageView *backImage;
@property (nonatomic ,strong) UIView *shadowView;
@property (nonatomic ,strong) UIImageView *headerImage;
@property (nonatomic ,strong) UILabel *nickName;
@property (nonatomic ,strong) UILabel *descript;

@property (nonatomic ,strong)UIImage *imgs;
@end

@implementation HYMineViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.navigationController setNavigationBarHidden:NO];
    self.title = @"我的";
    _imgs = [HYToolsKit createImageWithColor:[UIColor colorWithWhite:1 alpha:0]];
    [self.navigationController.navigationBar setBackgroundImage:_imgs forBarMetrics:UIBarMetricsDefault];
    self.navigationController.navigationBar.shadowImage = [UIImage new];
    self.navigationItem.rightBarButtonItem = [HYItemTool itemWithImage:@"mine-setting-icon" highImage:@"mine-setting-icon" target:self action:@selector(rightClick)];
    _halfHeight = (kScreenHeight) * 0.5 - 64;
    _infoArr = [NSMutableArray array];
    [self setUpUI];
}

-(void)getRequest
{
    [HYHttpTool POST:BaseUrl(selectByid) parameters:@{@"userId":[UserDefaults objectForKey:userId]} success:^(id responseObject) {
        NSArray *data = responseObject[@"pictures"];
        _infoArr = [HYInfoModel mj_objectArrayWithKeyValuesArray:data];
        [_collectionView reloadData];
    } failure:^(NSError *error) {
        
    }];
}

-(void)rightClick
{
    HYInformationViewController *infomation = [[HYInformationViewController alloc] init];
    [self.navigationController pushViewController:infomation animated:YES];
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return _infoArr.count;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    HYInfoModel *model = _infoArr[indexPath.row];
    HYInfoPicCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
    cell.backgroundColor = RandomColor;
    cell.urlStr = model.picturePhoto[0];
    return cell;
}


-(void)setUpUI
{
    self.view.userInteractionEnabled = YES;
    self.view.backgroundColor = [UIColor whiteColor];
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    flowLayout.itemSize = CGSizeMake(cellWH, cellWH);
    flowLayout.headerReferenceSize = CGSizeMake(0, 345);
    flowLayout.minimumLineSpacing = minSpace;
    flowLayout.minimumInteritemSpacing = minSpace;
    _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight) collectionViewLayout:flowLayout];
    _collectionView.delegate = self;
    _collectionView.dataSource = self;
    _collectionView.backgroundColor = [UIColor clearColor];
    [_collectionView registerClass:[HYInfoPicCell class] forCellWithReuseIdentifier:@"cell"];
    _collectionView.clipsToBounds = YES;
    
    UIImage *paint = [UIImage imageNamed:@"paint"];
    _backImage = [[UIImageView alloc] initWithImage:paint];
    _backImage.frame = CGRectMake(0, 0, ScreenWidth, 180);
    _backImage.clipsToBounds = YES;
    _backImage.contentMode = UIViewContentModeScaleToFill;
    _shadowView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 100)];
    _shadowView.backgroundColor = [UIColor colorWithRed:215/255.0 green:215/255.0 blue:215/255.0 alpha:0.8];

    _headerImage = [[UIImageView alloc] initWithFrame:CGRectMake(30, 100, 100, 100)];
    _headerImage.layer.cornerRadius = 50;
    _headerImage.clipsToBounds = YES;
    _headerImage.layer.borderWidth = 2;
    _headerImage.layer.borderColor =[UIColor whiteColor].CGColor;
    _headerImage.userInteractionEnabled = YES;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(setInfo)];
    [_headerImage addGestureRecognizer:tap];
    _headerImage.image = [UIImage imageNamed:@"QQHead"];
    
    _nickName = [[UILabel alloc] initWithFrame:CGRectMake(30, 210, 200, 20)];
    _nickName.text = @"土豆泥err";
    _nickName.textColor = [UIColor blackColor];
    
    _descript = [[UILabel alloc] initWithFrame:CGRectMake(30, 230, ScreenWidth - 60, 50)];
    _descript.font = [UIFont systemFontOfSize:13];
    _descript.numberOfLines = 0;
    _descript.textColor = [UIColor darkGrayColor];
    _descript.text = @"哈哈哈哈哈哈啊哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈啊哈哈哈哈哈哈哈哈哈哈哈哈";
    
    HYCustomButton *collection = [[HYCustomButton alloc] initWithFrame:CGRectMake(20, 280, 60, 60)];
    [collection setTitle1:@"113" Title2:@"关注"];
    
    HYCustomButton *fans = [[HYCustomButton alloc] initWithFrame:CGRectMake(85, 280, 60, 60)];
    [fans setTitle1:@"113" Title2:@"粉丝"];
    
    HYCustomButton *zan = [[HYCustomButton alloc] initWithFrame:CGRectMake(145, 280, 60, 60)];
    [zan setTitle1:@"726" Title2:@"被赞"];
    
    [self.view addSubview:_backImage];
    [self.view addSubview:_shadowView];
    [self.view addSubview:_collectionView];
    [self.collectionView addSubview:_headerImage];
    [self.collectionView addSubview:_nickName];
    [self.collectionView addSubview:_descript];
    [self.collectionView addSubview:collection];
    [self.collectionView addSubview:fans];
    [self.collectionView addSubview:zan];
}

-(void)setInfo{
    NSLog(@"点击了头像");
    
    NSString *str = [UserDefaults objectForKey:isLogin];
    if ([str isEqualToString:@""] || [str isEqualToString:@"NO"] || str == nil) {
        NSLog(@"未登录");
        HYLoginViewController *login = storyboardWith(@"Login", @"HYLoginViewController");
        [self presentViewController:login animated:YES completion:nil];
    }else{
        HYCardViewController *infomation = [[HYCardViewController alloc] initWithNibName:@"HYCardViewController" bundle:nil];
        //    HYCardViewController *infomation = [[HYCardViewController alloc] init];
        self.definesPresentationContext = YES;
        UIColor *color =[UIColor blackColor];
        infomation.view.backgroundColor = [color colorWithAlphaComponent:0.5];
        infomation.modalPresentationStyle = UIModalPresentationOverCurrentContext;
        [self presentViewController:infomation animated:YES completion:nil];
    }
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    CGFloat offY = scrollView.contentOffset.y;
//    NSLog(@"%f",offY);
    _imgs = [HYToolsKit createImageWithColor:[UIColor colorWithWhite:1 alpha:offY/100]];
    [self.navigationController.navigationBar setBackgroundImage:_imgs forBarMetrics:UIBarMetricsDefault];
    if (offY < 0) {
        
        self.backImage.frame = CGRectMake(0, 0, ScreenWidth, 180 - offY);
        self.shadowView.frame = CGRectMake(0, 0, ScreenWidth, 180 - offY);
//        self.shadowView.alpha = 0.8 + (offY * 0.003);
        self.shadowView.alpha = 0.8 + (offY * 0.003);
    }else
    {
        self.backImage.frame = CGRectMake(0, -offY, ScreenWidth, 180 - (offY / 8));
        self.shadowView.frame = CGRectMake(0, -offY, ScreenWidth, 180 - (offY / 8));
    }
    
}

-(void)viewWillAppear:(BOOL)animated
{
//    HYUserModel *model = [UserDefaults objectForKey:userId];
    NSString *str = [UserDefaults objectForKey:isLogin];
    if ([str isEqualToString:@""] || [str isEqualToString:@"NO"] || str == nil) {
        _nickName.text = @"点击头像登录";
        _descript.text = @"";
        _headerImage.image = [UIImage imageNamed:@"QQHead"];
    }else{
        [self getRequest];
        _nickName.text = [UserDefaults objectForKey:userNikename];
        _descript.text = [UserDefaults objectForKey:userInfo];
        [_headerImage sd_setImageWithURL:[NSURL URLWithString:[UserDefaults objectForKey:userHeadimg]] placeholderImage:[HYToolsKit createImageWithColor:RandomColor]];
    }
}

@end
