//
//  XXCurrentPlayLyricView.m
//  LZXMusicPlayer
//
//  Created by twzs on 16/6/30.
//  Copyright © 2016年 LZX. All rights reserved.
//

#import "XXCurrentPlayLyricView.h"
#import "XXLyricLabel.h"
#import "XXLyricFind.h"

@interface XXCurrentPlayLyricView ()

@property (nonatomic, weak) XXLyricLabel  *topLabel;

@property (nonatomic, weak) XXLyricLabel  *bottomLabel;

@end

@implementation XXCurrentPlayLyricView

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor clearColor];
        [self lrcLabel];
    }
    return self;
}

- (void)lrcLabel
{
    XXLyricLabel *topLabel = [[XXLyricLabel alloc]init];
    topLabel.textAlignment = NSTextAlignmentLeft;
    [self addSubview:topLabel];
    
    XXLyricLabel *bottomLabel = [[XXLyricLabel alloc]init];
    bottomLabel.textAlignment = NSTextAlignmentRight;
    [self addSubview:bottomLabel];
    
    self.topLabel = topLabel;
    self.bottomLabel = bottomLabel;
}

- (void)layoutSubviews
{
    NSInteger  width = self.bounds.size.width;
    NSInteger  height = self.bounds.size.height;
    
    self.topLabel.frame = CGRectMake(5, 5, width - 10, height / 3);
    self.bottomLabel.frame = CGRectMake(5, height - height / 3 - 5, width - 10, height / 3);
}

- (void)setCurrentTime:(NSTimeInterval)currentTime
{
    _currentTime = currentTime;
    
    [XXLyricFind currentWithNextPLayLyircCurrentPlayTime:currentTime lyricModel:^(NSString *currentLrc, NSString *nextLrc, float scale, NSInteger index) {
        
        if (index % 2 == 0) {
            
            self.topLabel.text = currentLrc;
            self.bottomLabel.text = nextLrc;
            
            self.topLabel.scale = scale;
            [self.topLabel setNeedsDisplay];
            self.bottomLabel.scale = 0;
            [self.bottomLabel setNeedsDisplay];
        } else {
            
            self.bottomLabel.text = currentLrc;
            self.topLabel.text = nextLrc;
            
            self.bottomLabel.scale = scale;
            [self.bottomLabel setNeedsDisplay];
            self.topLabel.scale = 0;
            [self.topLabel setNeedsDisplay];
        }
        
    }];
    
}

@end
