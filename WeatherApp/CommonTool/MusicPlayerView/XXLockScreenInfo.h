//
//  XXLockScreenInfo.h
//  LZXMusicPlayer
//
//  Created by twzs on 16/6/30.
//  Copyright © 2016年 LZX. All rights reserved.
//

#import <Foundation/Foundation.h>

@class UIViewController;
@class XXTableModel;
@class AVPlayer;
@interface XXLockScreenInfo : NSObject

+ (void)setUpLockScreenInfo:(UIViewController *)controller lrcModel:(XXTableModel *)lrcModel Player:(AVPlayer *)player;



@end
