//
//  LBCustomNavigationBarViewController.h
//  WeatherApp
//
//  Created by ligui on 16/6/15.
//  Copyright © 2016年 ZhenzhenXu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LBCustomNavigationBarViewController : UIViewController
@property (nonatomic, strong) NSString *navBarTitle;
@property (nonatomic, assign) NSInteger navBarColor;
- (void)backBtnClick:(id)sender;
@end
