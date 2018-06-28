//
//  CollectionViewController.h
//  collectionView
//
//  Created by ios01 on 2017/7/10.
//  Copyright © 2017年 ios01. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
@interface CollectionViewController : UICollectionViewController

//六个播放器
@property (nonatomic, strong) AEAudioFilePlayer *AEplayer;
@property (nonatomic, strong) AEAudioFilePlayer *scondAEplayer;
@property (nonatomic, strong) AEAudioFilePlayer *thirdAEplayer;
@property (nonatomic, strong) AEAudioFilePlayer *fouthAEplayer;
@property (nonatomic, strong) AEAudioFilePlayer *fifthAEplayer;
@property (nonatomic, strong) AEAudioFilePlayer *sixthAEplayer;
@property (nonatomic, strong) AEAudioFilePlayer *sevenAEplayer;
@property (nonatomic, strong) AEAudioFilePlayer *engthAEplayer;
- (BOOL)hasMusicPlaying;

@end
