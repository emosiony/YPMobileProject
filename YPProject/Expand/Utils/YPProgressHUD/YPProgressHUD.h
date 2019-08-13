//
//  YPProgressHUD.h
//  project
//
//  Created by 姚敦鹏 on 2018/10/13.
//  Copyright © 2018年 rocHome. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface YPProgressHUD : NSObject

/** 默认设置
 *  请在 appdelegate didFinishLaunchingWithOptions 中设置
 */
+(void)yp_hudDefaultInit;

#pragma mark -- 小菊花 提示
/** 直接文字HUD 2s移除 */
+(void)yp_showHUDMessage:(NSString *)message;
/** 直接文字HUD 回调 */
+(void)yp_showHUDMessage:(NSString *)message complete:(void(^)(void))complete;
/** HUD 回调 */
+(void)yp_showHUDMessage:(NSString *)message
          dismissTime:(NSTimeInterval)time
             complete:(void(^)(void))complete;

#pragma mark -- 加载中
+(void)yp_showDefaultLoading;

#pragma mark -- 加载中DIY...
+ (void)yp_showDIYLoading;

#pragma mark -- 自定义文字...
+ (void)yp_showDIYLoadingMsg:(NSString *)message;

#pragma mark -- 小菊花 网络请求 带activity 或者 图片
/** 显示HUD */
+(void)yp_showHUDWithTitle:(NSString *)title;

/** 成功HUD */
+(void)yp_showSuccessHUDWithTitle:(NSString *)title;
/** 失败HUD */
+(void)yp_showErrorHUDWithTitle:(NSString *)title;
/** 信息HUD */
+(void)yp_showInfoHUDWithTitle:(NSString *)title;

/** 隐藏HUD */
+(void)yp_dismissHUD;
/** 隐藏HUD带时间参数 */
+(void)yp_dismissHUDWithDelay:(NSTimeInterval)delay;

@end
