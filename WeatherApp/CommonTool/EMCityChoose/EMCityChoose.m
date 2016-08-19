//
//  EMCityChoose.m
//  CityChoose
//
//  Created by Eric MiAo on 15/8/26.
//  Copyright (c) 2015年 Eric MiAo. All rights reserved.
//

#import "EMCityChoose.h"
#import "EMCurrentCell.h"
#import "EMHotCitysCell.h"
#import "EMSearchCell.h"


@interface EMCityChoose ()<UISearchBarDelegate,UISearchDisplayDelegate>
{
    NSMutableDictionary *_dataSource;
    NSMutableArray *_titleArray;
    NSString *_chooseCity;
    UITableView *_aCityList;
    NSString *_currentCity;
    NSArray *_hotCitys;
    float _zoomHight;
    float _pointY;
    NSString *_theHotCityName;
    BOOL _hide;
    UISearchBar *_searchBar;
    UISearchDisplayController   *_display;
    NSMutableArray *_resualtArray;
    NSMutableArray *_citiesArray;
    EMCurrentCell *currentCityCell;
}
@property (nonatomic)cityListType cityListType;
@end


@implementation EMCityChoose

- (id)initWithPointY:(float)pointY buttonTitleCityName:(NSString *)aCityName hotCity:(NSArray *)theHotCitys cityType:(cityListType)cityListType hideSearchBar:(BOOL)hide{
    self = [super init];
    if (self) {
        self.view.frame = CGRectMake(0, pointY-5, SCREEN_WIDTH,0);
        self.view.backgroundColor = UIColorFromRGB(0xfdc257);
        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(methodOfNotification:) name:@"cityNameNotification" object:nil];
        _currentCity = aCityName;
        _hotCitys = theHotCitys;
        _pointY = pointY;
        _hide = hide;
        self.cityListType = cityListType;
        [[NSUserDefaults standardUserDefaults]setValue:_hotCitys forKey:@"hotCityName"];
        self.isShow = YES;
        [self startView:_pointY];
        NSString *countOfHotCity = [NSString stringWithFormat:@"%ld",(unsigned long)theHotCitys.count];
        [[NSUserDefaults standardUserDefaults]setValue:countOfHotCity forKey:@"hotCityNumber"];
        _titleArray = [[NSMutableArray alloc]init];
        for (int i = 0; i<26; i ++) {
            if (i==8||i==14||i==20||i==21) {
                continue;
            }
            NSString *theCityKey = [NSString stringWithFormat:@"%c",i+65];
            [_titleArray addObject:theCityKey];
        }
    }
    return self;
}

- (void)methodOfNotification:(NSNotification *)aNoti {
    NSDictionary *dic = aNoti.userInfo;
    
    _theHotCityName = [_hotCitys objectAtIndex:[[dic objectForKey:@"tag"] integerValue]];
    [self closeView];
}

- (void)startView:(float)viewPointY {
    
    CGRect rect = self.view.frame;
    rect.size.height += SCREEN_HIGHT - viewPointY;
    rect.origin.y += 5;
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.2];
    self.view.frame = rect;
    [UIView commitAnimations];
    [self setTableView];
    _zoomHight = rect.size.height;
    
}

- (void)closeView {
    self.isShow = NO;
    CGRect rect = self.view.frame;
    rect.size.height -= _zoomHight;
    rect.origin.y -= 5;
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.2];
    self.view.frame = rect;
    _aCityList.alpha = 0;
    
    [UIView commitAnimations];
    [self performSelector:@selector(removeView) withObject:self afterDelay:0.5];
    if ([_delegate respondsToSelector:@selector(stopDisplay:)]) {
        [_delegate stopDisplay:self];
    }
}

- (void)removeView {
    [self removeFromParentViewController];
    [self.view removeFromSuperview];
}

