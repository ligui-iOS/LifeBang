//
//  XXPlayerMusicTool.m
//  LZXMusicPlayer
//
//  Created by twzs on 16/6/27.
//  Copyright © 2016年 LZX. All rights reserved.
//

#import "XXPlayerMusicTool.h"


@interface XXPlayerMusicTool ()

@end

static NSMutableDictionary *players;

@implementation XXPlayerMusicTool

+ (void)initialize
{
    players = [NSMutableDictionary dictionary];
}

+ (AVPlayer *)playerMusicWithName:(NSString *)name
{
    //  根据名字去字典中查找播放器
    AVPlayer *player = players[name];
    
    if (nil == player) {
        // 创建播放器并且存进字典中
//        NSString *path = [[NSBundle mainBundle]pathForResource:name ofType:nil];
//        NSArray *nameArr = [name componentsSeparatedByString:@"?"];
        NSError *error;
        AVAudioSession *session = [AVAudioSession sharedInstance];
        [session setCategory:AVAudioSessionCategoryPlayback error:nil];
        
        AVPlayerItem *item = [[AVPlayerItem alloc] initWithURL:[NSURL URLWithString:name]];
        
        player = [[AVPlayer alloc] initWithPlayerItem:item];
        if (error) {
            NSLog(@"playerError%@",error);
        }
        [players setObject:player forKey:name];
    }
    
    [player play];
    return player;
}

+(void)pauseMusicWithName:(NSString *)name
{
    // 根据名字去字典中查找播放器
    
    AVPlayer *player = players[name];
    
    // 找到后执行 暂停操作
    
    if (player) {
        
        [player pause];
    }
}

+ (void)stopMusicWithName:(NSString *)name
{
    // 根据名字去字典中查找播放器
    
    AVPlayer *player = players[name];
    
    // 找到后执行 停止操作
    
    if (player) {
        
        // 想要保存 上次播放记录的  这两句可以不写  直接写[player  stop]
        [player pause];
    }
}

@end
