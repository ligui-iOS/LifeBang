//
//  BasicView.h
//  picker自定义选择器
//
//  Created by apple on 16/4/6.
//  Copyright © 2016年 雷晏. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BasicView : UIView
@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, strong) NSString *imageUrl;
- (void)show;
@end
