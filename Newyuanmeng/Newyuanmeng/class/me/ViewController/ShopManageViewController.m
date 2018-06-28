//
//  ShopManageViewController.m
//  huabi
//
//  Created by huangyang on 2017/12/21.
//  Copyright © 2017年 ltl. All rights reserved.
//

#import "ShopManageViewController.h"
#import "Newyuanmeng-Swift.h"
#import "AddressChoicePickerView.h"



@interface ShopManageViewController ()<UITableViewDelegate,UITableViewDataSource,UITextViewDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,CLLocationManagerDelegate>
@property (nonatomic , strong) UITableView *tableView;
@property (nonatomic , strong) NSString *imagurl;
@property (nonatomic , strong) UITextView *nameTextView;
@property (nonatomic , strong) UITextView *regionTextView;
@property (nonatomic , strong) UITextView *streetTextView;
@property (nonatomic , strong) UITextView *addressTextView;
@property (nonatomic , strong) UITextView *introduceTextView;
@property (nonatomic , strong) NSArray *titleArr;
@property (nonatomic , strong) UILabel *numberLabel;
@property (nonatomic , strong) UITextView *currentTextView;
@property (nonatomic , strong) NSArray *addressArr;
@property (nonatomic , strong) NSMutableArray *streetsArr;
@property (nonatomic , strong) UIImage *headImage;
//@property (nonatomic , strong) UIImageView *iconImageView;
@property (nonatomic , assign) NSInteger code;
@property (nonatomic , strong) NSTimer *timer;


@property (nonatomic, strong) CLLocationManager *locationManager;
@property (nonatomic, strong) UILabel *status;
@end

@implementation ShopManageViewController
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    _titleArr = @[@"商家名称",@"所在地区",@"详细地址"];
    [self createUI];
    [self loadData];
    
    // Do any additional setup after loading the view.
}

- (void)uploadImageSuccess{
    self.code = 1;
}

- (void)uploadImageFail{
    self.code = -1;
}

- (void)loadData{
    if (!CommonConfig.isLogin)
    {
        LoginViewController *singIn = [[LoginViewController alloc] init];
        [self.navigationController pushViewController:singIn animated:YES];
    }
    else
    {
        NSMutableArray *keys = [@[@"user_id",@"token"] mutableCopy];
        NSMutableArray *values = [@[@(CommonConfig.UserInfoCache.userId),[MyManager sharedMyManager].accessToken] mutableCopy];
        [SVProgressHUD show];
        [MySDKHelper postAsyncWithURL:@"/v1/my_promoter_detail" withParamBodyKey:keys withParamBodyValue:values needToken:CommonConfig.Token postSucceed:^(NSDictionary *result) {
            [SVProgressHUD dismiss];
            if ([result[@"code"] integerValue] == 0) {
                self.nameTextView.text = result[@"content"][@"shop_name"];
                self.regionTextView.text = [NSString stringWithFormat:@"%@ %@ %@",[self getNameFromIndex:[result[@"content"][@"province_id"] integerValue]],[self getNameFromIndex:[result[@"content"][@"city_id"] integerValue]],[self getNameFromIndex:[result[@"content"][@"region_id"] integerValue]]];
//                self.streetTextView.text = [self getNameFromIndex:[result[@"content"][@"tourist_id"] integerValue]];
                self.addressTextView.text = [NSString stringWithFormat:@"%@",result[@"content"][@"location"]];
                self.introduceTextView.text = result[@"content"][@"info"];
                self.streetsArr = [self getStreetsArr:[result[@"content"][@"region_id"] integerValue]];
                NSLog(@"街道 %d",[result[@"content"][@"region_id"] intValue]);
                self.streetsArr = [self getStreetsArr:[result[@"content"][@"region_id"] intValue]];
                UIImageView *imageView = [[UIImageView alloc] init];
                [imageView sd_setImageWithURL:[NSURL URLWithString:result[@"content"][@"picture"]] placeholderImage:[UIImage imageNamed:@"icon-60"] options:SDWebImageRefreshCached];
                UIImage *cachedImage = [[SDImageCache sharedImageCache] imageFromDiskCacheForKey:result[@"content"][@"picture"]];
                self.headImage = cachedImage;
                [self.tableView reloadData];

            }else{
                [NoticeView showMessage:result[@"message"]];
            }
            
            
        } postCancel:^(NSString *error) {
            NSLog(@"%@",error);
            [SVProgressHUD dismiss];
            [NoticeView showMessage:error];
        }];
    }
}

