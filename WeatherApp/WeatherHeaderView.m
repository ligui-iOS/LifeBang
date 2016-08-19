//
//  WeatherHeaderView.m
//  WeatherApp
//
//  Created by ZhenzhenXu on 4/30/13.
//  Copyright (c) 2013 ZhenzhenXu. All rights reserved.
//

#import "WeatherHeaderView.h"

@implementation WeatherHeaderView

@synthesize dateLabel=_dateLabel;
@synthesize refreshBtn=_refreshBtn;
@synthesize cityBtn=_cityBtn;
@synthesize leftBtn=_leftBtn;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        CGFloat btnWidth = [LBTool getWidthBoundingRectWithSize:@"今日健康菜品" height:24 fontSize:18];
        _refreshBtn=[[UIButton alloc] initWithFrame:CGRectMake(kScreenWidth-btnWidth-10, 0, btnWidth, 28)];
        _refreshBtn.titleLabel.font = CUSTOM_FONT(18);
//        [_refreshBtn setTitle:@"今日健康菜品" forState:UIControlStateNormal];
        [_refreshBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [self addSubview:_refreshBtn];
        
        CGFloat leftWidth = [LBTool getWidthBoundingRectWithSize:@"音乐" height:24 fontSize:18];
        _leftBtn = [[UIButton alloc] initWithFrame:CGRectMake(10, 0, leftWidth, 28)];
        _leftBtn.titleLabel.font = CUSTOM_FONT(18);
//        [_leftBtn setTitle:@"音乐" forState:UIControlStateNormal];
        [_leftBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [self addSubview:_leftBtn];
        
        _cityBtn=[[UIButton alloc] initWithFrame:CGRectMake((frame.size.width-200.0f)/2.0f, 4, 200, 20)];
        [_cityBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _cityBtn.titleLabel.font = CUSTOM_FONT(17);
        [_cityBtn setTitle:@"上海" forState:UIControlStateNormal];
        [self addSubview:_cityBtn];
        
        _dateLabel=[[UILabel alloc] initWithFrame:CGRectMake((frame.size.width-250.0f)/2.0f, 24, 250, 16)];
        _dateLabel.font=CUSTOM_FONT(14);
        _dateLabel.textColor=[UIColor whiteColor];
        _dateLabel.backgroundColor=[UIColor clearColor];
        _dateLabel.textAlignment=NSTextAlignmentCenter;
        //_dateLabel.text=@"2013年5月1日 星期日";
        [self addSubview:_dateLabel];
    }
    return self;
}

/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect
 {
 // Drawing code
 }
 */

@end