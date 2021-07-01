//
//  YPProgressHUD.m
//  project
//
//  Created by 姚敦鹏 on 2018/10/13.
//  Copyright © 2018年 rocHome. All rights reserved.
//

#import "YPProgressHUD.h"
#import <SVProgressHUD.h>
#import <SDWebImage/UIImage+GIF.h>

#define SHOW_IMAGE_SIZE CGSizeMake(50, 50)
#define SHOW_DELAY_TIME 2.0f

@implementation YPProgressHUD

#pragma mark -- 菊花
+(void)yp_hudDefaultInit {
    
    [SVProgressHUD setMinimumDismissTimeInterval:0.0f];
    [SVProgressHUD setImageViewSize:SHOW_IMAGE_SIZE];
    
    [SVProgressHUD setSuccessImage:IMAGENANED(@"hud_success")];
    [SVProgressHUD setErrorImage:IMAGENANED(@"hud_error")];
    [SVProgressHUD setInfoImage:IMAGENANED(@"hud_info")];
    
    [SVProgressHUD setDefaultStyle:SVProgressHUDStyleCustom];
    [SVProgressHUD setForegroundColor:[UIColor whiteColor]];
    [SVProgressHUD setBackgroundColor:[[UIColor blackColor] colorWithAlphaComponent:0.8f]];
    [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeClear];
}

/** HUD 1.5s 移除 */
+(void)yp_showHUDMessage:(NSString *)message
{
    [self yp_showHUDMessage:message complete:nil];
}

/** HUD 回调 */
+ (void)yp_showHUDMessage:(NSString *)message complete:(void(^)(void))complete
{
    [self yp_showHUDMessage:message dismissTime:SHOW_DELAY_TIME complete:complete];
}

/** HUD 回调 */
+ (void)yp_showHUDMessage:(NSString *)message
              dismissTime:(NSTimeInterval)time
                 complete:(void(^)(void))complete
{
    UIImage *emptyImage = nil;
    [SVProgressHUD showImage:emptyImage status:message];
    [self yp_dismissHUDWithDelay:time completion:complete];
}

#pragma mark -- 加载中...
+ (void)yp_showLoading {
    
    [self yp_showLoadingMsg:nil];
}

#pragma mark -- 自定义文字...
+ (void)yp_showLoadingMsg:(NSString *)message {
    
    [SVProgressHUD setMinimumDismissTimeInterval:MAXFLOAT];
    // 设置背景颜色为透明色
    [SVProgressHUD showImage:[self loadGifImage] status:message];
    
    [SVProgressHUD dismissWithCompletion:^{
        [SVProgressHUD setImageViewSize:SHOW_IMAGE_SIZE];
        [SVProgressHUD setMinimumDismissTimeInterval:0.0f];
    }];
}

#pragma mark -- 成功、失败、信息 HUD
/** 成功HUD */
+ (void)yp_showSuccessHUDWithTitle:(NSString *)title
{
    [SVProgressHUD showSuccessWithStatus:title];
    [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeBlack];
    [self yp_dismissHUDWithDelay:SHOW_DELAY_TIME];
}
/** 失败HUD */
+ (void)yp_showErrorHUDWithTitle:(NSString *)title
{
    [SVProgressHUD showErrorWithStatus:title];
    [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeBlack];
    [self yp_dismissHUDWithDelay:SHOW_DELAY_TIME];
}
/** 信息HUD */
+ (void)yp_showInfoHUDWithTitle:(NSString *)title
{
    [SVProgressHUD showInfoWithStatus:title];
    [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeBlack];
    [self yp_dismissHUDWithDelay:SHOW_DELAY_TIME];
}

+(UIImage *)loadGifImage {
    
    [SVProgressHUD setImageViewSize:CGSizeMake(53, 53)];
    NSString *path = [[NSBundle mainBundle] pathForResource:@"ac_loading" ofType:@"gif"];
    NSData *imgData = [NSData dataWithContentsOfFile:path];
    UIImage *image = [UIImage sd_imageWithGIFData:imgData];
    return image;
}
#pragma mark -- 隐藏
/** 隐藏HUD */
+ (void)yp_dismissHUD
{
    [self yp_dismissHUDWithDelay:0.0f];
}

/** 隐藏HUD带时间参数 */
+ (void)yp_dismissHUDWithDelay:(NSTimeInterval)delay
{
    [self yp_dismissHUDWithDelay:delay completion:nil];
}

+ (void)yp_dismissHUDWithDelay:(NSTimeInterval)delay completion:(void(^)(void))completion {
    
    dispatch_async(dispatch_get_main_queue(), ^{
        
        [SVProgressHUD dismissWithDelay:delay completion:^{
            
            [SVProgressHUD setImageViewSize:SHOW_IMAGE_SIZE];
            [SVProgressHUD setMinimumDismissTimeInterval:0.0f];
            completion ? completion() : nil;
        }];
    });
}


@end
