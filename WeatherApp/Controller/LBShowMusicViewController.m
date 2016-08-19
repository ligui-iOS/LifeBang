//
//  LBShowMusicViewController.m
//  WeatherApp
//
//  Created by ligui on 16/6/8.
//  Copyright © 2016年 ZhenzhenXu. All rights reserved.
//

#import "LBShowMusicViewController.h"
#import "AFNetWorkingGetPostRequest.h"
#import "Masonry/Masonry.h"
#import "LBMusicSearchResultListViewController.h"
#import "iflyMSC/IFlyMSC.h"
#define BAIDUMUSICURL @"http://tingapi.ting.baidu.com/v1/restserver/ting"
#define APPID_VALUE           @"5760caf2"

//#error 请修改为您在百度开发者平台申请的APP ID

//format=json&calback=&from=webapp_music&method=baidu.ting.song.downWeb&songid=877578&bit=24&_t=1393123213
@interface LBShowMusicViewController ()<UITextFieldDelegate,IFlyRecognizerViewDelegate>
@property (nonatomic, strong) UITextField *searchTextField;
@property (nonatomic, strong) UILabel *voiceResultLabel;
@property (nonatomic, strong) UIImageView *microphoneImageView;
@property (nonatomic, strong) IFlyRecognizerView *iflyRecognizerView;

@end

