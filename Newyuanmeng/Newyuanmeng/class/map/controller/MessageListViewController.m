//
//  MessageListViewController.m
//  huabi
//
//  Created by hy on 2018/1/30.
//  Copyright © 2018年 ltl. All rights reserved.
//

#import "MessageListViewController.h"
#import "Newyuanmeng-Swift.h"
#import "ShopChatViewController.h"
#import "RongYunListCell.h"
#import "SystemMessageViewController.h"

@interface MessageListViewController ()
@property (nonatomic, strong) NSArray *iconArr;
@property (nonatomic, strong) NSArray *titleArr;
@property (nonatomic, strong) NSArray *colorArr;
@end

@implementation MessageListViewController

-(id)init
{
    self = [super init];
    if (self) {
        //设置需要显示哪些类型的会话
        [self setDisplayConversationTypes:@[@(ConversationType_PRIVATE),
                                            @(ConversationType_DISCUSSION),
                                            @(ConversationType_CHATROOM),
                                            @(ConversationType_GROUP),
                                            @(ConversationType_APPSERVICE),
                                            @(ConversationType_SYSTEM)]];
        //设置需要将哪些类型的会话在会话列表中聚合显示
//        [self setCollectionConversationType:@[@(ConversationType_DISCUSSION),
//                                              @(ConversationType_GROUP)]];
    }
    return self;
}



- (CGFloat)rcConversationListTableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 70;
}

#pragma mark - 设置cell的删除事件
- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath{
    RCConversationModel *model = [self.conversationListDataSource objectAtIndex:indexPath.row];
    if(model.conversationModelType == RC_CONVERSATION_MODEL_TYPE_CUSTOMIZATION){
        return UITableViewCellEditingStyleNone;
    }else{
        return UITableViewCellEditingStyleDelete;
    }
}

#pragma mark - 修改cell样式
- (void)willDisplayConversationTableCell:(RCConversationBaseCell *)cell atIndexPath:(NSIndexPath *)indexPath{
    RCConversationModel *model = [self.conversationListDataSource objectAtIndex:indexPath.row];
    if(model.conversationModelType != RC_CONVERSATION_MODEL_TYPE_CUSTOMIZATION){
        RCConversationCell *RCcell = (RCConversationCell *)cell;
        RCcell.conversationTitle.font = [UIFont fontWithName:@"PingFangSC-Light" size:18];
        RCcell.messageContentLabel.font = [UIFont fontWithName:@"PingFangSC-Light" size:16];
        RCcell.messageCreatedTimeLabel.font = [UIFont fontWithName:@"PingFangSC-Light" size:14];
    }
}

#pragma mark - 自定义cell
- (RCConversationBaseCell *)rcConversationListTableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    RongYunListCell *cell = [tableView dequeueReusableCellWithIdentifier:@"RongYunListCell"];
    if (!cell) {
        cell = [[[NSBundle mainBundle]loadNibNamed:@"RongYunListCell" owner:self options:nil] firstObject];
//        cell.ListOneCount.hidden = YES;
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
//    NSInteger count = 0;
//    if(indexPath.row < _badgeValueArr.count){
//        count = [_badgeValueArr[indexPath.row] integerValue];
//    }
//    if(count>0){
//        cell.ListOneCount.hidden = NO;
//        cell.ListOneCount.text = [NSString stringWithFormat:@"%ld",count];
//    }else{
//        cell.ListOneCount.hidden = YES;
//    }
//    RCConversationModel *model = self.conversationListDataSource[indexPath.row];
//    [cell setRongYunListCellOneUIViewWithModel:model iconName:_iconArr[indexPath.row]];
    cell.imageV.backgroundColor = [UIColor colorWithHexString:_colorArr[indexPath.row]];
    cell.imageV.image = [UIImage iconWithInfo:TBCityIconInfoMake(_iconArr[indexPath.row], 30,[UIColor whiteColor])];
    cell.type.text = _titleArr[indexPath.row];
    return cell;
}

