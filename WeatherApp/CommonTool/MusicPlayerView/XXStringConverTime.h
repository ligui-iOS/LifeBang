//
//  XXStringConverTime.h
//  LZXMusicPlayer
//
//  Created by twzs on 16/6/30.
//  Copyright © 2016年 LZX. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface XXStringConverTime : NSObject


+ (NSString *)timeConverStringDuration:(NSTimeInterval)duration CurrentTime:(NSTimeInterval)currentTimer;


+ (NSTimeInterval)setUpTimeWithLrcTime:(NSString *)lrcTime;

@end