- (void)updateData:(NSArray *)keysArr withValue:valueArr{
    if (!CommonConfig.isLogin)
    {
        LoginViewController *singIn = [[LoginViewController alloc] init];
        [self.navigationController pushViewController:singIn animated:YES];
    }
    else
    {
        NSMutableArray *keys = [@[@"user_id",@"token"] mutableCopy];
        NSMutableArray *values = [@[@(CommonConfig.UserInfoCache.userId),CommonConfig.Token] mutableCopy];
        [keys addObjectsFromArray:keysArr];
        [values addObjectsFromArray:valueArr];
        [SVProgressHUD show];
        [MySDKHelper postAsyncWithURL:@"/v1/promoter_edit" withParamBodyKey:keys withParamBodyValue:values needToken:CommonConfig.Token postSucceed:^(NSDictionary *result) {
            [SVProgressHUD dismiss];
            [NoticeView showMessage:result[@"message"]];
            
        } postCancel:^(NSString *error) {
            NSLog(@"%@",error);
            [SVProgressHUD dismiss];
            [NoticeView showMessage:error];
        }];
    }
}
- (void)createUI{
    [self.view addSubview:self.tableView];
}

- (UITableView *)tableView {
    if (!_tableView) {
        UITableViewController* tvc=[[UITableViewController alloc] initWithStyle:UITableViewStyleGrouped];
        [self addChildViewController:tvc];
        [tvc.view setFrame:CGRectMake(0, -1, ScreenWidth, ScreenHeight)];
        _tableView = tvc.tableView;
        _tableView.delegate = self;
        _tableView.dataSource = self;
        [_tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"ShopManageCell"];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        //_tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    }
    return _tableView;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 3;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == 0) {
        return _titleArr.count;
    }
    return  1;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section == 0) {
       return 450*ScaleHeight;
    }
    return 0;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
