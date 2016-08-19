//
//  ViewController.m
//  WeatherApp
//
//  Created by ZhenzhenXu on 4/30/13.
//  Copyright (c) 2013 ZhenzhenXu. All rights reserved.
//

#import "WeatherViewController.h"
#import "ForecastWeatherView.h"
#import "SVProgressHUD.h"
#import "LBFoodListViewController.h"
#import <CoreLocation/CoreLocation.h>
#import "EMCityChoose.h"
#import "ChineseToPinyin.h"
#import "MMProgressHUD/MMProgressHUD.h"
#import "LBShowMusicViewController.h"
#import "IMPBlurTransparentView.h"
#import "HyPopMenuView.h"
#import "MenuLabel.h"
#import "LBAssistiveTouchView.h"
#import "UIColor+ImageGetColor.h"
@interface WeatherViewController()<CLLocationManagerDelegate,UIAlertViewDelegate>
{
    NSTimer *_labelTimer;
//    UIScrollView *_labelScrollView;
//    UILabel *_scrollLabel;
//    CGFloat scrollLabelWidth;
//    NSInteger scrollIndex;
    UIScrollView *labelScrollView;
    CGFloat scrollLabelWidth;
    CGFloat scrollIndex;
    EMCityChoose *_cityChooseViewController;
    UIView *weatherDetailView;
    LBAssistiveTouchView *touchView;
}
@property (nonatomic, retain) CLLocationManager *lbLocationManager;

@end
@implementation WeatherViewController

@synthesize scrollView=_scrollView;
@synthesize curWeatherView=_curWeatherView;//当前天气显示视图
@synthesize forecastWeatherView=_forecastWeatherView;
@synthesize dayWeatherRequest=_dayWeatherRequest;
@synthesize headerView=_headerView;
@synthesize timer=_timer;
@synthesize imageList=_imageList;
@synthesize dictType=_dictType;

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.navigationController.navigationBarHidden = YES;
//    NSLog(@"familyNames=====%@",[UIFont familyNames]);
    [self startUpdatingLocation];
	// Do any additional setup after loading the view, typically from a nib.
    _imageList=[[NSMutableArray alloc] initWithObjects:@"show_image_1.png", @"show_image_2.png", @"show_image_3.png", @"show_image_4.png", nil];
    [self createGradientBackground:self.view.bounds with:[_imageList objectAtIndex:0]];
    page=1;
    scrollIndex = 0;
    
    _dayWeatherRequest = [[DayWeatherRequest alloc] initRequest];
    _dayWeatherRequest.delegate = self;
    _dayWeatherRequest.requestUrl = @"http://apis.baidu.com/heweather/weather/free";
    _dayWeatherRequest.requestMethod = @"post";
    [self getWeatherDataFromCity:@"shanghai"];
    [self createViews];
    [self createMoreManuViews];
}
- (void)getWeatherDataFromCity:(NSString *)cityStr
{
    [SVProgressHUD showWithMaskType:SVProgressHUDMaskTypeGradient];
    _dayWeatherRequest.requestParameter = [NSMutableDictionary dictionaryWithObject:cityStr forKey:@"city"];
    [_dayWeatherRequest createConnection];
}
- (void)createLabelScroll
{
    if ((_labelTimer == nil)&&(labelScrollView!=nil)) {
        _labelTimer = [NSTimer scheduledTimerWithTimeInterval:0.05 target:self selector:@selector(labelTimerAction:) userInfo:nil repeats:YES];
    }
}
- (void)labelTimerAction:(id)sender
{
    CGFloat x = scrollIndex + 2;
    if (x > scrollLabelWidth+10) {
        x=-(kScreenWidth-20);
        [labelScrollView setContentOffset:CGPointMake(x, 0) animated:NO];
        scrollIndex = x;
        return;
    }
    
    [labelScrollView setContentOffset:CGPointMake(x, 0) animated:YES];
    scrollIndex = x;
}
- (void)createGradientBackground:(CGRect)rect with:(NSString*)bgurl{
    //Image background
    UIImage *bgImage=[UIImage imageNamed:bgurl];
    CGSize bgSize=bgImage.size;
    CGRect imageRect;
    if ((bgSize.width/bgSize.height)>(rect.size.width/rect.size.height)) {
        imageRect=CGRectMake(0, 0, rect.size.height*bgImage.size.width/bgImage.size.height, rect.size.height);
    }else{
        imageRect=CGRectMake(0, 0, rect.size.width,rect.size.width*bgImage.size.height/bgImage.size.width);
    }
    
    UIGraphicsBeginImageContext(imageRect.size);
    [bgImage drawInRect:imageRect];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    self.view.backgroundColor = [UIColor colorWithPatternImage:image];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    if (self.timer==nil) {
        self.timer=[NSTimer scheduledTimerWithTimeInterval:10.0f target:self selector:@selector(switchImages) userInfo:nil repeats:YES];
    }
    if ((_labelTimer == nil)&&(labelScrollView!=nil)) {
        _labelTimer = [NSTimer scheduledTimerWithTimeInterval:0.05 target:self selector:@selector(labelTimerAction:) userInfo:nil repeats:YES];
    }
}

