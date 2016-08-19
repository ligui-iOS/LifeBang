//
//  DayWeatherRequest.m
//  WeatherApp
//
//  Created by ZhenzhenXu on 5/8/13.
//  Copyright (c) 2013 ZhenzhenXu. All rights reserved.
//

#import "DayWeatherRequest.h"
#import "ApiStoreSDK.h"

@implementation DayWeatherRequest

@synthesize receivedData=_receivedData;
@synthesize requestUrl=_requestUrl;
@synthesize delegate=_delegate;

- (id)initRequest{
    if (self=[super init]) {
//        _requestUrl=@"http://www.weather.com.cn/data/sk/101020900.html";
    }
    return self;
}

- (void)createConnection{
    // Create the request.
    NSString *apikey = @"0c2db93ed25a73c9ddc31a28d66e68e0";
    APISCallBack* callBack = [APISCallBack alloc];
    
    callBack.onSuccess = ^(long status, NSString* responseString) {
        NSLog(@"onSuccess");
        if(responseString != nil) {
//            _resultText.text = [@"success\n" stringByAppendingString: responseString];
            NSLog(@"responseString=====%@",responseString);
            NSError *jsonError = nil;
            NSData *data = [responseString dataUsingEncoding:NSUTF8StringEncoding];
            NSDictionary *json = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&jsonError];
            [_delegate dayWeatherRequestFinished:json withError:nil];
        }
    };
    
    callBack.onError = ^(long status, NSString* responseString) {
        NSLog(@"onError");
        [_delegate dayWeatherRequestFinished:nil withError:[NSString stringWithFormat:@"网络连接失败--%@",responseString]];
    };
    
    callBack.onComplete = ^() {
        NSLog(@"onComplete");
    };
    
    //部分参数
    NSString *uri = _requestUrl;//@"http://apis.baidu.com/heweather/weather/free";
    NSString *method = _requestMethod;//@"post";
    NSMutableDictionary *parameter = _requestParameter;//[[NSMutableDictionary alloc] init];
    
    //请求API
    [ApiStoreSDK executeWithURL:uri method:method apikey:apikey parameter:parameter callBack:callBack];
}

@end