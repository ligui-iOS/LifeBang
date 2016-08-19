//
//  XXLyricFind.h
//  LZXMusicPlayer
//
//  Created by twzs on 16/6/30.
//  Copyright © 2016年 LZX. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface XXLyricFind : NSObject

+ (void)currentWithNextPLayLyircCurrentPlayTime:(NSTimeInterval)currentPlayTime lyricModel:(void (^)(NSString *currentLrc,NSString *nextLrc,float scale ,NSInteger index))lyricModel;

@end
