//
//  XXMusicimgaeView.m
//  LZXMusicPlayer
//
//  Created by twzs on 16/6/28.
//  Copyright © 2016年 LZX. All rights reserved.
//

#import "XXMusicimgaeView.h"
#import "XXTableModel.h"
#import "UIImageView+WebCache.h"

@interface XXMusicimgaeView ()

@property (nonatomic, weak) UIImageView   *bgimageView;

@end


@implementation XXMusicimgaeView


- (instancetype)initWithFrame:(CGRect)frame;
{
    if (self = [super initWithFrame:frame]) {
        [self addImageView];
    }
    return self;
}
- (void)addImageView
{
    UIImageView *musicImage = [[UIImageView alloc]init];
    [self addSubview:musicImage];
    self.bgimageView = musicImage;
}
- (void)layoutSubviews
{
    self.bgimageView.frame = self.bounds;
}
- (void)setMusicModel:(XXTableModel *)MusicModel
{
    _MusicModel = MusicModel;
    [self.bgimageView sd_setImageWithURL:[NSURL URLWithString:MusicModel.icon] placeholderImage:[UIImage imageNamed:@"travel_placeholder"]];
}

@end
