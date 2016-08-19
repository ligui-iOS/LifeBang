//
//  MyUtil.h
//  TestKitchen
//
//  Created by gaokunpeng on 15/5/7.
//  Copyright (c) 2015年 qianfeng. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MyUtil : NSObject

//创建label
+ (UILabel *)createLabelFrame:(CGRect)frame title:(NSString *)title font:(UIFont *)font;

//创建UIImageView
+ (UIImageView *)createImageView:(CGRect)frame imageName:(NSString *)imageName;

//按钮
+ (UIButton *)createBtnFrame:(CGRect)frame image:(NSString *)image selectImage:(NSString *)selectImageName highlightImage:(NSString *)highlightImage target:(id)target action:(SEL)action;

//输入框
+ (UITextField *)createTextFieldFrame:(CGRect)frame placeHolder:(NSString *)placeHolder isPwd:(BOOL)isPwd;





@end
