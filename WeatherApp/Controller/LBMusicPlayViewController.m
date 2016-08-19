//
//  LBMusicPlayViewController.m
//  WeatherApp
//
//  Created by ligui on 16/6/21.
//  Copyright © 2016年 ZhenzhenXu. All rights reserved.
//

#import "LBMusicPlayViewController.h"
#import "AFNetWorkingGetPostRequest.h"
#import <AVFoundation/AVFoundation.h>
#import "XXMusicimgaeView.h"
#import "XXControllerView.h"
#import "XXPlayerMusicTool.h"
#import "XXMusicData.h"
#import "XXTableModel.h"
#import "XXLyricsView.h"
#import "XXCurrentPlayLyricView.h"
#import "XXStringConverTime.h"
#import "XXLockScreenInfo.h"
#import <MediaPlayer/MediaPlayer.h>
#define BAIDUMUSICURL @"http://tingapi.ting.baidu.com/v1/restserver/ting"
//?_=1413017198449&callback=&format=json&from=webapp_music&method=baidu.ting.search.catalogSug&songid="
@interface LBMusicPlayViewController ()<AFNetWorkingGetPostRequestDelegage>
@property (nonatomic, weak) XXMusicimgaeView       *musicImageView;

@property (nonatomic, weak) XXControllerView       *musicController;

@property (nonatomic, weak) XXLyricsView           *lrcView;

@property (nonatomic, weak) XXCurrentPlayLyricView *CurrentPlayLyricView;

@property (nonatomic, strong) AVPlayer        *player;

@property (nonatomic, weak) UILabel                *timeLabel;

@property (nonatomic, weak) UILabel                *titleLabel;

@property (nonatomic, weak) UILabel                *nameLabel;

@property (nonatomic, strong) NSTimer              *timer;

@property (nonatomic, assign) BOOL                 playWithPause;

@property (nonatomic, strong) CADisplayLink        *link;
@end

static XXTableModel  *tableMusicModel;

@implementation LBMusicPlayViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    AFNetWorkingGetPostRequest *request = [[AFNetWorkingGetPostRequest alloc] init];
    request.delegate = self;
    NSString *urlStr = [BAIDUMUSICURL stringByAppendingString:@"?e=JoN56kTXnnbEpd9MVczkYJCSx%2FE1mkLx%2BPMIkTcOEu4%3D"];
    [request getRequestByUrl:urlStr parameters:[NSMutableDictionary dictionaryWithObjectsAndKeys: @"qianqian",@"from",
                                                       @"2.1.0",@"version",
                                                       @"baidu.ting.song.getInfos",@"method",
                                                       @"json",@"format",
                                                       self.songIdStr,@"songid",
                                                       @"1408284347323",@"ts",                                                       @"2",@"nw",
                                                       @"1",@"ucf",
                                                       @"1",@"res",
                                                       nil]];
    // Do any additional setup after loading the view.
}
#pragma mark------------------AFNetWorkingGetPostRequestDelegage---------
- (void)requestFinished:(id)responseData withError:(NSError *)error
{
    NSLog(@"responseData=======%@,%@",responseData,[responseData class]);
    //    NSData *data = [responseData dataUsingEncoding:NSUTF8StringEncoding];
    //    NSError *reperror;
    //    NSArray *arr = (NSArray *)[NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&reperror];;
    //    NSLog(@"arr=======%@,data=======%@",arr,data);
    //    if (reperror) {
    //        NSLog(@"reperror======%@",reperror);
    //    }
    NSError *respError;
    NSMutableString *mRepStr = [[NSMutableString alloc] initWithString:(NSString *)responseData];
    NSLog(@"mRepStr=====%@",mRepStr);
    NSData *data = [mRepStr dataUsingEncoding:NSUTF8StringEncoding];
    NSDictionary  *responseDict = (NSDictionary *)[NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&respError];
    NSLog(@"responseDict=========%@",responseDict);
    if (respError||!responseDict) {
        NSLog(@"respError======%@",respError);
        return;
    }
    tableMusicModel = [[XXTableModel alloc] init];
    tableMusicModel.name = [responseDict[@"songinfo"] objectForKey:@"title"];
    tableMusicModel.icon = [responseDict[@"songinfo"] objectForKey:@"pic_huge"];
    tableMusicModel.filename = [[[responseDict[@"songurl"] objectForKey:@"url"] firstObject] objectForKey:@"file_link"];
    tableMusicModel.lrcname = [responseDict[@"songinfo"] objectForKey:@"lrclink"];
    tableMusicModel.singer = [responseDict[@"songinfo"] objectForKey:@"author"];
    tableMusicModel.singerIcon = [responseDict[@"songinfo"] objectForKey:@"pic_singer"];
    
    [self currentPlayMusic];
}
#pragma mark ------------------------musicPlayer
- (void)currentPlayMusic
{
    // 判断 当前播放的歌曲  和 选中的歌曲是不是同一个
    if (tableMusicModel != [XXMusicData playingMusic]) {
        
        // 停止当前播放的歌曲
        [self stop];
    }
    // 构建界面
    [self addUI];
}
- (void)addUI
{
    [self addMusicImageView];
    [self addMusicControllerView];
    [self addlrcLabel];
    [self addLrcView];
    [self play];
    
}
#pragma mark - AddView
- (void)addMusicImageView
{
    XXMusicimgaeView *musicImage = [[XXMusicimgaeView alloc]initWithFrame:CGRectMake(0, kNavigationBarAndStatusHeight, self.view.bounds.size.width, self.view.bounds.size.height/3 *2)];
    [self.view addSubview:musicImage];
    UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(pan:)];
    [musicImage addGestureRecognizer:pan];
    
    self.musicImageView = musicImage;
}

