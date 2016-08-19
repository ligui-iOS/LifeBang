//
//  NSObject+XX.m
//  LZXMusicPlayer
//
//  Created by twzs on 16/6/27.
//  Copyright © 2016年 LZX. All rights reserved.
//

#import "NSObject+XX.h"
#import <objc/runtime.h>

@implementation NSObject (XX)

- (void)initWithDict:(NSDictionary *)dict
{
    // 获取这个对象的类名
    Class class = [self class];
    
    unsigned int outCount = 0;
    
    Ivar *ivars = class_copyIvarList(class, &outCount);
    
    for (int i = 0; i < outCount; i ++) {
        
        Ivar ivar = ivars[i];
        // 获取模型的每一个属性, 是带有_的属性
        NSString *key = [NSString stringWithUTF8String:ivar_getName(ivar)];
        // 截取字符串
        key = [key substringFromIndex:1];
        
        if (dict[key] == nil) {
            continue;
        }
        
        NSString *type = [NSString stringWithUTF8String:ivar_getTypeEncoding(ivar)];
        
        id value = dict[key];
        // 判断属性的类型   带"@" 表示为 是oc 类型  不带"@" 则为基本数据类型
        if ([type hasPrefix:@"@"]) {
            // 截取字符串 取中间部分
            type = [type substringWithRange:NSMakeRange(2, type.length - 3)];
            // 判断是否以 NS 开头 不是的为自定义类, 想要拿到的模型
            if (![type hasPrefix:@"NS"]) {
                //根据字符串得到类
                Class clas = NSClassFromString(type);
                // 创建对象
                NSObject *obj = [[clas alloc]init];
                // 再次调用这个方法, 把value值传入  obj为新的对象
                // 交换方法的时候, 这个地方必须得改
                [obj initWithDict:value];
                //  把value 值换为一个对象
                value = obj;
            }
        }
        // 根据key去字典中找对应的value
        [self setValue:value forKey:key];
    }
}

+ (void)modelDataWithDict:(NSDictionary *)dict
{
    return [[self alloc]initWithDict:dict];
}

+ (NSArray *)modelWithFileName:(NSString *)name
{
    NSString *path = [[NSBundle mainBundle]pathForResource:name ofType:nil];
    
    NSArray *temp = [NSArray arrayWithContentsOfFile:path];
    
    NSMutableArray *dataArray = [NSMutableArray arrayWithCapacity:temp.count];
    
    for (int i = 0; i < temp.count; i ++) {
        
        NSDictionary *dict = temp[i];
        
        NSObject *objct = [[self alloc] init];
        
        [objct initWithDict:dict];
        
        [dataArray addObject:objct];
    }
    
    return dataArray;
}


@end
