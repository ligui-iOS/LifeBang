//
//  IMPBlurTransparentView.m
//  IMobPay
//
//  Created by ligui on 15/9/15.
//  Copyright (c) 2015年 QTPay. All rights reserved.
//

#import "IMPBlurTransparentView.h"
@interface IMPBlurTransparentView()
{
    UIImage *outPutImage;
}
@end
@implementation IMPBlurTransparentView
- (id)initWithFrame:(CGRect)frame backgroundColor:(UIColor *)color blurLevel:(CGFloat)blurLevel
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = color;
        [self createUI:blurLevel view:self];
    }
    return self;
}
- (void)createUI:(CGFloat)blurLevel view:(UIView *)view
{
    if (IOS_VERSION>=8) {
        UIVisualEffectView *visualEfView = [[UIVisualEffectView alloc] initWithEffect:[UIBlurEffect effectWithStyle:UIBlurEffectStyleLight]];
        visualEfView.frame = CGRectMake(0, 0, self.bounds.size.width, self.bounds.size.height);
        visualEfView.alpha = blurLevel;
        [view addSubview:visualEfView];
    }else{
        UIImageView *blurImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.bounds.size.width, self.bounds.size.height)];
        UIImage *blurImage = [self blurryImage:[self createImageWithColor:[UIColor whiteColor]] withBlurLevel:blurLevel];
        blurImageView.image = blurImage;
        [view addSubview:blurImageView];
    }
}
- (UIImage *)blurryImage:(UIImage *)image withBlurLevel:(CGFloat)blur {
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        CIContext *context = [CIContext contextWithOptions:nil];
        CIImage *inputImage = [CIImage imageWithCGImage:image.CGImage];
        CIFilter *filter = [CIFilter filterWithName:@"CIGaussianBlur"
                                      keysAndValues:kCIInputImageKey, inputImage,
                            @"inputRadius", @(blur),
                            nil];
        
        CIImage *outputImage = filter.outputImage;
        
        CGImageRef outImage = [context createCGImage:outputImage
                                            fromRect:[outputImage extent]];
        dispatch_async(dispatch_get_main_queue(), ^{
            outPutImage = [UIImage imageWithCGImage:outImage];
        });
    });
    return outPutImage;
}
- (UIImage *)createImageWithColor: (UIColor *) color
{
    CGRect rect=CGRectMake(0.0f, 0.0f, 1.0f, 1.0f);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    
    UIImage *theImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return theImage;
}
@end
