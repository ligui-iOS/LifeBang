//
//  EMCityChoose.h
//  CityChoose
//
//  Created by Eric MiAo on 15/8/26.
//  Copyright (c) 2015年 苗舒宣. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EMCityChoose_CurrentCity.h"
#import "ChineseToPinyin.h"
#define SCREEN_HIGHT [UIScreen mainScreen].bounds.size.height
#define SCREEN_WIDTH [UIScreen mainScreen].bounds.size.width

/*
 * 导入整个文件夹，在需要的地方import此.h文件即可
 * 在需要出现城市选择器的button所绑定的方法中创建EMCityChoose
 * 在需要传入当前城市的时候调用 [EMCityChoose_CurrentCity getCurrentCity:@"xxx"]; （必须要实现）
 */
/*
                                            *
                                        *   *   *
                                    *       *        *
                                *           *           *
                                            *
                                            *   
                                            *
                                            *
                                            *
 */

typedef NS_ENUM(NSInteger, cityListType) {
    cityListTypeLongType    = 0,    // 长字符城市列表
    cityListTypeShortType   = 1,    // 短字符城市列表
};
@interface EMCityChoose : UIViewController<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic,assign)id delegate;    // 如需要实现回调方法，设置delegate
@property (nonatomic,assign)BOOL isShow;    // 用于获取当前城市选择器的状态 控制点击的button实现 出现&消失

/**
 * 初始化方法
 * 传入 1 Point：指定出现列表的纵坐标（列表的宽高自适应屏幕尺寸） 2 buttonTitleCityName：指定当前button的显示的城市（这里请传入变量 如：button.titleLabel.text） 3 hotCity: 指定需要显示的热门城市  4 cityListType: 指定列表类型  5 hideSearchBar: 是否显示搜索条
 */
- (id)initWithPointY:(float)pointY buttonTitleCityName:(NSString *)aCityName hotCity:(NSArray *)theHotCitys cityType:(cityListType)cityListType hideSearchBar:(BOOL)hide;



/**
 *获得所选则的城市名
 */
- (NSString *)getCityName;



/**
 *关闭城市选择器
 */
- (void)closeView;


@end

@protocol EMCityChooseDelegate <NSObject>
@optional

- (void)startDisplay:(EMCityChoose *)aCityChooseViewController;         // 当城市选择器出现时回调该方法

- (void)stopDisplay:(EMCityChoose *)aCityChooseViewController;          // 当城市选择器消失时回调该方法

- (void)refreshCurrentCity:(EMCityChoose *)aCityChooseViewController;   // 当刷新当前位置时回调该方法

@end
// 版权属于原作者
// http://code4app.com (cn) http://code4app.net (en)
// 发布代码于最专业的源码分享网站: Code4App.com