//
//  LBMovieInformationViewController.m
//  WeatherApp
//
//  Created by ligui on 16/6/23.
//  Copyright © 2016年 ZhenzhenXu. All rights reserved.
//

#import "LBMovieInformationViewController.h"
#import "LBMovieListModel.h"
#import "LBMovieListTableViewCell.h"
#import "AFNetWorkingGetPostRequest.h"
#import "LBFooterRefreshView.h"
#import "SVProgressHUD.h"
#import <MJRefresh/MJRefresh.h>
#import "BasicView.h"
#define DOUBANMOVIEURL @"https://api.douban.com/v2/movie/top250?start="
@interface LBMovieInformationViewController ()<UITableViewDelegate,UITableViewDataSource,AFNetWorkingGetPostRequestDelegage>
@property (nonatomic, strong) UITableView *movieListView;
@property (nonatomic, strong) NSMutableArray *listDataArr;
@property (nonatomic, assign) NSInteger curPage;
@property (nonatomic, strong) AFNetWorkingGetPostRequest *request;
@end

@implementation LBMovieInformationViewController

- (void)viewDidLoad {
    self.navBarTitle = @"Top250";
    [super viewDidLoad];
    self.listDataArr = [[NSMutableArray alloc] init];
    self.curPage = 0;
    // Do any additional setup after loading the view.
    _request = [[AFNetWorkingGetPostRequest alloc] init];
    _request.delegate = self;
    [_request getRequestByUrl:[NSString stringWithFormat:@"%@%ld",DOUBANMOVIEURL,self.curPage] parameters:nil];
    [SVProgressHUD showWithMaskType:SVProgressHUDMaskTypeGradient];
    [self createTableView];
}
#pragma mark------------------AFNetWorkingGetPostRequestDelegage---------
- (void)requestFinished:(id)responseData withError:(NSError *)error
{
    [SVProgressHUD dismiss];
    NSLog(@"responseData=======%@,%@",responseData,[responseData class]);
    //    NSData *data = [responseData dataUsingEncoding:NSUTF8StringEncoding];
    //    NSError *reperror;
    //    NSArray *arr = (NSArray *)[NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&reperror];;
    //    NSLog(@"arr=======%@,data=======%@",arr,data);
    //    if (reperror) {
    //        NSLog(@"reperror======%@",reperror);
    //    }
    NSError *respError;
    NSData *data = [(NSString *)responseData dataUsingEncoding:NSUTF8StringEncoding];
    NSDictionary  *responseDict = (NSDictionary *)[NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&respError];
    NSLog(@"responseDict=========%@",responseDict);
    if (respError||!responseDict) {
        NSLog(@"respError======%@",respError);
        return;
    }
    [_movieListView.mj_footer endRefreshing];
    for (NSDictionary *dict in responseDict[@"subjects"]) {
        LBMovieListModel *sModel = [[LBMovieListModel alloc] init];
        [sModel setValuesForKeysWithDictionary:dict];
        [self.listDataArr addObject:sModel];
    }
    [self.movieListView reloadData];
    
}
- (void)createTableView
{
    _movieListView = [[UITableView alloc] initWithFrame:CGRectMake(0, kNavigationBarAndStatusHeight, kScreenWidth, kScreenHeight-kNavigationBarAndStatusHeight) style:UITableViewStyleGrouped];
    _movieListView.delegate = self;
    _movieListView.dataSource = self;
    [self.view addSubview:_movieListView];
    
    _movieListView.mj_footer = [LBFooterRefreshView footerWithRefreshingBlock:^{
        self.curPage+=20;
        [_request getRequestByUrl:[NSString stringWithFormat:@"%@%ld",DOUBANMOVIEURL,self.curPage] parameters:nil];
        [SVProgressHUD showWithMaskType:SVProgressHUDMaskTypeGradient];
    }];
}
#pragma mark------------------UITableViewDelegate---------
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _listDataArr.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 100;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.001;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0.001;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellID = @"movieListCell";
    LBMovieListTableViewCell *songCell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (!songCell) {
        songCell = [[LBMovieListTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
    }
    songCell.backgroundColor = [UIColor clearColor];
    songCell.selectionStyle = UITableViewCellSelectionStyleNone;
    [songCell setCellData:self.listDataArr[indexPath.row]];
    return songCell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    LBMovieListModel *sModel = (LBMovieListModel *)self.listDataArr[indexPath.row];
    
    BasicView *basicView = [[BasicView alloc]initWithFrame:self.view.bounds];
    basicView.imageUrl = sModel.images[@"large"];
    basicView.center = self.view.center;
    basicView.userInteractionEnabled = YES;
    basicView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:basicView];
    [basicView show];
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
