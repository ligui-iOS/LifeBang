//
//  ForecastWeatherRequest.h
//  WeatherApp
//
//  Created by ZhenzhenXu on 5/8/13.
//  Copyright (c) 2013 ZhenzhenXu. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol AFNetWorkingGetPostRequestDelegage

-(void)requestFinished:(id )responseData withError:(NSError *)error;

@end
@interface AFNetWorkingGetPostRequest : NSObject
@property (nonatomic,weak) id<AFNetWorkingGetPostRequestDelegage>delegate;
- (void)postRequestByUrl:(NSString *)url parameters:(NSMutableDictionary *)dict;
- (void)getRequestByUrl:(NSString *)url parameters:(NSMutableDictionary *)dict;
@end