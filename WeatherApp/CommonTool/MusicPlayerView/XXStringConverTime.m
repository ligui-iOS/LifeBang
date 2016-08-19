//
//  XXStringConverTime.m
//  LZXMusicPlayer
//
//  Created by twzs on 16/6/30.
//  Copyright © 2016年 LZX. All rights reserved.
//

#import "XXStringConverTime.h"

@implementation XXStringConverTime


+ (NSString *)timeConverStringDuration:(NSTimeInterval)duration CurrentTime:(NSTimeInterval)currentTimer
{
    // 计算总时长
    // 分
    NSInteger totalMinute = duration / 60;
    // 秒
    NSInteger totalSecond = (int)duration % 60;
    // 计算当前播放时长
    // 分
    NSInteger currentMinute = currentTimer / 60;
    // 秒
    NSInteger currentSecond = (int)currentTimer % 60;
    
    return [NSString stringWithFormat:@"%02ld:%02ld / %02ld:%02ld",(long)currentMinute,(long)currentSecond,(long)totalMinute,(long)totalSecond];
}


+ (NSTimeInterval)setUpTimeWithLrcTime:(NSString *)lrcTime
{
    // 01:05.12
    
    NSString *minute = [lrcTime substringWithRange:NSMakeRange(0, 2)];
    
    if ([minute hasPrefix:@"0"]) {
        
        minute = [minute substringFromIndex:1];
        
    }
    
    NSString *second = [lrcTime substringWithRange:NSMakeRange(3, 2)];
    
    if ([second hasPrefix:@"0"]) {
        
        second = [second substringFromIndex:1];
    }
    
    NSString *mSecond = [lrcTime substringWithRange:NSMakeRange(6, 2)];
    
    
    return minute.intValue * 60 + second.intValue  + mSecond.intValue / 100;
    
}

@end