@implementation LBShowMusicViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self createUI];
    [self createSpeechRecognizer];

}
- (void)createUI
{
    NSString *tipsStr = @"说一说\n或者输一下\n你想听的";
    
    NSMutableAttributedString *attributeTipsStr = [[NSMutableAttributedString alloc] initWithString:tipsStr];
    NSLog(@"attributeTipsStr.length=====%ld",attributeTipsStr.length);
    NSDictionary *longTopDict = [NSDictionary dictionaryWithObjectsAndKeys:
                                 CUSTOM_FONT(30),NSFontAttributeName,
                                 UIColorFromRGB(0xba2ca3),NSForegroundColorAttributeName,nil];
    NSDictionary *longBottomDict = [NSDictionary dictionaryWithObjectsAndKeys:
                                    CUSTOM_FONT(32),NSFontAttributeName,
                                    UIColorFromRGB(0xd12f35),NSForegroundColorAttributeName,nil];
    NSDictionary *lastDict = [NSDictionary dictionaryWithObjectsAndKeys:
                              CUSTOM_FONT(35),NSFontAttributeName,
                              UIColorFromRGB(0x6f83e5),NSForegroundColorAttributeName,nil];
    
    [attributeTipsStr setAttributes:longTopDict range:NSMakeRange(0, 3)];
    [attributeTipsStr setAttributes:longBottomDict range:NSMakeRange(4, 5)];
    [attributeTipsStr setAttributes:lastDict range:NSMakeRange(9, attributeTipsStr.length-9)];
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    [paragraphStyle setLineSpacing:20];
    [attributeTipsStr addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, attributeTipsStr.length)];
    
    UILabel *tipsLabel = [[UILabel alloc] initWithFrame:CGRectMake(30, 80, kScreenWidth-60, [attributeTipsStr boundingRectWithSize:CGSizeMake(kScreenWidth-60, CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin context:nil].size.height)];
    tipsLabel.attributedText = attributeTipsStr;
    tipsLabel.textAlignment = NSTextAlignmentCenter;
    tipsLabel.numberOfLines = 0;
    [self.view addSubview:tipsLabel];
    
    UIView *searchView = [[UIView alloc] initWithFrame:CGRectMake(30, 300, kScreenWidth-60, 50)];
    searchView.layer.masksToBounds = YES;
    searchView.layer.cornerRadius = 5;
    searchView.layer.borderColor = UIColorFromRGB(0x76d5ff).CGColor;
    searchView.layer.borderWidth = 1;
    [self.view addSubview:searchView];
    
    UIButton *searchBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    searchBtn.frame = CGRectMake(2, 2, searchView.frame.size.height-4, searchView.frame.size.height-4);
    [searchBtn setImage:[[UIImage imageNamed:@"search_music"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] forState:UIControlStateNormal];
    [searchBtn addTarget:self action:@selector(searchBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [searchView addSubview:searchBtn];
    
    _searchTextField = [[UITextField alloc] initWithFrame:CGRectMake(searchBtn.frame.origin.x+searchBtn.frame.size.width+10, 2, searchView.frame.size.width-(searchBtn.frame.origin.x+searchBtn.frame.size.width+10), searchBtn.frame.size.height)];
    _searchTextField.placeholder = @"搜索内容...";
    _searchTextField.delegate = self;
    _searchTextField.returnKeyType = UIReturnKeySearch;
    _searchTextField.font = CUSTOM_FONT(25);
    [_searchTextField setValue:CUSTOM_FONT(25) forKeyPath:@"_placeholderLabel.font"];
    _searchTextField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    [searchView addSubview:self.searchTextField];
    
    _microphoneImageView = [[UIImageView alloc] initWithFrame:CGRectMake((kScreenWidth-41)/2, searchView.frame.origin.y+searchView.frame.size.height+30, 41, 82)];
    NSMutableArray *images = [NSMutableArray array];
    for (int i = 1; i<=5; i++) {
        UIImage *image = [UIImage imageNamed:[NSString stringWithFormat:@"microphone_0%d", i]];
        [images addObject:image];
    }
    
    dispatch_async(dispatch_get_main_queue(), ^{
        _microphoneImageView.animationImages = images;
        _microphoneImageView.animationDuration = 1;
        [_microphoneImageView startAnimating];
        _microphoneImageView.userInteractionEnabled = YES;
        [self.view addSubview:_microphoneImageView];
    });
    
    UITapGestureRecognizer *microphoneImageViewTap = [[UITapGestureRecognizer alloc] init];
    microphoneImageViewTap.numberOfTapsRequired = 1;
    [microphoneImageViewTap addTarget:self action:@selector(microphoneImageViewTap)];
    [_microphoneImageView addGestureRecognizer:microphoneImageViewTap];
    
    _voiceResultLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, _microphoneImageView.frame.origin.y+_microphoneImageView.frame.size.height+5, 300, 30)];
    _voiceResultLabel.font = [UIFont systemFontOfSize:13];
    _voiceResultLabel.textColor = [UIColor blackColor];
    _voiceResultLabel.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:_voiceResultLabel];
}
- (void)createSpeechRecognizer
{
    NSString *initString = [NSString stringWithFormat:@"%@=%@", [IFlySpeechConstant APPID], APPID_VALUE];
    
    [IFlySpeechUtility createUtility:initString];
    _iflyRecognizerView = [[IFlyRecognizerView alloc] initWithCenter:self.view.center];
    _iflyRecognizerView.delegate = self;
    
    [_iflyRecognizerView setParameter:@"iat" forKey:[IFlySpeechConstant IFLY_DOMAIN]];
    [_iflyRecognizerView setParameter:@"asr.pcm" forKey:[IFlySpeechConstant ASR_AUDIO_PATH]];
    [_iflyRecognizerView setParameter:@"plain" forKey:[IFlySpeechConstant RESULT_TYPE]];
}
- (void)searchBtnClick:(id)sender
{
    if (self.searchTextField&&![self.searchTextField.text isEqualToString:@""]) {
        [self toSearchResultListPage];
    } else {
        return;
    }
}
#pragma mark------------------UITextFieldDelegate---------
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if (textField.text&&![textField.text isEqualToString:@""]) {
        [self toSearchResultListPage];
    }
    return YES;
}
- (void)microphoneImageViewTap
{
    NSLog(@"microphoneImageViewTap");
    [_iflyRecognizerView start];
}
- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    [IFlySpeechUtility destroy];
}
#pragma mark IFlyRecognizerViewDelegate

- (void)onResult:(NSArray *)resultArray isLast:(BOOL)isLast
{
    NSMutableString *result = [[NSMutableString alloc] init];
    NSDictionary *dic = [resultArray objectAtIndex:0];
    for (NSString *key in dic) {
        [result appendFormat:@"%@", key];
    }
    if (result&&![result isEqualToString:@""]) {
        _searchTextField.text = result;
    }
}
- (void)onError:(IFlySpeechError *)error
{
    NSLog(@"errorCode:%@", [error errorDesc]);
}
- (void)toSearchResultListPage
{
    LBMusicSearchResultListViewController *ctrl = [[LBMusicSearchResultListViewController alloc] init];
    ctrl.searchResultStr = self.searchTextField.text;
    [self.navigationController pushViewController:ctrl animated:YES];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    NSLog(@"ctrl====%@ didReceiveMemoryWarning",[self class]);
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
