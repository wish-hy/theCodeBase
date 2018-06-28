//
//  PaperRedViewController.m
//  huabi
//
//  Created by hy on 2018/1/8.
//  Copyright © 2018年 ltl. All rights reserved.
//   红包View

#import "PaperRedViewController.h"
#import "Newyuanmeng-Swift.h"
#import "ChoosePayMents.h"

@interface PaperRedViewController ()<UITextFieldDelegate,UIPickerViewDelegate,UIPickerViewDataSource,UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UIImageView *redType;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *width;
@property (weak, nonatomic) IBOutlet UILabel *type;
@property (weak, nonatomic) IBOutlet UITextField *money;
@property (weak, nonatomic) IBOutlet UILabel *typeName;
@property (weak, nonatomic) IBOutlet UIButton *changeType;
@property (weak, nonatomic) IBOutlet UITextField *count;
@property (weak, nonatomic) IBOutlet UITextField *whereFrom;

@property (weak, nonatomic) IBOutlet UITextField *discription;
@property (weak, nonatomic) IBOutlet UILabel *lastMoney;

@property (nonatomic,strong)UIPickerView *picker;

@property (nonatomic,strong)NSArray *info;
@property (weak, nonatomic) IBOutlet CornerButton *sendRedBag;

@property (nonatomic,assign)BOOL pinShouqi;
@property(nonatomic,strong)UIToolbar *myToolbar;

@property (nonatomic,strong)UIView *backGround;
@end

@implementation PaperRedViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _whereFrom.delegate = self;
    _sendRedBag.alpha = 0.6;
    _sendRedBag.userInteractionEnabled = NO;
    self.info = @[@"100",@"200",@"300",@"400",@"500",@"600",@"700",@"800",@"900",@"1000"];
    _whereFrom.delegate = self;
    self.pinShouqi = YES;
    
    self.picker = [[UIPickerView alloc] initWithFrame:CGRectMake(0, self.view.bounds.size.height, self.view.bounds.size.height, 220)];
//    self.picker.backgroundColor = [UIColor lightGrayColor];
    self.picker.delegate = self;
    self.picker.dataSource = self;
    
    
    // --- tool bar ---
    UIBarButtonItem *doneBBI = [[UIBarButtonItem alloc]
                                initWithTitle:@"确定"
                                style:UIBarButtonItemStyleDone
                                target:self
                                action:@selector(doneClick)];
    
    UIBarButtonItem *cancelBBI = [[UIBarButtonItem alloc] initWithTitle:@"取消" style:UIBarButtonItemStylePlain target:self action:@selector(cancelClick)];
    
    UIBarButtonItem *flexibleBBI = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    
    self.myToolbar = [[UIToolbar alloc]initWithFrame:
                      CGRectMake(0, 0, self.view.bounds.size.width, 40)];
    self.myToolbar.backgroundColor = [UIColor blueColor];
    [self.myToolbar setBarStyle:UIBarStyleBlackOpaque];
    
    NSArray *toolbarItems = @[cancelBBI,flexibleBBI,doneBBI];
    [self.myToolbar setItems:toolbarItems];
    
    
     [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textValueChange) name:UITextFieldTextDidChangeNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(removeView) name:@"closeChooseView" object:nil];
    
    [_changeType setTitle:@"改为拼手气红包" forState:UIControlStateSelected];
    [_changeType setTitle:@"改为普通红包" forState:UIControlStateNormal];
}

- (IBAction)changeType:(id)sender {
    if (_pinShouqi) {// 改为拼手气
        _typeName.text = @"当前为普通红包，";
        _width.constant = 0;
        _changeType.selected = YES;
        _pinShouqi = NO;
    }
    else
    {   // 改为普通

        _typeName.text = @"当前为拼手气红包，";
        _width.constant = 30;
        _changeType.selected = NO;
        _pinShouqi = YES;
    }
   
}

-(void)textValueChange
{
    if (_money.text == nil || _count.text == nil || _whereFrom.text == nil || [_money.text isEqualToString:@""] || [_count.text isEqualToString:@""] || [_whereFrom.text isEqualToString:@""]) {
        _sendRedBag.alpha = 0.6;
        _sendRedBag.userInteractionEnabled = NO;
        _lastMoney.text = @"0.00";
    }else{
        _sendRedBag.alpha = 1;
        _sendRedBag.userInteractionEnabled = YES;
        _lastMoney.text = _money.text;
    }
}

- (IBAction)sendRedBag:(id)sender {
    
    UIView *backGround = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight)];
    backGround.backgroundColor = [UIColor grayColor];
    backGround.alpha = 0.5;
    _backGround = backGround;
    [self.view addSubview:backGround];
    ChoosePayMents *choose = [ChoosePayMents creatChoosePayMentView];
//    choose.frame = CGRectMake(0, 0, ScreenWidth, ScreenHeight);
    
    NSString *type = @"";
    if (_pinShouqi) {
        type = @"1";
    }else{
        type = @"2";
    }
    NSArray *keys = @[@"user_id",@"amount",@"info",@"range",@"num",@"type",@"redbag_type"];
    NSArray *values = @[@(CommonConfig.UserInfoCache.userId),_money.text,_discription.text,_whereFrom.text,_count.text,@"2",type];
    choose.isRedBag = YES;
    choose.redBagKeys = [keys mutableCopy];
    choose.redBagValues = [values mutableCopy];
    [self.view addSubview:choose];
    
    [choose mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(ScreenHeight/2+50);
        make.left.mas_equalTo(self.view.mas_left);
        make.right.mas_equalTo(self.view.mas_right);
        make.bottom.mas_equalTo(self.view.mas_bottom);
    }];
}


- (void)doneClick {
    if ( [self.whereFrom isFirstResponder] ) {
        [self.whereFrom resignFirstResponder];
    }
}

- (void)cancelClick {
    [self doneClick];
}



-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}
-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return self.info.count;
}
-(CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component
{
    return 30;
}

-(CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component
{
    return self.view.bounds.size.width;
}

-(UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view
{
    if (!view) {
        view = [[UIView alloc] init];
    }
    UILabel *textlabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 30)];
    textlabel.textAlignment = NSTextAlignmentCenter;
    textlabel.text = self.info[row];
    textlabel.font = [UIFont systemFontOfSize:18];
    [view addSubview:textlabel];
    return view;
}

-(void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    self.whereFrom.text = self.info[row];
    [self textValueChange];
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    if (textField == self.whereFrom) {
        self.whereFrom.inputView = self.picker;
        self.whereFrom.inputAccessoryView = self.myToolbar;
}
    return YES;
}


-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [_money resignFirstResponder];
    [_count resignFirstResponder];
    [_whereFrom resignFirstResponder];
    [_discription resignFirstResponder];
}

- (IBAction)backClick:(id)sender {
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

-(void)removeView
{
    [_backGround removeFromSuperview];
}
@end
