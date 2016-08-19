//
//  LBFoodListViewController.m
//  WeatherApp
//
//  Created by ligui on 16/2/28.
//  Copyright © 2016年 ZhenzhenXu. All rights reserved.
//

#import "LBFoodListViewController.h"
#import "SMVerticalSegmentedControl.h"
#import "DayWeatherRequest.h"
#import "SVProgressHUD.h"
#import "LBFoodListModel.h"
#import "LBCollectionViewCell.h"
#import "MyLayout.h"
#import "LBFoodDetailViewController.h"
#import "UIPopoverListView.h"
#import <TencentOpenAPI/QQApiInterfaceObject.h>
#import <TencentOpenAPI/QQApiInterface.h>
#import "WXApi.h"
#import <MJRefresh/MJRefresh.h>
#import "LBFooterRefreshView.h"

@interface LBFoodListViewController ()<DayWeatherRequestDelegage,UICollectionViewDataSource,UICollectionViewDelegate,MyLayoutDelegate,UIPopoverListViewDataSource, UIPopoverListViewDelegate>
{
    SMVerticalSegmentedControl *foodListSegCtrl;
    DayWeatherRequest *_request;
}
@property (nonatomic,strong)NSMutableArray *foodListArr;
@property (nonatomic,strong)NSMutableArray *listDataArr;
@property (nonatomic,strong)NSMutableArray *listIdArr;
@property (nonatomic,strong)UICollectionView *LBCollectionView;
@property (nonatomic,assign)NSInteger curPage;
@property (nonatomic,strong)NSString *curFoodId;
@property (nonatomic,assign)NSInteger totalFoodData;
@end

@implementation LBFoodListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.curPage = 1;
    self.navigationController.navigationBarHidden = YES;
    _listDataArr = [NSMutableArray array];
    _foodListArr = [NSMutableArray array];
    _listIdArr = [NSMutableArray array];
    [self createNavBar];
    _request = [[DayWeatherRequest alloc] initRequest];
    _request.delegate = self;
