//
//  IMPTencentWXShareView.h
//  IMobPay
//
//  Created by ligui on 15/9/16.
//  Copyright (c) 2015年 QTPay. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface IMPTencentWXShareView : UIView
@property (nonatomic,strong)UIViewController *shareCtrl;
@property (nonatomic,strong)NSString *shareTitle;
@property (nonatomic,strong)NSString *shareurl;
@property (nonatomic,strong)NSString *message;
@property (nonatomic,strong)NSString *shareImageurl;
@property (nonatomic,strong)UIImage *shareImage;
@property (nonatomic,strong)NSArray *shareMessageArr;//1.分享至好友标题 2.分享至好友内容 3.朋友圈内容
- (id)initWithFrame:(CGRect)frame withShareMark:(NSString *)shareMark;
@end
