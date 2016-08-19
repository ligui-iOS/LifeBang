//
//  IMPTencentWXShareView.m
//  IMobPay
//
//  Created by ligui on 15/9/16.
//  Copyright (c) 2015年 QTPay. All rights reserved.
//

#import "IMPTencentWXShareView.h"
#import "IMPBlurTransparentView.h"
#import <TencentOpenAPI/QQApiInterfaceObject.h>
#import <TencentOpenAPI/QQApiInterface.h>
#import <MessageUI/MessageUI.h>
#import "WXApi.h"
#import "SDWebImageManager.h"
@interface IMPTencentWXShareView()<MFMessageComposeViewControllerDelegate>
{
    enum WXScene weiXinScene;
    NSString *tencentWXShareMark;
}
@end
@implementation IMPTencentWXShareView
- (id)initWithFrame:(CGRect)frame withShareMark:(NSString *)shareMark
{
    self = [super initWithFrame:frame];
    if (self) {
        tencentWXShareMark = shareMark;
        if ([shareMark isEqualToString:@"recommendShare"]||[shareMark isEqualToString:@"setting"]) {
            [self createRecommandShareUI];
        }else if ([shareMark isEqualToString:@"weChatSubscription"]){
            [self createWeChatSubscriptionUI];
        }else{
            [self createUI];
        }
    }
    return self;
}
- (void)createWeChatSubscriptionUI
{
    IMPBlurTransparentView *blurView = [[IMPBlurTransparentView alloc] initWithFrame:self.bounds backgroundColor:[UIColor whiteColor] blurLevel:1];
    blurView.alpha = 0.95;
    [self addSubview:blurView];
    
    UILabel *shareTipsLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, kScreenHeight/2-70, kScreenWidth, 20)];
    shareTipsLabel.text = @"赶紧把好东西分享给好友~";
    shareTipsLabel.textAlignment = NSTextAlignmentCenter;
    shareTipsLabel.font = [UIFont systemFontOfSize:13];
    [blurView addSubview:shareTipsLabel];
    
    NSArray *shareImageArr = @[@"shareview_weixin",@"shareview_weixinfriends"];
    NSArray *shareTitleArr = @[@"微信好友",@"朋友圈"];
    for (int i=0; i<2; i++) {
        UIButton *shareBtn = [UIButton buttonWithType:UIButtonTypeSystem];
        shareBtn.frame = CGRectMake((kScreenWidth/39)*8+(i%2)*((kScreenWidth/39)*7+(kScreenWidth/39)*9), kScreenHeight/2+(i/2)*((kScreenWidth/39)*7+20+40), (kScreenWidth/39)*7, (kScreenWidth/39)*7);
        [shareBtn setImage:[[UIImage imageNamed:shareImageArr[i]] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] forState:UIControlStateNormal];
        shareBtn.tag = i+100;
        [shareBtn addTarget:self action:@selector(shareBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        [blurView addSubview:shareBtn];
        
        UILabel *shareTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(shareBtn.frame.origin.x-20, shareBtn.frame.origin.y+shareBtn.frame.size.height+5, shareBtn.frame.size.width+40, 20)];
        shareTitleLabel.text = shareTitleArr[i];
        shareTitleLabel.textAlignment = NSTextAlignmentCenter;
        shareTitleLabel.font = [UIFont systemFontOfSize:15];
        [blurView addSubview:shareTitleLabel];
    }
    UIButton *cancelBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    cancelBtn.frame = CGRectMake(kScreenWidth/2-15, kScreenHeight-50,30, 30);
    [cancelBtn setImage:[[UIImage imageNamed:@"shareview_close"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] forState:UIControlStateNormal];
    [cancelBtn addTarget:self action:@selector(cancelBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [blurView addSubview:cancelBtn];
}
- (void)createUI
{
    IMPBlurTransparentView *blurView = [[IMPBlurTransparentView alloc] initWithFrame:self.bounds backgroundColor:[UIColor whiteColor] blurLevel:1];
    blurView.alpha = 0.8;
    [self addSubview:blurView];
    
    UILabel *shareTipsLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, kScreenHeight/2-10, kScreenWidth, 20)];
    shareTipsLabel.text = @"赶紧通知好友收钱去~";
    shareTipsLabel.textAlignment = NSTextAlignmentCenter;
    shareTipsLabel.font = [UIFont systemFontOfSize:15];
    [blurView addSubview:shareTipsLabel];
    
    NSArray *shareImageArr = @[@"shareview_message",@"shareview_weixin",@"shareview_qq"];
    NSArray *shareTitleArr = @[@"短信",@"微信",@"QQ"];
    for (int i=0; i<3; i++) {
        UIButton *shareBtn = [UIButton buttonWithType:UIButtonTypeSystem];
        shareBtn.frame = CGRectMake(kScreenWidth/12+i*(kScreenWidth/3), kScreenHeight/2+60, kScreenWidth/6, kScreenWidth/6);
        [shareBtn setImage:[[UIImage imageNamed:shareImageArr[i]] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] forState:UIControlStateNormal];
        shareBtn.tag = i;
        [shareBtn addTarget:self action:@selector(shareBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        [blurView addSubview:shareBtn];
        
        UILabel *shareTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(shareBtn.frame.origin.x, shareBtn.frame.origin.y+shareBtn.frame.size.height+5, shareBtn.frame.size.width, 20)];
        shareTitleLabel.text = shareTitleArr[i];
        shareTitleLabel.textAlignment = NSTextAlignmentCenter;
        shareTitleLabel.font = [UIFont systemFontOfSize:15];
        [blurView addSubview:shareTitleLabel];
    }
    UIButton *cancelBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    cancelBtn.frame = CGRectMake(kScreenWidth/2-15, kScreenHeight-50,30, 30);
    [cancelBtn setImage:[[UIImage imageNamed:@"shareview_close"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] forState:UIControlStateNormal];
    [cancelBtn addTarget:self action:@selector(cancelBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [blurView addSubview:cancelBtn];
}
- (void)createRecommandShareUI
{
    IMPBlurTransparentView *blurView = [[IMPBlurTransparentView alloc] initWithFrame:self.bounds backgroundColor:[UIColor whiteColor] blurLevel:1];
    blurView.alpha = 0.95;
    [self addSubview:blurView];
    
    UILabel *shareTipsLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, kScreenHeight/2-70, kScreenWidth, 20)];
    shareTipsLabel.text = @"赶紧把好东西分享给好友~";
    shareTipsLabel.textAlignment = NSTextAlignmentCenter;
    shareTipsLabel.font = [UIFont systemFontOfSize:13];
    [blurView addSubview:shareTipsLabel];
    
    NSArray *shareImageArr = @[@"shareview_weixin",@"shareview_weixinfriends",@"shareview_qq",@"shareview_qzone"];
    NSArray *shareTitleArr = @[@"微信好友",@"朋友圈",@"QQ好友",@"QQ空间"];
    for (int i=0; i<4; i++) {
        UIButton *shareBtn = [UIButton buttonWithType:UIButtonTypeSystem];
        shareBtn.frame = CGRectMake((kScreenWidth/39)*8+(i%2)*((kScreenWidth/39)*7+(kScreenWidth/39)*9), kScreenHeight/2+(i/2)*((kScreenWidth/39)*7+20+40), (kScreenWidth/39)*7, (kScreenWidth/39)*7);
        [shareBtn setImage:[[UIImage imageNamed:shareImageArr[i]] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] forState:UIControlStateNormal];
        shareBtn.tag = i+10;
        [shareBtn addTarget:self action:@selector(shareBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        [blurView addSubview:shareBtn];
        
        UILabel *shareTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(shareBtn.frame.origin.x-20, shareBtn.frame.origin.y+shareBtn.frame.size.height+5, shareBtn.frame.size.width+40, 20)];
        shareTitleLabel.text = shareTitleArr[i];
        shareTitleLabel.textAlignment = NSTextAlignmentCenter;
        shareTitleLabel.font = [UIFont systemFontOfSize:15];
        [blurView addSubview:shareTitleLabel];
    }
    UIButton *cancelBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    cancelBtn.frame = CGRectMake(kScreenWidth/2-15, kScreenHeight-50,30, 30);
    [cancelBtn setImage:[[UIImage imageNamed:@"shareview_close"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] forState:UIControlStateNormal];
    [cancelBtn addTarget:self action:@selector(cancelBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [blurView addSubview:cancelBtn];
}
- (void)shareBtnClick:(UIButton *)btn
{
    if (btn.tag == 0) {
        [self shareToMessage];
    }else if(btn.tag == 1){
        weiXinScene = WXSceneSession;
        [self shareTextToWeiXin];
    }else if(btn.tag == 2){
        [self shareToQQ:NO];
    }else if(btn.tag == 10){
        [self shareToWeiXin];
    }else if(btn.tag == 11){
        weiXinScene = WXSceneTimeline;
        [self shareToWeiXin];
    }else if(btn.tag == 12){
        [self shareToQQ:NO];
    }else if(btn.tag == 13){
        [self shareToQQ:YES];
    }else if(btn.tag == 100){
        weiXinScene = WXSceneSession;
        [self sharePhotoToWeiXin];
    }else if(btn.tag == 101){
        weiXinScene = WXSceneTimeline;
        [self sharePhotoToWeiXin];
    }
//    [self removeFromSuperview];
}
- (void)shareTextToWeiXin
{
    SendMessageToWXReq* req = [[SendMessageToWXReq alloc] init];
    req.text = self.message;
    req.bText = YES;
    req.scene = weiXinScene;
    
    [WXApi sendReq:req];
}
- (void)sharePhotoToWeiXin
{
    WXMediaMessage *message = [WXMediaMessage message];
    [message setThumbImage:[UIImage imageNamed:@"shareview_publicnumberThumb.png"]];
//    [message setTitle:kIMPIPAppName];
    
    WXImageObject *ext = [WXImageObject object];
//    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"success" ofType:@"png"];
//    NSLog(@"filepath :%@",filePath);
    UIImage *photoImage = [UIImage imageNamed:@"shareview_publicnumber"];
    
    //UIImage* image = [UIImage imageWithContentsOfFile:filePath];
//    UIImage* image = [UIImage imageWithData:ext.imageData];
    ext.imageData = UIImagePNGRepresentation(photoImage);
    
    //    UIImage* image = [UIImage imageNamed:@"res5thumb.png"];
    //    ext.imageData = UIImagePNGRepresentation(image);
    
    message.mediaObject = ext;
    
    SendMessageToWXReq *req = [[SendMessageToWXReq alloc] init];
    req.bText = NO;
    req.message = message;
    req.scene = weiXinScene;
    
    [WXApi sendReq:req];
    [self cancelBtnClick];
}
- (void)shareToMessage
{
    [self showMessageView:self.message];
}
- (void)showMessageView:(NSString *)bodyOfMessage
{
    if( [MFMessageComposeViewController canSendText] )
    {
        MFMessageComposeViewController * controller = [[MFMessageComposeViewController alloc] init];
        controller.body = bodyOfMessage;
        controller.messageComposeDelegate = self;
        [self.shareCtrl presentViewController:controller animated:YES completion:nil];
    }
    else
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示信息"
                                                        message:@"该设备不支持短信功能"
                                                       delegate:nil
                                              cancelButtonTitle:@"确定"
                                              otherButtonTitles:nil, nil];
        [alert show];
    }
}
- (void)messageComposeViewController:(MFMessageComposeViewController *)controller didFinishWithResult:(MessageComposeResult)result
{
    [self.shareCtrl dismissViewControllerAnimated:YES completion:nil];
    [self cancelBtnClick];
    
    if (result == MessageComposeResultCancelled){
        NSLog(@"Message cancelled");
    }else if (result == MessageComposeResultSent){
        NSLog(@"Message sent");
    }else{
        NSLog(@"Message failed");
    }
}
- (void)shareToWeiXin
{
    if (self.shareurl == nil && self.shareImageurl == nil && self.shareTitle != nil) {
        SendMessageToWXReq* req = [[SendMessageToWXReq alloc] init];
        req.text = self.shareTitle;
        req.bText = YES;
        req.scene = weiXinScene;
        
        [WXApi sendReq:req];
        return;
    }
    WXMediaMessage *message = [WXMediaMessage message];
    if (([tencentWXShareMark isEqualToString:@"recommendShare"]||[tencentWXShareMark isEqualToString:@"setting"])&&self.shareMessageArr) {
        if (weiXinScene==WXSceneTimeline) {
            message.title = self.shareMessageArr[2];
        }else{
            message.title = self.shareMessageArr[0];
            message.description = self.shareMessageArr[1];
        }
    }else{
        message.title = self.shareTitle;
        message.description = self.message;
    }
    /*
     if (weiXinScene==WXSceneTimeline) {
     if ([tencentWXShareMark isEqualToString:@"recommendShare"]) {
     message.title = self.shareTitle;
     }else{
     message.title = self.message;
     }
     */
//    SDWebImageManager *manager = [[SDWebImageManager alloc] init];
    [message setThumbImage:self.shareImage];
    
    WXWebpageObject *ext = [WXWebpageObject object];
    ext.webpageUrl = self.shareurl;
    
    message.mediaObject = ext;
    
    SendMessageToWXReq* req = [[SendMessageToWXReq alloc] init];
    req.bText = NO;
    req.message = message;
    req.scene = weiXinScene;
    
    [WXApi sendReq:req];
    [self cancelBtnClick];
}
- (void)shareToQQ:(BOOL)isToQzone
{
    if (self.shareurl == nil && self.shareImageurl == nil && !self.shareTitle == nil) {
        QQApiTextObject *txtObj = [QQApiTextObject objectWithText:self.message];
        SendMessageToQQReq *req = [SendMessageToQQReq reqWithContent:txtObj];
        //将内容分享到qq
        QQApiSendResultCode qqResp = [QQApiInterface sendReq:req];
        [self cancelBtnClick];
        return;
    }
    NSString *utf8String = self.shareurl;
    NSString *description = self.message;
//    NSString *previewImageUrl = self.shareImageurl;
    
    if (([tencentWXShareMark isEqualToString:@"recommendShare"]||[tencentWXShareMark isEqualToString:@"setting"])&&self.shareMessageArr) {
        if (isToQzone) {
            self.shareTitle = self.shareMessageArr[2];
            description = @" ";
        }else{
            self.shareTitle = self.shareMessageArr[0];
            description = self.shareMessageArr[1];
        }
    }
    NSData *imageData = UIImagePNGRepresentation(self.shareImage);;
    QQApiURLObject *newsObj = [QQApiURLObject objectWithURL:[NSURL URLWithString:utf8String] title:self.shareTitle description:description previewImageData:imageData targetContentType:QQApiURLTargetTypeNews];
//                                objectWithURL:[NSURL URLWithString:utf8String]
//                                title:self.shareTitle
//                                description:description
//                                previewImageURL:[NSURL URLWithString:previewImageUrl]];
    if (isToQzone) {
        [newsObj setCflag:kQQAPICtrlFlagQZoneShareOnStart];
    }
    SendMessageToQQReq *req = [SendMessageToQQReq reqWithContent:newsObj];
    QQApiSendResultCode qqResp = [QQApiInterface sendReq:req];
    NSLog(@"qqResp============%d",qqResp);
    [self cancelBtnClick];
}
- (void)cancelBtnClick
{
    [self removeFromSuperview];
}
@end
