//
//  DetailsView.m
//  huabi
//
//  Created by teammac3 on 2017/3/29.
//  Copyright © 2017年 ltl. All rights reserved.
//

#import "DetailsView.h"

@interface DetailsView()<UITableViewDataSource,UITableViewDelegate>

//标题
@property(nonatomic,strong)NSArray *titleArr;
//内容
@property(nonatomic,strong)NSArray *contentArr;

@end

@implementation DetailsView

- (instancetype)initWithFrame:(CGRect)frame{
    
    if (self = [super initWithFrame:frame]) {
        
        self.backgroundColor = [UIColor whiteColor];
        self.layer.borderWidth = 1;
        self.layer.borderColor = [UIColor greenColor].CGColor;
        
        _titleArr = @[@"专区名称",@"申请时间",@"地理位置",@"联系人",@"支付状态"];
        
    }
    return self;
}

#pragma mark - 数据的set方法
- (void)setModel:(pend_districtModel *)model{
    
    _model = model;
    
    _contentArr = @[model.name,model.apply_time,model.location,model.linkman,model.pay_status];
    
    
    //创建视图
    [self createView];

}

- (void)setBtnTag:(NSInteger)btnTag{
    
    _btnTag = btnTag;
    
    //支付按钮
    UIButton *confirmButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width-40, 30)];
    confirmButton.center = CGPointMake(self.center.x-20, self.frame.size.height-confirmButton.frame.size.height/2-10);
    confirmButton.backgroundColor = [UIColor colorWithRed:118/255.0 green:202/255.0 blue:39/255.0 alpha:1];
    [confirmButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [confirmButton setTitle:@"马上支付" forState:UIControlStateNormal];
    confirmButton.layer.cornerRadius = 2;
    confirmButton.tag = btnTag;
    [confirmButton addTarget:self action:@selector(confirmButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:confirmButton];
}

#pragma mark - 创建视图
- (void)createView{
    
    UITableView *tableV = [[UITableView alloc] initWithFrame:CGRectMake(10, 0, self.frame.size.width-20, self.frame.size.height-50) style:UITableViewStylePlain];
    tableV.delegate = self;
    tableV.dataSource = self;
    tableV.separatorStyle = UITableViewCellSeparatorStyleNone;
    tableV.scrollEnabled = NO;
    [self addSubview:tableV];
}

#pragma mark - UItableViewDelegate方法
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 5;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cellID"];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"cellID"];
        cell.textLabel.text = self.titleArr[indexPath.row];
        cell.textLabel.font = [UIFont systemFontOfSize:12];
        cell.detailTextLabel.text = self.contentArr[indexPath.row];
        if (indexPath.row == 0) {
            cell.detailTextLabel.font = [UIFont systemFontOfSize:14];
        }else{
            cell.detailTextLabel.font = [UIFont systemFontOfSize:12];
        }
        if (indexPath.row == 4) {
            if ([self.contentArr[indexPath.row] isEqualToString:@"0"]) {
                    cell.detailTextLabel.text = @"未付款";
            }else{
                    cell.detailTextLabel.text = @"";
            }
        }
        
    }
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.row == 0) {
        return 30;
    }
    return 20;
}

#pragma mark - 按钮事件
- (void)confirmButtonAction:(UIButton *)btn{
    
    self.block(btn.tag);
    
}

@end
