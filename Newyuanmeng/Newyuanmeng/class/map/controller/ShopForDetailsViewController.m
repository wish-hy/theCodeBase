//
//  ShopForDetailsViewController.m
//  huabi
//
//  Created by huangyang on 2017/12/21.
//  Copyright © 2017年 ltl. All rights reserved.
//

#import "ShopForDetailsViewController.h"
#import "SellerInfoModel.h"
#import "MessageBoardViewController.h"
#import "ShopChatViewController.h"

@interface ShopForDetailsViewController ()
@property (weak, nonatomic) IBOutlet CoreImageView *shopImage;
@property (weak, nonatomic) IBOutlet UIButton *mapBtn;
@property (weak, nonatomic) IBOutlet UILabel *focus;
@property (weak, nonatomic) IBOutlet UILabel *shopName;
@property (weak, nonatomic) IBOutlet UILabel *rank;
@property (weak, nonatomic) IBOutlet UILabel *info;
@property (weak, nonatomic) IBOutlet UIButton *chatButton;

@property (nonatomic,strong)SellerInfoModel *model;

@end

@implementation ShopForDetailsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.mapBtn setImage:[UIImage iconWithInfo:TBCityIconInfoMake(@"\U0000e6ac", 30, [UIColor whiteColor])] forState:UIControlStateNormal];
    [self.chatButton setImage:[UIImage iconWithInfo:TBCityIconInfoMake(@"\U0000e6c2", 20, [UIColor whiteColor])] forState:UIControlStateNormal];
    [self setInfo];
}

- (void)viewWillAppear:(BOOL)animated{
    [self.navigationController setNavigationBarHidden:YES];
}

-(void)setInfo
{
    NSArray *keyArr = @[@"id"];
    NSArray *valueArr = @[_ID];
    
//    self.modelArr = [[NSMutableArray alloc] init];
    [SVProgressHUD show];
    [MySDKHelper postAsyncWithURL:@"/v1/seller_info" withParamBodyKey:keyArr withParamBodyValue:valueArr needToken:@"" postSucceed:^(NSDictionary *result) {
        if ([result[@"code"] integerValue] == 0) {
            NSDictionary *shopInfo = result[@"content"];
            SellerInfoModel *model = [SellerInfoModel mj_objectWithKeyValues:shopInfo];
            _model = model;
//            NSLog(@"shop_name-----------%@",model.info);
            self.shopName.text = model.shop_name;
            
            NSString *imgUrl = [NSString stringWithFormat:@"%@%@",imgHost,model.picture];
            [self.shopImage sd_setImageWithURL:[NSURL URLWithString:imgUrl] placeholderImage:[UIImage imageNamed:@"icon-60"] options:SDWebImageAllowInvalidSSLCertificates];
            
            self.focus.text = [NSString stringWithFormat:@"关注%@人",model.attention_num];
            if ([model.info isKindOfClass:[NSNull class]]) {
                self.info.text = @"暂无店铺详情";
            }
            else
            {
                self.info.text = model.info;
            }
            
            if (model.is_district == 1) {
                self.rank.text = @"经销商";
            }
            else if (model.is_district == 0)
            {
                self.rank.text = @"代理";
            }
            else
            {
                self.rank.text = @"会员";
            }
        }else{
            [NoticeView showMessage:result[@"message"]];
        }
        [SVProgressHUD dismiss];
    } postCancel:^(NSString *error) {
        [SVProgressHUD dismiss];
    }];
}

- (IBAction)showInMap:(id)sender {
    
}
//进入聊天室
- (IBAction)enterChat:(UIButton *)sender {
//    MessageBoardViewController *controller = [[MessageBoardViewController alloc] init];
//    controller.targetId = self.model.user_id;
//    controller.model = _model;
//    [self.navigationController pushViewController:controller animated:YES];
    ShopChatViewController *chat = [[ShopChatViewController alloc] initWithConversationType:ConversationType_PRIVATE targetId:self.model.user_id];
    chat.title = self.model.shop_name;
    [self.navigationController pushViewController:chat animated:YES];
}

- (IBAction)backClick:(UIButton *)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

@end
