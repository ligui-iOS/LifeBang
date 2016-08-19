//
//  XXControllerView.m
//  LZXMusicPlayer
//
//  Created by twzs on 16/6/28.
//  Copyright © 2016年 LZX. All rights reserved.
//

#import "XXControllerView.h"
#import "XXTableModel.h"

@interface XXControllerView ()

@end

@implementation XXControllerView

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor blackColor];
        [self addUI];
    }
    return self;
}

- (void)addUI
{
    [self addLabel];
    [self addBtn];
}

- (void)addLabel
{
    
    UILabel *titleLabel  = [[UILabel alloc]init];
    titleLabel.textColor = [UIColor whiteColor];
    titleLabel.font = CUSTOM_FONT(17);
    [self addSubview:titleLabel];
    
    UILabel *nameLabel   = [[UILabel alloc]init];
    nameLabel.textColor  = [UIColor whiteColor];
    nameLabel.font = CUSTOM_FONT(17);
    [self addSubview:nameLabel];
    
    UILabel *timeLabel   = [[UILabel alloc]init];
    timeLabel.font = [UIFont systemFontOfSize:14];
    timeLabel.textColor  = [UIColor whiteColor];
    [self addSubview:timeLabel];
    
    self.titleLabel      = titleLabel;
    self.nameLabel       = nameLabel;
    self.timeLabel       = timeLabel;
    
}
- (void)addBtn
{
    UIButton *playOrPauseBtn  = [UIButton buttonWithType:UIButtonTypeCustom];
    [playOrPauseBtn setImage:[UIImage imageNamed:@"pause"] forState:UIControlStateNormal];
    [playOrPauseBtn setImage:[UIImage imageNamed:@"play"] forState:UIControlStateSelected];
    [self addSubview:playOrPauseBtn];
    
    UIButton *nextBtn         = [UIButton buttonWithType:UIButtonTypeCustom];
    [nextBtn setImage:[UIImage imageNamed:@"previous"] forState:UIControlStateNormal];
    [self addSubview:nextBtn];
    
    UIButton *previousBtn     = [UIButton buttonWithType:UIButtonTypeCustom];
    [previousBtn setImage:[UIImage imageNamed:@"next"] forState:UIControlStateNormal];
    [self addSubview:previousBtn];
    
    UISlider *slider             = [[UISlider alloc]init];
    slider.minimumTrackTintColor = [UIColor whiteColor];
    [slider setThumbImage:[UIImage imageNamed:@"slider"] forState:UIControlStateNormal];
    slider.maximumTrackTintColor = [UIColor whiteColor];
    slider.minimumTrackTintColor = [UIColor greenColor];
    [self addSubview:slider];
    
    self.playOrPause          = playOrPauseBtn;
    self.next                 = nextBtn;
    self.previous             = previousBtn;
    self.sliderBtn            = slider;
    
}
- (void)layoutSubviews
{
    float width            = self.bounds.size.width;
    float height           = self.bounds.size.height;
 
    self.titleLabel.frame  = CGRectMake(5, 5, width - 10, 30);
    self.nameLabel.frame   = CGRectMake(5, CGRectGetMaxY(self.titleLabel.frame) + 5, width - 10, 30);
    self.sliderBtn.frame   = CGRectMake(5, CGRectGetMaxY(self.nameLabel.frame) + 5 , width - 10, 10);
    self.timeLabel.frame   = CGRectMake(width - 100, CGRectGetMaxY(self.sliderBtn.frame) + 2, 90, 30);
    self.playOrPause.frame = CGRectMake((width - width/4)/2, height - width/4 - 10, width/4, width/4);
    
    self.next.frame        = CGRectMake(self.playOrPause.frame.origin.x - self.playOrPause.frame.size.width, self.playOrPause.frame.origin.y + self.playOrPause.frame.size.width/4, self.playOrPause.frame.size.width/2,self.playOrPause.frame.size.width/2);
    
    self.previous.frame    = CGRectMake(CGRectGetMaxX(self.playOrPause.frame) + self.playOrPause.frame.size.width/2, self.playOrPause.frame.origin.y + self.playOrPause.frame.size.width/4, self.playOrPause.frame.size.width/2,self.playOrPause.frame.size.width/2);

}
- (void)setMusicModel:(XXTableModel *)musicModel
{
    _musicModel = musicModel;
    
    self.titleLabel.text = musicModel.singer;
    self.nameLabel.text  = musicModel.name;
}


@end
