//
//  CollectionViewController.m
//  collectionView
//
//  Created by ios01 on 2017/7/10.
//  Copyright © 2017年 ios01. All rights reserved.
//

#import "CollectionViewController.h"
#import "CollectionViewCell.h"

#import <MediaPlayer/MediaPlayer.h>
#import "CellModel.h"
@interface CollectionViewController ()

//数据源
@property (nonatomic, copy) NSMutableArray *buttonImageArray;
@property (strong, nonatomic) UIButton *pointButton;
//录音
@property (nonatomic, strong)AVAudioSession *session;
@property (nonatomic, copy)NSURL *recordFileUrl;
@property (nonatomic, strong)AVAudioRecorder *recorder;

@property (nonatomic, copy) NSString *recordUrlString;

@property (nonatomic, strong) NSMutableArray *array;

@property (nonatomic, strong) NSMutableArray *selectedArray;

@end

@implementation CollectionViewController

#pragma mark 音量控件

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = UIColorFromRGB(0x191f23);
    self.collectionView.backgroundColor = MainColor;
    [self loadData];
    _array = [NSMutableArray arrayWithCapacity:0];
    _selectedArray = [NSMutableArray arrayWithCapacity:0];
    [self.array addObjectsFromArray:@[@"0",@"0",@"0",@"0",@"0",@"0"]];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(notifica:) name:@"NSNotification" object:nil];
    
}
//监听uislider动态控制volume
- (void)notifica:(NSNotification *)notification{
    NSNumber *number = [notification.userInfo objectForKey:@"声音"];
    [appDelegate.audioController setMasterOutputVolume:[number floatValue]];
}


#pragma mark 初始化数据源
//初始化数据源
- (void)loadData{
    if (![[NSUserDefaults standardUserDefaults] objectForKey:@"Drum"]) {
        NSMutableArray *drums = [[NSMutableArray alloc] initWithCapacity:0];
        for (int i = 0; i < 6 ; i ++) {
            NSString *string = [NSString stringWithFormat:@"Drum_%d",i];
            [drums addObject:string];
        }
        NSMutableArray *percussions = [[NSMutableArray alloc] init];
        for (int i = 0; i < 6 ; i ++) {
            NSString *string = [NSString stringWithFormat:@"Percussion_%d",i];
            [percussions addObject:string];
        }
        NSMutableArray *synths = [[NSMutableArray alloc] init];
        for (int i = 0; i < 6 ; i ++) {
            NSString *string = [NSString stringWithFormat:@"Synth_%d",i];
            [synths addObject:string];
        }
        NSMutableArray *loops = [[NSMutableArray alloc] init];
        for (int i = 0; i < 6 ; i ++) {
            NSString *string = [NSString stringWithFormat:@"Loop_%d",i];
            [loops addObject:string];
        }
        NSMutableArray *melodics = [[NSMutableArray alloc] init];
        for (int i = 0; i < 6 ; i ++) {
            NSString *string = [NSString stringWithFormat:@"Melodic_%d",i];
            [melodics addObject:string];
        }
        NSMutableArray *bass = [[NSMutableArray alloc] init];
        for (int i = 0; i < 6 ; i ++) {
            NSString *string = [NSString stringWithFormat:@"Bass_%d",i];
            [bass addObject:string];
        }
        NSMutableArray *fx = [[NSMutableArray alloc] init];
        for (int i = 0; i < 6 ; i ++) {
            NSString *string = [NSString stringWithFormat:@"Fx_%d",i];
            [fx addObject:string];
        }
        NSMutableArray *vocal = [[NSMutableArray alloc] init];
        for (int i = 0; i < 6 ; i ++) {
            NSString *string = [NSString stringWithFormat:@"Vocal_%d",i];
            [vocal addObject:string];
        }
        [[NSUserDefaults standardUserDefaults] setObject:drums forKey:@"Drum"];
        [[NSUserDefaults standardUserDefaults] setObject:percussions forKey:@"Percussion"];
        [[NSUserDefaults standardUserDefaults] setObject:synths forKey:@"Synth"];
        [[NSUserDefaults standardUserDefaults] setObject:loops forKey:@"Loop"];
        [[NSUserDefaults standardUserDefaults] setObject:melodics forKey:@"Melodic"];
        [[NSUserDefaults standardUserDefaults] setObject:bass forKey:@"Bass"];
        [[NSUserDefaults standardUserDefaults] setObject:fx forKey:@"Fx"];
        [[NSUserDefaults standardUserDefaults] setObject:vocal forKey:@"Vocal"];
    }
}


