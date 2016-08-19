//
//  LBFoodListModel.m
//  WeatherApp
//
//  Created by ligui on 16/2/29.
//  Copyright © 2016年 ZhenzhenXu. All rights reserved.
//

#import "LBFoodListModel.h"

@implementation LBFoodListModel
- (void)setValue:(id)value forUndefinedKey:(NSString *)key
{
    
}
- (void)setValuesForKeysWithDictionary:(NSDictionary<NSString *,id> *)keyedValues
{
    self.name = keyedValues[@"name"];
    self.keywords = keyedValues[@"keywords"];
    self.img = keyedValues[@"img"];
    self.foodDescription = keyedValues[@"description"];
    self.FoodId = keyedValues[@"id"];
}
@end
