//
//  LBOnePageWebviewViewController.m
//  WeatherApp
//
//  Created by ligui on 16/6/23.
//  Copyright © 2016年 ZhenzhenXu. All rights reserved.
//

#import "LBOnePageWebviewViewController.h"
#import "SVProgressHUD.h"

@interface LBOnePageWebviewViewController ()<UIWebViewDelegate>
@property (nonatomic, retain) UIWebView *oneWebView;
@end

@implementation LBOnePageWebviewViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self createWebView];
}
- (void)createWebView
{
    _oneWebView = [[UIWebView alloc] initWithFrame:CGRectMake(0, kNavigationBarAndStatusHeight, kScreenWidth, kScreenHeight-kNavigationBarAndStatusHeight)];
    [_oneWebView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:self.oneWebviewUrl]]];
    _oneWebView.delegate = self;
    [self.view addSubview:_oneWebView];
}
- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    [SVProgressHUD showWithMaskType:SVProgressHUDMaskTypeGradient];
        return YES;
}
- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    NSString *str = @"document.getElementsByClassName('b_crumb')[0].remove();";
    [webView stringByEvaluatingJavaScriptFromString:str];
    NSString *bannerStr = @"document.getElementsByClassName('b_banner')[0].remove();";
    [webView stringByEvaluatingJavaScriptFromString:bannerStr];
    NSString *removeBottomStr = @"document.getElementsByClassName('qn_footer')[0].remove();";
    [webView stringByEvaluatingJavaScriptFromString:removeBottomStr];
    NSString *removeMoreStr = @"document.getElementsByClassName('relevant-list')[0].remove();";
    [webView stringByEvaluatingJavaScriptFromString:removeMoreStr];
    NSString *stopStr = @"document.addEventListener('touchend',function(e){ e.stopPropagation();e.preventDefault();}, false);";
    [webView stringByEvaluatingJavaScriptFromString:stopStr];

    [SVProgressHUD dismiss];
}
- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [SVProgressHUD dismiss];
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
