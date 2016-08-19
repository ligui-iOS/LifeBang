//
//  CurrentDayWeatherView.m
//  WeatherApp
//
//  Created by ZhenzhenXu on 4/30/13.
//  Copyright (c) 2013 ZhenzhenXu. All rights reserved.
//

#import "CurrentDayWeatherView.h"
#import "SDWebImage/UIImageView+WebCache.h"
//#import "UIImageView+WebCache.h"
#import "MMProgressHUD/MMProgressHUD.h"

static NSString *bundleURL = @"http://files.heweather.com/cond_icon/";

@implementation CurrentDayWeatherView

@synthesize weatherLabel=_weatherLabel;
@synthesize weatherView=_weatherView;
@synthesize upTempLabel=_upTempLabel;
@synthesize downTempLabel=_downTempLabel;
@synthesize curTempLabel=_curTempLabel;
@synthesize windLabel=_windLabel;
@synthesize windDescLabel=_windDescLabel;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        [self createViews];
    }
    return self;
}

- (void)createViews{
    CGFloat offsetY=self.frame.size.height-164.0f;
    _weatherView=[[UIImageView alloc] initWithFrame:CGRectMake(10, 10+offsetY, 28.0f, 28.0f)];
    _weatherView.backgroundColor=[UIColor clearColor];
    [self addSubview:_weatherView];
    
    _weatherLabel=[[UILabel alloc] initWithFrame:CGRectMake(42, 13+offsetY, 268.0f, 21)];
    _weatherLabel.font=CUSTOM_FONT(17);
    _weatherLabel.textColor=[UIColor whiteColor];
    _weatherLabel.backgroundColor=[UIColor clearColor];
    [self addSubview:_weatherLabel];
    
    _windLabel=[[UILabel alloc] initWithFrame:CGRectMake(21, 49+offsetY, 60, 14)];
    _windLabel.font=CUSTOM_FONT(16);
    _windLabel.textColor=[UIColor whiteColor];
    _windLabel.backgroundColor=[UIColor clearColor];
    [self addSubview:_windLabel];
    
    _upTempLabel=[[UILabel alloc] initWithFrame:CGRectMake(36.0f, 45+offsetY, 40, 20)];
    _upTempLabel.font=CUSTOM_FONT(16);
    _upTempLabel.textColor=[UIColor whiteColor];
    _upTempLabel.backgroundColor=[UIColor clearColor];
    [self addSubview:_upTempLabel];
    
    _windDescLabel=[[UILabel alloc] initWithFrame:CGRectMake(91, 49+offsetY, 60, 14)];
    _windDescLabel.font=CUSTOM_FONT(16);
    _windDescLabel.textColor=[UIColor whiteColor];
    _windDescLabel.backgroundColor=[UIColor clearColor];
    [self addSubview:_windDescLabel];
    
    _downTempLabel=[[UILabel alloc] initWithFrame:CGRectMake(106.0f, 45+offsetY, 40, 20)];
    _downTempLabel.font=CUSTOM_FONT(16);
    _downTempLabel.textColor=[UIColor whiteColor];
    _downTempLabel.backgroundColor=[UIColor clearColor];
    [self addSubview:_downTempLabel];
    
    _curTempLabel=[[UILabel alloc] initWithFrame:CGRectMake(15, 70+offsetY, 300, 80)];
    _curTempLabel.font=CUSTOM_FONT(80);
    _curTempLabel.textColor=[UIColor whiteColor];
    _curTempLabel.backgroundColor=[UIColor clearColor];
    [self addSubview:_curTempLabel];
}

- (void)fillCurrentTempWith:(NSDictionary*)dict{
    _curTempLabel.text=[NSString stringWithFormat:@"%@°", [dict objectForKey:@"tmp"]];
}

-(void) fillViewWith:(NSDictionary *)weather{
    _weatherLabel.text=[[weather objectForKey:@"cond"] objectForKey:@"txt"];
    
    [_weatherView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@.png",bundleURL,[[weather objectForKey:@"cond"] objectForKey:@"code"]]]];
    _windLabel.text = [[weather objectForKey:@"wind"] objectForKey:@"dir"];
    _windDescLabel.text = [[weather objectForKey:@"wind"] objectForKey:@"sc"];;
    //Temp
    NSString *tempKey=[NSString stringWithFormat:@"temp%d", 1];
    NSString *temp=[weather objectForKey:tempKey];
    NSArray *temps=[self parserTemp:temp];
    if (temps&&temps.count>1) {
        _upTempLabel.text=[NSString stringWithFormat:@"%@°",[temps objectAtIndex:1]];
        _downTempLabel.text=[NSString stringWithFormat:@"%@°",[temps objectAtIndex:0]];
    }
}

- (NSArray*)parserTemp:(NSString*)temp{
    temp=[temp stringByReplacingOccurrencesOfString:@"℃" withString:@""];
    return [temp componentsSeparatedByString:@"~"];
}

@end