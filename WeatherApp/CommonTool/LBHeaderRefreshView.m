//
//  LBHeaderRefreshView.m
//  WeatherApp
//
//  Created by ligui on 16/6/13.
//  Copyright © 2016年 ZhenzhenXu. All rights reserved.
//

#import "LBHeaderRefreshView.h"

@implementation LBHeaderRefreshView
#pragma mark - 重写方法
#pragma mark 基本设置
- (void)prepare
{
    [super prepare];
    
    // 设置普通状态的动画图片
    NSMutableArray *idleImages = [NSMutableArray array];
    for (int i = 0; i<3; i++) {
        UIImage *image = [UIImage imageNamed:[NSString stringWithFormat:@"loading_birdspoint_000%d", i]];
        [idleImages addObject:image];
    }
    [self setImages:idleImages forState:MJRefreshStateIdle];
    
    // 设置即将刷新状态的动画图片（一松开就会刷新的状态）
    NSMutableArray *refreshingImages = [NSMutableArray array];
    for (int i = 0; i<=9; i++) {
        UIImage *image = [UIImage imageNamed:[NSString stringWithFormat:@"loading_birds_000%d", i]];
        [refreshingImages addObject:image];
    }
    [self setImages:refreshingImages forState:MJRefreshStatePulling];
    
    // 设置正在刷新状态的动画图片
    [self setImages:refreshingImages forState:MJRefreshStateRefreshing];
}
@end
