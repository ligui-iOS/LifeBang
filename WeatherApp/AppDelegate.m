//
//  AppDelegate.m
//  WeatherApp
//
//  Created by ZhenzhenXu on 4/30/13.
//  Copyright (c) 2013 ZhenzhenXu. All rights reserved.
//

#import "AppDelegate.h"
#import "WeatherViewController.h"
#import "APService.h"
#import <TencentOpenAPI/TencentOAuth.h>
#import "WXApi.h"
#import "LBRecievePushDetailViewController.h"
#import "KeyboardManager.h"
#import "BaiduMobAdSplash.h"
@interface AppDelegate()<TencentSessionDelegate,BaiduMobAdSplashDelegate>
@property (strong, nonatomic) UIView *customSplashView;

@property (strong, nonatomic) BaiduMobAdSplash *splash;

@end
@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // Override point for customization after application launch.
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    // Override point for customization after application launch.
    self.window.backgroundColor = [UIColor whiteColor];
    WeatherViewController *ctrl = [[WeatherViewController alloc] init];
    UINavigationController *navCtrl = [[UINavigationController alloc] initWithRootViewController:ctrl];
    [self.window setRootViewController:navCtrl];
    [self.window makeKeyAndVisible];
    
    [WXApi registerApp:LBWXAppId];
    
    TencentOAuth *tencentAuth = [[TencentOAuth alloc] initWithAppId:LBTencentAppId andDelegate:self];
    tencentAuth.redirectURI = @"www.baidu.com";
    [NSThread sleepForTimeInterval:1.0];
    
    /**
     *  极光推送注册
     */
    if ([[UIDevice currentDevice].systemVersion floatValue] >= 8.0) {
        //categories
        [APService
         registerForRemoteNotificationTypes:(UIUserNotificationTypeBadge |
                                             UIUserNotificationTypeSound |
                                             UIUserNotificationTypeAlert)
         categories:nil];
    } else {
        //categories nil
        [APService
         registerForRemoteNotificationTypes:(UIRemoteNotificationTypeBadge |
                                             UIRemoteNotificationTypeSound |
                                             UIRemoteNotificationTypeAlert)
         categories:nil];
        [APService
         registerForRemoteNotificationTypes:(UIRemoteNotificationTypeBadge |
                                             UIRemoteNotificationTypeSound |
                                             UIRemoteNotificationTypeAlert)
         categories:nil];
    }
    [APService setupWithOption:launchOptions];
    [[UIApplication sharedApplication] setApplicationIconBadgeNumber:0];//角标清零
    
    BaiduMobAdSplash *splash = [[BaiduMobAdSplash alloc] init];
    splash.delegate = self;
    //把在mssp.baidu.com上创建后获得的代码位id写到这里
    splash.AdUnitTag = @"2621304";
    splash.canSplashClick = YES;
    self.splash = splash;
    
    //可以在customSplashView上显示包含icon的自定义开屏
    self.customSplashView = [[UIView alloc]initWithFrame:self.window.frame];
    self.customSplashView.backgroundColor = [UIColor whiteColor];
    [self.window addSubview:self.customSplashView];
    
    //在baiduSplashContainer用做上展现百度广告的容器，注意尺寸必须大于200*200，并且baiduSplashContainer需要全部在window内，同时开机画面不建议旋转
    CGFloat width = self.window.frame.size.width;
    CGFloat height= self.window.frame.size.height;
    UIView * baiduSplashContainer = [[UIView alloc]initWithFrame:CGRectMake(0, 0, width, height-60)];
    [self.customSplashView addSubview:baiduSplashContainer];
    
    UIImageView *view = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"baidu_icon"]];
    [view setFrame:CGRectMake(60, height-60, 200, 60)];
    [self.customSplashView addSubview:view];
    
    //在的baiduSplashContainer里展现百度广告
    [splash loadAndDisplayUsingContainerView:baiduSplashContainer];

    return YES;
}
#pragma mark----------------------RemoteNotification----start------------
#if __IPHONE_OS_VERSION_MAX_ALLOWED > __IPHONE_7_1
- (void)application:(UIApplication *)application
didRegisterUserNotificationSettings:
(UIUserNotificationSettings *)notificationSettings {
    [application registerForRemoteNotifications];
}

