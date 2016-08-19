//
//  XXLyricLabel.m
//  LZXMusicPlayer
//
//  Created by twzs on 16/6/30.
//  Copyright © 2016年 LZX. All rights reserved.
//

#import "XXLyricLabel.h"
#import "XXLyricFind.h"

@interface XXLyricLabel ()


@end

@implementation XXLyricLabel

- (void)drawRect:(CGRect)rect
{
    [super drawRect:rect];
    
    // 重绘 的颜色
    [[UIColor greenColor] set];
    
    rect.size.width *= self.scale;
    
    UIRectFillUsingBlendMode(rect, kCGBlendModeSourceIn);

}

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        self.textColor = [UIColor whiteColor];
    }
    return self;
}

@end
