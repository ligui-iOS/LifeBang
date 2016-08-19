//
//  LBTravelNotesListViewController.m
//  WeatherApp
//
//  Created by ligui on 16/6/23.
//  Copyright © 2016年 ZhenzhenXu. All rights reserved.
//

#import "LBTravelNotesListViewController.h"
#import "DayWeatherRequest.h"
#import "SVProgressHUD.h"
#import "RGCardViewLayout.h"
#import <MJRefresh/MJRefresh.h>
#import "LBFooterRefreshView.h"
#import "LBTravelNotesCollectionViewCell.h"
#import "LBOnePageWebviewViewController.h"

@interface LBTravelNotesListViewController ()<DayWeatherRequestDelegage,UICollectionViewDelegate,UICollectionViewDataSource>
{
    DayWeatherRequest *_request;
}
@property (nonatomic, assign) NSInteger curPage;
@property (nonatomic, strong) NSString *queryStr;
@property (nonatomic, strong) NSMutableArray *notesListDataArr;
@property (nonatomic, strong) UICollectionView *notesCollectionView;
@property (nonatomic, assign) NSInteger totalNotesData;
@end

@implementation LBTravelNotesListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.curPage = 1;
    self.queryStr = @"";
    _notesListDataArr = [[NSMutableArray alloc] init];
    [self getTravelNotesListData];
    [self createCollectionView];
    // Do any additional setup after loading the view.
}
- (void)getTravelNotesListData
{
    _request = [[DayWeatherRequest alloc] initRequest];
    _request.delegate = self;
    _request.requestUrl = @"http://apis.baidu.com/qunartravel/travellist/travellist";
    _request.requestParameter = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                 [NSString stringWithFormat:@"%ld",self.curPage],@"page",
                                 self.queryStr,@"query", nil];
    _request.requestType = @"travelNotes";
    _request.requestMethod = @"GET";
    [SVProgressHUD showWithMaskType:SVProgressHUDMaskTypeGradient];
    [_request createConnection];
}
- (void)createCollectionView
{
    RGCardViewLayout *layout = [[RGCardViewLayout alloc] init];
    self.notesCollectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, kNavigationBarAndStatusHeight, kScreenWidth, kScreenHeight-kNavigationBarAndStatusHeight) collectionViewLayout:layout];
    self.notesCollectionView.dataSource = self;
    self.notesCollectionView.delegate = self;
    self.notesCollectionView.backgroundColor = UIColorFromRGB(0xf0f0f0);
    self.notesCollectionView.showsHorizontalScrollIndicator = NO;
    [self.notesCollectionView registerClass:[LBTravelNotesCollectionViewCell class] forCellWithReuseIdentifier:@"LBTravelNotesCollectionViewCell"];
    //    [self.LBCollectionView registerNib:[UINib nibWithNibName:@"LBCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"LBCollectionViewCell"];
    [self.view addSubview:self.notesCollectionView];
}
#pragma mark UICollectionViewDataSource
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return _notesListDataArr.count;
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return 1;
    NSLog(@"_foodListArr.count==%ld",_notesListDataArr.count);
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    LBTravelNotesCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"LBTravelNotesCollectionViewCell" forIndexPath:indexPath];
    cell.backgroundColor = [UIColor whiteColor];
    cell.layer.masksToBounds = YES;
    cell.layer.cornerRadius = 5;
    [cell setCellData:self.notesListDataArr[indexPath.section]];
    return cell;
}
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    LBOnePageWebviewViewController *ctrl = [[LBOnePageWebviewViewController alloc] init];
    ctrl.navBarTitle = @"旅行日志详情";
    LBTravelNotesModel *nModel = (LBTravelNotesModel *)self.notesListDataArr[indexPath.section];
    ctrl.oneWebviewUrl = nModel.bookUrl;
    [self.navigationController pushViewController:ctrl animated:YES];
}
#pragma mark --------------------DayWeatherRequestDelegage--------------
- (void)dayWeatherRequestFinished:(NSDictionary *)data withError:(NSString *)error
{
    [SVProgressHUD dismiss];
    if (error) {
        [SVProgressHUD showErrorWithStatus:error];
    }else{
        NSLog(@"data===%@",data);
        if ([_request.requestType isEqualToString:@"travelNotes"]) {
            NSDictionary *dict = data[@"data"];
            if (dict&&![dict isEqual:@""]) {
                self.totalNotesData = [dict[@"count"] integerValue];
                for (NSDictionary *dic in dict[@"books"]) {
                    LBTravelNotesModel *nModel = [[LBTravelNotesModel alloc] init];
                    [nModel setValuesForKeysWithDictionary:dic];
                    [_notesListDataArr addObject:nModel];
                }
                [_notesCollectionView reloadData];
            }
        }
    }
}
#pragma mark - UIScrollViewDelegate Methods
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    //    [refreshTableHeaderView egoRefreshScrollViewDidScroll:scrollView];
    
    if (_notesCollectionView.contentOffset.x == _notesCollectionView.contentSize.width-_notesCollectionView.frame.size.width) {
        if (self.totalNotesData%10 == 0) {
            if (self.curPage < self.totalNotesData/10) {
                self.curPage++;
            }else {
                return;
            }
        }else {
            if (self.curPage < self.totalNotesData/10+1) {
                self.curPage++;
            }else {
                return;
            }
        }
        [self getTravelNotesListData];
    }
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
