//
//  HYEssenceViewController.m
//  study
//
//  Created by hy on 2018/3/28.
//  Copyright © 2018年 hy. All rights reserved.
//

#import "HYEssenceViewController.h"
#import "HYEssenceCell.h"
#import "HYWebViewController.h"

@interface HYEssenceViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic ,strong)UITableView *tableView;

@property (nonatomic ,strong)NSArray *dataArr;

@end

@implementation HYEssenceViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"专题";
    self.view.backgroundColor = [UIColor redColor];
    self.tableView.backgroundColor = [UIColor whiteColor];
    _dataArr = @[
                    @{
                         @"title":@"就算是有经验的摄影师 也会犯的5个小错误",
                         @"imgUrl":@"http://p7mm0t0oh.bkt.clouddn.com/ce2bbFkTBaHyk.jpg",
                         @"url":@"http://p7mm0t0oh.bkt.clouddn.com/123.html",
                         @"userName":@"wish_hy",
                         @"userHeader":@"http://p7mm0t0oh.bkt.clouddn.com/31baabd373.jpg"
                     },
                    @{
                        @"title":@"你是什么类型的摄影师？总有你最擅长的照片",
                        @"imgUrl":@"http://p7mm0t0oh.bkt.clouddn.com/cexVLqQmmiLM.jpg",
                        @"url":@"http://p7mm0t0oh.bkt.clouddn.com/2344.html",
                        @"userName":@"wish_hy",
                        @"userHeader":@"http://p7mm0t0oh.bkt.clouddn.com/31baabd373.jpg"
                        },
                    @{
                        @"title":@"对光影的巧妙运用 拍出不一样的光影大片",
                        @"imgUrl":@"http://p7mm0t0oh.bkt.clouddn.com/ceFz3hOgkvtQ.jpg",
                        @"url":@"http://p7mm0t0oh.bkt.clouddn.com/234242.html",
                        @"userName":@"wish_hy",
                        @"userHeader":@"http://p7mm0t0oh.bkt.clouddn.com/31baabd373.jpg"
                        }
                 ];
}


#pragma mark --- tableViewDelegate
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _dataArr.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *dic = _dataArr[indexPath.row];
    HYEssenceCell *cell = [HYEssenceCell creatCellInTableView:tableView];
    [cell.titleImg sd_setImageWithURL:dic[@"imgUrl"]];
    cell.title.text = dic[@"title"];
    [cell.userImg sd_setImageWithURL:dic[@"userHeader"]];
    cell.userName.text = dic[@"userName"];
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *dic = _dataArr[indexPath.row];
    HYWebViewController *webView = [[HYWebViewController alloc] init];
    webView.urls = dic[@"url"];
    webView.webTitle = dic[@"userName"];
    [self.navigationController pushViewController:webView animated:YES];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 120;
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

@end