//    _request.requestUrl = @"http://apis.baidu.com/tngou/cook/classify";//http://tnfs.tngou.net/img 1:1.5
//    _request.requestParameter = nil;
//    _request.requestType = @"foodListType";
//    _request.requestMethod = @"get";
//    [SVProgressHUD showWithMaskType:SVProgressHUDMaskTypeGradient];
//    [_request createConnection];
    [self toDownloadDataFromUrl:@"http://apis.baidu.com/tngou/cook/classify" parameter:nil type:@"foodListType" method:@"get"];
    [self createCollectionView];
    // Do any additional setup after loading the view.
}
- (void)toDownloadDataFromUrl:(NSString *)urlStr parameter:(NSMutableDictionary *)dict type:(NSString *)typeStr method:(NSString *)methodStr
{
    _request.requestUrl = urlStr;//http://tnfs.tngou.net/img 1:1.5
    _request.requestParameter = dict;
    _request.requestType = typeStr;
    _request.requestMethod = methodStr;
    [SVProgressHUD showWithMaskType:SVProgressHUDMaskTypeGradient];
    [_request createConnection];
}
- (void)createSegmentView
{
    foodListSegCtrl=[[SMVerticalSegmentedControl alloc] initWithSectionTitles:_listDataArr];
    foodListSegCtrl.backgroundColor = UIColorFromRGB(0xecf0f1);
    foodListSegCtrl.selectionStyle = SMVerticalSegmentedControlSelectionStyleBox;
    [foodListSegCtrl setFrame:CGRectMake(0, kNavigationBarAndStatusHeight, 40,kScreenHeight-kNavigationBarAndStatusHeight)];
//    __block LBFoodListViewController *blockSelf = self;
    __block NSMutableArray *blockArr = _listIdArr;
    __block LBFoodListViewController *blockFoodList = self;
    foodListSegCtrl.indexChangeBlock = ^(NSInteger index) {
//        listRequest.delegate = blockSelf;
//        listRequest.requestUrl = @"http://apis.baidu.com/tngou/cook/list";//http://tnfs.tngou.net/img 1:1.5
//        listRequest.requestParameter = [NSMutableDictionary dictionaryWithObjectsAndKeys:
//                                        blockArr[index],@"id",
//                                        @"1",@"page",
//                                        @"10",@"rows", nil];
//        listRequest.requestMethod = @"get";
//        listRequest.requestType = @"foodList";
//        [SVProgressHUD showWithMaskType:SVProgressHUDMaskTypeGradient];
//        [listRequest createConnection];
        [blockFoodList toDownloadDataFromUrl:@"http://apis.baidu.com/tngou/cook/list" parameter:[NSMutableDictionary dictionaryWithObjectsAndKeys:
                                                                                        blockArr[index],@"id",
                                                                                        @"1",@"page",
                                                                                        @"10",@"rows", nil] type:@"foodList" method:@"get"];
        blockFoodList.curPage = 1;
        blockFoodList.curFoodId = blockArr[index];
//        blockSelf = nil;
//        blockArr = nil;
//        listRequest = nil;
    };
    [self.view addSubview:foodListSegCtrl];
    [self toDownloadDataFromUrl:@"http://apis.baidu.com/tngou/cook/list" parameter:[NSMutableDictionary dictionaryWithObjectsAndKeys:
                                                                                    [_listIdArr firstObject],@"id",
                                                                                    @"1",@"page",
                                                                                    @"10",@"rows", nil] type:@"foodList" method:@"get"];
    self.curFoodId = [_listIdArr firstObject];
}
- (void)createNavBar
{
    UIImageView *navImageView = [MyUtil createImageView:CGRectMake(0, 0, kScreenWidth, kNavigationBarAndStatusHeight) imageName:@"navBar"];
    navImageView.userInteractionEnabled = YES;
    
    UILabel *navLabel=[MyUtil createLabelFrame:CGRectMake(kScreenWidth/2-100, 22, 200, 40) title:@"食谱" font:CUSTOM_FONT(20)];
    navLabel.textAlignment=NSTextAlignmentCenter;
    navLabel.textColor=[UIColor whiteColor];
    [navImageView addSubview:navLabel];
    
    UIButton *navBtn=[MyUtil createBtnFrame:CGRectMake(10, 27, 33, 25) image:@"back_black" selectImage:nil highlightImage:nil target:self action:@selector(backBtnClick:)];
    [navImageView addSubview:navBtn];
    
    NSString *btnStr = @"分享一下";
    CGFloat btnWith = [LBTool getWidthBoundingRectWithSize:btnStr height:20 fontSize:15];
    UIButton *rightNavBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    rightNavBtn.frame = CGRectMake(kScreenWidth-btnWith-10, 32, btnWith+2, 20);
    [rightNavBtn setTitle:btnStr forState:UIControlStateNormal];
    [rightNavBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    rightNavBtn.titleLabel.font = CUSTOM_FONT(15);
    [rightNavBtn addTarget:self action:@selector(rightNavBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [navImageView addSubview:rightNavBtn];
    
    [self.view addSubview:navImageView];
}
- (void)dayWeatherRequestFinished:(NSDictionary *)data withError:(NSString *)error
{
    [SVProgressHUD dismiss];
    if (error) {
        [SVProgressHUD showErrorWithStatus:error];
    }else{
        NSLog(@"data===%@",data);
        if ([_request.requestType isEqualToString:@"foodListType"]) {
            for (NSDictionary *dict in data[@"tngou"]) {
                [_listDataArr addObject:dict[@"title"]];
                [_listIdArr addObject:[NSString stringWithFormat:@"%@",dict[@"id"]]];
            }
            [self createSegmentView];
        }else if ([_request.requestType isEqualToString:@"foodList"]){
            NSLog(@"foodlist");
            if (_foodListArr.count>1) {
                if (self.curPage == 1) {
                    [_foodListArr removeAllObjects];
                }else {
                    [self.LBCollectionView.mj_footer endRefreshing];
                }
            }
            self.totalFoodData = [data[@"total"] integerValue];
            for (NSDictionary *dict in data[@"tngou"]) {
                LBFoodListModel *lbModel = [[LBFoodListModel alloc] init];
                [lbModel setValuesForKeysWithDictionary:dict];
                [_foodListArr addObject:lbModel];
            }
            [self.LBCollectionView reloadData];
        }
    }
}
- (void)createCollectionView
{
    MyLayout *layout = [[MyLayout alloc] initWithSectionInsets:UIEdgeInsetsMake(10, 10, 10, 10) itemSpacing:10 lineSpacing:10];
    layout.delegate = self;
    self.LBCollectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(40, kNavigationBarAndStatusHeight, kScreenWidth-40, kScreenHeight-kNavigationBarAndStatusHeight) collectionViewLayout:layout];
    self.LBCollectionView.dataSource = self;
    self.LBCollectionView.delegate = self;
    self.LBCollectionView.backgroundColor = UIColorFromRGB(0xf0f0f0);
    [self.LBCollectionView registerClass:[LBCollectionViewCell class] forCellWithReuseIdentifier:@"LBCollectionViewCell"];
//    [self.LBCollectionView registerNib:[UINib nibWithNibName:@"LBCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"LBCollectionViewCell"];
    [self.view addSubview:self.LBCollectionView];
    
    self.LBCollectionView.mj_footer = [LBFooterRefreshView footerWithRefreshingBlock:^{
        [self loadMoreFoodListData];
    }];
}
#pragma mark UICollectionViewDataSource
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return _foodListArr.count;
    NSLog(@"_foodListArr.count==%ld",_foodListArr.count);
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    LBCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"LBCollectionViewCell" forIndexPath:indexPath];
    cell.backgroundColor = [UIColor whiteColor];
    cell.layer.masksToBounds = YES;
    cell.layer.cornerRadius = 5;
    [cell setCellData:self.foodListArr[indexPath.item]];
    return cell;
}
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    LBFoodListModel *model = self.foodListArr[indexPath.item];
    LBFoodDetailViewController *ctrl = [[LBFoodDetailViewController alloc] init];
    ctrl.foodDetailId = [NSString stringWithFormat:@"%@",model.FoodId];
    [self.navigationController pushViewController:ctrl animated:YES];
}
#pragma mark MyLayoutDelegate
- (CGFloat)heightAtindexPath:(NSIndexPath *)indexPath
{
    LBFoodListModel *model = self.foodListArr[indexPath.item];
    CGFloat descHeight = [LBTool getHeightBoundingRectWithSize:model.foodDescription width:(kScreenWidth-70)/2 fontSize:11]+5;
    return ((kScreenWidth-70)*1.5)/2+20+descHeight;
}
- (void)backBtnClick:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)rightNavBtnClick:(id)sender
{
    CGFloat xWidth = self.view.bounds.size.width - 20.0f;
    CGFloat yHeight = 272.0f;
    CGFloat yOffset = (self.view.bounds.size.height - yHeight)/2.0f;
    UIPopoverListView *poplistview = [[UIPopoverListView alloc] initWithFrame:CGRectMake(10, yOffset, xWidth, yHeight)];
    poplistview.delegate = self;
    poplistview.datasource = self;
    poplistview.listView.scrollEnabled = FALSE;
    [poplistview setTitle:@"分享至："];
    [poplistview show];
}
#pragma mark - UIPopoverListViewDataSource

