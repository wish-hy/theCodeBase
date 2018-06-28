//
//  AddressChoicePickerView.m
//  Wujiang
//
//  Created by zhengzeqin on 15/5/27.
//  Copyright (c) 2015年 com.injoinow. All rights reserved.
//  make by 郑泽钦 分享

#import "AddressChoicePickerView.h"

#define screenh [UIScreen mainScreen].bounds.size.height

@interface AddressChoicePickerView()<UIPickerViewDataSource,UIPickerViewDelegate>
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *contentViewHegithCons;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *top;



@property (weak, nonatomic) IBOutlet UIPickerView *pickView;
@property (strong, nonatomic) AreaObject *locate;

//省 数组
@property (strong, nonatomic) NSArray *provinceArr;
//城市 数组
@property (strong, nonatomic) NSArray *cityArr;
//区县 数组
@property (strong, nonatomic) NSArray *areaArr;

@property (nonatomic , assign) BOOL isFromOther;


@end
@implementation AddressChoicePickerView

- (instancetype)initWithData:(NSArray *)data{
    
    if (self = [super init]) {
        self = [[[NSBundle mainBundle]loadNibNamed:@"AddressChoicePickerView" owner:nil options:nil]firstObject];
        self.frame = [UIScreen mainScreen].bounds;
        self.pickView.delegate = self;
        self.pickView.dataSource = self;
        self.provinceArr = data;
        self.cityArr = self.provinceArr[0][@"cities"];
        self.areaArr = self.cityArr[0][@"areas"];
        self.locate.province = self.provinceArr[0][@"name"];
        self.locate.provinceid = [NSString stringWithFormat:@"%@",self.provinceArr[0][@"id"]];
        self.locate.city = self.cityArr[0][@"name"];
        self.locate.cityid = [NSString stringWithFormat:@"%@",self.cityArr[0][@"id"]];
        if (self.areaArr.count) {
            self.locate.area = self.areaArr[0][@"name"];
            self.locate.areaid = [NSString stringWithFormat:@"%@",self.areaArr[0][@"id"]];
        }else{
            self.locate.area = @"";
        }
        [self customView];
 
    }
    return self;
}

- (instancetype)initWithFromArr:(NSMutableArray *)dataArr{
    
    if (self = [super init]) {
        self = [[[NSBundle mainBundle]loadNibNamed:@"AddressChoicePickerView" owner:nil options:nil]firstObject];
        self.frame = [UIScreen mainScreen].bounds;
        self.pickView.delegate = self;
        self.pickView.dataSource = self;
        self.provinceArr = dataArr;
        self.isFromOther = YES;
        [self customView];
        self.locate.province = dataArr[0][@"name"];
        self.locate.provinceid = [NSString stringWithFormat:@"%@",dataArr[0][@"id"]];
        
    }
    return self;
}

- (void)customView{
    self.top.constant = -screenh;
    [self layoutIfNeeded];
}

#pragma mark - setter && getter

- (AreaObject *)locate{
    if (!_locate) {
        _locate = [[AreaObject alloc]init];
    }
    return _locate;
}

#pragma mark - action

//选择完成
- (IBAction)finishBtnPress:(UIButton *)sender {
    if (self.block) {
        self.block(self,sender,self.locate);
    }
    [self hide];
}

//隐藏
- (IBAction)dissmissBtnPress:(UIButton *)sender {
    
    [self hide];
}

#pragma  mark - function

- (void)show{
    UIWindow *win = [[UIApplication sharedApplication] keyWindow];
    UIView *topView = [win.subviews firstObject];
    [topView addSubview:self];
    [UIView animateWithDuration:0.3 animations:^{
        self.top.constant = (screenh - 250.0)/2.0;
        [self layoutIfNeeded];
    }];
}

