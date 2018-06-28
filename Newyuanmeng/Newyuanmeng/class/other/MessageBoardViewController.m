//
//  MessageBoardViewController.m
//  ZhongShengHealth
//
//  Created by teammac3 on 2017/12/27.
//  Copyright © 2017年 Mr.Xiao. All rights reserved.
//

#import "MessageBoardViewController.h"
#import "Newyuanmeng-Swift.h"
#import "RCDLiveKitCommonDefine.h"
#import <AFNetworking/AFNetworking.h>

//#import "AFHTTPRequestOperationManager.h"
#import <CommonCrypto/CommonDigest.h>
#import "RCDLive.h"
#import "RCDLiveMessageModel.h"
#import "RCDLiveGiftMessage.h"
#import "RCDLiveKitUtility.h"

@interface MessageBoardViewController ()<UITableViewDelegate,UITableViewDataSource,UITextViewDelegate,RCConnectionStatusChangeDelegate>
@property (nonatomic , strong) UITableView *chatTableView;
@property (nonatomic , strong) UITextView *textView;
@property (nonatomic , strong) UIButton *sendBtn;
@property (nonatomic , strong) NSMutableArray *messageArr;
@property (nonatomic , strong) UIView *inputView;
@property (nonatomic , assign) UIView *bgvView;
@property (nonatomic , assign) UIView *naviView;
@property (nonatomic , strong) NSString *lastSectionName;
/*!
 当前会话的会话类型
 */
@property(nonatomic) RCConversationType conversationType;

/*!
 播放内容地址
 */
@property(nonatomic, strong) NSString *contentURL;
@end

@implementation MessageBoardViewController