//    if (indexPath.section == 0 && indexPath.row == self.titleArr.count - 1) {
//        return 150*ScaleHeight;
//    }else
    if (indexPath.section == 2){
        return 400*ScaleHeight;
    }
    return 90*ScaleHeight;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    if (section == 0) {
        UIImageView *imageViewBgv = [[UIImageView alloc] init];
        imageViewBgv.image = [UIImage imageNamed:@"icon-60"];
       // imageViewBgv.backgroundColor = [UIColor redColor];
        imageViewBgv.image = self.headImage;
        UIView *zhezao = [UIView new];
        zhezao.backgroundColor = [UIColor colorWithWhite:0.6 alpha:0.8];
        [imageViewBgv addSubview:zhezao];
        [zhezao mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.left.right.bottom.mas_equalTo(imageViewBgv);
        }];
        
        //返回按钮
        UIButton *backBtn = [UIButton new];
        [backBtn setImage:[UIImage iconWithInfo:TBCityIconInfoMake(icon_back, 50*ScaleWidth, [UIColor whiteColor])] forState:UIControlStateNormal];
        [backBtn addTarget:self action:@selector(backAction:) forControlEvents:UIControlEventTouchUpInside];
        [imageViewBgv addSubview:backBtn];
        [backBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(imageViewBgv.mas_top).mas_equalTo(20+15*ScaleHeight);
            make.left.mas_equalTo(imageViewBgv.mas_left).mas_offset(20*ScaleWidth);
            make.width.mas_equalTo(60*ScaleWidth);
            make.height.mas_equalTo(60*ScaleHeight);
        }];
        //导航栏的标题
        UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 36*ScaleWidth)];
        titleLabel.text = @"店铺管理";
        titleLabel.textAlignment = NSTextAlignmentCenter;
        titleLabel.font = [UIFont systemFontOfSize:18];
        titleLabel.textColor = [UIColor colorWithHexString:@"#fafafa"];
        [imageViewBgv addSubview:titleLabel];
        [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.mas_equalTo(imageViewBgv.mas_centerX);
            make.centerY.mas_equalTo(backBtn.mas_centerY);
        }];
        
        UIView *view = [[UIView alloc] init];
        view.backgroundColor = [UIColor whiteColor];
        [imageViewBgv addSubview:view];
        [view mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.left.right.mas_equalTo(imageViewBgv);
            make.height.mas_equalTo(100*ScaleHeight);
        }];
        
        UIImageView *iconImageView = [UIImageView new];
        iconImageView.image = [UIImage imageNamed:@"icon-6"];
        iconImageView.layer.cornerRadius = 150*ScaleWidth/2;
       // iconImageView.backgroundColor = [UIColor redColor];
        iconImageView.layer.masksToBounds = YES;
        iconImageView.userInteractionEnabled = YES;
        iconImageView.image = self.headImage;
        [imageViewBgv addSubview:iconImageView];
        [iconImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.mas_equalTo(view.mas_top);
            make.centerX.mas_equalTo(view.mas_centerX);
            make.width.height.mas_equalTo(150*ScaleWidth);
        }];
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(selectImage:)];
        tap.numberOfTapsRequired = 1;
        [iconImageView addGestureRecognizer:tap];
        imageViewBgv.userInteractionEnabled = YES;
        view.userInteractionEnabled = YES;
        return imageViewBgv;
    }
    return nil;
}
//选择图片
- (void)selectImage:(UITapGestureRecognizer *)tap{
    // 1、 获取摄像设备
    AVCaptureDevice *device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    if (device) {
        AVAuthorizationStatus status = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
        if (status == AVAuthorizationStatusNotDetermined) {
            [AVCaptureDevice requestAccessForMediaType:AVMediaTypeVideo completionHandler:^(BOOL granted) {
                if (granted) {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        //                        QRCodeScanningVC *vc = [[QRCodeScanningVC alloc] init];
                        //                        [self.navigationController pushViewController:vc animated:YES];
                    });
                    
                    SGQRCodeLog(@"当前线程 - - %@", [NSThread currentThread]);
                    // 用户第一次同意了访问相机权限
                    SGQRCodeLog(@"用户第一次同意了访问相机权限");
                    
                } else {
                    
                    // 用户第一次拒绝了访问相机权限
                    SGQRCodeLog(@"用户第一次拒绝了访问相机权限");
                }
            }];
        } else if (status == AVAuthorizationStatusAuthorized) { // 用户允许当前应用访问相机
            UIAlertController *controller = [UIAlertController alertControllerWithTitle:@"提示" message:@"请选择相册或者相机获取照片" preferredStyle:UIAlertControllerStyleActionSheet];
            UIAlertAction *albumAction = [UIAlertAction actionWithTitle:@"相册" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                [self open:1];
            }];
            
            UIAlertAction *cemeraAction = [UIAlertAction actionWithTitle:@"相机" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                [self open:2];
                
            }];
            UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
            
            [controller addAction:cancelAction];
            [controller addAction:albumAction];
            [controller addAction:cemeraAction];
        [self presentViewController:controller animated:YES completion:^{}];
            
            
        } else if (status == AVAuthorizationStatusDenied) { // 用户拒绝当前应用访问相机
            UIAlertController *alertC = [UIAlertController alertControllerWithTitle:@"⚠️ 警告" message:@"请去-> [设置 - 隐私 - 相机] 打开访问开关" preferredStyle:(UIAlertControllerStyleAlert)];
            UIAlertAction *alertA = [UIAlertAction actionWithTitle:@"确定" style:(UIAlertActionStyleDefault) handler:^(UIAlertAction * _Nonnull action) {
                
            }];
            
            [alertC addAction:alertA];
            [self presentViewController:alertC animated:YES completion:nil];
            
        } else if (status == AVAuthorizationStatusRestricted) {
            NSLog(@"因为系统原因, 无法访问相册");
        }
    } else {
        UIAlertController *alertC = [UIAlertController alertControllerWithTitle:@"温馨提示" message:@"未检测到您的摄像头" preferredStyle:(UIAlertControllerStyleAlert)];
        UIAlertAction *alertA = [UIAlertAction actionWithTitle:@"确定" style:(UIAlertActionStyleDefault) handler:^(UIAlertAction * _Nonnull action) {
            
        }];
        
        [alertC addAction:alertA];
        [self presentViewController:alertC animated:YES completion:nil];
    }
}


