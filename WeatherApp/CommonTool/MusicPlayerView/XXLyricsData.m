//
//  XXLyricsData.m
//  LZXMusicPlayer
//
//  Created by twzs on 16/6/29.
//  Copyright © 2016年 LZX. All rights reserved.
//

#import "XXLyricsData.h"
#import "XXTableModel.h"
#import "XXLyricsModel.h"

@interface XXLyricsData ()

@end

static NSArray *lrcDataArray;
static XXLyricsData *LYRICSDATA;

@implementation XXLyricsData

+ (void)initialize
{
    lrcDataArray = [NSArray array];
}

+ (NSArray *)lrcs
{
    return lrcDataArray;
}

+ (instancetype)shareLyrics
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        LYRICSDATA = [[XXLyricsData alloc]init];
    });
    return LYRICSDATA;
}

- (void)setLrcModel:(XXTableModel *)lrcModel
{
    _lrcModel = lrcModel;
    
    NSMutableArray *array = [NSMutableArray array];
    
    // 歌词文件路劲
//    NSString *path         = [[NSBundle mainBundle]pathForResource:lrcModel.lrcname ofType:nil];
    // 用字符串接受
    NSString *lrcsString   = [NSString stringWithContentsOfURL:[NSURL URLWithString:lrcModel.lrcname] encoding:NSUTF8StringEncoding error:nil];
    //  用换行符 分割成 数组
    NSArray *lrcArray = [lrcsString componentsSeparatedByString:@"\n"];
    //遍历数组
    for (int i = 0; i < lrcArray.count; i ++) {
        
        NSString *lrcStr = lrcArray[i];
        
        if ([lrcStr hasPrefix:@"[0"]) {
            
            // 截取时间
            NSString *time          = [lrcStr substringWithRange:NSMakeRange(1, 8)];
            
            // 截取歌词
            NSString *lrcLine       = [lrcStr substringFromIndex:10];
            
            // 创建歌词模型
            XXLyricsModel *lrcModel = [[XXLyricsModel alloc]init];
            
            lrcModel.time           = time;
            
            lrcModel.lrc            = lrcLine;
            
            [array addObject:lrcModel];
        }
    }
    lrcDataArray = array;
    
}

@end
