//
//  CurrentDayWeatherView.h
//  WeatherApp
//
//  Created by ZhenzhenXu on 4/30/13.
//  Copyright (c) 2013 ZhenzhenXu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CurrentDayWeatherView : UIView

@property (nonatomic, strong) UIImageView *weatherView;
@property (nonatomic, strong) UILabel *weatherLabel;
@property (nonatomic, strong) UILabel *upTempLabel;
@property (nonatomic, strong) UILabel *downTempLabel;
@property (nonatomic, strong) UILabel *curTempLabel;//实时温度
@property (nonatomic, strong) UILabel *windLabel;//风力
@property (nonatomic, strong) UILabel *windDescLabel;//风力强度

- (void)createViews;
- (void)fillCurrentTempWith:(NSDictionary*)dict;
-(void) fillViewWith:(NSDictionary *)weather;

- (NSArray*)parserTemp:(NSString*)temp;
@end