- (void)open:(NSInteger)index{
    NSInteger typeString;
    if (index == 1) {
        typeString = UIImagePickerControllerSourceTypePhotoLibrary;
    }else{
        typeString = UIImagePickerControllerSourceTypeCamera;
    }
    UIImagePickerController *imagePickerController = [[UIImagePickerController alloc] init];
    imagePickerController.delegate = self;
    imagePickerController.allowsEditing = YES;
    imagePickerController.sourceType = typeString;
    [self presentViewController:imagePickerController animated:YES completion:^{}];
    
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    [picker dismissViewControllerAnimated:YES completion:^{}];
    UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage];
    self.headImage = image;
    self.timer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(uploadImageData) userInfo:nil repeats:YES];
    // NSData *data = UIImageJPEGRepresentation(self.pickImage, 0.5);
    [SVProgressHUD show];
    NSData *imageData = UIImageJPEGRepresentation(image, 0.5);
    NSString *imageurl = [MySDKHelper uploadImageToUPyun:imageData];
    imageurl = imageurl == nil ? @"" : imageurl;
    self.imagurl = imageurl;
    /* 此处info 有六个值
     
     * UIImagePickerControllerMediaType; // an NSString UTTypeImage)
     
     * UIImagePickerControllerOriginalImage;  // a UIImage 原始图片
     
     * UIImagePickerControllerEditedImage;    // a UIImage 裁剪后图片
     
     * UIImagePickerControllerCropRect;       // an NSValue (CGRect)
     
     * UIImagePickerControllerMediaURL;       // an NSURL
     
     * UIImagePickerControllerReferenceURL    // an NSURL that references an asset in the AssetsLibrary framework
     
     * UIImagePickerControllerMediaMetadata    // an NSDictionary containing metadata from a captured photo
     
     */
    
    //    NSLog(@"%@",info);
}

- (void)uploadImageData{
    if (self.code == 1) {
        self.code = 0;
        NSArray *keys = @[@"picture"];
        NSArray *values = @[self.imagurl];
        [self updateData:keys withValue:values];
        [self.timer fire];
        [self.tableView reloadData];

        self.timer = nil;
        [SVProgressHUD dismiss];
    }else if (self.code == -1) {
        self.code = 0;
        [NoticeView showMessage:@"上传失败"];
        [self.timer fire];
        self.timer = nil;
        [SVProgressHUD dismiss];
        return;
    }
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [self dismissViewControllerAnimated:YES completion:^{}];
}

