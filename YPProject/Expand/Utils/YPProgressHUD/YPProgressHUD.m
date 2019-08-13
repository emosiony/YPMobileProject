//
//  YPProgressHUD.m
//  project
//
//  Created by 姚敦鹏 on 2018/10/13.
//  Copyright © 2018年 rocHome. All rights reserved.
//

#import "YPProgressHUD.h"
#import <SVProgressHUD.h>

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
    [SVProgressHUD dismissWithDelay:time completion:^{
        complete ? complete() : nil;
    }];
}

#pragma mark -- 加载中...
+ (void)yp_showDefaultLoading {
    [self yp_showHUDWithTitle:@"加载中..."];
}

#pragma mark -- 文字
/** 显示HUD */
+ (void)yp_showHUDWithTitle:(NSString *)title
{
    [SVProgressHUD showWithStatus:title];
    [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeBlack];
}

#pragma mark -- 加载中...
+ (void)yp_showDIYLoading {
    [self yp_showDIYLoadingMsg:@"加载中..."];
}

#pragma mark -- 自定义文字...
+ (void)yp_showDIYLoadingMsg:(NSString *)message {
    
    [SVProgressHUD setMinimumDismissTimeInterval:MAXFLOAT];
    // 设置背景颜色为透明色
    [SVProgressHUD showImage:[self loadGifImage] status:message];
    [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeClear];
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
    
    [SVProgressHUD setImageViewSize:SHOW_IMAGE_SIZE];
    
    // 设置即将刷新状态的动画图片（一松开就会刷新的状态）
    NSMutableArray *loadingImages = [NSMutableArray array];
    for (NSUInteger i = 1; i <= 9; i++) {
        UIImage *image = [UIImage imageNamed:[NSString stringWithFormat:@"icon_hud_%zd", i]];
        [loadingImages addObject:image];
    }
    
    return [UIImage animatedImageWithImages:loadingImages duration:SHOW_DELAY_TIME];
}
#pragma mark -- 隐藏
/** 隐藏HUD */
+ (void)yp_dismissHUD
{
    dispatch_async(dispatch_get_main_queue(), ^{
        
        [SVProgressHUD setMinimumDismissTimeInterval:0.0f];
        [SVProgressHUD dismiss];
    });
}

/** 隐藏HUD带时间参数 */
+ (void)yp_dismissHUDWithDelay:(NSTimeInterval)delay
{
    dispatch_async(dispatch_get_main_queue(), ^{
        
        [SVProgressHUD setMinimumDismissTimeInterval:0.0f];
        [SVProgressHUD dismissWithDelay:delay];
    });
}

@end