- (void)hide{
    [UIView animateWithDuration:0.3 animations:^{
        self.alpha = 0;
        self.top.constant = -screenh;
        [self layoutIfNeeded];
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}


#pragma mark - UIPickerViewDataSource

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    if (self.isFromOther) {
        return 1;
    }
    return 3;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    switch (component) {
        case 0:
            return self.provinceArr.count;
            break;
        case 1:
            if (self.cityArr.count) {
                return self.cityArr.count;
                break;
            }
        case 2:
            if (self.areaArr.count) {
                return self.areaArr.count;
                break;
            }
        default:
            return 0;
            break;
    }
}
- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component{
    NSString *name;
    switch (component) {
        case 0:{
            NSDictionary *dic = [self.provinceArr objectAtIndex:row];
            name = dic[@"name"];
        }
           
            break;
        case 1:
            if (self.cityArr.count) {
                NSDictionary *dic = [self.cityArr objectAtIndex:row];
                name = dic[@"name"];
                break;
            }
        case 2:
            if (self.areaArr.count) {
                NSDictionary *dic = [self.areaArr objectAtIndex:row];
                name = dic[@"name"];
                break;
            }
        default:
            name = @"";
            break;
    }
    return name;
}
#pragma mark - UIPickerViewDelegate

- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view{
    UILabel* pickerLabel = (UILabel*)view;
    if (!pickerLabel){
        pickerLabel = [[UILabel alloc] init];
        pickerLabel.minimumScaleFactor = 8.0;
        pickerLabel.adjustsFontSizeToFitWidth = YES;
        [pickerLabel setTextAlignment:NSTextAlignmentCenter];
        [pickerLabel setBackgroundColor:[UIColor clearColor]];
        [pickerLabel setFont:[UIFont boldSystemFontOfSize:15]];
    }
    pickerLabel.text=[self pickerView:pickerView titleForRow:row forComponent:component];
    return pickerLabel;
}


- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component{
    switch (component) {
        case 0:
        {
            if (self.isFromOther) {
                NSDictionary *dic = self.provinceArr[row];
                self.locate.province = dic[@"name"];
                self.locate.provinceid = [NSString stringWithFormat:@"%@",self.provinceArr[row][@"id"]];
            }else{
                self.cityArr = [[self.provinceArr objectAtIndex:row] objectForKey:@"cities"];
                [self.pickView reloadComponent:1];
                [self.pickView selectRow:0 inComponent:1 animated:YES];
                
                
                self.areaArr = [[self.cityArr objectAtIndex:0] objectForKey:@"areas"];
                [self.pickView reloadComponent:2];
                [self.pickView selectRow:0 inComponent:2 animated:YES];
                
                self.locate.province = self.provinceArr[row][@"name"];
                self.locate.provinceid = [NSString stringWithFormat:@"%@",self.provinceArr[row][@"id"]];
                self.locate.city = self.cityArr[0][@"name"];
                self.locate.cityid = [NSString stringWithFormat:@"%@",self.cityArr[0][@"id"]];
                if (self.areaArr.count) {
                    self.locate.area = self.areaArr[0][@"name"];
                    self.locate.areaid = [NSString stringWithFormat:@"%@",self.areaArr[0][@"id"]];
                }else{
                    self.locate.area = @"";
                }
            }
            break;
        }
        case 1:{
            self.areaArr = [[self.cityArr objectAtIndex:row] objectForKey:@"areas"];
            [self.pickView reloadComponent:2];
            [self.pickView selectRow:0 inComponent:2 animated:YES];
            
            self.locate.city = self.cityArr[row][@"name"];
            self.locate.cityid = [NSString stringWithFormat:@"%@",self.cityArr[0][@"id"]];
            if (self.areaArr.count) {
                self.locate.area = self.areaArr[0][@"name"];
                self.locate.areaid = [NSString stringWithFormat:@"%@",self.areaArr[0][@"id"]];
            }else{
                self.locate.area = @"";
            }
            break;
        }
        case 2:{
            if (self.areaArr.count != 0) {
                self.locate.area = self.areaArr[row][@"name"];
                self.locate.areaid = [NSString stringWithFormat:@"%@",self.areaArr[row][@"id"]];
            }else{
                self.locate.area = @"";
            }
            
            break;
        }
        default:
            break;
    }
}


@end
// 版权属于原作者
// http://code4app.com (cn) http://code4app.net (en)
// 发布代码于最专业的源码分享网站: Code4App.com