- (void)switchImages
{
    CATransition *transition = [CATransition animation];
    transition.duration = 1.0f;
    transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    transition.type = kCATransitionFade;
    transition.delegate = self;
    [self.view.layer addAnimation:transition forKey:@"EaseInOut"];
    
    NSString *imageUrl = [_imageList objectAtIndex:page];
    [self createGradientBackground:self.view.bounds with:imageUrl];
    page=(page+1)%_imageList.count;
}

- (void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    if (_timer!=nil) {
        [_timer invalidate];
        _timer = nil;
    }
    if (_labelTimer) {
        [_labelTimer invalidate];
        _labelTimer = nil;
    }
//    if (touchView) {
//        [touchView imageViewStopAnimation];
//    }
}

- (void)createViews{
    _headerView=[[WeatherHeaderView alloc] initWithFrame:CGRectMake(0, 20, kScreenWidth, 44)];
//    [_headerView.refreshBtn addTarget:self action:@selector(refreshData) forControlEvents:UIControlEventTouchUpInside];
    [_headerView.cityBtn addTarget:self action:@selector(cityBtnClick:) forControlEvents:UIControlEventTouchUpInside];
//    [_headerView.leftBtn addTarget:self action:@selector(leftBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_headerView];
    
    CGRect rect=self.view.bounds;
    rect.origin.y=44.0f;
    rect.size.height-=44.0f;
    _scrollView.frame=rect;
    
    _curWeatherView=[[CurrentDayWeatherView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth/2, 160)];
    [_curWeatherView fillViewWith:nil];
//    UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(singleTapGestureCaptured:)];
//    [_curWeatherView addGestureRecognizer:singleTap];
    
    _forecastWeatherView=[[ForecastWeatherView alloc] initWithFrame:CGRectMake(8, kScreenHeight-240, kScreenWidth-16, 240)];
    [self.view addSubview:_forecastWeatherView];
}

