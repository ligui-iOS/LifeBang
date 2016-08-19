//
//  ForecastWeatherView.m
//  WeatherApp
//
//  Created by ZhenzhenXu on 4/30/13.
//  Copyright (c) 2013 ZhenzhenXu. All rights reserved.
//

#import "ForecastWeatherView.h"
#import "UIImageView+WebCache.h"
static NSString *bundleURL = @"http://files.heweather.com/cond_icon/";

@implementation ForecastWeatherView

@synthesize dayLabels=_dayLabels;
@synthesize imageViews=_imageViews;
@synthesize upTempLabels=_upTempLabels;
@synthesize downTempLabels=_downTempLabels;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        UILabel *titleLabel=[[UILabel alloc] initWithFrame:CGRectMake(8, 5, 288, 20)];
        titleLabel.font=CUSTOM_FONT(17);
        titleLabel.textColor=[UIColor whiteColor];
        titleLabel.backgroundColor=[UIColor clearColor];
        titleLabel.text=@"预报";
        [self addSubview:titleLabel];
        //Line
        UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(8, 29, frame.size.width-16, 1)];
        lineView.backgroundColor = [UIColor whiteColor];
        [self addSubview:lineView];
        //Row Height:67
//        UIImageView *imageView=[[UIImageView alloc] initWithFrame:CGRectMake(8, 30, 288, 178)];
//        imageView.image=[UIImage imageNamed:@"Forecast"];
//        imageView.backgroundColor=[UIColor clearColor];
//        [self addSubview:imageView];
        self.backgroundColor=[UIColor colorWithWhite:0.0f alpha:0.5f];
        
        [self createDetailViews];
    }
    return self;
}

- (void)createDetailViews{
    _dayLabels=[[NSMutableArray alloc] init];
    _imageViews=[[NSMutableArray alloc] init];
    _upTempLabels=[[NSMutableArray alloc] init];
    _downTempLabels=[[NSMutableArray alloc] init];
}

-(void) fillViewWith:(NSArray *)weather
{
//    NSString *plistPath=[[NSBundle mainBundle] pathForResource:@"Weather" ofType:@"plist"];
//    NSDictionary *image_dict=[[NSDictionary alloc] initWithContentsOfFile:plistPath];
    
    for (int i=0; i<weather.count; i++) {
        CGFloat curHeight=i*30.0f+30.0f;
        
        UILabel *dayLabel=[[UILabel alloc] initWithFrame:CGRectMake(8, curHeight+7, 120, 20)];
        dayLabel.font=CUSTOM_FONT(17);
        dayLabel.textColor=[UIColor whiteColor];
        dayLabel.backgroundColor=[UIColor clearColor];
        [_dayLabels addObject:dayLabel];
        [self addSubview:dayLabel];
        
        UIImageView *imageView=[[UIImageView alloc] initWithFrame:CGRectMake(8+128, curHeight+2, 30, 30)];
        imageView.backgroundColor=[UIColor clearColor];
        [_imageViews addObject:imageView];
        [self addSubview:imageView];
        
        UILabel *upTempLabel=[[UILabel alloc] initWithFrame:CGRectMake(kScreenWidth-130, curHeight+7, 55, 20)];
        upTempLabel.font=CUSTOM_FONT(17);
        upTempLabel.textColor=[UIColor whiteColor];
        upTempLabel.backgroundColor=[UIColor clearColor];
        upTempLabel.textAlignment=NSTextAlignmentRight;
        [_upTempLabels addObject:upTempLabel];
        [self addSubview:upTempLabel];
        
        UILabel *lowTempLabel=[[UILabel alloc] initWithFrame:CGRectMake(kScreenWidth-75, curHeight+7, 55, 20)];
        lowTempLabel.font=CUSTOM_FONT(17);
        lowTempLabel.textColor=[UIColor whiteColor];
        lowTempLabel.backgroundColor=[UIColor clearColor];
        lowTempLabel.textAlignment=NSTextAlignmentRight;
        [_downTempLabels addObject:lowTempLabel];
        [self addSubview:lowTempLabel];
    }
    
    for (NSInteger i=0; i<weather.count; i++) {
        //Week
        NSDictionary *dict = weather[i];
        UILabel *dayLabel=[_dayLabels objectAtIndex:i];
        dayLabel.text = dict[@"date"];
        //Image
//        NSString *imageKey=[NSString stringWithFormat:@"img%d",2*i+3];
//        NSString *image=[dict objectForKey:imageKey];
        UIImageView *imageView=[_imageViews objectAtIndex:i];
        [imageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@.png",bundleURL,[dict[@"cond"] objectForKey:@"code_d"]]]];
//        imageView.image=[UIImage imageNamed:[NSString stringWithFormat:@"%@%@",bundleURL,[image_dict objectForKey:image]]];
        //Temp
        NSDictionary *tempDict=[dict objectForKey:@"tmp"];
        UILabel *upLabel=[_upTempLabels objectAtIndex:i];
        upLabel.text=[NSString stringWithFormat:@"%@°",[tempDict objectForKey:@"max"]];
        UILabel *downLabel=[_downTempLabels objectAtIndex:i];
        downLabel.text=[NSString stringWithFormat:@"%@°",[tempDict objectForKey:@"min"]];
    }
}

- (NSArray*)parserTemp:(NSString*)temp{
    temp=[temp stringByReplacingOccurrencesOfString:@"℃" withString:@""];
    return [temp componentsSeparatedByString:@"~"];
}

- (NSString*)getWeekOffset:(NSInteger)offset from:(NSDate*)date{
    NSArray *daySymbols = [[NSArray alloc] initWithObjects:@"星期日",@"星期一",@"星期二",@"星期三",@"星期四",@"星期五",@"星期六", nil];
    NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    NSDateComponents *comps = [gregorian components:NSWeekdayCalendarUnit fromDate:date];
    int weekday = [comps weekday];
    NSInteger cur=(offset+weekday)%7;
    return [daySymbols objectAtIndex:cur];
}

@end