- (UITableViewCell *)popoverListView:(UIPopoverListView *)popoverListView
                    cellForIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier = @"cell";
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                                    reuseIdentifier:identifier];
    
    NSInteger row = indexPath.row;
    cell.textLabel.font = CUSTOM_FONT(20);
    cell.imageView.frame = CGRectMake(10, 10, 40, 40);
    NSArray *titleArr = @[@"QQ",@"QQ空间",@"微信",@"微信朋友圈"];
    NSArray *iconArr = @[@"shareview_qq",@"shareview_qzone",@"shareview_weixin",@"shareview_weixinfriends"];
    cell.textLabel.text = titleArr[row];
    
    
    UIImage *icon = [UIImage imageNamed:iconArr[row]];
    CGSize itemSize = CGSizeMake(40, 40);
    UIGraphicsBeginImageContextWithOptions(itemSize, NO, 0.0);
    CGRect imageRect = CGRectMake(0.0, 0.0, itemSize.width, itemSize.height);
    [icon drawInRect:imageRect];
    cell.imageView.image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();

//    if(row == 0){
//        cell.textLabel.text = @"QQ";
//        cell.imageView.image = [UIImage imageNamed:@"shareview_qq"];
//    }else if (row == 1){
//        cell.textLabel.text = @"QQ空间";
//        cell.imageView.image = [UIImage imageNamed:@"shareview_qzone"];
//    }else if (row == 2){
//        cell.textLabel.text = @"微信";
//        cell.imageView.image = [UIImage imageNamed:@"shareview_weixin"];
//    }else {
//        cell.textLabel.text = @"微信朋友圈";
//        cell.imageView.image = [UIImage imageNamed:@"shareview_weixinfriends"];
//    }
    
    return cell;
}
- (NSInteger)popoverListView:(UIPopoverListView *)popoverListView
       numberOfRowsInSection:(NSInteger)section
{
    return 4;
}