//- (void)refreshData{
////    [_dayWeatherRequest createConnection];
////    [_forecastWeatherRequest createConnection];
////    [SVProgressHUD showWithMaskType:SVProgressHUDMaskTypeGradient];
//    LBFoodListViewController *ctrl = [[LBFoodListViewController alloc] init];
//    [self.navigationController pushViewController:ctrl animated:YES];
//}
- (void)cityBtnClick:(UIButton *)btn
{
    [EMCityChoose_CurrentCity getCurrentCity:[_headerView.cityBtn currentTitle]];
//    NSLog(@"[_headerView.cityBtn currentTitle]==%@",[_headerView.cityBtn currentTitle]);
    NSArray *hotCityArray = [NSArray arrayWithObjects:@"北京市",@"广州市",@"上海市",@"重庆市",@"成都市",@"杭州市",@"南京市",@"武汉市",@"西安市",@"郑州市",@"南宁市" ,@"长沙市",@"长春市",@"太原市",nil];
    if (!_cityChooseViewController.isShow) {
        _cityChooseViewController = [[EMCityChoose alloc]initWithPointY:110 buttonTitleCityName:[_headerView.cityBtn currentTitle] hotCity:hotCityArray cityType:(cityListType)cityListTypeShortType hideSearchBar:NO];
        _cityChooseViewController.delegate = self;
        [self addChildViewController:_cityChooseViewController];
        _cityChooseViewController.view.layer.masksToBounds = YES;
        _cityChooseViewController.view.layer.cornerRadius = 5;
        _cityChooseViewController.view.alpha = 0.96;
        [self.view addSubview:_cityChooseViewController.view];
    }else {
        [_cityChooseViewController closeView];
    }
}
#pragma mark ------------DayWeatherRequestDelegage--------
-(void) dayWeatherRequestFinished:(NSDictionary*)data withError:(NSString*)error{
    [SVProgressHUD dismiss];
    if (error) {
        [SVProgressHUD showErrorWithStatus:error];
    }else{
        [_curWeatherView fillCurrentTempWith:[[[data objectForKey:@"HeWeather data service 3.0"] lastObject] objectForKey:@"now"]];
        [_curWeatherView fillViewWith:[[[data objectForKey:@"HeWeather data service 3.0"] lastObject] objectForKey:@"now"]];
        [_forecastWeatherView fillViewWith:[[[data objectForKey:@"HeWeather data service 3.0"] lastObject] objectForKey:@"daily_forecast"]];
        _headerView.dateLabel.text = [NSString stringWithFormat:@"更新时间：%@",[[[[[data objectForKey:@"HeWeather data service 3.0"] lastObject] objectForKey:@"basic"] objectForKey:@"update"] objectForKey:@"loc"]];
        [self createLabelScrollView:[self dealWithWeatherDictionaryData:[[[data objectForKey:@"HeWeather data service 3.0"] lastObject] objectForKey:@"suggestion"]]];
    }
}
/**
 *  处理API过来的数据使其符合显示
 *
 *  @param dict <#dict description#>
 *
 *  @return <#return value description#>
 */
- (NSArray *)dealWithWeatherDictionaryData:(NSDictionary *)dict
{
    NSMutableArray *mArr = [NSMutableArray array];
    NSArray *suggestionArr = @[@"comf",@"cw",@"drsg",@"flu",@"sport",@"trav",@"uv"];
    NSArray *titleArr = @[@"舒适度指数",@"洗车指数",@"穿衣指数",@"感冒指数",@"运动指数",@"旅游指数",@"紫外线指数"];
    for (int i=0 ; i<suggestionArr.count ; i++) {
        NSDictionary *sDict = dict[suggestionArr[i]];
        NSString *detailStr = [NSString stringWithFormat:@"%@",sDict[@"txt"]];//sDict[@"brf"],
        [mArr addObject:[NSDictionary dictionaryWithObject:detailStr forKey:[NSString stringWithFormat:@"%@:%@",titleArr[i],sDict[@"brf"]]]];
    }
    return [NSArray arrayWithArray:mArr];
    
}
/**
 *  利用arr创建label以及跑马灯
 *
 *  @param arr <#arr description#>
 */
