//
//  SettingViewController.m
//  huabi
//
//  Created by hy on 2018/1/24.
//  Copyright © 2018年 ltl. All rights reserved.
//

#import "SettingViewController.h"
#import "Newyuanmeng-Swift.h"

@interface SettingViewController ()
@property (weak, nonatomic) IBOutlet UISwitch *musicOpen;
@property (weak, nonatomic) IBOutlet UIView *myCollection;
@property (weak, nonatomic) IBOutlet UIView *myAdress;
@property (weak, nonatomic) IBOutlet UIView *helpCenter;
@property (weak, nonatomic) IBOutlet UIView *aboutUs;


@end

@implementation SettingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
   NSString *voc =  [[NSUserDefaults standardUserDefaults] objectForKey:@"voice"];
    if ([voc isEqualToString:@"1"]) {
        [self.musicOpen setOn:YES];
    }else{
        [self.musicOpen setOn:NO];
    }
    UITapGestureRecognizer *Collection = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(collections)];
    [self.myCollection addGestureRecognizer:Collection];
    
    UITapGestureRecognizer *adress = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(chooseAdress)];
    [self.myAdress addGestureRecognizer:adress];
    
    UITapGestureRecognizer *help = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(helpCenters)];
    [self.helpCenter addGestureRecognizer:help];
    
    UITapGestureRecognizer *about = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(aboutour)];
    [self.aboutUs addGestureRecognizer:about];
    
//    UITapGestureRecognizer *auth = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(authentications)];
//    [self.authentication addGestureRecognizer:auth];
}

- (IBAction)musicOffOpen:(id)sender {
    NSLog(@"%@",sender);
    if (self.musicOpen.on) {
        NSLog(@"开");
        [[NSUserDefaults standardUserDefaults] setObject:@"1" forKey:@"voice"];
    }
    else
    {
        NSLog(@"关");
        [[NSUserDefaults standardUserDefaults] setObject:@"0" forKey:@"voice"];
    }
}

-(void)collections
{
    NSLog(@"我的收藏");
    MessageViewController *shouCang = [[UIStoryboard storyboardWithName:@"Me" bundle:nil] instantiateViewControllerWithIdentifier:@"MessageViewController"];
    shouCang.isShow = NO;
    shouCang.isSystem = NO;
    shouCang.isFirst = NO;
    shouCang.isCollect = YES;
    [self.navigationController pushViewController:shouCang animated:YES];
}

-(void)chooseAdress
{
    NSLog(@"我的地址");
    AddressViewController *address = [[UIStoryboard storyboardWithName:@"Me" bundle:nil] instantiateViewControllerWithIdentifier:@"AddressViewController"];
    [self.navigationController pushViewController:address animated:YES];
}
- (IBAction)loginOut:(id)sender {
    [(AppDelegate *)[[UIApplication sharedApplication] delegate] logOut];
    [self.navigationController popViewControllerAnimated:YES];
     //    (UIApplication.shared.delegate as! AppDelegate).logOut()
//
//    self.navigationController?.popViewController(animated: true)
}

-(void)helpCenters
{
    NSLog(@"客服中心");
    MessageViewController *shouCang = [[UIStoryboard storyboardWithName:@"Me" bundle:nil] instantiateViewControllerWithIdentifier:@"MessageViewController"];
    shouCang.isShow = NO;
    shouCang.isSystem = NO;
    shouCang.isCollect = NO;
    shouCang.isFirst = YES;
    [self.navigationController pushViewController:shouCang animated:YES];
}

-(void)aboutour
{
    NSLog(@"关于我们");
    AboutUsController *about = [[UIStoryboard storyboardWithName:@"Me" bundle:nil] instantiateViewControllerWithIdentifier:@"AboutUsController"];
    [self.navigationController pushViewController:about animated:YES];
}
- (IBAction)back:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}


- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:NO];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}

@end
