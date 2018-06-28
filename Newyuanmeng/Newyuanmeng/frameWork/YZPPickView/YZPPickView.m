//
//  YZPPickView.m
//  PickView
//
//  Created by m on 16/6/23.
//  Copyright © 2016年 . All rights reserved.
//

#import "YZPPickView.h"

@interface YZPPickView ()<UIPickerViewDelegate,UIPickerViewDataSource>
{
    NSArray*_provinceArray;
    NSArray *_cityArray;
    
    UIPickerView *_pickerView;
    
}

@end

@implementation YZPPickView

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        _provinceArray = [self provinceArray];
        
        _cityArray = [self cityArray];
        
        //父类 UIView
        _pickerView = [[UIPickerView alloc]initWithFrame:CGRectMake(0, 10, frame.size.width, frame.size.height-50)];
        _pickerView.backgroundColor = [UIColor lightGrayColor];
        
        _pickerView.dataSource = self;
        _pickerView.delegate = self;
        [self addSubview:_pickerView];
    }
    return self;
    
}

- (void)setHasDefaul:(BOOL)hasDefaul{
    
    [self choosePlaceWithPickerView:_pickerView];
    
}

//UIPickerViewDataSource  必须实现的协议方法
//设置列的数目
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 2;
}

//设置某一列的行数目
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    
    if (component == 0) {
        return _provinceArray.count;
    }
    if (component == 1) {
        
        NSInteger selectedComponent0Row = [pickerView selectedRowInComponent:0];
        
        Provice *provice = _provinceArray[selectedComponent0Row];
        
        NSMutableArray *cityArray = [NSMutableArray array];
        for (City *city in _cityArray) {
            if (city.proID == provice.proID) {
                [cityArray addObject:city];
            }
        }
        return cityArray.count;
    }
    
    return 0;
}

//设置某列某行的标题
- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    
    if (component == 0) {
        
        Provice *provice = _provinceArray[row];
        
        return provice.name;
        
    }
    if (component == 1) {
        
        NSInteger selectedComponent0Row = [pickerView selectedRowInComponent:0];
        
        Provice *provice = _provinceArray[selectedComponent0Row];
        
        
        NSMutableArray *cityArray = [NSMutableArray array];
        
        for (City *city in _cityArray) {
            if (city.proID == provice.proID) {
                [cityArray addObject:city];
            }
        }
        City *city = cityArray[row];
        return city.name;
    }
    return @"";
}

//当选中某一行的时候，pickerView 重新加载
//选中某列的某一行会调用的方法
- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component{
    
    //刷新
    [pickerView  reloadAllComponents];
    //修改选中行 为 0行
    [pickerView selectRow:row inComponent:component animated:YES];

    [self choosePlaceWithPickerView:pickerView];
}

- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component{
    return 30;
}
//自定义picker
- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view
{
    UILabel *pickerLabel = (UILabel*)view;
    if (!pickerLabel) {
        pickerLabel = [[UILabel alloc]init];
        pickerLabel.font = [UIFont systemFontOfSize:14];
        pickerLabel.backgroundColor = [UIColor whiteColor];
        pickerLabel.adjustsFontSizeToFitWidth = YES;
        pickerLabel.textAlignment = NSTextAlignmentCenter;
        
    }
    pickerLabel.text = [self pickerView:pickerView titleForRow:row forComponent:component];
    
    return pickerLabel;
    
}

- (void)choosePlaceWithPickerView:(UIPickerView *)pickerView{
    NSInteger selectedComponent0Row = [pickerView selectedRowInComponent:0];
    
    Provice *provice = _provinceArray[selectedComponent0Row];
    
    NSMutableArray *cityArray = [NSMutableArray array];
    for (City *city in _cityArray) {
        if (city.proID == provice.proID) {
            [cityArray addObject:city];
        }
    }
    
    NSInteger selectedComponent1Row = [pickerView selectedRowInComponent:1];

    City *city = cityArray[selectedComponent1Row];
    [_delegate didSelectPickView:provice city:city];

}

- (NSArray *)provinceArray{
    NSString *path = [[NSBundle mainBundle] pathForResource:@"province" ofType:@"plist"];
    NSArray *array = [[NSArray alloc] initWithContentsOfURL:[NSURL fileURLWithPath:path]];
    NSMutableArray *proviceMutableArray = [NSMutableArray array];
    for (NSDictionary *dic in array) {
        Provice  *province = [[Provice alloc] initWithProviceDic:dic];
        [proviceMutableArray addObject:province];
        
    }
    return proviceMutableArray;
}

- (NSArray *)cityArray{
    NSString *path = [[NSBundle mainBundle] pathForResource:@"city" ofType:@"plist"];
    NSArray *array = [[NSArray alloc] initWithContentsOfURL:[NSURL fileURLWithPath:path]];
    NSMutableArray *cityMutableArray = [NSMutableArray array];
    for (NSDictionary *dic in array) {
        City *city = [[City alloc] initWithCityDic:dic];
        [cityMutableArray addObject:city];
        
    }
    return cityMutableArray;
}

@end