- (void)createLabelScrollView:(NSArray *)arr
{
    if (weatherDetailView) {
        [weatherDetailView removeFromSuperview];
        weatherDetailView = nil;
    }
    if (scrollIndex) {
        scrollIndex = 0;
    }
    weatherDetailView = [[UIView alloc] initWithFrame:CGRectMake(0, kNavigationBarAndStatusHeight, kScreenWidth, 180)];
    [self.view addSubview:weatherDetailView];
    
    [self.view insertSubview:weatherDetailView belowSubview:touchView];
    
    [weatherDetailView addSubview:_curWeatherView];
    
    NSMutableString *mStr = [[NSMutableString alloc] init];
    for (int i=0; i<arr.count; i++) {
        NSDictionary *dict = arr[i];
        UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(kScreenWidth/2, 20*i,kScreenWidth/2, 20)];
        titleLabel.text = [[dict allKeys] lastObject];
        titleLabel.font = CUSTOM_FONT(17);
        titleLabel.textColor = [UIColor whiteColor];
        [weatherDetailView addSubview:titleLabel];
        
        [mStr appendString:[[dict allValues] lastObject]];
        
    }
    labelScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(10, 20*(arr.count+1), kScreenWidth-20, 20)];
    [weatherDetailView addSubview:labelScrollView];
    
    scrollLabelWidth = [LBTool getWidthBoundingRectWithSize:mStr height:20 fontSize:17];
    UILabel *scrollLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0,scrollLabelWidth+10, 20)];
    scrollLabel.text = mStr;
    scrollLabel.font = CUSTOM_FONT(17);
    scrollLabel.textColor = [UIColor whiteColor];
    [labelScrollView addSubview:scrollLabel];
    
    labelScrollView.contentSize = CGSizeMake(scrollLabelWidth+10, 20);
    labelScrollView.showsHorizontalScrollIndicator = NO;
    
    [self createLabelScroll];
}
- (void)startUpdatingLocation
{
    if (!self.lbLocationManager) {
        self.lbLocationManager = [[CLLocationManager alloc] init];
        self.lbLocationManager.delegate = self;
        self.lbLocationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters;
        self.lbLocationManager.distanceFilter = kCLDistanceFilterNone;
        
        
        if ([[[UIDevice currentDevice]systemVersion] floatValue]>8.0) {
            [self.lbLocationManager requestWhenInUseAuthorization];
        }
    }
    
    [self.lbLocationManager startUpdatingLocation];
}
#pragma mark - CLLocationManagerDelegate
- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations
{
    CLLocation *location = [locations lastObject];
//    [USER_DEFAULT setObject:[NSString stringWithFormat:@"%f", location.coordinate.latitude] forKey:kIMPCurrentLocationLatitude];
//    [USER_DEFAULT setObject:[NSString stringWithFormat:@"%f", location.coordinate.longitude] forKey:kIMPCurrentLocationLongitude];
    CLGeocoder * geoCoder = [[CLGeocoder alloc] init];
    [geoCoder reverseGeocodeLocation:location completionHandler:^(NSArray *placemarks, NSError *error) {
        for (CLPlacemark * placemark in placemarks) {
            
            NSString *test = [placemark locality];
            NSLog(@"%@", test);
            [_headerView.cityBtn setTitle:test forState:UIControlStateNormal];
        }
    }];
    [self.lbLocationManager stopUpdatingLocation];
    [SVProgressHUD dismiss];
    NSString *cityStr = [_headerView.cityBtn currentTitle];
    [self getWeatherDataFromCity:[ChineseToPinyin pinyinFromChiniseString:[self removeShiFromString:cityStr]]];
}
-(void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error{
    if ([error code]==kCLErrorDenied) {
        NSLog(@"访问被拒绝");
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"生活邦" message:@"是否去打开定位" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"去设置", nil];
        [alertView show];
    }
    if ([error code]==kCLErrorLocationUnknown) {
        NSLog(@"无法获取位置信息");
    }
}
#pragma mark-------------EMCityChooseDelegate--------
- (void)startDisplay:(EMCityChoose *)aCityChooseViewController {
    NSLog(@"列表出现了");
}

- (void)stopDisplay:(EMCityChoose *)aCityChooseViewController {
    NSLog(@"列表消失了");
    NSLog(@"选择城市为:%@",[aCityChooseViewController getCityName]);
    NSString *cityStr = [aCityChooseViewController getCityName];
    [_headerView.cityBtn setTitle:cityStr forState:UIControlStateNormal];
    [self getWeatherDataFromCity:[ChineseToPinyin pinyinFromChiniseString:[self removeShiFromString:cityStr]]];
//    [_showCityListButton setTitle:[aCityChooseViewController getCityName] forState:UIControlStateNormal];
}