// Called when your app has been activated by the user selecting an action from
// a local notification.
// A nil action identifier indicates the default action.
// You should call the completion handler as soon as you've finished handling
// the action.
- (void)application:(UIApplication *)application
handleActionWithIdentifier:(NSString *)identifier
forLocalNotification:(UILocalNotification *)notification
  completionHandler:(void (^)())completionHandler {
}

// Called when your app has been activated by the user selecting an action from
// a remote notification.
// A nil action identifier indicates the default action.
// You should call the completion handler as soon as you've finished handling
// the action.
- (void)application:(UIApplication *)application
handleActionWithIdentifier:(NSString *)identifier
forRemoteNotification:(NSDictionary *)userInfo
  completionHandler:(void (^)())completionHandler {
}
#endif
- (void)application:(UIApplication *)application
didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
    // Required
    [APService registerDeviceToken:deviceToken];
    [APService setDebugMode];
}
- (void)application:(UIApplication *)application
didReceiveRemoteNotification:(NSDictionary *)userInfo {
    // Required
    [APService handleRemoteNotification:userInfo];
}
- (void)application:(UIApplication *)application
didReceiveRemoteNotification:(NSDictionary *)userInfo
fetchCompletionHandler:(void
                        (^)(UIBackgroundFetchResult))completionHandler {
    // IOS 7 Support Required
    [APService handleRemoteNotification:userInfo];
    NSLog(@"baiduUserInfo=%@",userInfo);
    if ([UIApplication sharedApplication].applicationState == UIApplicationStateActive) {
        UILocalNotification *localNotification = [[UILocalNotification alloc] init];
        localNotification.userInfo = userInfo;
        localNotification.soundName = UILocalNotificationDefaultSoundName;
        localNotification.alertBody = [[userInfo objectForKey:@"aps"] objectForKey:@"alert"];
        localNotification.fireDate = [NSDate date];
        [[UIApplication sharedApplication] scheduleLocalNotification:localNotification];
    }else{
        completionHandler(UIBackgroundFetchResultNewData);
    }
    [self networkDidReceiveMessage:userInfo];
}
- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error
{
    NSLog(@"DeviceToken 获取失败，原因：%@",error);
}
- (void)networkDidReceiveMessage:(NSDictionary *)userInfo {
//    NSString *content = [userInfo valueForKey:@"content"];
    NSDictionary *extras = [userInfo valueForKey:@"extras"];
//    NSString *customizeField1 = [extras valueForKey:@"customizeField1"];
    NSLog(@"userInfo==%@",userInfo);
    if ([userInfo valueForKey:@"controller"]) {
        UIViewController *scene = [[NSClassFromString([userInfo valueForKey:@"controller"]) alloc] init];
        [self.window.rootViewController presentViewController:scene animated:YES completion:nil];
    }else if ([userInfo valueForKey:@"lifeTips"]) {
        LBRecievePushDetailViewController *ctrl = [[LBRecievePushDetailViewController alloc] init];
        ctrl.lifeTipsStr = [userInfo valueForKey:@"lifeTips"];
//        [self.window.rootViewController.navigationController pushViewController:ctrl animated:YES];
        [self.window.rootViewController presentViewController:ctrl animated:YES completion:nil];
    }
    
}
#pragma mark----------------------RemoteNotification----end------------
- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}
- (NSString *)publisherId
{
    return @"e0732ba5"; //your_own_app_id. iOS和Android的app需要使用不同appid
}
/**
 *  广告展示失败
 */
- (void)splashlFailPresentScreen:(BaiduMobAdSplash *)splash withError:(BaiduMobFailReason) reason
{
    NSLog(@"splashlFailPresentScreen withError:%d",reason);
    //自定义开屏移除
    [self.customSplashView removeFromSuperview];
}

/**
 *  广告展示结束
 */
- (void)splashDidDismissScreen:(BaiduMobAdSplash *)splash
{
    NSLog(@"splashDidDismissScreen");
    //自定义开屏移除
    [self.customSplashView removeFromSuperview];
}
- (void)keyboard{
    IQKeyboardManager *manager = [IQKeyboardManager sharedManager];    // 开启
    manager.enable = YES;    // 点击空白区域 自动退出键盘
    manager.shouldResignOnTouchOutside = YES;    // 键盘的工具条上: 前后箭头+完成按钮
    manager.enableAutoToolbar = NO;
}
@end
