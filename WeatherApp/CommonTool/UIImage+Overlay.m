//
//  UIImage+Overlay.m
//  IMobPay
//
//  Created by hehualiang on 5/9/14.
//  Copyright © 2014 QTPay All rights reserved..
//

#import "UIImage+Overlay.h"

@implementation UIImage (Overlay)
- (UIImage *)imageWithColor:(UIColor *)color
{
    CGRect rect = CGRectMake(0.0f, 0.0f, 1.0f, 1.0f);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
}
@end
