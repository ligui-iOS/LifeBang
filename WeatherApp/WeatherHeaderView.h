//
//  WeatherHeaderView.h
//  WeatherApp
//
//  Created by ZhenzhenXu on 4/30/13.
//  Copyright (c) 2013 ZhenzhenXu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>

@interface WeatherHeaderView : UIView

@property (nonatomic, strong) UILabel *dateLabel;
@property (nonatomic, strong) UIButton *refreshBtn;
@property (nonatomic, strong) UIButton *cityBtn;
@property (nonatomic, strong) UIButton *leftBtn;

@end