- (void)backAction:(UIButton *)btn{
    [self.navigationController popViewControllerAnimated:YES];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ShopManageCell"];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"ShopManageCell"];
    }
    for (UIView *view in cell.contentView.subviews) {
        [view removeFromSuperview];
    }
    if (indexPath.section == 0) {
        UILabel *label = [UILabel new];
        label.text = _titleArr[indexPath.row];
        label.textColor =  [UIColor blackColor];
        label.font = [UIFont systemFontOfSize:28*ScaleWidth];
        [cell.contentView addSubview:label];
        [label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(cell.contentView.mas_left).mas_offset(20*ScaleWidth);
            make.centerY.mas_equalTo(cell.contentView.mas_centerY);
            make.width.mas_equalTo(150*ScaleWidth);
        }];
        UITextView *textView = [UITextView new];
        textView.font = [UIFont systemFontOfSize:28*ScaleWidth];
        textView.textColor = [UIColor blackColor];
        textView.delegate = self;
        textView.scrollEnabled = NO;
        [cell.contentView addSubview:textView];
        [textView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(label.mas_right).mas_equalTo(40*ScaleWidth);
            make.right.mas_equalTo(cell.contentView.mas_right).mas_equalTo(-10*ScaleWidth);
            make.centerY.mas_equalTo(label.mas_centerY);
            make.bottom.mas_equalTo(cell.contentView.mas_bottom).mas_equalTo(-10*ScaleHeight);
        }];
        if (indexPath.row == 0) {
            if (self.nameTextView != nil) {
                textView.text = self.nameTextView.text;
            }
            self.nameTextView = textView;
        }else if (indexPath.row == 1){
            if (self.regionTextView != nil) {
                textView.text = self.regionTextView.text;
            }
            self.regionTextView = textView;
//        }else if (indexPath.row == 2){
//            if (self.streetTextView != nil) {
//                textView.text = self.streetTextView.text;
//            }
//            self.streetTextView = textView;
        }else{
            [label mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.left.mas_equalTo(cell.contentView.mas_left).mas_offset(20*ScaleWidth);
                make.top.mas_equalTo(cell.contentView.mas_top).mas_equalTo(25*ScaleHeight);
            }];
            [textView mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.left.mas_equalTo(label.mas_right).mas_equalTo(40*ScaleWidth);
                make.right.mas_equalTo(cell.contentView.mas_right).mas_equalTo(-10*ScaleWidth);
                make.top.mas_equalTo(cell.contentView.mas_top).mas_equalTo(10*ScaleHeight);
                make.bottom.mas_equalTo(cell.contentView.mas_bottom).mas_equalTo(-10*ScaleHeight);
            }];
            textView.scrollEnabled = YES;
            if (self.addressTextView != nil) {
                textView.text = self.addressTextView.text;
            }
            self.addressTextView = textView;
        }
        if (indexPath.row < self.titleArr.count - 1) {
            UIView *line = [UIView new];
            line.backgroundColor = [UIColor colorWithWhite:0.8 alpha:0.6];
            [cell.contentView addSubview:line];
            [line mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.mas_equalTo(cell.contentView.mas_bottom);
                make.left.mas_equalTo(cell.contentView.mas_left);
                make.width.mas_equalTo(ScreenWidth);
                make.height.mas_equalTo(1);
            }];
        }
        if (indexPath.row > 0 && indexPath.row < self.titleArr.count - 1) {
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            textView.userInteractionEnabled = NO;
        }
    }else if (indexPath.section == 1)
    {
        UIView *dinWei = [[UIView alloc] init];
//        dinWei.backgroundColor = [UIColor greenColor];
        [cell.contentView addSubview:dinWei];
        [dinWei mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(cell.contentView.mas_top);
            make.bottom.mas_equalTo(cell.contentView.mas_bottom);
            make.left.mas_equalTo(cell.contentView.mas_left);
            make.right.mas_equalTo(cell.contentView.mas_right);
        }];
        
        UILabel *lab = [[UILabel alloc] init];
        lab.text = @"点击定位当前位置";
        lab.font = [UIFont systemFontOfSize:16];
        self.status = lab;
        [dinWei addSubview:lab];
        [lab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.center.mas_equalTo(dinWei.center);
        }];
        
        UIImageView *image = [[UIImageView alloc] init];
        image.image = [UIImage iconWithInfo:TBCityIconInfoMake(@"\U0000e69a", 20, [UIColor redColor])];
        [dinWei addSubview:image];
        [image mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(lab.mas_left);
            make.centerY.mas_equalTo(lab);
            make.width.mas_equalTo(20);
            make.height.mas_equalTo(20);
        }];
        
    }else{
        UILabel *label = [UILabel new];
        label.text = @"店铺介绍";
        label.textColor =  [UIColor blackColor];
        label.font = [UIFont systemFontOfSize:28*ScaleWidth];
        [cell.contentView addSubview:label];
        [label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(cell.contentView.mas_left).mas_offset(20*ScaleWidth);
            make.top.mas_equalTo(cell.contentView.mas_top).mas_equalTo(20*ScaleHeight);
        }];
        UILabel *label1 = [UILabel new];
        
        label1.text = [NSString stringWithFormat:@"(0/100)"];
        label1.textColor =  [UIColor colorWithWhite:0.8 alpha:0.9];
        label1.font = [UIFont systemFontOfSize:28*ScaleWidth];
        [cell.contentView addSubview:label1];
        [label1 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(label.mas_right).mas_offset(20*ScaleWidth);
            make.centerY.mas_equalTo(label.mas_centerY);
        }];
        self.numberLabel = label1;
        UITextView *textView = [UITextView new];
        textView.text = @"请输入店铺相关介绍";
        textView.delegate = self;
        textView.textColor = [UIColor colorWithWhite:0.8 alpha:0.9];
        textView.font = [UIFont systemFontOfSize:28*ScaleWidth];
        
        [cell.contentView addSubview:textView];
        [textView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(label.mas_bottom).mas_equalTo(30*ScaleHeight);
            make.bottom.mas_equalTo(cell.contentView.mas_bottom).mas_equalTo(-10*ScaleHeight);
            make.left.mas_equalTo(cell.contentView.mas_left).mas_equalTo(20*ScaleWidth);
            make.right.mas_equalTo(cell.contentView.mas_right).mas_equalTo(-10*ScaleWidth);
        }];
        if (self.introduceTextView != nil) {
            textView.text = self.introduceTextView.text;
            label1.text = [NSString stringWithFormat:@"(%ld/100)",(unsigned long)self.introduceTextView.text.length];
        }
        self.introduceTextView = textView;
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.section == 0 && indexPath.row == 1 && indexPath.row < self.titleArr.count - 1) {
        [MySDKHelper getCityName:^(NSString *city) {
            NSLog(@"city:%@",city);
            if (city != nil || ![city isEqualToString:@""]) {
                NSArray *dataArr = [city componentsSeparatedByString:@"+"];
                self.regionTextView.text = dataArr[0];
                self.addressTextView.text = dataArr[0];
                NSArray *dataArr1 = [dataArr[1] componentsSeparatedByString:@" "];
                self.streetsArr = [self getStreetsArr:[[dataArr1 lastObject] integerValue]];
                NSArray *dataArr2 = [dataArr[0] componentsSeparatedByString:@" "];
                if (self.streetsArr.count == 0) {
                    self.streetTextView.text = [dataArr2 lastObject];
                    NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
                    [dic setObject:[[dataArr2 lastObject] mutableCopy] forKey:@"name"];
                    [dic setObject:[dataArr1 lastObject] forKey:@"id"];
                    self.streetsArr = [[NSMutableArray alloc] init];
                    [self.streetsArr addObject:dic];
                    //self.streetsArr = [@{ @"name" :  , @"id" : } mutableCopy];
                    NSString *locationString = [NSString stringWithFormat:@"%@%@%@%@",dataArr2[0],dataArr2[1],dataArr2[2],dataArr2[2]];
                    self.addressTextView.text = locationString;
                    NSArray *keys = @[@"province_id",@"city_id",@"region_id",@"tourist_id",@"location"];
                    NSArray *values = @[dataArr1[0],dataArr1[1],dataArr1[2],dataArr1[2],locationString];
                    [self updateData:keys withValue:values];
                }else{
                    //                self.streetsArr = [@[] mutableCopy];
                    NSDictionary *dic = self.streetsArr[0];
                    //                self.streetTextView.text = dic[@"name"];
                    self.streetTextView.text = nil;
                    self.addressTextView.text = [NSString stringWithFormat:@"%@",self.regionTextView.text];
                    NSArray *dataArr3 = [self.addressTextView.text componentsSeparatedByString:@" "];
                    NSMutableString *locationString = [[NSMutableString alloc] init];
                    for (NSString *string in dataArr3) {
                        [locationString appendString:string];
                    }
                    self.addressTextView.text = locationString;
                    NSArray *keys = @[@"province_id",@"city_id",@"region_id",@"tourist_id",@"location"];
                    NSArray *values = @[dataArr1[0],dataArr1[1],dataArr1[2],dic[@"id"],locationString];
                    [self updateData:keys withValue:values];
                }
            }
        }];
        
    }
