//
//  LBMovieListModel.h
//  WeatherApp
//
//  Created by ligui on 16/7/8.
//  Copyright © 2016年 ZhenzhenXu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LBMovieListModel : NSObject
@property (nonatomic, strong) NSDictionary *rating;
@property (nonatomic, strong) NSArray *genres;
@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSArray *casts;
@property (nonatomic, strong) NSArray *directors;
@property (nonatomic, strong) NSDictionary *images;
@property (nonatomic, strong) NSString *year;
@end
