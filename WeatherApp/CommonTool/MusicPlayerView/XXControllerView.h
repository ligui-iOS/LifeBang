//
//  XXControllerView.h
//  LZXMusicPlayer
//
//  Created by twzs on 16/6/28.
//  Copyright © 2016年 LZX. All rights reserved.
//

#import <UIKit/UIKit.h>


@class XXTableModel;
@interface XXControllerView : UIView

@property (nonatomic, strong) XXTableModel  *musicModel;

@property (nonatomic, weak) UIButton  *playOrPause;

@property (nonatomic, weak) UIButton  *next;

@property (nonatomic, weak) UIButton  *previous;

@property (nonatomic, weak) UISlider  *sliderBtn;

@property (nonatomic, weak) UILabel  *timeLabel;

@property (nonatomic, weak) UILabel  *titleLabel;

@property (nonatomic, weak) UILabel  *nameLabel;


@end