- (NSMutableArray *)buttonImageArray{
    if (!_buttonImageArray) {
        _buttonImageArray = [NSMutableArray arrayWithCapacity:0];
//        [CellModel careatModel:@"drum_s" button:@"drum_play"];
        CellModel *model = [[CellModel alloc] init];
        model.buttonImageUrl = @"drum_s";
        model.selectedButtonUrl = @"drum_play";
        CellModel *model1 = [[CellModel alloc] init];
        model1.buttonImageUrl = @"percussion_s";
        model1.selectedButtonUrl = @"percussion_play";
        CellModel *model2 = [[CellModel alloc] init];
        model2.buttonImageUrl = @"bass_s";
        model2.selectedButtonUrl = @"bass_play";
        CellModel *model3 = [[CellModel alloc] init];
        model3.buttonImageUrl = @"synth_s";
        model3.selectedButtonUrl = @"synth_play";
        CellModel *model4 = [[CellModel alloc] init];
        model4.buttonImageUrl = @"melodic_s";
        model4.selectedButtonUrl = @"melodic_play";
        CellModel *model5 = [[CellModel alloc] init];
        model5.buttonImageUrl = @"loop_s";
        model5.selectedButtonUrl = @"loop_play";
        CellModel *model6 = [[CellModel alloc] init];
        model6.buttonImageUrl = @"fx1";
        model6.selectedButtonUrl = @"fx_play";
        CellModel *model7 = [[CellModel alloc] init];
        model7.buttonImageUrl = @"vocal1";
        model7.selectedButtonUrl = @"vocal_play";
        [_buttonImageArray addObjectsFromArray:@[model,model1,model2,model3,model4,model5,model6,model7]];
    }
    return _buttonImageArray;
}


- (UIStatusBarStyle)preferredStatusBarStyle{
    return UIStatusBarStyleLightContent;
}

#pragma mark <UICollectionViewDataSource>
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 4;
}

