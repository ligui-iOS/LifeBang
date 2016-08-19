//
//  LBTool.m
//  WeatherApp
//
//  Created by ligui on 16/2/19.
//  Copyright © 2016年 ZhenzhenXu. All rights reserved.
//

#import "LBTool.h"
static LBTool *sharedClient = nil;
@implementation LBTool
+ (CGFloat)getWidthBoundingRectWithSize:(NSString *)str height:(CGFloat)height fontSize:(CGFloat)fontSize
{
    return [str boundingRectWithSize:CGSizeMake(CGFLOAT_MAX, height) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:fontSize]} context:nil].size.width;
}
+ (CGFloat)getHeightBoundingRectWithSize:(NSString *)str width:(CGFloat)width fontSize:(CGFloat)fontSize
{
    return [str sizeWithFont:[UIFont systemFontOfSize:fontSize]
             constrainedToSize:CGSizeMake(width, CGFLOAT_MAX)
                 lineBreakMode:NSLineBreakByWordWrapping].height;
    
    //[str boundingRectWithSize:CGSizeMake(width, CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:fontSize]} context:nil].size.width;
}
+ (NSMutableAttributedString *)changeRowSpacing:(CGFloat)height andLabelString:(NSString *)textStr
{
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc]initWithString:textStr];;
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc]init];
    [paragraphStyle setLineSpacing:height];
    [attributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, textStr.length)];
    return attributedString;
}
+ (LBTool *)sharedClient
{
    @synchronized(self){
        if(!sharedClient) {
            sharedClient = [[super allocWithZone:NULL] init];
        }
    }
    return sharedClient;
}
@end