//    else if (indexPath.section == 0 && indexPath.row == 2){
//        if (self.streetsArr == nil || self.streetsArr.count == 0) {
//            //self.streetsArr = [@{@"name" : @"-1"} mutableCopy];
//            return;
//        }
//        AddressChoicePickerView *addressPickerView = [[AddressChoicePickerView alloc] initWithFromArr:self.streetsArr];
//
//        addressPickerView.block = ^(AddressChoicePickerView *view, UIButton *btn, AreaObject *locate) {
//            NSString *city = [NSString stringWithFormat:@"%@",locate];
//            NSArray *dataArr = [city componentsSeparatedByString:@"+"];
//            NSArray *dataArr1 = [dataArr[0] componentsSeparatedByString:@" "];
//            NSArray *dataArr2 = [dataArr[1] componentsSeparatedByString:@" "];
//            self.streetTextView.text = [dataArr1 firstObject];
//            NSString *dataString = [NSString stringWithFormat:@"%@ %@",self.regionTextView.text,[dataArr1 firstObject]];
//            NSArray *dataArr3 = [dataString componentsSeparatedByString:@" "];
//            NSMutableString *locationString = [[NSMutableString alloc] init];
//            for (NSString *string in dataArr3) {
//                [locationString appendString:string];
//            }
//            self.addressTextView.text = locationString;
//            NSArray *keys = @[@"tourist_id",@"location"];
//            NSArray *values = @[dataArr2[0],locationString];
//            [self updateData:keys withValue:values];
//        };
//        [addressPickerView show];
//    }
    else if (indexPath.section == 1)
    {
        [self AutoDinWei];
    }
}

