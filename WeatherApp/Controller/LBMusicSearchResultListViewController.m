//
//  LBMusicSearchResultListViewController.m
//  WeatherApp
//
//  Created by ligui on 16/6/20.
//  Copyright © 2016年 ZhenzhenXu. All rights reserved.
//

#import "LBMusicSearchResultListViewController.h"
#import "AFNetWorkingGetPostRequest.h"
#import "LBSongModel.h"
#import "LBSongListTableViewCell.h"
#import "LBMusicPlayViewController.h"
#import "YGGravityImageView.h"
#define BAIDUMUSICURL @"http://tingapi.ting.baidu.com/v1/restserver/ting"

@interface LBMusicSearchResultListViewController ()<AFNetWorkingGetPostRequestDelegage,UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong) NSMutableArray *listDataArr;
@property (nonatomic, strong) UITableView *songTableView;
@end

@implementation LBMusicSearchResultListViewController

- (void)viewDidLoad {
    self.navBarTitle = @"搜索结果";
    [super viewDidLoad];
    self.view.backgroundColor = UIColorFromRGB(0x366361);
    self.listDataArr = [[NSMutableArray alloc] init];
    NSLog(@"self.searchResultStr========%@",self.searchResultStr);
    // Do any additional setup after loading the view.
    AFNetWorkingGetPostRequest *request = [[AFNetWorkingGetPostRequest alloc] init];
    request.delegate = self;
    [request getRequestByUrl:BAIDUMUSICURL parameters:[NSMutableDictionary dictionaryWithObjectsAndKeys: @"webapp_music",@"from",
                                                       @"baidu.ting.search.catalogSug",@"method",
                                                       @"json",@"format",
                                                       @"",@"callback",
                                                       [self removeSpecialSymbolFromStr:self.searchResultStr],@"query",
                                                       @"1413017198449",@"_",
                                                       nil]];
    [self createTableView];
}
- (void)createTableView
{
    _songTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, kNavigationBarAndStatusHeight, kScreenWidth, kScreenHeight-kNavigationBarAndStatusHeight) style:UITableViewStyleGrouped];
    UIImageView *bgImageView = [[UIImageView alloc] initWithFrame:_songTableView.frame];
    bgImageView.image = [UIImage imageNamed:@"music_backgound"];
    _songTableView.backgroundView = bgImageView;
    _songTableView.delegate = self;
    _songTableView.dataSource = self;
    [self.view addSubview:_songTableView];
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
    return 60;
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
    static NSString *cellID = @"songListCell";
    LBSongListTableViewCell *songCell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (!songCell) {
        songCell = [[LBSongListTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
    }
    songCell.selectionStyle = UITableViewCellSelectionStyleNone;
    songCell.keyWordStr = [self removeSpecialSymbolFromStr:self.searchResultStr];
    songCell.backgroundColor = [UIColor clearColor];
    [songCell setCellData:self.listDataArr[indexPath.row]];
    return songCell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    LBMusicPlayViewController *ctrl = [[LBMusicPlayViewController alloc] init];
    LBSongModel *sModel = _listDataArr[indexPath.row];
    ctrl.songIdStr = sModel.songid;
    ctrl.navBarTitle = sModel.songname;
    [self.navigationController pushViewController:ctrl animated:YES];
}
#pragma mark------------------AFNetWorkingGetPostRequestDelegage---------
- (void)requestFinished:(id)responseData withError:(NSError *)error
{
    NSLog(@"responseData=======%@,%@",responseData,[responseData class]);
    //    NSData *data = [responseData dataUsingEncoding:NSUTF8StringEncoding];
    //    NSError *reperror;
    //    NSArray *arr = (NSArray *)[NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&reperror];;
    //    NSLog(@"arr=======%@,data=======%@",arr,data);
    //    if (reperror) {
    //        NSLog(@"reperror======%@",reperror);
    //    }
    NSError *respError;
    NSMutableString *mRepStr = [[NSMutableString alloc] initWithString:(NSString *)responseData];
    [mRepStr deleteCharactersInRange:NSMakeRange(mRepStr.length-2, 2)];
    [mRepStr deleteCharactersInRange:NSMakeRange(0, 1)];
    NSLog(@"mRepStr=====%@",mRepStr);
    NSData *data = [mRepStr dataUsingEncoding:NSUTF8StringEncoding];
    NSDictionary  *responseDict = (NSDictionary *)[NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&respError];
    NSLog(@"responseDict=========%@",responseDict);
    if (respError||!responseDict) {
        NSLog(@"respError======%@",respError);
        return;
    }
    for (NSDictionary *dict in responseDict[@"song"]) {
        LBSongModel *sModel = [[LBSongModel alloc] init];
        [sModel setValuesForKeysWithDictionary:dict];
        [self.listDataArr addObject:sModel];
    }
    [self.songTableView reloadData];
    
}
- (NSString *)removeSpecialSymbolFromStr:(NSString *)str
{
    NSCharacterSet *set = [NSCharacterSet characterSetWithCharactersInString:@"@／：；（）¥「」＂、[]{}#%-*+=_\\|~＜＞$€^•'@#$%^&*()_+'\"。“”，"];
    return [str stringByTrimmingCharactersInSet:set];
}
-(UIImage *)imageResize :(UIImage*)img andResizeTo:(CGSize)newSize
{
    CGFloat scale = [[UIScreen mainScreen] scale];
    
    //UIGraphicsBeginImageContext(newSize);
    UIGraphicsBeginImageContextWithOptions(newSize, NO, scale);
    [img drawInRect:CGRectMake(0,0,newSize.width,newSize.height)];
    UIImage* newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
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
 }
*/

@end