- (void)setTableView {
    NSString *path;
    if (self.cityListType == cityListTypeShortType) {
        path = [[NSBundle mainBundle]pathForResource:@"EMcitydict_S" ofType:@"plist"];
    }else {
        path = [[NSBundle mainBundle]pathForResource:@"EMcitydict" ofType:@"plist"];
    }
    
    _dataSource = [NSMutableDictionary dictionaryWithContentsOfFile:path];
    
    CGRect rect = self.view.frame;
    _aCityList = [[UITableView alloc]initWithFrame:CGRectMake(5, 5, rect.size.width-10, rect.size.height-10) style:UITableViewStylePlain];
    [_aCityList registerClass:[EMCurrentCell class] forCellReuseIdentifier:@"currentCityCell"];
    [_aCityList registerClass:[EMHotCitysCell class] forCellReuseIdentifier:@"hotCell"];
    [_aCityList registerClass:[EMSearchCell class] forCellReuseIdentifier:@"SearchCell"];
    
    _aCityList.bounces = NO;
    _aCityList.backgroundColor = [UIColor clearColor];
    _aCityList.delegate = self;
    _aCityList.dataSource = self;
    _aCityList.showsVerticalScrollIndicator = NO;
    _resualtArray = [[NSMutableArray alloc]init];
    _citiesArray = [[NSMutableArray alloc]init];
    
    NSArray *allCityKeys = [_dataSource allKeys];
    for (int i =0 ; i < 22; i++) {
        [_citiesArray addObjectsFromArray:[_dataSource objectForKey:[allCityKeys objectAtIndex:i]]];
    }
    
    _searchBar = [[UISearchBar alloc]init];
    _searchBar.placeholder = @"输入城市名或拼音";
    _searchBar.backgroundColor = [UIColor clearColor];
    _searchBar.delegate = self;
    _searchBar.barTintColor = [UIColor colorWithRed:233/255.0 green:233/255.0 blue:233/255.0 alpha:1];
    
    _display = [[UISearchDisplayController alloc] initWithSearchBar:_searchBar contentsController:self];
    _display.delegate = self;
    _display.searchResultsDataSource = self;
    _display.searchResultsDelegate = self;
    _searchBar.frame = CGRectMake(0, 0, SCREEN_WIDTH-25, 40);
    UIView *aView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 40)];
    [aView addSubview:_searchBar];
    
    if (_hide) {
        
    }else {
        _aCityList.tableHeaderView = aView;
    }
    [self.view addSubview:_aCityList];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    if (_hide) {
        NSArray *array = _dataSource.allKeys;
        return [array count]+3;
    }else {
        if (tableView == _aCityList) {
            NSArray *array = _dataSource.allKeys;
            return [array count]+4;
        }else {
            return 1;
        }
    }
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    if (_hide) {
        if (section == 0) {
            return [NSString stringWithFormat:@"当前城市"];
        }
        if (section == 1) {
            return [NSString stringWithFormat:@"热门城市"];
        }
        if (section == 2) {
            return [NSString stringWithFormat:@"其他城市"];
        }
        else {
            return [_titleArray objectAtIndex:section-3];
        }
    }else {
        if (tableView == _aCityList) {
            if (section == 0||section == 1) {
                return nil;
            }
            if (section == 2) {
                return [NSString stringWithFormat:@"热门城市"];
            }
            if (section == 3) {
                return nil;
            }
            else {
                return [_titleArray objectAtIndex:section-4];
            }
        }else {
            return nil;
        }
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (_hide) {
        return 30;
    }else {
        if (tableView == _aCityList) {
            if (section > 3||section == 2) {
                return 30;
            }else {
                return 0.01;
            }
        }else {
            return 0.01;
        }
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (_hide) {
        switch (section) {
            case 0:
                return 1;
                break;
            case 1:
                return 1;
                break;
            case 2:
                return 0;
                break;
            default:
                break;
        }
        if (section > 2) {
            NSString *theCityKey = [_titleArray objectAtIndex:section-3];
            NSArray *array = [_dataSource objectForKey:theCityKey];
            return [array count];
        }else {
            return 0;
        }
    }else {
        if (tableView == _aCityList) {
            switch (section) {
                case 0:
                    return 1;
                    break;
                case 1:
                    return 1;
                    break;
                case 2:
                    return 1;
                    break;
                case 3:
                    return 0;
                    break;
                default:
                    break;
            }
            if (section > 3) {
                NSString *theCityKey = [_titleArray objectAtIndex:section-4];
                NSArray *array = [_dataSource objectForKey:theCityKey];
                return [array count];
            }else {
                return 0;
            }
        }else {
            return _resualtArray.count;
        }
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (_hide) {
        NSInteger numberofHotCity = _hotCitys.count;
        if (SCREEN_WIDTH == 320) {
            if (indexPath.section == 0) {
                return 55;
            }else if (indexPath.section == 1) {
                return ((numberofHotCity-1)/3 +1)*45 + 10;
            }else if (indexPath.section == 2) {
                return 0;
            }else {
                return 40;
            }
        }else if (SCREEN_WIDTH == 375) {
            if (indexPath.section == 0) {
                return 60;
            }else if (indexPath.section == 1) {
                return ((numberofHotCity-1)/3 +1)*50 + 10;
            }else if (indexPath.section == 2) {
                return 0;
            }else {
                return 40;
            }
        }else {
            if (indexPath.section == 0) {
                return 70;
            }else if (indexPath.section == 1) {
                return ((numberofHotCity-1)/3 +1)*60 + 10;
            }else if (indexPath.section == 2) {
                return 0;
            }else {
                return 40;
            }
        }
    }else {
        NSInteger numberofHotCity = _hotCitys.count;
        if (tableView == _aCityList) {
            if (SCREEN_WIDTH == 320) {
                if (indexPath.section == 0) {
                    return 0;
                }else if (indexPath.section == 1) {
                    return 55;
                }else if (indexPath.section == 2) {
                    
                    return ((numberofHotCity-1)/3 +1)*45 + 10;
                }else if (indexPath.section == 3) {
                    return 0;
                }else {
                    return 40;
                }
            }else if (SCREEN_WIDTH == 375) {
                if (indexPath.section == 0) {
                    return 0;
                }else if (indexPath.section == 1) {
                    return 60;
                }else if (indexPath.section == 2) {
                    return ((numberofHotCity-1)/3 +1)*50 + 10;
                }else if (indexPath.section == 3) {
                    return 0;
                }else {
                    return 40;
                }
            }else {
                if (indexPath.section == 0) {
                    return 0;
                }else if (indexPath.section == 1) {
                    return 70;
                }else if (indexPath.section == 2) {
                    return ((numberofHotCity-1)/3 +1)*60 + 10;
                }else if (indexPath.section == 3) {
                    return 0;
                }else {
                    return 40;
                }
            }
            
        }else {
            return 40;
        }
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (_hide) {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell1"];
        if (indexPath.section == 0) {
            currentCityCell = [tableView dequeueReusableCellWithIdentifier:@"currentCityCell"];
            currentCityCell.cityLabel.text = [[NSUserDefaults standardUserDefaults]objectForKey:@"currentCity"];
            return currentCityCell;
        }
        if (indexPath.section == 1) {
            EMHotCitysCell *hotCell = [tableView dequeueReusableCellWithIdentifier:@"hotCell"];
            return hotCell;
        }
        if (indexPath.section == 2) {
            if (!cell) {
                cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell1"];
            }
            return cell;
        }
        else  {
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
            if (!cell) {
                cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
            }
            
            NSString *theCityKey = [_titleArray objectAtIndex:indexPath.section-3];
            NSArray *array = [_dataSource objectForKey:theCityKey];
            cell.textLabel.text = [array objectAtIndex:indexPath.row];
            return cell;
        }
    }else {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell1"];
        if (tableView == _aCityList) {
            if (indexPath.section == 0) {
                if (!cell) {
                    cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell1"];
                }
                return cell;
            }
            if (indexPath.section == 1) {
                currentCityCell = [tableView dequeueReusableCellWithIdentifier:@"currentCityCell"];
                currentCityCell.cityLabel.text = [[NSUserDefaults standardUserDefaults]objectForKey:@"currentCity"];
                return currentCityCell;
            }
            if (indexPath.section == 2) {
                EMHotCitysCell *hotCell = [tableView dequeueReusableCellWithIdentifier:@"hotCell"];
                return hotCell;
            }
            if (indexPath.section == 3) {
                if (!cell) {
                    cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell1"];
                }
            }
            else  {
                UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
                if (!cell) {
                    cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
                }
                
                NSString *theCityKey = [_titleArray objectAtIndex:indexPath.section-4];
                NSArray *array = [_dataSource objectForKey:theCityKey];
                cell.textLabel.text = [array objectAtIndex:indexPath.row];
                cell.textLabel.font = CUSTOM_FONT(17);
                return cell;
            }
            return cell;
        }
#pragma mark - 搜索结果
        else {
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell3"];
            if (!cell) {
                cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell3"];
            }
            cell.textLabel.text = [_resualtArray objectAtIndex:indexPath.row];
            return cell;
        }
    }
}

- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView {
    if (_hide) {
        NSMutableArray *titleSectionArray = [NSMutableArray arrayWithObjects:@"~",@"$",@"#", nil];
        for (int i = 0; i < 22; i ++) {
            [titleSectionArray addObject:[_titleArray objectAtIndex:i]];
        }
        if ([_delegate respondsToSelector:@selector(startDisplay:)]) {
            [_delegate startDisplay:self];
        }
        self.isShow = YES;
        return titleSectionArray;
    }else {
        NSMutableArray *titleSectionArray = [NSMutableArray arrayWithObjects:@"~",@"$",@"#",@"^", nil];
        for (int i = 0; i < 22; i ++) {
            [titleSectionArray addObject:[_titleArray objectAtIndex:i]];
        }
        if ([_delegate respondsToSelector:@selector(startDisplay:)]) {
            [_delegate startDisplay:self];
        }
        self.isShow = YES;
        return titleSectionArray;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (_hide) {
        if (indexPath.section == 0) {
            if ([_delegate respondsToSelector:@selector(refreshCurrentCity:)]) {
                [_delegate refreshCurrentCity:self];
            }
            _chooseCity = [[NSUserDefaults standardUserDefaults]objectForKey:@"currentCity"];
            [[NSUserDefaults standardUserDefaults]setValue:_chooseCity forKey:@"cityName"];
            [self zhengzaidingwei];
        }
        if (indexPath.section == 1) {
            
        }
        if (indexPath.section > 2 ) {
            NSInteger chooseSection = indexPath.section;
            NSInteger chooseRow = indexPath.row;
            
            NSString *currentSection = [_titleArray objectAtIndex:chooseSection-3];
            _chooseCity = [[_dataSource objectForKey:currentSection] objectAtIndex:chooseRow];
            [[NSUserDefaults standardUserDefaults]setValue:_chooseCity forKey:@"cityName"];
        }
        if (indexPath.section == 0) {
        }
        [self closeView];
    }else {
        if (tableView == _aCityList) {
            if (indexPath.section == 0) {
            }
            if (indexPath.section == 1) {
                if ([_delegate respondsToSelector:@selector(refreshCurrentCity:)]) {
                    [_delegate refreshCurrentCity:self];
                }
                
                _chooseCity = [[NSUserDefaults standardUserDefaults]objectForKey:@"currentCity"];
                [[NSUserDefaults standardUserDefaults]setValue:_chooseCity forKey:@"cityName"];
                [self zhengzaidingwei];
            }
            if (indexPath.section == 2) {
                return;
            }
            if (indexPath.section > 3 ) {
                NSInteger chooseSection = indexPath.section;
                NSInteger chooseRow = indexPath.row;
                NSString *currentSection = [_titleArray objectAtIndex:chooseSection-4];
                _chooseCity = [[_dataSource objectForKey:currentSection] objectAtIndex:chooseRow];
                [[NSUserDefaults standardUserDefaults]setValue:_chooseCity forKey:@"cityName"];
            }
            
        }else {
            [[NSUserDefaults standardUserDefaults]setValue:[_resualtArray objectAtIndex:indexPath.row] forKey:@"cityName"];
            _chooseCity = [_resualtArray objectAtIndex:indexPath.row];
            [self closeView];
        }
        [self closeView];
    }
}

- (void)zhengzaidingwei {
    currentCityCell.GPSLabel.text = @"正在重新定位";
    currentCityCell.GPSLabel.font = CUSTOM_FONT(14);
}

- (NSString *)getCityName {
    NSString *name = [[NSUserDefaults standardUserDefaults] valueForKey:@"cityName"];
    if (_theHotCityName) {
        if ([[_theHotCityName substringFromIndex:_theHotCityName.length-1] isEqualToString:@"市"]) {
            return [_theHotCityName substringToIndex:_theHotCityName.length-1];
        }else {
            return _theHotCityName;
        }
    }
    if (_chooseCity) {
        return name;
    }
    if ([[_currentCity substringFromIndex:_currentCity.length-1] isEqualToString:@"市"]) {
        return [_currentCity substringToIndex:_currentCity.length-1];
    }else {
        return _currentCity;
    }
}


- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar {
    NSLog(@"begin");
}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {
    NSLog(@"%@",searchText);
}

- (BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchString:(NSString *)searchString {
    [_resualtArray removeAllObjects];
    NSLog(@"内容：%@",searchString);
    for (int i = 0; i < _citiesArray.count; i ++) {
        if ([[ChineseToPinyin pinyinFromChiniseString:[_citiesArray objectAtIndex:i]] hasPrefix:[searchString uppercaseString]]||[[_citiesArray objectAtIndex:i] hasPrefix:searchString]) {
            [_resualtArray addObject:[_citiesArray objectAtIndex:i]];
        }
    }
    return YES;
}


- (BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchScope:(NSInteger)searchOption{
    [self searchDisplayController:controller shouldReloadTableForSearchString:_searchBar.text];
    return YES;
}



- (void)viewDidLoad {
    [super viewDidLoad];
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
// 版权属于原作者
// http://code4app.com (cn) http://code4app.net (en)
// 发布代码于最专业的源码分享网站: Code4App.com