//- (void)viewDidLoad {
//    [super viewDidLoad];
//
//    self.view.backgroundColor = [UIColor whiteColor];
//    self.title = _model.shop_name;
//    self.messageArr = [[NSMutableArray alloc] init];
//    self.lastSectionName = @"";
//    [self createUI];
//    
//    
//    // Do any additional setup after loading the view.
//}
//
//
//
//
//#pragma 点击发送文字
//- (void)sendMessageAction:(UIButton *)sender
//{
//    // 发送文字
//    //int x = arc4random() % 100; // 随机出现模拟发送或接收
//     RCTextMessage *rcTextMessage = [RCTextMessage messageWithContent:self.textView.text];
//    [self sendMessage:rcTextMessage pushContent:nil];
//    [self.inputView.superview layoutIfNeeded];
//    [UIView animateWithDuration:0.3 animations:^{
//        [self.inputView mas_updateConstraints:^(MASConstraintMaker *make) {
//            make.height.mas_equalTo(60);
//        }];
//        [self.inputView.superview layoutIfNeeded];//强制绘制
//    }];
//    self.textView.text = @"";
//  //  NSDictionary *msgDict = [NSDictionary dictionaryWithObjectsAndKeys:x % 2 ? @"me" : @"she", @"name", _textView.text, @"content", nil];
//}
//
//-(NSString *)getNowTimeTimestamp{
//    NSDateFormatter *formatter = [[NSDateFormatter alloc] init] ;
//    
//    [formatter setDateStyle:NSDateFormatterMediumStyle];
//    
//    [formatter setTimeStyle:NSDateFormatterShortStyle];
//    
//    [formatter setDateFormat:@"YYYY-MM-dd HH:mm:ss"]; // ----------设置你想要的格式,hh与HH的区别:分别表示12小时制,24小时制
//    
//    //设置时区,这个对于时间的处理有时很重要
//    
//    NSTimeZone* timeZone = [NSTimeZone timeZoneWithName:@"Asia/Shanghai"];
//    
//    [formatter setTimeZone:timeZone];
//    
//    NSDate *datenow = [NSDate date];//现在时间,你可以输出来看下是什么格式
//    
//    NSString *timeSp = [NSString stringWithFormat:@"%ld", (long)[datenow timeIntervalSince1970]];
//    
//    return timeSp;
//    
//}
//
//- (void)viewWillAppear:(BOOL)animated{
//    self.navigationController.navigationBar.hidden = NO;
//    [self.navigationController setNavigationBarHidden:YES];
//    
//    // 注册键盘通知
//    //监听键盘出现和消失
//    [[NSNotificationCenter defaultCenter]addObserver:self
//                                            selector:@selector(keyboardWillShow:)
//                                                name:UIKeyboardWillShowNotification object:nil]; //使用通知系统会自动移动需要移动的控件
//    [[NSNotificationCenter defaultCenter]addObserver:self
//                                            selector:@selector(keyboardWillHide:)
//                                                name:UIKeyboardWillHideNotification object:nil];
//    [self registerNotification]; //注册融云的通知
//    [[RCIMClient sharedRCIMClient] setRCConnectionStatusChangeDelegate:self];
//    [self loginRongCloud]; //获取历史信息
//}
//
//- (void)viewWillDisappear:(BOOL)animated{
//    [[NSNotificationCenter defaultCenter] removeObserver:self];
//    [[RCIMClient sharedRCIMClient] logout];
//}
//
///**
// *  注册监听Notification
// */
//- (void)registerNotification {
//    //注册接收消息
//    [[NSNotificationCenter defaultCenter]
//     addObserver:self
//     selector:@selector(didReceiveMessageNotification:)
//     name:RCDLiveKitDispatchMessageNotification
//     object:nil];
//}
//
//#pragma mark -- 注册融云
///**
// *登录融云，这里只是为了演示所以直接调融云的server接口获取token来登录，为了您的app安全，这里建议您通过你们自己的服务端来获取token。
// *
// */
//-(void)loginRongCloud
//{
//    NSLog(@"mytok,en:%@",CommonConfig.UserInfoCache.rongyun_token);
//    __weak __typeof(&*self)weakSelf = self;
//    [[RCDLive sharedRCDLive] connectRongCloudWithToken:CommonConfig.UserInfoCache.rongyun_token success:^(NSString *userId) {
//        dispatch_async(dispatch_get_main_queue(), ^{
//            RCUserInfo *user = [[RCUserInfo alloc] init];
//            user.userId = userId;
//            user.portraitUri = [NSString stringWithFormat:@"%@",CommonConfig.UserInfoCache.photo];
//            user.name = CommonConfig.UserInfoCache.nickName;
//            [RCIMClient sharedRCIMClient].currentUserInfo = user;
//            weakSelf.conversationType = ConversationType_PRIVATE;
//            //聊天室类型进入时需要调用加入聊天室接口，退出时需要调用退出聊天室接口
//            if (ConversationType_PRIVATE == self.conversationType) {
//               NSArray *arr =  [[RCIMClient sharedRCIMClient] getHistoryMessages:weakSelf.conversationType targetId:self.targetId oldestMessageId:-1 count:10];
//                [self.messageArr addObjectsFromArray:arr];
//                [self.chatTableView reloadData];
//            }
//        });
//    } error:^(RCConnectErrorCode status) {
//        dispatch_async(dispatch_get_main_queue(), ^{
//            NSLog(@"错误code：%ld",status);
//            NSLog(@"未知错误");
//            
//        });
//    } tokenIncorrect:^{
//        dispatch_async(dispatch_get_main_queue(), ^{
//            
//            
//            NSLog(@"token错误");
//        });
//    }];
//}
//
//
///*!
// 发送消息(除图片消息外的所有消息)
// 
// @param messageContent 消息的内容
// @param pushContent    接收方离线时需要显示的远程推送内容
// 
// @discussion 当接收方离线并允许远程推送时，会收到远程推送。
// 远程推送中包含两部分内容，一是pushContent，用于显示；二是pushData，用于携带不显示的数据。
// 
// SDK内置的消息类型，如果您将pushContent置为nil，会使用默认的推送格式进行远程推送。
// 自定义类型的消息，需要您自己设置pushContent来定义推送内容，否则将不会进行远程推送。
// 
// 如果您需要设置发送的pushData，可以使用RCIM的发送消息接口。
// */
//- (void)sendMessage:(RCMessageContent *)messageContent
//        pushContent:(NSString *)pushContent {
//    if (_targetId == nil) {
//        return;
//    }
//    messageContent.senderUserInfo = [RCDLive sharedRCDLive].currentUserInfo;
//    if (messageContent == nil) {
//        return;
//    }
//
//    [[RCDLive sharedRCDLive] sendMessage:self.conversationType
//                                targetId:self.targetId
//                                 content:messageContent
//                             pushContent:pushContent
//                                pushData:nil
//                                 success:^(long messageId) {
//                                     __weak typeof(&*self) __weakself = self;
//                                     dispatch_async(dispatch_get_main_queue(), ^{
//                                         RCMessage *message = [[RCMessage alloc] initWithType:__weakself.conversationType
//                                                                                     targetId:__weakself.targetId
//                                                                                    direction:MessageDirection_SEND
//                                                                                    messageId:messageId
//                                                                                      content:messageContent];
//                                         if ([message.content isMemberOfClass:[RCDLiveGiftMessage class]] ) {
//                                             message.messageId = -1;//插入消息时如果id是-1不判断是否存在
//                                         }
//                                         
//                                         [__weakself appendAndDisplayMessage:message];
//                                         
//                                     });
//                                 } error:^(RCErrorCode nErrorCode, long messageId) {
//                                     [[RCIMClient sharedRCIMClient]deleteMessages:@[ @(messageId) ]];
//                                 }];
//    
//}
///**
// *  将消息加入本地数组
// *
// *
// */
//- (void)appendAndDisplayMessage:(RCMessage *)rcMessage {
//    if (!rcMessage) {
//        return;
//    }
//    RCDLiveMessageModel *model = [[RCDLiveMessageModel alloc] initWithMessage:rcMessage];
//    if([rcMessage.content isMemberOfClass:[RCDLiveGiftMessage class]]){
//        model.messageId = -1;
//    }
//    if ([self appendMessageModel:model]) {
//        NSIndexPath *indexPath =
//        [NSIndexPath indexPathForItem:0
//                            inSection:self.messageArr.count-1];
//        NSIndexSet *indexSet = [NSIndexSet indexSetWithIndex:self.messageArr.count - 1];
//        [self.chatTableView insertSections:indexSet withRowAnimation:UITableViewRowAnimationLeft];
//       // [self.chatTableView insertRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationLeft];
//        
//        [self.chatTableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionBottom animated:YES];
//        
//    }
//}
//
///**
// *  如果当前会话没有这个消息id，把消息加入本地数组
// *
// *
// */
//- (BOOL)appendMessageModel:(RCDLiveMessageModel *)model {
//    long newId = model.messageId;
//    for (RCDLiveMessageModel *__item in self.messageArr) {
//        /*
//         * 当id为－1时，不检查是否重复，直接插入
//         * 该场景用于插入临时提示。
//         */
//        if (newId == -1) {
//            break;
//        }
//        if (newId == __item.messageId) {
//            return NO;
//        }
//    }
//    if (!model.content) {
//        return NO;
//    }
//    //这里可以根据消息类型来决定是否显示，如果不希望显示直接return NO
//    
//    //数量不可能无限制的大，这里限制收到消息过多时，就对显示消息数量进行限制。
//    //用户可以手动下拉更多消息，查看更多历史消息。
//    if (self.messageArr.count>100) {
//        //                NSRange range = NSMakeRange(0, 1);
//        RCDLiveMessageModel *message = self.messageArr[0];
//        [[RCIMClient sharedRCIMClient] deleteMessages:@[@(message.messageId)]];
//        [self.messageArr removeObjectAtIndex:0];
//        NSIndexPath *firstIndexPath = [NSIndexPath indexPathForRow:0 inSection:0];
//        [self.chatTableView deleteRowsAtIndexPaths:@[firstIndexPath] withRowAnimation:UITableViewRowAnimationNone];
//        
//    }
//    [self.messageArr addObject:model];
//    
//    return YES;
//}
//
//
///**
// *  接收到消息的回调
// *
// *
// */
//- (void)didReceiveMessageNotification:(NSNotification *)notification {
//    __block RCMessage *rcMessage = notification.object;
//    RCDLiveMessageModel *model = [[RCDLiveMessageModel alloc] initWithMessage:rcMessage];
//    NSDictionary *leftDic = notification.userInfo;
//    if (leftDic && [leftDic[@"left"] isEqual:@(0)]) {
//        //self.isNeedScrollToButtom = YES;
//    }
//    if (model.conversationType == self.conversationType &&
//        [model.targetId isEqual:self.targetId]) {
//        __weak typeof(&*self) __blockSelf = self;
//        dispatch_async(dispatch_get_main_queue(), ^{
//            if (rcMessage) {
//                [__blockSelf appendAndDisplayMessage:rcMessage];
//                UIMenuController *menu = [UIMenuController sharedMenuController];
//                menu.menuVisible=NO;
//                //如果消息不在最底部，收到消息之后不滚动到底部，加到列表中只记录未读数
//                //                if (![self isAtTheBottomOfTableView]) {
//                //                    self.unreadNewMsgCount ++ ;
//                //                    [self updateUnreadMsgCountLabel];
//                //                }
//            }
//        });
//    }
//}
//
///**
// *  加入聊天室失败的提示
// *
// *  @param title 提示内容
// */
//- (void)loadErrorAlert:(NSString *)title {
//    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:title message:nil preferredStyle:UIAlertControllerStyleAlert];
//    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
//        [self.navigationController popViewControllerAnimated:YES];
//    }];
//    [alertController addAction:cancelAction];
//    [self presentViewController:alertController animated:YES completion:nil];
//}
//
//
//#pragma mark - 列表代理
//- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    NSString *messageText;
//    RCDLiveMessageModel *model = self.messageArr[indexPath.section];
//    RCMessageContent *messageContent = model.content;
//    if ([messageContent isMemberOfClass:[RCTextMessage class]]){
//        RCTextMessage *notification = (RCTextMessage *)messageContent;
//        NSString *localizedMessage = [RCDLiveKitUtility formatMessage:notification];
//        messageText = localizedMessage;
//        
//    }
//    if (messageText == nil) {
//        messageText = @"";
//    }
//    
//    UIFont *font = [UIFont systemFontOfSize:14];
//     CGRect size = [messageText boundingRectWithSize:CGSizeMake(ScreenWidth-145*ScaleWidth-70, 20000.0f) options:NSStringDrawingUsesLineFragmentOrigin  attributes:@{NSFontAttributeName : font} context:nil];
//    NSLog(@"width:%f",size.size.width);
//    NSLog(@"sdfsd:%f",ScreenWidth-145*ScaleWidth-60);
//    NSLog(@"height:%f",size.size.height);
//    if (size.size.height > 50) {
//        return size.size.height - 50 + 200*ScaleHeight ;
//    }
//    return  165*ScaleHeight;
//}
//
//- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
//{
//    return 1;
//}
//- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
//   return self.messageArr.count;
//}
//
//- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
//    return nil;
//}
//- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
//    return 0.01;
//}
////- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
////    RCDLiveMessageModel *model = self.messageArr[section];
////    NSString *dateString =[self timeWithTimeIntervalString:[NSString stringWithFormat:@"%lld",model.sentTime] withFormat:@"yy-MM-dd"];
////    if (![self.lastSectionName isEqualToString:dateString]) {
////        return 100*ScaleHeight;
////    }
////    return 0.01;
////}
////- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
////    RCDLiveMessageModel *model = self.messageArr[section];
////    NSString *dateString =[self timeWithTimeIntervalString:[NSString stringWithFormat:@"%lld",model.sentTime] withFormat:@"yy-MM-dd"];
////    if (![self.lastSectionName isEqualToString:dateString]) {
////        UIView *view = [UIView new];
////        UILabel *label = [UILabel new];
////        label.text = dateString;
////        label.textColor =  [UIColor colorWithHexString:@"#333333"];
////        label.font = [UIFont systemFontOfSize:24*ScaleWidth];
////        label.layer.borderColor = [UIColor colorWithHexString:@"#999999"].CGColor;
////        label.layer.borderWidth = 0.3;
////        label.layer.cornerRadius = 21/2;
////        label.textAlignment = NSTextAlignmentCenter;
////        [view addSubview:label];
////        [label mas_makeConstraints:^(MASConstraintMaker *make) {
////            make.centerX.mas_equalTo(view.mas_centerX);
////            make.centerY.mas_equalTo(view.mas_centerY);
////            make.height.mas_equalTo(21);
////            make.width.mas_equalTo(150*ScaleWidth);
////        }];
////        UIView *line = [UIView new];
////        line.backgroundColor = [UIColor colorWithWhite:0.8 alpha:0.6];
////        [view addSubview:line];
////        [line mas_makeConstraints:^(MASConstraintMaker *make) {
////            make.centerY.mas_equalTo(label.mas_centerY);
////            make.left.mas_equalTo(view.mas_left).mas_offset(50*ScaleWidth);
////            make.right.mas_equalTo(label.mas_left).mas_equalTo(-20*ScaleWidth);
////            make.height.mas_equalTo(1);
////        }];
////
////        UIView *line1 = [UIView new];
////        line1.backgroundColor = [UIColor colorWithWhite:0.8 alpha:0.6];
////        [view addSubview:line1];
////        [line1 mas_makeConstraints:^(MASConstraintMaker *make) {
////            make.centerY.mas_equalTo(label.mas_centerY);
////            make.left.mas_equalTo(label.mas_right).mas_offset(20*ScaleWidth);
////            make.right.mas_equalTo(view.mas_right).mas_equalTo(-50*ScaleWidth);
////            make.height.mas_equalTo(1);
////        }];
////        self.lastSectionName = dateString;
////        return view;
////    }
////    return nil;
////}
//
//
//
//- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    static NSString *cellIdentifier = @"MessageBoardCell";
//    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
//    if (cell == nil)
//    {
//        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
//    }
//    // 添加每条消息
//    for (UIView *view in cell.contentView.subviews)
//    {
//        [view removeFromSuperview];
//    }
//    cell.backgroundColor = [UIColor clearColor];
//    cell.contentView.backgroundColor = [UIColor clearColor];
//    NSString *messageText;
//    BOOL isMe = false;
//    RCDLiveMessageModel *model = self.messageArr[indexPath.section];
//    RCMessageContent *messageContent = model.content;
//    NSString *headURL;
//    if ([messageContent isMemberOfClass:[RCTextMessage class]]){
//        RCTextMessage *notification = (RCTextMessage *)messageContent;
//        NSString *localizedMessage = [RCDLiveKitUtility formatMessage:notification];
//        messageText = localizedMessage;
//        if ([notification.senderUserInfo.userId integerValue] == CommonConfig.UserInfoCache.userId) {
//            isMe = YES;
//        }else{
//            isMe = NO;
//        }
//        headURL = notification.senderUserInfo.portraitUri;
//    }
//    if (messageText == nil) {
//        messageText = @"";
//    }
//    UIFont *textFont = [UIFont systemFontOfSize:14];
//    // 根据字符长度去限制size
//    CGRect textSize =  [messageText boundingRectWithSize:CGSizeMake(ScreenWidth-145*ScaleWidth-70, 20000.0f) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName : textFont} context:nil];
//    UIImageView *avatar;
//    UILabel *timeLabel = [UILabel new];
////    timeLabel.text = [self timeWithTimeIntervalString:[NSString stringWithFormat:@"%lld",model.sentTime] withFormat:@"HH:mm"];
//    timeLabel.font = [UIFont systemFontOfSize:24*ScaleWidth];
//    timeLabel.textColor = [UIColor colorWithHexString:@"#333333"];
//    timeLabel.textAlignment = NSTextAlignmentCenter;
//    [cell.contentView addSubview:timeLabel];
//    if (isMe)
//    {
//   
//        avatar = [[UIImageView alloc] init];
//        [avatar sd_setImageWithURL:CommonConfig.UserInfoCache.photo];
//        
//        avatar.frame = CGRectMake(tableView.frame.size.width - 10 - 50, 0, 50, 50);
//
//        avatar.layer.cornerRadius = 25;
//        avatar.clipsToBounds = YES;
//        [cell addSubview:avatar];
//      
//        UIImage *bubbleImg = [UIImage imageNamed:@"形状-1-副本"];
//        UIImageView *bubbleImageView = [[UIImageView alloc] initWithImage:bubbleImg];
//        
//        UILabel *bubbleTextLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 5, textSize.size.width + 10, textSize.size.height + 20)];
//        bubbleTextLabel.backgroundColor = [UIColor clearColor];
//        bubbleTextLabel.font = textFont;
//        bubbleTextLabel.numberOfLines = 0; // 这句很关键
//        bubbleTextLabel.lineBreakMode = NSLineBreakByWordWrapping;
//        bubbleTextLabel.text = messageText;
//        bubbleTextLabel.textAlignment = NSTextAlignmentLeft;
//        [bubbleImageView addSubview:bubbleTextLabel];
//        [bubbleTextLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//
//            make.top.mas_equalTo(bubbleImageView.mas_top).mas_equalTo(6*ScaleHeight);
//            make.left.mas_equalTo(bubbleImageView.mas_left).mas_equalTo(25*ScaleWidth);
//            make.right.mas_equalTo(bubbleImageView.mas_right).mas_equalTo(-20*ScaleWidth);
//            make.bottom.mas_equalTo(bubbleImageView.mas_bottom).mas_equalTo(-6*ScaleWidth);
//        }];
//
//
//        [cell.contentView addSubview:bubbleImageView];
//        [bubbleImageView mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.right.mas_equalTo(avatar.mas_left).mas_equalTo(-25*ScaleWidth);
//            make.centerY.mas_equalTo(avatar.mas_centerY);
//            make.height.mas_equalTo(textSize.size.height + 40*ScaleHeight);
//            if (textSize.size.width < ScreenWidth-145*ScaleWidth-60) {
//                make.width.mas_equalTo(textSize.size.width + 60*ScaleWidth);
//            }else{
//                make.left.mas_equalTo(cell.mas_left).mas_equalTo(50*ScaleWidth);
//            }
//        }];
//        
//        [timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.centerY.mas_equalTo(cell.contentView.mas_centerY);
//            make.right.mas_equalTo(bubbleImageView.mas_left).mas_equalTo(-10*ScaleWidth);
//        }];
//      
//    }
//    else
//    {
//        // 创建头像
//        avatar = [[UIImageView alloc] init];
//        [avatar sd_setImageWithURL:[NSURL URLWithString:headURL]];
//        avatar.frame = CGRectMake(10, 0, 50, 50);
//        [cell.contentView addSubview:avatar];
//        
//        // 文字信息
//        UIImage *bubbleImg = [UIImage imageNamed:@"形状-1"];
//        UIImageView *bubbleImageView = [[UIImageView alloc] initWithImage:bubbleImg];
//        
//        UILabel *bubbleTextLabel = [[UILabel alloc] initWithFrame:CGRectMake(30, 5, textSize.size.width + 10, textSize.size.height + 10)];
//        bubbleTextLabel.backgroundColor = [UIColor clearColor];
//        bubbleTextLabel.font = textFont;
//        bubbleTextLabel.numberOfLines = 0; // 这句很关键
//        bubbleTextLabel.lineBreakMode = NSLineBreakByWordWrapping;
//        bubbleTextLabel.text = messageText;
//        bubbleTextLabel.textAlignment = NSTextAlignmentLeft;
//        [bubbleImageView addSubview:bubbleTextLabel];
//        [bubbleTextLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.top.mas_equalTo(bubbleImageView.mas_top);
//            make.left.mas_equalTo(bubbleImageView.mas_left).mas_equalTo(20*ScaleWidth);
//            make.right.mas_equalTo(bubbleImageView.mas_right).mas_equalTo(-25*ScaleWidth);
//            make.bottom.mas_equalTo(bubbleImageView.mas_bottom);
//        }];
//        [cell.contentView addSubview:bubbleImageView];
//        [bubbleImageView mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.left.mas_equalTo(avatar.mas_right).mas_equalTo(25*ScaleWidth);
//
//            make.top.mas_equalTo(cell.mas_top).mas_equalTo(6*ScaleHeight);
//            make.height.mas_equalTo(textSize.size.height + 26*ScaleHeight);
//            if (textSize.size.width < ScreenWidth-124*ScaleWidth-60) {
//                make.width.mas_equalTo(textSize.size.width + 60*ScaleWidth);
//            }else{
//                make.right.mas_equalTo(cell.mas_right).mas_equalTo(-50*ScaleWidth);
//            }
//        }];
//        
//        [timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.centerY.mas_equalTo(cell.contentView.mas_centerY);
//            make.left.mas_equalTo(bubbleImageView.mas_right).mas_equalTo(10*ScaleWidth);
//        }];
//    }
//
////    avatar.layer.borderWidth = 0.3;
////    avatar.layer.cornerRadius = 25;
//   // avatar.layer.masksToBounds = YES;
////    avatar.layer.borderColor = [UIColor colorWithRed:229/250.0 green:228/255.0 blue:230/255.0 alpha:1].CGColor;
////    nameLabel.textColor = [UIColor colorWithHexString:@"#666666"];
////    nameLabel.font = [UIFont systemFontOfSize:12];
////    nameLabel.numberOfLines = 1;
////    nameLabel.textAlignment = NSTextAlignmentCenter;
////    [cell addSubview:nameLabel];
////    [nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
////        make.top.mas_equalTo(avatar.mas_bottom).mas_equalTo(10*ScaleHeight);
////        make.centerX.mas_equalTo(avatar.mas_centerX);
////        make.right.left.mas_equalTo(avatar);
////    }];
//    
//    return cell;
//}
//
//
//-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
//{
//    return @"";
//}
//
//#pragma mark - 编辑框代理
//- (void)textViewDidBeginEditing:(UITextView *)textView
//{
//    // 开始输文字，就把列表上移
//    textView.text = @"";
//}
//
//
//- (void)textViewDidEndEditing:(UITextView *)textView
//{
//  
//}
//- (void)textViewDidChange:(UITextView *)textView
//{
//    if (textView.text.length > 0) {
//        self.sendBtn.enabled = YES;
//        self.sendBtn.alpha = 1;
//    }else{
//        self.sendBtn.enabled = NO;
//        self.sendBtn.alpha = 0.6;
//    }
//    [textView scrollRangeToVisible:NSMakeRange(textView.text.length, 1)];
//}
//
//- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
//    return YES;
//}
//
//#pragma mark - 键盘通知
//-(void)keyboardWillShow:(NSNotification *)notification
//{
//    
//    
//    //获取键盘的高度
//    NSDictionary *userInfo = [notification userInfo];
//    NSValue *aValue = [userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
//    CGRect keyboardRect = [aValue CGRectValue];
//    int height = keyboardRect.size.height;
//        [self.inputView.superview layoutIfNeeded];
//        [UIView animateWithDuration:0.3 animations:^{
//            [self.inputView mas_updateConstraints:^(MASConstraintMaker *make) {
//                make.bottom.mas_equalTo(self.inputView.superview.mas_bottom).mas_equalTo(-height);
//            }];
//        }];
//    [self.inputView.superview layoutIfNeeded];//强制绘制
//    if (self.messageArr.count > 0) {
//          [self.chatTableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:self.messageArr.count-1] atScrollPosition:UITableViewScrollPositionBottom animated:NO];
//    }
//  
//}
//
//-(void)keyboardWillHide:(NSNotification *)notification
//{
//
//    // 收起键盘，列表
//    [self.inputView.superview layoutIfNeeded];//强制绘制
//        [UIView animateWithDuration:0.3 animations:^{
//            [self.inputView mas_updateConstraints:^(MASConstraintMaker *make) {
//                make.bottom.mas_equalTo(self.inputView.superview.mas_bottom);
//            }];
//            
//        }];
//    [self.inputView.superview layoutIfNeeded];//强制绘制
//    if (self.messageArr.count > 0) {
//        [self.chatTableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:self.messageArr.count-1] atScrollPosition:UITableViewScrollPositionBottom animated:NO];
//    }
//}
//
//#pragma mark - 触摸响应
//- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
//{
//    [self.view endEditing:YES];
//    [self.textView resignFirstResponder];
//}
//
//#pragma mark -- 融云代理方法
//
//
//- (void)onConnectionStatusChanged:(RCConnectionStatus)status {
//    NSLog(@"10");
//}
//
//- (void)encodeWithCoder:(nonnull NSCoder *)aCoder {
//    NSLog(@"11");
//}
//
//- (void)traitCollectionDidChange:(nullable UITraitCollection *)previousTraitCollection {
//    NSLog(@"12");
//}
//
//- (void)preferredContentSizeDidChangeForChildContentContainer:(nonnull id<UIContentContainer>)container {
//    NSLog(@"13");
//}
//
//- (CGSize)sizeForChildContentContainer:(nonnull id<UIContentContainer>)container withParentContainerSize:(CGSize)parentSize {
//    NSLog(@"14");
//    return CGSizeMake(0, 0);
//}
//
//- (void)systemLayoutFittingSizeDidChangeForChildContentContainer:(nonnull id<UIContentContainer>)container {
//    NSLog(@"15");
//}
//
//- (void)viewWillTransitionToSize:(CGSize)size withTransitionCoordinator:(nonnull id<UIViewControllerTransitionCoordinator>)coordinator {
//    NSLog(@"16");
//}
//
//- (void)willTransitionToTraitCollection:(nonnull UITraitCollection *)newCollection withTransitionCoordinator:(nonnull id<UIViewControllerTransitionCoordinator>)coordinator {
//    NSLog(@"17");
//}
//
//- (void)didUpdateFocusInContext:(nonnull UIFocusUpdateContext *)context withAnimationCoordinator:(nonnull UIFocusAnimationCoordinator *)coordinator {
//    NSLog(@"18");
//}
//
//- (void)setNeedsFocusUpdate {
//    NSLog(@"19");
//}
//
//- (BOOL)shouldUpdateFocusInContext:(nonnull UIFocusUpdateContext *)context {
//    NSLog(@"20");
//    return YES;
//}
//
//- (void)updateFocusIfNeeded {
//    NSLog(@"21");
//}
//
//#pragma mark - 创建导航条
////创建导航条
//- (void)createNavigationBar{
//    // 导航条
//    UIImageView *naviView = [[UIImageView alloc] initWithFrame:CGRectMake(0,-20, ScreenWidth,64)];
//    naviView.backgroundColor = [UIColor colorWithRed:240/255.0 green:109/255.0 blue:69/255.0 alpha:1];
//    naviView.userInteractionEnabled = YES;
//    [self.bgvView addSubview:naviView];
//    self.naviView = naviView;
//    
//    
//    //返回按钮
//    UIButton *backBtn = [UIButton new];
//    [backBtn setImage:[UIImage imageNamed:@"back2"] forState:UIControlStateNormal];
//    [backBtn addTarget:self action:@selector(backAction:) forControlEvents:UIControlEventTouchUpInside];
//    [naviView addSubview:backBtn];
//    [backBtn mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.centerY.mas_equalTo(naviView.mas_top).mas_equalTo(42);
//        make.left.mas_equalTo(naviView.mas_left);
//        make.size.mas_equalTo(CGSizeMake(110*ScaleWidth, 24));
//    }];
//    //导航栏的标题
//    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 36*ScaleWidth)];
//    titleLabel.text = _model.shop_name;
//    titleLabel.textAlignment = NSTextAlignmentCenter;
//    titleLabel.font = [UIFont systemFontOfSize:36*ScaleWidth];
//    titleLabel.textColor = [UIColor colorWithHexString:@"#fafafa"];
//    CGPoint titlePoint = CGPointMake(naviView.center.x, 44/2);
//    titleLabel.center = titlePoint;
//    [naviView addSubview:titleLabel];
//    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.centerY.mas_equalTo(backBtn.mas_centerY);
//        make.centerX.mas_equalTo(naviView.mas_centerX);
//    }];
//    
//    
//}
//- (void)backAction:(UIButton *)btn{
//    [self.navigationController popViewControllerAnimated:YES];
//}
//
//-(void)loadView{
//    UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
//    self.view = scrollView;
//}
//
//- (void)createUI{
//    
//    UIView *bgvView = [[UIView alloc] init];
//    bgvView.frame = CGRectMake(0, 0, ScreenWidth, ScreenHeight-20);
//    self.bgvView = bgvView;
//    [self.view addSubview:bgvView];
//    
//    [self createNavigationBar];
//    
//    UIView *view = [UIView new];
//    self.inputView = view;
//    view.layer.borderColor = [UIColor colorWithRed:229/250.0 green:228/255.0 blue:230/255.0 alpha:1].CGColor;
//    view.layer.borderWidth = 0.3;
//    view.frame = CGRectMake(0, ScreenHeight - 116*ScaleHeight - 64, ScreenWidth, 116*ScaleHeight);
//    view.backgroundColor = [UIColor whiteColor];
//    [self.bgvView addSubview:view];
//    [view mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.right.mas_equalTo(self.bgvView);
//        make.bottom.mas_equalTo(self.bgvView.mas_bottom);
//        make.height.mas_equalTo(116*ScaleHeight);
//    }];
//    // 初始化列表
//    self.chatTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight - 60 - 64) style:UITableViewStylePlain];
//    self.chatTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
//    self.chatTableView.allowsSelection = NO;
//    [self.chatTableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"MessageBoardCell"];
//    self.chatTableView.delegate = self;
//    self.chatTableView.dataSource = self;
//    [self.bgvView addSubview:_chatTableView];
//    [self.chatTableView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.right.mas_equalTo(self.bgvView);
//        make.bottom.mas_equalTo(self.inputView.mas_top);
//        // make.height.mas_equalTo(ScreenHeight-64-60);
//        make.top.mas_equalTo(self.naviView.mas_bottom);
//    }];
//    
//    // 发送按钮
//    self.sendBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//    self.sendBtn.frame = CGRectMake(ScreenWidth - 70, 30-20, 60, 40);
//    self.sendBtn.enabled = NO;
//    self.sendBtn.alpha = 0.6;
//    self.sendBtn.layer.cornerRadius = 76*ScaleHeight/2;
//    self.sendBtn.backgroundColor = [UIColor colorWithRed:240/255.0 green:109/255.0 blue:69/255.0 alpha:1];;
//    [self.sendBtn setTitle:@"send" forState:UIControlStateNormal];
//    // [self.sendBtn setTitleColor:baseColor forState:UIControlStateNormal];
//    [self.sendBtn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateHighlighted];
//    [self.sendBtn addTarget:self
//                     action:@selector(sendMessageAction:)
//           forControlEvents:UIControlEventTouchUpInside];
//    [view addSubview:_sendBtn];
//    [_sendBtn mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.centerY.mas_equalTo(self.inputView.mas_centerY);
//        make.height.mas_equalTo(76*ScaleHeight);
//        make.width.mas_equalTo(124*ScaleWidth);
//        make.right.mas_equalTo(view.mas_right).mas_equalTo(-10);
//    }];
//    
//    
//    UIView *huiview = [UIView new];
//    huiview.layer.borderColor = [UIColor colorWithRed:229/250.0 green:228/255.0 blue:230/255.0 alpha:1].CGColor;
//    huiview.layer.borderWidth = 0.3;
//    [self.inputView addSubview:huiview];
//    huiview.backgroundColor = [UIColor colorWithRed:241/255.0 green:241/255.0 blue:241/255.0 alpha:1];
//    huiview.layer.cornerRadius = 76*ScaleHeight/2;
//    [huiview mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.height.mas_equalTo(76*ScaleHeight);
//        make.centerY.mas_equalTo(self.inputView.mas_centerY);
//        make.left.mas_equalTo(self.inputView.mas_left).mas_equalTo(26*ScaleWidth);
//        make.right.mas_equalTo(self.sendBtn.mas_left).mas_equalTo(-26*ScaleWidth);
//    }];
//    
//    
//    
//    // 编辑框
//    self.textView = [[UITextView alloc] initWithFrame:CGRectMake(10, 30-20 , ScreenWidth - 80, 40)];
//    self.textView.layer.cornerRadius = 10*ScaleWidth;
//    self.textView.font = [UIFont systemFontOfSize:36*ScaleWidth];
//    self.textView.delegate = self;
//    self.textView.textContainer.lineBreakMode = NSLineBreakByClipping;
//    self.textView.keyboardType = UIKeyboardTypeDefault;
//    self.textView.backgroundColor = [UIColor clearColor];
//    self.textView.textColor = [UIColor colorWithRed:206/255.0 green:206/255.0 blue:206/255.0 alpha:1];
//    self.textView.text = @"input...";
//    [huiview addSubview:_textView];
//    [_textView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.mas_equalTo(huiview.mas_left).mas_equalTo(10*ScaleWidth);
//        make.right.mas_equalTo(huiview.mas_right).mas_equalTo(-10*ScaleWidth);
//        make.top.mas_equalTo(huiview.mas_top);
//        make.bottom.mas_equalTo(huiview.mas_bottom);
//    }];
//    
//    
//}
///*
//#pragma mark - Navigation
//
//// In a storyboard-based application, you will often want to do a little preparation before navigation
//- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
//    // Get the new view controller using [segue destinationViewController].
//    // Pass the selected object to the new view controller.
//}
//*/

@end
