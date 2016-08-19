//
//  LBAssistiveTouchView.m
//  WeatherApp
//
//  Created by ligui on 16/6/15.
//  Copyright © 2016年 ZhenzhenXu. All rights reserved.
//

#import "LBAssistiveTouchView.h"

@implementation LBAssistiveTouchView{
    CGPoint _endPoint;
    CGPoint _startPoint;
    UIImageView *_animationImageView;
}
- (instancetype)init   {
    self = [super init];
    if(self){
        [self parametersSetup];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if(self){
        [self parametersSetup];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if(self){
        [self parametersSetup];
    }
    return self;
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    UITouch *touch = [touches anyObject];
    _startPoint = [touch locationInView:[self superview]];
}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self move:touches];
}

- (void)touchesCancelled:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self move:touches];
}

- (void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self move:touches];
}

/**
 *  设置关键参数
 */
- (void)parametersSetup {
    _animationImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.bounds.size.width, self.bounds.size.height)];
    [self addSubview:_animationImageView];
    NSMutableArray *images = [NSMutableArray array];
    for (int i = 0; i<=18; i++) {
        UIImage *image = [UIImage imageNamed:[NSString stringWithFormat:@"touch_animation_000%d", i]];
        [images addObject:image];
    }
    _animationImageView.animationImages = images;
    _animationImageView.animationDuration = 3;
    [_animationImageView startAnimating];
    self.userInteractionEnabled = YES;
}
- (void)imageViewStopAnimation
{
    [_animationImageView stopAnimating];
    _animationImageView = nil;
}

/**
 *  获取精准的CGPoint
 *
 *  @param start 移动前CGPoint
 *  @param end   移动的CGPoint
 *
 *  @return 精准的CGPoint
 */
- (CGPoint)getAccuratePoint:(CGPoint)start end:(CGPoint)end {
    end.x = end.x - (start.x - self.frame.origin.x);
    end.y = end.y - (start.y - self.frame.origin.y);
    return end;
}

/**
 *  边界检测
 *
 *  @param point 精准的CGPoint
 *
 *  @return 是否越界
 */
- (BOOL)checkPoint:(CGPoint)point {
    if (point.x < 0 && -point.x >= self.frame.size.width/2) {
        return false;
    }
    if(point.y < 0 && -point.y >= self.frame.size.height/2){
        return false;
    }
    return true;
}

/**
 *  移动并作根据事件和精准的CGPoint作动画
 *
 *  @param touches 触摸的信息
 */
- (void)move:(NSSet<UITouch *> *)touches{
    UITouch *touch = [touches anyObject];
    _endPoint = [touch locationInView:[self superview]];
    CGPoint end = [self getAccuratePoint:_startPoint end:_endPoint];
    if ([self checkPoint:end]) {
        self.frame = CGRectMake(end.x, end.y, self.frame.size.width, self.frame.size.height);
    }
    _startPoint = _endPoint;
    if (touch.phase == UITouchPhaseEnded || touch.phase == UITouchPhaseCancelled) {
        [self animate:end];
    }
}

/**
 *  根据当前的精准的CGPoint作动画
 *
 *  @param point 精准的CGPoint
 */
- (void)animate:(CGPoint)point {
    
    if (point.x < 0) {
        point.x = 0;
    }
    
    if(point.x >= ([self superview].frame.size.width - self.frame.size.width)){
        point.x = [self superview].frame.size.width - self.frame.size.width;
    }
    
    if (point.y < 0) {
        point.y = 0;
    }
    
    if(point.y >= ([self superview].frame.size.height - self.frame.size.height)){
        point.y = [self superview].frame.size.height - self.frame.size.height;
    }
    
    if (point.y < point.x ) {
        point.y = 0;
    } else if(([self superview].frame.size.height - point.y) < point.x){
        point.y = [self superview].frame.size.height - self.frame.size.height;
    } else {
        if ((point.x + self.frame.size.width/2) < [self superview].frame.size.width / 2) {
            point.x = 0;
        }
        if ((point.x + self.frame.size.width/2) >= [self superview].frame.size.width / 2) {
            point.x = [self superview].frame.size.width - self.frame.size.width;
        }
    }
    [UIView animateWithDuration:0.3f animations:^{
        self.frame = CGRectMake(point.x, point.y, self.frame.size.width, self.frame.size.height);
    }];
}

@end
