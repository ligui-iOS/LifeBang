//
//  LBTool.h
//  WeatherApp
//
//  Created by ligui on 16/2/19.
//  Copyright © 2016年 ZhenzhenXu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LBTool : NSObject
+ (LBTool *)sharedClient;
+ (CGFloat)getWidthBoundingRectWithSize:(NSString *)str height:(CGFloat)height fontSize:(CGFloat)fontSize;
+ (NSMutableAttributedString *)changeRowSpacing:(CGFloat)height andLabelString:(NSString *)textStr;
+ (CGFloat)getHeightBoundingRectWithSize:(NSString *)str width:(CGFloat)width fontSize:(CGFloat)fontSize;
@end