- (void)addMusicControllerView
{
    XXControllerView *musicController = [[XXControllerView alloc]initWithFrame:CGRectMake(0, self.view.bounds.size.height/3 * 2, self.view.bounds.size.width, self.view.bounds.size.height/3)];
    [musicController.playOrPause addTarget:self action:@selector(playeOrPauseEvent) forControlEvents:UIControlEventTouchUpInside];
    [musicController.next addTarget:self action:@selector(nextEvent) forControlEvents:UIControlEventTouchUpInside];
    [musicController.previous addTarget:self action:@selector(previousEvent) forControlEvents:UIControlEventTouchUpInside];
    [musicController.sliderBtn addTarget:self action:@selector(sliderBtnStartEvent:) forControlEvents:UIControlEventTouchDown];
    [musicController.sliderBtn addTarget:self action:@selector(sliderBtnChangeEvent:) forControlEvents:UIControlEventValueChanged];
    [musicController.sliderBtn addTarget:self action:@selector(sliderBtnEndEvent:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:musicController];
    self.musicController = musicController;
}

- (void)addLrcView
{
    XXLyricsView *lrcView = [[XXLyricsView alloc]initWithFrame:CGRectMake(self.view.bounds.size.width, 0, self.musicImageView.bounds.size.width,self.musicImageView.bounds.size.height)];
    [self.view addSubview:lrcView];
    UIPanGestureRecognizer *lrcViewPan = [[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(lrcViewPanEvent:)];
    [lrcView addGestureRecognizer:lrcViewPan];
    self.lrcView = lrcView;
}

- (void)addlrcLabel
{
    XXCurrentPlayLyricView *currentPlayLyricView = [[XXCurrentPlayLyricView alloc]initWithFrame:CGRectMake(0, self.musicImageView.bounds.size.height - 70, self.musicImageView.bounds.size.width, 70)];
    [self.view addSubview:currentPlayLyricView];
    self.CurrentPlayLyricView = currentPlayLyricView;
}
#pragma mark - Updata
- (void)setUIAssignment
{
    self.musicImageView.MusicModel = tableMusicModel;
    self.musicController.musicModel = tableMusicModel;
    
}
#pragma mark - Player
// 播放选中的歌曲
- (void)play
{
//    XXTableModel *tableModel = [XXMusicData playingMusic];
//    tableMusicModel = tableModel;
    
    self.player = [XXPlayerMusicTool playerMusicWithName:tableMusicModel.filename];
    
    //  传递歌词数据
    self.lrcView.playerModel = tableMusicModel;
    
    
    [self setUIAssignment];
    
    [self addTimer];
    [self addLink];
    
    [self setUpLockScreenInfo];
        
}
// 停止当前播放的歌曲
- (void)stop
{
    [self removeTimer];
    [self removeLink];
    
    [XXPlayerMusicTool stopMusicWithName:tableMusicModel.filename];
}

#pragma mark - PlayerController
// 开始或暂停
- (void)playeOrPauseEvent
{
    self.playWithPause = !self.playWithPause;
    self.musicController.playOrPause.selected = self.playWithPause;
    if (!self.playWithPause) {
        
        [XXPlayerMusicTool playerMusicWithName:tableMusicModel.filename];
        
        [self addTimer];
        [self addLink];
        
    }else {
        
        [XXPlayerMusicTool pauseMusicWithName:tableMusicModel.filename];
        
        [self removeTimer];
        [self removeLink];
    }
}
// 下一首
- (void)nextEvent
{
    [XXPlayerMusicTool stopMusicWithName:tableMusicModel.filename];
    
    [XXMusicData nextMusic];
    
    [self play];
}
// 上一首
- (void)previousEvent
{
    [XXPlayerMusicTool stopMusicWithName:tableMusicModel.filename];
    
    [XXMusicData previousMusic];
    
    [self play];
    
}

#pragma mark - Timer

- (void)addTimer
{
    self.timer = [NSTimer scheduledTimerWithTimeInterval:1.f target:self selector:@selector(updataEvent:) userInfo:nil repeats:YES];
    [[NSRunLoop mainRunLoop]addTimer:self.timer forMode:NSRunLoopCommonModes];
}

- (void)removeTimer
{
    [self.timer invalidate];
    
    self.timer = nil;
}

- (void)updataEvent:(NSTimer *)sender
{
    self.musicController.sliderBtn.value  = CMTimeGetSeconds(self.player.currentItem.currentTime) / CMTimeGetSeconds(self.player.currentItem.duration);
    self.musicController.timeLabel.text = [XXStringConverTime timeConverStringDuration:(int)CMTimeGetSeconds(self.player.currentItem.duration) CurrentTime:(int)CMTimeGetSeconds(self.player.currentItem.currentTime)];
}

- (void)addLink
{
    self.link = [CADisplayLink displayLinkWithTarget:self selector:@selector(updateCurrentTime)];
    [self.link addToRunLoop:[NSRunLoop mainRunLoop] forMode:NSRunLoopCommonModes];
}

- (void)removeLink
{
    [self.link invalidate];
    self.link = nil;
}

- (void)updateCurrentTime
{
    self.lrcView.currenTime = CMTimeGetSeconds(self.player.currentItem.duration);
    self.CurrentPlayLyricView.currentTime = CMTimeGetSeconds(self.player.currentItem.duration);
}

#pragma mark - SliderEvent

- (void)sliderBtnStartEvent:(UISlider *)sender
{
    [self removeTimer];
}

- (void)sliderBtnChangeEvent:(UISlider *)sender
{
    // 边界处理, 可以不写这个判断
    if (sender.value >= sender.value - 0.01) {
        sender.value = sender.value - 0.01;
    }
    int32_t timer = self.player.currentItem.asset.duration.timescale;
//    NSTimeInterval currentTime = sender.value *CMTimeGetSeconds(self.player.currentItem.duration);
    [self.player seekToTime:CMTimeMakeWithSeconds(sender.value , timer) toleranceBefore:kCMTimeZero toleranceAfter:kCMTimeZero];
    self.musicController.timeLabel.text = [XXStringConverTime timeConverStringDuration:(int)CMTimeGetSeconds(self.player.currentItem.duration) CurrentTime:CMTimeGetSeconds(self.player.currentItem.currentTime)];
}

- (void)sliderBtnEndEvent:(UISlider *)sender
{
    [self addTimer];
}
#pragma mark - pan
- (void)pan:(UIPanGestureRecognizer *)sender
{
    [UIView animateWithDuration:2 animations:^{
        self.lrcView.frame = CGRectMake(0, 0, self.musicImageView.bounds.size.width,self.musicImageView.bounds.size.height);
        self.CurrentPlayLyricView.alpha = 0;
    }];
}

- (void)lrcViewPanEvent:(UIPanGestureRecognizer *)sender
{
    [UIView animateWithDuration:2 animations:^{
        self.lrcView.frame = CGRectMake(self.view.bounds.size.width, 0, self.musicImageView.bounds.size.width,self.musicImageView.bounds.size.height);
        self.CurrentPlayLyricView.alpha = 1;
    }];
}

#pragma mark - 设置锁屏信息
- (void)setUpLockScreenInfo
{
    [XXLockScreenInfo setUpLockScreenInfo:self lrcModel:tableMusicModel Player:self.player];
}
#pragma mark  - 设置当前界面为第一响应者
- (BOOL)canBecomeFirstResponder
{
    return YES;
}

- (void)remoteControlReceivedWithEvent:(UIEvent *)event
{
    
    if (event.subtype == UIEventSubtypeRemoteControlPlay) {
        
        [self playeOrPauseEvent];
    }
    if (event.subtype == UIEventSubtypeRemoteControlPause) {
        
        [self playeOrPauseEvent];
    }
    if (event.subtype == UIEventSubtypeRemoteControlStop) {
        
        [self playeOrPauseEvent];
    }
    if (event.subtype == UIEventSubtypeRemoteControlNextTrack) {
        
        [self nextEvent];
    }
    if (event.subtype == UIEventSubtypeRemoteControlPreviousTrack) {
        
        [self previousEvent];
    }
    
}
- (void)back
{
    // 移除定时器
    [self removeTimer];
    [self removeLink];
    
    [self dismissViewControllerAnimated:YES completion:nil];
}
- (void)viewDidDisappear:(BOOL)animated
{
    [XXPlayerMusicTool pauseMusicWithName:tableMusicModel.filename];
    
    [self removeTimer];
    [self removeLink];
    
    self.player = nil;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