-(void)AutoDinWei
{
    self.locationManager = [[CLLocationManager alloc] init];
    self.locationManager.delegate = self;
    self.locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    // distanceFilter是距离过滤器，为了减少对定位装置的轮询次数，位置的改变不会每次都去通知委托，而是在移动了足够的距离时才通知委托程序
    // 它的单位是米，这里设置为至少移动1000再通知委托处理更新;
    self.locationManager.distanceFilter = 1000.0f; // 如果设为kCLDistanceFilterNone，则每秒更新一次;
    if ([CLLocationManager locationServicesEnabled]) {
        // 启动位置更新
        // 开启位置更新需要与服务器进行轮询所以会比较耗电，在不需要时用stopUpdatingLocation方法关闭;
        self.status.text = @"正在定位";
        if ([CLLocationManager authorizationStatus] == kCLAuthorizationStatusDenied){
            UIAlertController *controller = [UIAlertController alertControllerWithTitle:@"⚠️ 提示" message:@"开启定位:设置 > 隐私 > 定位服务 > 圆梦商城" preferredStyle:UIAlertControllerStyleActionSheet];
            UIAlertAction *alertA = [UIAlertAction actionWithTitle:@"确定" style:(UIAlertActionStyleDefault) handler:^(UIAlertAction * _Nonnull action) {
                
            }];
            [controller addAction:alertA];
            [self presentViewController:controller animated:YES completion:nil];
            
        }else{
            if ([[[UIDevice currentDevice] systemVersion] floatValue] > 8.0)
            {
                [_locationManager requestAlwaysAuthorization];
                [_locationManager requestWhenInUseAuthorization];
            }
            
            [self.locationManager startUpdatingLocation];
        }
        
    }else {
        UIAlertController *controller = [UIAlertController alertControllerWithTitle:@"⚠️ 提示" message:@"开启定位:设置 > 隐私 > 定位服务" preferredStyle:UIAlertControllerStyleActionSheet];
        UIAlertAction *alertA = [UIAlertAction actionWithTitle:@"确定" style:(UIAlertActionStyleDefault) handler:^(UIAlertAction * _Nonnull action) {
            
        }];
        
        [controller addAction:alertA];
        [self presentViewController:controller animated:YES completion:nil];
    }
}

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray<CLLocation *> *)locations{
    CLLocation *location = [locations lastObject];
    //    CLLocationDegrees latitude = location.coordinate.latitude;
    //    CLLocationDegrees longitude = location.coordinate.longitude;
    NSLog(@"纬度:%f",location.coordinate.latitude);
    NSLog(@"经度:%f",location.coordinate.longitude);
    [manager stopUpdatingLocation];
    CLGeocoder * geoCoder = [[CLGeocoder alloc] init];
    [geoCoder reverseGeocodeLocation:location completionHandler:^(NSArray<CLPlacemark *> * _Nullable placemarks, NSError * _Nullable error) {
        CLPlacemark *placemark = [placemarks lastObject];
            //获取城市
            NSString *city = placemark.locality;
            if (!city) {
                //四大直辖市的城市信息无法通过locality获得，只能通过获取省份的方法来获得（如果city为空，则可知为直辖市）
                city = placemark.administrativeArea;
            }
            NSLog(@"city = %@", city);//石家庄市
            NSLog(@"--%@",placemark.name);//黄河大道221号
            NSLog(@"++++%@",placemark.subLocality); //裕华区
            NSLog(@"administrativeArea == %@",placemark.administrativeArea); //河北省
            NSString *province_id = [self getIndexFromName:[NSString stringWithFormat:@"%@",placemark.administrativeArea]];
            NSString *city_id = [self getIndexFromName:[NSString stringWithFormat:@"%@",city]];
            NSString *region_id = [self getIndexFromName:[NSString stringWithFormat:@"%@",placemark.subLocality]];
        
        self.regionTextView.text = [NSString stringWithFormat:@"%@ %@ %@",placemark.administrativeArea,city,placemark.subLocality];
        self.addressTextView.text = [NSString stringWithFormat:@"%@%@%@%@",placemark.administrativeArea,city,placemark.subLocality,placemark.name];
        
        self.status.text = @"定位成功，点击刷新";
        NSString *str = [NSString stringWithFormat:@"%@%@%@%@",placemark.administrativeArea,city,placemark.subLocality,placemark.name];
        NSLog(@"%@",str);
        
        NSArray *keys = @[@"province_id",@"city_id",@"region_id",@"location"];
        NSArray *values = @[province_id,city_id,region_id,str];
        [self updateData:keys withValue:values];
    }];
    //系统会一直更新数据，直到选择停止更新，因为我们只需要获得一次经纬度即可，所以获取之后就停止更新
    [manager stopUpdatingLocation];
}