#pragma mark - UIPopoverListViewDelegate
- (void)popoverListView:(UIPopoverListView *)popoverListView
     didSelectIndexPath:(NSIndexPath *)indexPath
{
    UIImage *image = [UIImage imageNamed:@"Icon-57"];
    NSArray *shareArr = @[@"生活邦",@"看看天气\n看看适合今天干什么\n看看能吃点什么\n……\n那就先这样吧",@"https://itunes.apple.com/us/app/sheng-huo-bang-lifebang/id1090309328?l=zh&ls=1&mt=8",image];
    if(indexPath.row == 0){
        [self shareToQQ:NO andArray:shareArr];
    }else if (indexPath.row == 1){
        [self shareToQQ:YES andArray:shareArr];
    }else if (indexPath.row == 2){
        [self shareToWeiXin:NO andArray:shareArr];
    }else {
        [self shareToWeiXin:YES andArray:shareArr];
    }
}

- (CGFloat)popoverListView:(UIPopoverListView *)popoverListView
   heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60.0f;
}
- (void)shareToQQ:(BOOL)isToQzone andArray:(NSArray *)arr
{
    NSString *utf8String = arr[2];
    NSString *description = arr[1];
    
    NSData *imageData = UIImagePNGRepresentation(arr[3]);;
    QQApiURLObject *newsObj = [QQApiURLObject objectWithURL:[NSURL URLWithString:utf8String] title:arr[0] description:description previewImageData:imageData targetContentType:QQApiURLTargetTypeNews];
    if (isToQzone) {
        [newsObj setCflag:kQQAPICtrlFlagQZoneShareOnStart];
    }
    SendMessageToQQReq *req = [SendMessageToQQReq reqWithContent:newsObj];
    QQApiSendResultCode qqResp = [QQApiInterface sendReq:req];
    NSLog(@"qqResp============%d",qqResp);
}
- (void)shareToWeiXin:(BOOL)isToSceneTimeline andArray:(NSArray *)arr
{
    WXMediaMessage *message = [WXMediaMessage message];
    message.title = arr[0];
    message.description = arr[1];
    [message setThumbImage:arr[3]];
    
    WXWebpageObject *ext = [WXWebpageObject object];
    ext.webpageUrl = arr[2];
    
    message.mediaObject = ext;
    
    SendMessageToWXReq* req = [[SendMessageToWXReq alloc] init];
    req.bText = NO;
    req.message = message;
    if (isToSceneTimeline) {
        req.scene = WXSceneTimeline;
    }else{
        req.scene = WXSceneSession;
    }
    
    [WXApi sendReq:req];
}
- (void)loadMoreFoodListData
{
    if (self.totalFoodData%10 == 0) {
        if (self.curPage < self.totalFoodData/10) {
            self.curPage++;
        }else {
            return;
        }
    }else {
        if (self.curPage < self.totalFoodData/10+1) {
            self.curPage++;
        }else {
            return;
        }
    }
    [self toDownloadDataFromUrl:@"http://apis.baidu.com/tngou/cook/list" parameter:[NSMutableDictionary dictionaryWithObjectsAndKeys:
                                                                                    self.curFoodId,@"id",
                                                                                    [NSString stringWithFormat:@"%ld",self.curPage],@"page",
                                                                                    @"10",@"rows", nil] type:@"foodList" method:@"get"];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
@end
