//
//  LBFoodDetailViewController.m
//  WeatherApp
//
//  Created by ligui on 16/3/2.
//  Copyright © 2016年 ZhenzhenXu. All rights reserved.
//

#import "LBFoodDetailViewController.h"
#import "DayWeatherRequest.h"
#import "SVProgressHUD.h"
#import "SDWebImage/UIImageView+WebCache.h"
#define IMAGEURL @"http://tnfs.tngou.net/img"


@interface LBFoodDetailViewController ()<DayWeatherRequestDelegage,UIWebViewDelegate>
{
    DayWeatherRequest *_request;
    UIWebView *foodWebview;
}
@property (nonatomic, strong) NSString *foodDetailUrl;
@property (nonatomic, strong) UIProgressView *proView;
@property (nonatomic, strong) NSString *nameStr;
@property (nonatomic, strong) NSString *imgUrlStr;
@end

@implementation LBFoodDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = UIColorFromRGB(0xf0f0f0);
    self.navigationController.navigationBarHidden = YES;
    [self createNavBar];
    _request = [[DayWeatherRequest alloc] initRequest];
    _request.delegate = self;
    _request.requestUrl = @"http://apis.baidu.com/tngou/cook/show";//http://tnfs.tngou.net/img 1:1.5
    _request.requestParameter = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                 self.foodDetailId,@"id",nil];
    _request.requestType = @"foodListType";
    _request.requestMethod = @"get";
    [SVProgressHUD showWithMaskType:SVProgressHUDMaskTypeGradient];
    [_request createConnection];
    // Do any additional setup after loading the view.
}
- (void)createNavBar
{
    UIImageView *navImageView = [MyUtil createImageView:CGRectMake(0, 0, kScreenWidth, kNavigationBarAndStatusHeight) imageName:@"navBar"];
    navImageView.userInteractionEnabled = YES;
    
    UILabel *navLabel=[MyUtil createLabelFrame:CGRectMake(kScreenWidth/2-100, 22, 200, 40) title:@"菜品详情" font:CUSTOM_FONT(20)];
    navLabel.textAlignment=NSTextAlignmentCenter;
    navLabel.textColor=[UIColor whiteColor];
    [navImageView addSubview:navLabel];
    
    UIButton *navBtn=[MyUtil createBtnFrame:CGRectMake(10, 27, 33, 25) image:@"back_black" selectImage:nil highlightImage:nil target:self action:@selector(backBtnClick:)];
    [navImageView addSubview:navBtn];
    
    [self.view addSubview:navImageView];
}
- (void)dayWeatherRequestFinished:(NSDictionary *)data withError:(NSString *)error
{
    [SVProgressHUD dismiss];
    if (error) {
        [SVProgressHUD showErrorWithStatus:error];
    }else{
        NSLog(@"data===%@",data);
        self.foodDetailUrl = data[@"message"];
        self.nameStr = data[@"name"];
        self.imgUrlStr = [NSString stringWithFormat:@"%@%@",IMAGEURL,data[@"img"]];
        [self createFoodDetailView];
    }
}
- (void)createFoodDetailView
{
    UIScrollView *foodDetailScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, kNavigationBarAndStatusHeight, kScreenWidth, kScreenHeight-kNavigationBarAndStatusHeight)];
    [self.view addSubview:foodDetailScrollView];
    
    UILabel *nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, kScreenWidth-20, 30)];
    nameLabel.text = self.nameStr;
    nameLabel.font = CUSTOM_FONT(25);
    [foodDetailScrollView addSubview:nameLabel];
    
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(60, nameLabel.frame.origin.y+nameLabel.frame.size.height+10, kScreenWidth-120, (kScreenWidth-120)*1.5)];
    [imageView sd_setImageWithURL:[NSURL URLWithString:self.imgUrlStr] placeholderImage:[UIImage imageNamed:@"Default"]];
    [foodDetailScrollView addSubview:imageView];
    
    NSAttributedString * attrStr = [[NSAttributedString alloc] initWithData:[self.foodDetailUrl dataUsingEncoding:NSUnicodeStringEncoding] options:@{ NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType } documentAttributes:nil error:nil];
    UILabel *myLabel = [[UILabel alloc] init];
    myLabel.attributedText = attrStr;
    myLabel.numberOfLines = 0;
    myLabel.font = CUSTOM_FONT(15);
    CGFloat strHeight = [myLabel.attributedText boundingRectWithSize:CGSizeMake(kScreenWidth-20, CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin context:nil].size.height;
    myLabel.frame = CGRectMake(10, imageView.frame.origin.y+imageView.frame.size.height+10, kScreenWidth-20, strHeight+20);
    [foodDetailScrollView addSubview:myLabel];
    
    foodDetailScrollView.contentSize = CGSizeMake(kScreenWidth, myLabel.frame.origin.y+myLabel.frame.size.height);
}
- (void)backBtnClick:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
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
