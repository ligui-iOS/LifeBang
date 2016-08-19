//
//  XXLyricFind.m
//  LZXMusicPlayer
//
//  Created by twzs on 16/6/30.
//  Copyright © 2016年 LZX. All rights reserved.
//

#import "XXLyricFind.h"
#import "XXLyricsData.h"
#import "XXStringConverTime.h"
#import "XXLyricsModel.h"

@interface XXLyricFind ()

@end

@implementation XXLyricFind


+ (void)currentWithNextPLayLyircCurrentPlayTime:(NSTimeInterval)currentPlayTime lyricModel:(void (^)(NSString *currentLrc,NSString *nextLrc,float scale ,NSInteger index))lyricModel;
{
    int  index = 0;
    
    NSArray *array = [XXLyricsData lrcs];
    
    for (int i = index; i < array.count; i ++) {
        
        XXLyricsModel *lrcModel = array[i];
        
        NSTimeInterval time = [XXStringConverTime setUpTimeWithLrcTime:lrcModel.time];
        
        if (i < array.count - 1) {
            
            XXLyricsModel *nextModel = array[i + 1];
            
            NSTimeInterval nextTime = [XXStringConverTime setUpTimeWithLrcTime:nextModel.time];
            
            if (currentPlayTime > time && currentPlayTime < nextTime && i != index) {
                
                index = i;
                
                float  scale = (currentPlayTime - time)/(nextTime - time);

                lyricModel(lrcModel.lrc,nextModel.lrc,scale,index);
            }
            
        }
    }
    
}

@end
