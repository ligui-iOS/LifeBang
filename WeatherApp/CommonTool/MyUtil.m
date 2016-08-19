//
//  MyUtil.m
//  TestKitchen
//
//  Created by gaokunpeng on 15/5/7.
//  Copyright (c) 2015年 qianfeng. All rights reserved.
//

#import "MyUtil.h"

@implementation MyUtil

+(UILabel *)createLabelFrame:(CGRect)frame title:(NSString *)title font:(UIFont *)font
{
    UILabel *label = [[UILabel alloc] initWithFrame:frame];
    if (title) {
        label.text = title;
    }
    if (font) {
        label.font = font;
    }
    return label;
    
}

+(UIImageView *)createImageView:(CGRect)frame imageName:(NSString *)imageName
{
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:frame];
    if (imageName) {
        imageView.image = [UIImage imageNamed:imageName];
    }
    return imageView;
}

+(UIButton *)createBtnFrame:(CGRect)frame image:(NSString *)image selectImage:(NSString *)selectImageName highlightImage:(NSString *)highlightImage target:(id)target action:(SEL)action
{
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = frame;
    if (image) {
        [btn setBackgroundImage:[UIImage imageNamed:image] forState:UIControlStateNormal];
    }
    if (selectImageName) {
        [btn setBackgroundImage:[UIImage imageNamed:selectImageName] forState:UIControlStateSelected];
    }
    if (highlightImage) {
        [btn setBackgroundImage:[UIImage imageNamed:highlightImage] forState:UIControlStateHighlighted];
    }
    if (target && action) {
        [btn addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    }
    return btn;
}

+(UITextField *)createTextFieldFrame:(CGRect)frame placeHolder:(NSString *)placeHolder isPwd:(BOOL)isPwd
{
    UITextField *textField = [[UITextField alloc] initWithFrame:frame];
    textField.borderStyle = UITextBorderStyleRoundedRect;
    if (placeHolder) {
        textField.placeholder = placeHolder;
    }
    if (isPwd) {
        textField.secureTextEntry = YES;
    }
    return textField;
}

@end
