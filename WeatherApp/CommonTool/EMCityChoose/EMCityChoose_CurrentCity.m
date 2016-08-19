//
//  EMCityChoose_CurrentCity.m
//  CityChoose
//
//  Created by Eric MiAo on 15/8/27.
//  Copyright (c) 2015年 Eric MiAo. All rights reserved.
//

#import "EMCityChoose_CurrentCity.h"

@implementation EMCityChoose_CurrentCity
+ (NSString *)getCurrentCity:(NSString *)currentCity {
    [[NSUserDefaults standardUserDefaults]setValue:currentCity forKey:@"currentCity"];
    return [[NSUserDefaults standardUserDefaults]objectForKey:@"currentCity"];
}
@end
// 版权属于原作者
// http://code4app.com (cn) http://code4app.net (en)
// 发布代码于最专业的源码分享网站: Code4App.com