-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    if (section == 0) {
        return UIEdgeInsetsMake(20, 10, 5, 10);//分别为上、左、下、右
    }
    return UIEdgeInsetsMake(0, 10, 5, 10);//分别为上、左、下、右
    
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    int width = (UISCREEN_WIDTH - 3 * 10) / 2;
    int height = (UISCREEN_HEIGHT / 5.8);
    return CGSizeMake(width, height);
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return 2;
}
//cell中设置对应的buttonImage
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *identify = @"myCell";
    CollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:identify forIndexPath:indexPath];
    
    if (indexPath.section == 0) {
        cell.cellModel = self.buttonImageArray[indexPath.row];
        if (indexPath.row == 0) {
            [self changeButtonImage:cell.firstButton imageUrl:@"drum_f"];
            [self changeButtonImage:cell.thirdButton imageUrl:@"drum_f"];
            [self changeButtonImage:cell.fourthButton imageUrl:@"drum_f"];
            [self changeButtonImage:cell.fifthButton imageUrl:@"drum_f"];
        }else{
            [self changeButtonImage:cell.thirdButton imageUrl:@"percussion_f"];
            [self changeButtonImage:cell.fourthButton imageUrl:@"percussion_f"];
            [self changeButtonImage:cell.fifthButton imageUrl:@"percussion_f"];
        }
    }else if (indexPath.section == 1){
        cell.cellModel = self.buttonImageArray[indexPath.row + 2];
        if (indexPath.row == 0) {
            [self changeButtonImage:cell.firstButton imageUrl:@"bass_f"];
            [self changeButtonImage:cell.second imageUrl:@"bass_f"];
        }else{
            [self changeButtonImage:cell.firstButton imageUrl:@"synth_f(1)"];
            [self changeButtonImage:cell.second imageUrl:@"synth_f(1)"];
        }
    }else if (indexPath.section == 2){
        cell.cellModel = self.buttonImageArray[indexPath.row + 4];
        if (indexPath.row == 0) {
            [self changeButtonImage:cell.fourthButton imageUrl:@"melodic_f"];
            [self changeButtonImage:cell.fifthButton imageUrl:@"melodic_f"];
            [self changeButtonImage:cell.sixthButton imageUrl:@"melodic_f"];
        }else{
            [self changeButtonImage:cell.second imageUrl:@"loop_f"];
            [self changeButtonImage:cell.thirdButton imageUrl:@"loop_f"];
            [self changeButtonImage:cell.sixthButton imageUrl:@"loop_f"];
        }
    }else if (indexPath.section == 3){
        cell.cellModel = self.buttonImageArray[indexPath.row + 6];
    }
    if (indexPath.section == 3) {
        //点下的事件
        [self touchDown:cell.firstButton];
        [self touchDown:cell.second];
        [self touchDown:cell.thirdButton];
        [self touchDown:cell.fourthButton];
        [self touchDown:cell.fifthButton];
        [self touchDown:cell.sixthButton];
        //松手事件
        [self touchUp:cell.firstButton];
        [self touchUp:cell.second];
        [self touchUp:cell.thirdButton];
        [self touchUp:cell.fourthButton];
        [self touchUp:cell.fifthButton];
        [self touchUp:cell.sixthButton];
    }else{
        //前六个cell的点击事件
        [self action:cell.firstButton];
        [self action:cell.second];
        [self action:cell.thirdButton];
        [self action:cell.fourthButton];
        [self action:cell.fifthButton];
        [self action:cell.sixthButton];
    }
    return cell;
}

- (void)changeButtonImage:(UIButton *)button imageUrl:(NSString *)imageUrl{
    [button setImage:[UIImage imageNamed:imageUrl] forState:UIControlStateNormal];
}

- (void)action:(UIButton *)sender{
    [sender addTarget:self action:@selector(firstClick:) forControlEvents:UIControlEventTouchUpInside];
}

- (void)touchUp:(UIButton *)sender{
    [sender addTarget:self action:@selector(upOninse:) forControlEvents:UIControlEventTouchUpInside];
}

- (void)touchDown:(UIButton *)sender{
    [sender addTarget:self action:@selector(secondClick:) forControlEvents:UIControlEventTouchDown];
}


//获取点击cell的方法
- (NSIndexPath *)getindexPath:(UIButton *)sender{
    UIView *view = [sender superview];
    CollectionViewCell *cell = (CollectionViewCell *)[[view superview] superview];
    NSIndexPath *indexPath = [self.collectionView indexPathForCell:cell];
    return indexPath;
}

#pragma mark - 第7.8cell的事件
//第7.8cell的事件
- (void)secondClick:(UIButton *)sender{
    NSMutableArray *fx = [[NSUserDefaults standardUserDefaults] objectForKey:@"Fx"];
    NSMutableArray *vocal = [[NSUserDefaults standardUserDefaults] objectForKey:@"Vocal"];
    //获取当前点击cell
    NSIndexPath *indexPath = [self getindexPath:sender];
    sender.backgroundColor = [UIColor clearColor];
    if (sender.tag == 101)
    {
        if (indexPath.row == 0) {
            [self creactSeventhAEplayer:fx[0] WithofType:@"mp3"];
        }else{
            [self creacteightAEplayer:vocal[0] WithofType:@"mp3"];
        }
    }
    else if (sender.tag == 102)
    {
        if (indexPath.row == 0) {
            [self creactSeventhAEplayer:fx[1] WithofType:@"mp3"];
        }else{
            [self creacteightAEplayer:vocal[1] WithofType:@"mp3"];
        }
    }
    else if (sender.tag == 103)
    {
        if (indexPath.row == 0) {
            [self creactSeventhAEplayer:fx[2] WithofType:@"mp3"];
        }else{
            [self creacteightAEplayer:vocal[2] WithofType:@"mp3"];
        }
    }
    else if (sender.tag == 104){
        if (indexPath.row == 0) {
            [self creactSeventhAEplayer:fx[3] WithofType:@"mp3"];
        }else{
            [self creacteightAEplayer:vocal[3] WithofType:@"mp3"];
        }
    }
    else if (sender.tag == 105){
        if (indexPath.row == 0) {
            [self creactSeventhAEplayer:fx[4] WithofType:@"mp3"];
        }else{
            [self creacteightAEplayer:vocal[4] WithofType:@"mp3"];
        }
    }
    else if (sender.tag == 106){
        if (indexPath.row == 0) {
            [self creactSeventhAEplayer:fx[5] WithofType:@"mp3"];
        }else{
            [self creacteightAEplayer:vocal[5] WithofType:@"mp3"];
        }
    }
}

