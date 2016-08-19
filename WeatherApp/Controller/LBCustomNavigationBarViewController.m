//
//  LBCustomNavigationBarViewController.m
//  WeatherApp
//
//  Created by ligui on 16/6/15.
//  Copyright © 2016年 ZhenzhenXu. All rights reserved.
//

#import "LBCustomNavigationBarViewController.h"

@interface LBCustomNavigationBarViewController ()

@end

@implementation LBCustomNavigationBarViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.navigationBarHidden = YES;
    self.view.backgroundColor = UIColorFromRGB(0xf5f5f9);
    [self createNavBar];
}
- (void)createNavBar
{
    if (!self.navBarColor) {
        self.navBarColor = 0x76d5ff;
    }
    UIImageView *navImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kNavigationBarAndStatusHeight)];//[MyUtil createImageView:CGRectMake(0, 0, kScreenWidth, kNavigationBarAndStatusHeight) imageName:@"navBar"];
    UIImage *image = [[UIImage alloc] init];
    navImageView.image = [image imageWithColor:UIColorFromRGB(self.navBarColor)];
    navImageView.userInteractionEnabled = YES;
    
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, kNavigationBarAndStatusHeight-0.5, kScreenWidth, 0.5)];
    lineView.backgroundColor = UIColorFromRGB(0xf0f0f0);
    [self.view addSubview:lineView];
    
    if (!self.navBarTitle) {
        self.navBarTitle = @"";
    }
    
    UILabel *navLabel = [MyUtil createLabelFrame:CGRectMake(kScreenWidth/2-100, 22, 200, 40) title:self.navBarTitle font:CUSTOM_FONT(20)];
    navLabel.textAlignment = NSTextAlignmentCenter;
    navLabel.textColor = [UIColor whiteColor];
    [navImageView addSubview:navLabel];
    
    UIButton *navBtn=[MyUtil createBtnFrame:CGRectMake(10, 27, 33, 25) image:@"back_black" selectImage:nil highlightImage:nil target:self action:@selector(backBtnClick:)];
    [navImageView addSubview:navBtn];
    
    [self.view addSubview:navImageView];
}
- (void)backBtnClick:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
