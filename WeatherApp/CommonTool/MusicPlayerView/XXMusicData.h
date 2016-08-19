//
//  XXMusicData.h
//  LZXMusicPlayer
//
//  Created by twzs on 16/6/27.
//  Copyright © 2016年 LZX. All rights reserved.
//

#import <Foundation/Foundation.h>

@class XXTableModel;
@interface XXMusicData : NSObject

+ (NSArray *)dataArray;
//下一首歌曲
+ (void)nextMusic;
// 上一首歌曲
+ (void)previousMusic;
// 设置当前歌曲
+ (void)setMusic:(XXTableModel *)music;
// 获取当前歌曲
+ (XXTableModel *)playingMusic;

@end