- (void)refreshCurrentCity:(EMCityChoose *)aCityChooseViewController {
    NSLog(@"刷新位置。");
    [self.lbLocationManager startUpdatingLocation];
    [SVProgressHUD showWithStatus:@"正在定位" maskType:SVProgressHUDMaskTypeGradient];
}
- (NSString *)removeShiFromString:(NSString *)str
{
    if ([[str substringFromIndex:str.length-1] isEqualToString:@"市"]) {
        return [str substringToIndex:str.length-1];
    }else{
        return str;
    }
}
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1) {
        NSURL *url = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
        if ([[UIApplication sharedApplication] canOpenURL:url]) {
            [[UIApplication sharedApplication] openURL:url];
        }
    }
}
//- (void)leftBtnClick:(id)sender
//{
//    LBShowMusicViewController *ctrl = [[LBShowMusicViewController alloc] init];
//    [self.navigationController pushViewController:ctrl animated:YES];
//}
- (void)createMoreManuViews
{
//    IMPBlurTransparentView *blurView = [[IMPBlurTransparentView alloc] initWithFrame:CGRectMake(0, SCREEN_HIGHT/2-20, 40, 40) backgroundColor:[UIColor blackColor] blurLevel:0.9];
//    blurView.layer.masksToBounds = YES;
//    blurView.alpha = 0.6;
//    blurView.layer.cornerRadius = 20;
//    [self.view addSubview:blurView];
//    
//    UILabel *manuLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 40, 40)];
//    manuLabel.text = @"更多";
//    manuLabel.font = CUSTOM_FONT(13);
//    manuLabel.textColor = [UIColor whiteColor];
//    manuLabel.textAlignment = NSTextAlignmentCenter;
//    [blurView addSubview:manuLabel];
    
    touchView = [[LBAssistiveTouchView alloc] initWithFrame:CGRectMake(0, SCREEN_HIGHT/2-20, 80, 80)];
    touchView.layer.masksToBounds = YES;
//    touchView.alpha = 0.9;
    touchView.layer.cornerRadius = 10;
    [self.view addSubview:touchView];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] init];
    tap.numberOfTapsRequired = 1;
    [tap addTarget:self action:@selector(moreManuClick)];
    [touchView addGestureRecognizer:tap];
    
}
- (void)moreManuClick
{
    NSArray *ctrlArr = @[@"LBShowMusicViewController",@"LBFoodListViewController",@"LBMovieInformationViewController",@"LBTravelNotesListViewController"];
    [HyPopMenuView CreatingPopMenuObjectItmes:@[[MenuLabel CreatelabelIconName:@"icon_music" Title:@"音乐"],[MenuLabel CreatelabelIconName:@"icon_food" Title:@"今日健康菜品"],[MenuLabel CreatelabelIconName:@"icon_movie" Title:@"电影资讯"],[MenuLabel CreatelabelIconName:@"icon_travel" Title:@"旅行"]] TopView:nil OpenOrCloseAudioDictionary:nil SelectdCompletionBlock:^(MenuLabel *menuLabel, NSInteger index) {
        if (index == 1) {
            LBFoodListViewController *ctrl = [[LBFoodListViewController alloc] init];
            [self.navigationController pushViewController:ctrl animated:YES];
        }else {
            LBCustomNavigationBarViewController *ctrl = [(LBCustomNavigationBarViewController *)[NSClassFromString(ctrlArr[index]) alloc] init];
            ctrl.navBarTitle = menuLabel.title;
            ctrl.navBarColor = [self getColorOfRGBValue:[self getColorFromImage:[UIImage imageNamed:menuLabel.iconName]]];
            [self.navigationController pushViewController:ctrl animated:YES];
        }
    }];

}
- (UIColor *)getColorFromImage:(UIImage *)image
{
    return [UIColor getPixelColorAtLocation:CGPointMake(50, 20) inImage:image];
}
- (NSInteger)getColorOfRGBValue:(UIColor *)color
{
    const CGFloat *components = CGColorGetComponents(color.CGColor);
    int r = components[0] * 255;
    int g = components[1] * 255;
    int b = components[2] * 255;
    NSString *red = [NSString stringWithFormat:@"%02x", r];
    NSString *green = [NSString stringWithFormat:@"%02x", g];
    NSString *blue = [NSString stringWithFormat:@"%02x", b];
    
    
    NSString *str = [NSString stringWithFormat:@"0x%@%@%@", red, green, blue];
    unsigned long colorRGB = strtol([str UTF8String], NULL, 16);
    return colorRGB;
}
- (void)didReceiveMemoryWarning
{
    NSLog(@"ctrl====%@ didReceiveMemoryWarning",[self class]);
}
@end