//
//  LBTravelNotesModel.h
//  WeatherApp
//
//  Created by ligui on 16/6/23.
//  Copyright © 2016年 ZhenzhenXu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LBTravelNotesModel : NSObject
@property (nonatomic, strong) NSString *bookUrl;
@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSString *headImage;
@property (nonatomic, strong) NSString *userName;
@property (nonatomic, strong) NSString *startTime;
@property (nonatomic, strong) NSString *routeDays;
@property (nonatomic, strong) NSString *text;
@end