- (NSString *)getNameFromIndex:(NSInteger) index{
    if (self.addressArr == nil) {
        NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
        NSArray *addressData = [userDefault valueForKey:@"addressdata"];
        self.addressArr = addressData;
    }
    NSString *string;
    for (int k = 0; k < self.addressArr.count; k++) {
        NSMutableDictionary *dic3 = [[NSMutableDictionary alloc]initWithDictionary:[self.addressArr objectAtIndex:k]];
        if ([dic3[@"id"] integerValue] == index) {
            string = dic3[@"name"];
        }
    }
    if (string == nil) {
        string = @"";
    }
    return string;
}

-(NSString *)getIndexFromName:(NSString *)name{
    if (self.addressArr == nil) {
        NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
        NSArray *addressData = [userDefault valueForKey:@"addressdata"];
        self.addressArr = addressData;
    }
    NSString *string;
    for (int k = 0; k < self.addressArr.count; k++) {
        NSMutableDictionary *dic3 = [[NSMutableDictionary alloc]initWithDictionary:[self.addressArr objectAtIndex:k]];
        if ([dic3[@"name"] isEqualToString:name]) {
            string = dic3[@"id"];
        }
    }
    if (string == nil) {
        string = @"";
    }
    return string;
}

- (NSMutableArray *)getStreetsArr:(NSInteger )index{
    if (self.addressArr == nil) {
        NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
        NSArray *addressData = [userDefault valueForKey:@"addressdata"];
        self.addressArr = addressData;
    }
   NSMutableArray *arr = [[NSMutableArray alloc] init];
    for (int k = 0; k < self.addressArr.count; k++) {
        NSMutableDictionary *dic3 = [[NSMutableDictionary alloc]initWithDictionary:[self.addressArr objectAtIndex:k]];
        if ([dic3[@"parent_id"] integerValue] == index) {
            [arr addObject:dic3];
        }
    }
    return arr;
}

- (void)scrollViewWillBeginDecelerating:(UIScrollView *)scrollView{
    [self.currentTextView resignFirstResponder];
}
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.currentTextView resignFirstResponder];
}

- (void)textViewDidBeginEditing:(UITextView *)textView{
    self.currentTextView = textView;
    if (textView == self.introduceTextView) {
        textView.text = @"";
    }
}
- (void)textViewDidEndEditing:(UITextView *)textView{
    if (textView == self.nameTextView) {
        NSArray *keys = @[@"name"];
        NSArray *values = @[textView.text];
        [self updateData:keys withValue:values];
    }else if (textView == self.introduceTextView){
        NSArray *keys = @[@"info"];
        NSArray *values = @[textView.text];
        [self updateData:keys withValue:values];
    }else if (textView == self.addressTextView){
        NSArray *keys = @[@"location"];
        NSArray *values = @[textView.text];
        [self updateData:keys withValue:values];
    }
}
- (void)textViewDidChange:(UITextView *)textView{
    if (textView.text.length >= 100) {
        textView.text = [textView.text substringWithRange:NSMakeRange(0, 100)];
    }
    self.numberLabel.text = [NSString stringWithFormat:@"(%ld/100)",(unsigned long)textView.text.length];
}




- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    self.navigationController.navigationBar.hidden = YES;
    self.navigationController.navigationBarHidden = YES;
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(uploadImageSuccess) name:@"uploadImageSuccess" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(uploadImageFail) name:@"uploadImageFail" object:nil];
}



- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}

- (IBAction)backClick:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

@end
