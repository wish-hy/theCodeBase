//
//  ShopChatViewController.m
//  huabi
//
//  Created by hy on 2018/1/29.
//  Copyright © 2018年 ltl. All rights reserved.
//

#import "ShopChatViewController.h"
#import "Newyuanmeng-Swift.h"


@interface ShopChatViewController ()<RCIMUserInfoDataSource>
@property (nonatomic, strong) UIButton *sendBtn;
@end

@implementation ShopChatViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.navigationController.navigationBar setBackgroundImage:[self createImageWithColor:[UIColor colorWithHexString:@"#F2794E"]] forBarMetrics:UIBarMetricsDefault];
    self.navigationController.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName:[UIColor whiteColor],NSFontAttributeName:[UIFont boldSystemFontOfSize:17]};
    [self.chatSessionInputBarControl setInputBarType:(RCChatSessionInputBarControlDefaultType) style:(RC_CHAT_INPUT_BAR_STYLE_CONTAINER)];
    [RCIM sharedRCIM].userInfoDataSource = self;
    [[RCIM sharedRCIM] getUserInfoCache:self.targetId];
    [RCIM sharedRCIM].enableTypingStatus = YES;
    [RCIM sharedRCIM].enablePersistentUserInfoCache = YES;
    [RCIM sharedRCIM].enableMessageRecall = YES;
}



#pragma mark - loadUserInfoData
-(void)getUserInfoWithUserId:(NSString *)userId completion:(void (^)(RCUserInfo *))completion
{
    NSLog(@"user_id %@",userId);
        if(userId == nil || userId.length == 0){
            completion(nil);
            return;
        }
    
        if([userId isEqualToString:[RCIM sharedRCIM].currentUserInfo.userId]){
    
            RCUserInfo *myselfInfo = [[RCUserInfo alloc] initWithUserId:[RCIM sharedRCIM].currentUserInfo.userId name:[RCIM sharedRCIM].currentUserInfo.name portrait:[RCIM sharedRCIM].currentUserInfo.portraitUri];
            completion(myselfInfo);
        }
    
}



#pragma mark 发送消息
/*!
 发送消息
 
 @param messageContent 消息的内容
 @param pushContent    接收方离线时需要显示的远程推送内容
 
 @discussion 当接收方离线并允许远程推送时，会收到远程推送。
 远程推送中包含两部分内容，一是pushContent，用于显示；二是pushData，用于携带不显示的数据。
 
 SDK内置的消息类型，如果您将pushContent置为nil，会使用默认的推送格式进行远程推送。
 自定义类型的消息，需要您自己设置pushContent来定义推送内容，否则将不会进行远程推送。
 
 如果您需要设置发送的pushData，可以使用RCIM的发送消息接口。
 */  // 3456
-(void)sendMessage:(RCMessageContent *)messageContent pushContent:(NSString *)pushContent
{
    messageContent.senderUserInfo = [RCIM sharedRCIM].currentUserInfo;
    
    [[RCIM sharedRCIM] sendMessage:ConversationType_PRIVATE targetId:self.targetId content:messageContent pushContent:pushContent pushData:nil success:^(long messageId) {
        
        NSLog(@"发送成功");
    } error:^(RCErrorCode nErrorCode, long messageId) {
        NSLog(@"发送失败 %ld %ld",(long)nErrorCode,messageId);
    }];
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

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:NO];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    [self.navigationController setNavigationBarHidden:YES animated:NO];
}
@end