- (void)upOninse:(UIButton *)button{
    NSLog(@"松开");
    NSIndexPath *path = [self getindexPath:button];
    if (path.row == 0) {
//        [_seventhPlayer stop];
        if (_sevenAEplayer) {
            [appDelegate.audioController removeChannels:@[_sevenAEplayer]];
            _sevenAEplayer = nil;
        }
    }else{
        if (_engthAEplayer) {
            [appDelegate.audioController removeChannels:@[_engthAEplayer]];
            _engthAEplayer = nil;
        }
    }
}

//前六个cell的事件
- (void)firstClick:(UIButton *)sender{
    //获取view中点击到的某一个cell
    UIView *view = [sender superview];
    CollectionViewCell *cell = (CollectionViewCell *)[[view superview] superview];
    NSIndexPath *indexPath = [self.collectionView indexPathForCell:cell];
    NSLog(@"第%ld个cell",(long)indexPath.row + 1);
    [self togglePlayBtn:sender cell:cell];
    [self playMusic:sender indexPath:indexPath];
    if ([self hasMusicPlaying]) {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"notificationNames" object:nil userInfo:nil];
    }else {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"notificationN" object:nil userInfo:nil];
    }
}


- (BOOL)hasMusicPlaying {
    return [_AEplayer channelIsPlaying] || [_scondAEplayer channelIsPlaying] || [_thirdAEplayer channelIsPlaying] || [_fouthAEplayer channelIsPlaying] || [_fifthAEplayer channelIsPlaying] || [_sixthAEplayer channelIsPlaying];
}

- (void)togglePlayBtn:(UIButton *)sender cell:(CollectionViewCell *)cell {
    
    if (sender != cell.firstButton) {
        cell.firstButton.selected = NO;
    }
    if (sender != cell.second) {
        cell.second.selected = NO;
    }
    if (sender != cell.thirdButton) {
        cell.thirdButton.selected = NO;
    }
    if (sender != cell.fourthButton) {
        cell.fourthButton.selected = NO;
    }
    if (sender != cell.fifthButton) {
        cell.fifthButton.selected = NO;
    }
    if (sender != cell.sixthButton) {
        cell.sixthButton.selected = NO;
    }

    sender.selected =!sender.selected;
}



- (void)playMusic:(UIButton *)sender indexPath:(NSIndexPath *)indexPath {
    int adapter = 101;
    int realIndex = (int)sender.tag - adapter;
    
    NSMutableArray *drums = [[NSUserDefaults standardUserDefaults] objectForKey:@"Drum"];
    NSMutableArray *percussions = [[NSUserDefaults standardUserDefaults] objectForKey:@"Percussion"];
    NSMutableArray *synths = [[NSUserDefaults standardUserDefaults] objectForKey:@"Synth"];
    NSMutableArray *loops = [[NSUserDefaults standardUserDefaults] objectForKey:@"Loop"];
    NSMutableArray *melodics = [[NSUserDefaults standardUserDefaults] objectForKey:@"Melodic"];
    NSMutableArray *bass = [[NSUserDefaults standardUserDefaults] objectForKey:@"Bass"];

    NSString *fileExteration = @"mp3";
    
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            [self creactAEplayer:drums[realIndex] WithofType:fileExteration buttonStatus:sender];
        }else{
            [self creactSecondAEplayer:percussions[realIndex] WithofType:fileExteration buttonStatus:sender];
        }
    }else if (indexPath.section == 1){
        if (indexPath.row == 0) {
            [self creactThirdAEplayer:bass[realIndex] WithofType:fileExteration buttonStatus:sender];
        }else{
            [self creactFourthAEplayer:synths[realIndex] WithofType:fileExteration buttonStatus:sender];
        }
    }else if (indexPath.section == 2){
        if (indexPath.row == 0) {
            [self creactFifthAEplayer:melodics[realIndex] WithofType:fileExteration buttonStatus:sender];
        }else{
            [self creactSixAEplayer:loops[realIndex] WithofType:fileExteration buttonStatus:sender];
        }
    }
}

