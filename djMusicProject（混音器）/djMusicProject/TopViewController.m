//
//  TopViewController.m
//  collectionView
//
//  Created by ios01 on 2017/7/24.
//  Copyright © 2017年 ios01. All rights reserved.
//

#import "TopViewController.h"
#import "CollectionViewController.h"
#import "AppDelegate.h"
#import "CABasicAnimation+Ext.h"

@interface TopViewController ()
@property (weak, nonatomic) IBOutlet UIView *chirdView;
@property (weak, nonatomic) IBOutlet UIButton *firstButton;
@property (weak, nonatomic) IBOutlet UIButton *storeButton;
@property (weak, nonatomic) IBOutlet UIButton *recordButton;
@property (weak, nonatomic) IBOutlet UIButton *pointButton;
@property (weak, nonatomic) IBOutlet UISlider *slider;
@property (strong, nonatomic) CollectionViewController *collection;
@property (weak, nonatomic) IBOutlet UIView *headerView;
@property (weak, nonatomic) IBOutlet UIView *footView;


//TheAmazingAudioEngine
@property (nonatomic, strong) AERecorder *recorder;

@end

@implementation TopViewController




- (IBAction)changeValue:(UISlider *)sender {
    NSNumber *number = [NSNumber numberWithFloat:sender.value];
    NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithCapacity:0];
    [dic setObject:number forKey:@"声音"];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"NSNotification" object:nil userInfo:dic];
    
    NSLog(@"appDelegate.window = %lf", appDelegate.volumeValue);
    appDelegate.volumeValue = sender.value;
    
}


- (void)viewDidLoad {
    [super viewDidLoad];
    _headerView.backgroundColor = MainColor;
    _footView.backgroundColor = MainColor;
    self.navigationController.navigationBar.hidden = YES;
//    _chirdView.backgroundColor = UIColorFromRGB(0x191f23);
    [self addApla];
    [self addSlider];
    [self addCollectionView];
}

- (void)addApla{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(notifi:) name:@"notificationNames" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(notificationMeth:) name:@"notificationN" object:nil];
}

- (void)notifi:(NSNotification *)notification{
    _firstButton.alpha = 0.4;
    _storeButton.alpha = 0.4;
}

- (void)notificationMeth:(NSNotification *)notification{
    _firstButton.alpha = 1.0;
    _storeButton.alpha = 1.0;
}

- (void)addCollectionView{
    UIStoryboard *mainBoard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    CollectionViewController *coll = (CollectionViewController *)[mainBoard instantiateViewControllerWithIdentifier:@"collectionViewController"];
    coll.view.frame = self.chirdView.bounds;
//    coll.view.frame = CGRectMake(0, 64, FFScreen_W, FFScreen_H - 64 - 61);
    [self.chirdView addSubview:coll.view];
    [coll didMoveToParentViewController:self];
    [self addChildViewController:coll];
    _collection = coll;
}

- (void)addSlider{
    UIImageView *view = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 27, 15)];
    view.image = [UIImage imageNamed:@"volume(1)"];
    [_slider setThumbImage:view.image forState:UIControlStateNormal];
    [_slider setThumbImage:view.image forState:UIControlStateHighlighted];
    [_slider addTarget:self action:@selector(changeValue:) forControlEvents:UIControlEventValueChanged];
    appDelegate.volumeValue = [_slider value];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)pushView:(UIButton *)sender {
//    if ([_collection hasMusicPlaying]) {
//        return;
//    }
//    [self.mm_drawerController toggleDrawerSide:MMDrawerSideLeft animated:YES completion:nil];
    
}

- (IBAction)storeButton:(UIButton *)sender {
//    if ([_collection hasMusicPlaying]) {
//        return;
//    }
//    UIStoryboard *mainBoard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
//    StoreViewController *storeViewController = (StoreViewController *)[mainBoard instantiateViewControllerWithIdentifier:@"StoreViewController"];
//    [self.navigationController pushViewController:storeViewController animated:YES];
////    当我们push成功之后，关闭我们的抽屉
//    [self.mm_drawerController closeDrawerAnimated:YES completion:^(BOOL finished) {
//        //设置打开抽屉模式为MMOpenDrawerGestureModeNone，也就是没有任何效果。
//        [self.mm_drawerController setOpenDrawerGestureModeMask:MMOpenDrawerGestureModeNone];
//    }];
}


- (IBAction)recodingButton:(UIButton *)sender {
    sender.selected =! sender.selected;
    NSLog(@"录音");
    //1.获取沙盒地址
    NSString *paths = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    // 获取系统当前时间
    NSDate * date = [NSDate date];
    NSTimeInterval sec = [date timeIntervalSinceNow];
    NSDate * currentDate = [[NSDate alloc] initWithTimeIntervalSinceNow:sec];
    //        设置时间输出格式：
    NSDateFormatter * df = [[NSDateFormatter alloc] init];
    [df setDateFormat:@"yyyy年MM月dd日 HH:mm:ss"];
    NSString * na = [df stringFromDate:currentDate];
    NSString *pathString = [[NSString alloc] initWithFormat:@"/%@_www.m4a",na];
    if (sender.selected == YES) {
        [sender setImage:[UIImage imageNamed:@"rec"] forState:UIControlStateNormal];
        [_pointButton setImage:[UIImage imageNamed:@"rec_red"] forState:UIControlStateNormal];
        [_pointButton.layer addAnimation:[CABasicAnimation opacityForever_Animation:0.5] forKey:nil];
        NSLog(@"开始录音");
        if ( _recorder ) {
            [_recorder finishRecording];
            [appDelegate.audioController removeOutputReceiver:_recorder];
            [appDelegate.audioController removeInputReceiver:_recorder];
            self.recorder = nil;
            _recordButton.selected = NO;
        } else {
            self.recorder = [[AERecorder alloc] initWithAudioController:appDelegate.audioController];
            //2.获取文件路径
            NSString *path = [paths stringByAppendingString:pathString];
            NSError *error = nil;
            if ( ![_recorder beginRecordingToFileAtPath:path fileType:kAudioFileM4AType error:&error] ) {
                [[[UIAlertView alloc] initWithTitle:@"Error"
                                            message:[NSString stringWithFormat:@"Couldn't start recording: %@", [error localizedDescription]]
                                           delegate:nil
                                  cancelButtonTitle:nil
                                  otherButtonTitles:@"OK", nil] show];
                self.recorder = nil;
                return;
            }
            
            _recordButton.selected = YES;
            
            [appDelegate.audioController addOutputReceiver:_recorder];
            //            [_audioController addInputReceiver:_recorder];
        }
    }else{
        [_pointButton setImage:[UIImage imageNamed:@"rec_white"] forState:UIControlStateNormal];
        [sender setImage:[UIImage imageNamed:@"rec_normal_09"] forState:UIControlStateNormal];
        [_pointButton.layer removeAllAnimations];
        NSLog(@"停止录音");
        [_recorder finishRecording];
        //        [_audioController removeInputReceiver:_recorder];
        [appDelegate.audioController removeOutputReceiver:_recorder];
        self.recorder = nil;
    }
    
}


- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
}


@end
