//
//  LBRecievePushDetailViewController.m
//  WeatherApp
//
//  Created by ligui on 16/3/10.
//  Copyright © 2016年 ZhenzhenXu. All rights reserved.
//

#import "LBRecievePushDetailViewController.h"
@interface LBRecievePushDetailViewController ()

@end

@implementation LBRecievePushDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.navigationBar.hidden = YES;
    [self createNavBar];
    [self createPushContent];
    // Do any additional setup after loading the view.
}
- (void)createPushContent
{
    UIWebView *webView = [[UIWebView alloc] initWithFrame:CGRectMake(0, kNavigationBarAndStatusHeight, kScreenWidth, kScreenHeight-kNavigationBarAndStatusHeight)];
    [webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:self.lifeTipsStr]]];
    [self.view addSubview:webView];
}
- (void)createNavBar
{
    UIImageView *navImageView = [MyUtil createImageView:CGRectMake(0, 0, kScreenWidth, kNavigationBarAndStatusHeight) imageName:@"navBar"];
    navImageView.userInteractionEnabled = YES;
    
    UILabel *navLabel=[MyUtil createLabelFrame:CGRectMake(kScreenWidth/2-100, 22, 200, 40) title:@"打鸡血" font:CUSTOM_FONT(20)];
    navLabel.textAlignment=NSTextAlignmentCenter;
    navLabel.textColor=[UIColor whiteColor];
    [navImageView addSubview:navLabel];
    
    UIButton *navBtn=[MyUtil createBtnFrame:CGRectMake(10, 27, 33, 25) image:@"back_black" selectImage:nil highlightImage:nil target:self action:@selector(backBtnClick:)];
    [navImageView addSubview:navBtn];
    
    [self.view addSubview:navImageView];
}
- (void)backBtnClick:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