#pragma mark - 创建播放器
- (void)creactAEplayer:(NSString *)urlPath WithofType:(NSString *)TypeName buttonStatus:(UIButton *)sender{
    if (sender.selected == YES) {
        if (_AEplayer) {
            [appDelegate.audioController removeChannels:@[_AEplayer]];
            _AEplayer = nil;
        }
        NSString *urlString = [[NSBundle mainBundle] pathForResource:urlPath ofType:TypeName];
        NSURL *url = [NSURL fileURLWithPath:urlString];
        NSError *error = nil;
        _AEplayer = [[AEAudioFilePlayer alloc] initWithURL:url error:&error];
        _AEplayer.loop = YES;
        // 进行播放
        [appDelegate.audioController addChannels:@[_AEplayer]];
    }
    if (sender.selected == NO) {
        if (_AEplayer) {
            [appDelegate.audioController removeChannels:@[_AEplayer]];
            _AEplayer = nil;
        }
    }
}

- (void)creactSecondAEplayer:(NSString *)urlPath WithofType:(NSString *)TypeName buttonStatus:(UIButton *)sender{
    if (sender.selected == YES) {
        if (_scondAEplayer) {
            [appDelegate.audioController removeChannels:@[_scondAEplayer]];
            _scondAEplayer = nil;
        }
        NSString *urlString = [[NSBundle mainBundle] pathForResource:urlPath ofType:TypeName];
        NSURL *url = [NSURL fileURLWithPath:urlString];
        NSError *error = nil;
        _scondAEplayer = [[AEAudioFilePlayer alloc] initWithURL:url error:&error];
        _scondAEplayer.loop = YES;
        // 进行播放
        [appDelegate.audioController addChannels:@[_scondAEplayer]];
    }
    if (sender.selected == NO) {
        if (_scondAEplayer) {
            [appDelegate.audioController removeChannels:@[_scondAEplayer]];
            _scondAEplayer = nil;
        }
    }
}
- (void)creactThirdAEplayer:(NSString *)urlPath WithofType:(NSString *)TypeName buttonStatus:(UIButton *)sender{
    if (sender.selected == YES) {
        if (_thirdAEplayer) {
            [appDelegate.audioController removeChannels:@[_thirdAEplayer]];
            _thirdAEplayer = nil;
        }
        NSString *urlString = [[NSBundle mainBundle] pathForResource:urlPath ofType:TypeName];
        NSURL *url = [NSURL fileURLWithPath:urlString];
        NSError *error = nil;
        _thirdAEplayer = [[AEAudioFilePlayer alloc] initWithURL:url error:&error];
        _thirdAEplayer.loop = YES;
        // 进行播放
        [appDelegate.audioController addChannels:@[_thirdAEplayer]];
    }
    if (sender.selected == NO) {
        if (_thirdAEplayer) {
            [appDelegate.audioController removeChannels:@[_thirdAEplayer]];
            _thirdAEplayer = nil;
        }
    }
}
- (void)creactFourthAEplayer:(NSString *)urlPath WithofType:(NSString *)TypeName buttonStatus:(UIButton *)sender{
    if (sender.selected == YES) {
        if (_fouthAEplayer) {
            [appDelegate.audioController removeChannels:@[_fouthAEplayer]];
            _fouthAEplayer = nil;
        }
        NSString *urlString = [[NSBundle mainBundle] pathForResource:urlPath ofType:TypeName];
        NSURL *url = [NSURL fileURLWithPath:urlString];
        NSError *error = nil;
        _fouthAEplayer = [[AEAudioFilePlayer alloc] initWithURL:url error:&error];
        _fouthAEplayer.loop = YES;
        // 进行播放
        [appDelegate.audioController addChannels:@[_fouthAEplayer]];
    }
    if (sender.selected == NO) {
        if (_fouthAEplayer) {
            [appDelegate.audioController removeChannels:@[_fouthAEplayer]];
            _fouthAEplayer = nil;
        }
    }
}
- (void)creactFifthAEplayer:(NSString *)urlPath WithofType:(NSString *)TypeName buttonStatus:(UIButton *)sender{
    if (sender.selected == YES) {
        if (_fifthAEplayer) {
            [appDelegate.audioController removeChannels:@[_fifthAEplayer]];
            _fifthAEplayer = nil;
        }
        NSString *urlString = [[NSBundle mainBundle] pathForResource:urlPath ofType:TypeName];
        NSURL *url = [NSURL fileURLWithPath:urlString];
        NSError *error = nil;
        _fifthAEplayer = [[AEAudioFilePlayer alloc] initWithURL:url error:&error];
        _fifthAEplayer.loop = YES;
        // 进行播放
        [appDelegate.audioController addChannels:@[_fifthAEplayer]];
    }
    if (sender.selected == NO) {
        if (_fifthAEplayer) {
            [appDelegate.audioController removeChannels:@[_fifthAEplayer]];
            _fifthAEplayer = nil;
        }
    }
}
- (void)creactSixAEplayer:(NSString *)urlPath WithofType:(NSString *)TypeName buttonStatus:(UIButton *)sender{
    if (sender.selected == YES) {
        if (_sixthAEplayer) {
            [appDelegate.audioController removeChannels:@[_sixthAEplayer]];
            _sixthAEplayer = nil;
        }
        NSString *urlString = [[NSBundle mainBundle] pathForResource:urlPath ofType:TypeName];
        NSURL *url = [NSURL fileURLWithPath:urlString];
        NSError *error = nil;
        _sixthAEplayer = [[AEAudioFilePlayer alloc] initWithURL:url error:&error];
        _sixthAEplayer.loop = YES;
        // 进行播放
        [appDelegate.audioController addChannels:@[_sixthAEplayer]];
    }
    if (sender.selected == NO) {
        if (_sixthAEplayer) {
            [appDelegate.audioController removeChannels:@[_sixthAEplayer]];
            _sixthAEplayer = nil;
        }
    }
}
- (void)creactSeventhAEplayer:(NSString *)urlPath WithofType:(NSString *)TypeName{
    sleep(0.2);
        if (_sevenAEplayer) {
            [appDelegate.audioController removeChannels:@[_sevenAEplayer]];
            _sevenAEplayer = nil;
        }
        NSString *urlString = [[NSBundle mainBundle] pathForResource:urlPath ofType:TypeName];
        NSURL *url = [NSURL fileURLWithPath:urlString];
        NSError *error = nil;
        _sevenAEplayer = [[AEAudioFilePlayer alloc] initWithURL:url error:&error];
        // 进行播放
        [appDelegate.audioController addChannels:@[_sevenAEplayer]];
}
- (void)creacteightAEplayer:(NSString *)urlPath WithofType:(NSString *)TypeName{
    sleep(0.2);
        if (_engthAEplayer) {
            [appDelegate.audioController removeChannels:@[_engthAEplayer]];
            _engthAEplayer = nil;
        }
        NSString *urlString = [[NSBundle mainBundle] pathForResource:urlPath ofType:TypeName];
        NSURL *url = [NSURL fileURLWithPath:urlString];
        NSError *error = nil;
        _engthAEplayer = [[AEAudioFilePlayer alloc] initWithURL:url error:&error];
        // 进行播放
        [appDelegate.audioController addChannels:@[_engthAEplayer]];
}





@end