#pragma mark - cell选中事件
- (void)onSelectedTableRow:(RCConversationModelType)conversationModelType conversationModel:(RCConversationModel *)model atIndexPath:(NSIndexPath *)indexPath{
    [self.conversationListTableView deselectRowAtIndexPath:indexPath animated:YES];
    if(model.conversationModelType == RC_CONVERSATION_MODEL_TYPE_CUSTOMIZATION){
        NSString *cellTitle = model.conversationTitle;
        if([cellTitle isEqualToString:@"系统消息"]){
            NSLog(@"系统消息");
            SystemMessageViewController *message = [[SystemMessageViewController alloc] init];
            message.titleStr = @"系统消息";
            message.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:message animated:YES];
            //系统消息
//            NewsSystemSecondViewController *svc = [[NewsSystemSecondViewController alloc]init];
//            svc.hidesBottomBarWhenPushed = YES;
//            [self.navigationController pushViewController:svc animated:YES];
        }else if ([cellTitle isEqualToString:@"客服消息"]){
            //评论
            NSLog(@"客服消息");
            SystemMessageViewController *message = [[SystemMessageViewController alloc] init];
            message.titleStr = @"客服消息";
            message.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:message animated:YES];
//            SystemCommentViewController *svc = [[SystemCommentViewController alloc]init];
//            svc.hidesBottomBarWhenPushed = YES;
//            [self.navigationController pushViewController:svc animated:YES];
        }
//        else if ([cellTitle isEqualToString:@"点赞"]){
//            //点赞
//            ClickLinckedViewController *svc = [[ClickLinckedViewController alloc]init];
//            svc.hidesBottomBarWhenPushed = YES;
//            [self.navigationController pushViewController:svc animated:YES];
//        }else if ([cellTitle isEqualToString:@"访客"]){
//            //访客
//            MyVistorsViewController *svc = [[MyVistorsViewController alloc]init];
//            svc.hidesBottomBarWhenPushed = YES;
//            [self.navigationController pushViewController:svc animated:YES];
//        }
    }else{
        //会话列表

        ShopChatViewController *conversationVC = [[ShopChatViewController alloc]init];
        conversationVC.conversationType = model.conversationType;
        conversationVC.targetId = model.targetId;
        ////        conversationVC.title = [self getUserNameWithUserID:model.targetId];
        conversationVC.title =@"";
        [self.navigationController pushViewController:conversationVC animated:YES];
    }
}


- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"我的消息";
    self.conversationListTableView.tableFooterView = [[UIView alloc]init];
    [self.navigationController.navigationBar setBackgroundImage:[self createImageWithColor:[UIColor colorWithHexString:@"#F2794E"]] forBarMetrics:UIBarMetricsDefault];
    self.navigationItem.titleView.tintColor = [UIColor whiteColor];
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:17],NSForegroundColorAttributeName:[UIColor whiteColor]}];
}
         
-(NSMutableArray *)willReloadTableData:(NSMutableArray *)dataSource
{
    _titleArr = @[@"系统消息",@"客服消息"];
    _iconArr = @[@"\U0000e644",@"\U0000e646"];
    _colorArr = @[@"#4ED1FF",@"#91A8FF"];
    for (int i = 0; i<_titleArr.count; i++) {
        RCConversationModel *model = [[RCConversationModel alloc]init];
        model.conversationModelType = RC_CONVERSATION_MODEL_TYPE_CUSTOMIZATION;
        model.conversationTitle = _titleArr[i];
        model.isTop = YES;
        [dataSource insertObject:model atIndex:i];
    }
    return dataSource;
}


- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self refreshConversationTableViewIfNeeded];
    [self.navigationController setNavigationBarHidden:NO animated:NO];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    [self.navigationController setNavigationBarHidden:YES animated:NO];
}

#pragma mark 颜色转换为图片

- (UIImage*)createImageWithColor:(UIColor*)color{
    
    CGRect rect = CGRectMake(0.0f,0.0f,1.0f,1.0f);UIGraphicsBeginImageContext(rect.size);
    
    CGContextRef context=UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [color CGColor]);
    
    CGContextFillRect(context, rect);
    
    UIImage *theImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return theImage;
    
}

@end
