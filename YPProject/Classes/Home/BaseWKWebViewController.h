//
//  BaseWKWebViewController.h
//  HobbyCollection
//
//  Created by mac on 2020/5/28.
//  Copyright © 2020 djm. All rights reserved.
//

#import "YPBaseController.h"
//#import "AiCWkWebViewJsHandler.h"
#import <WebKit/WebKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_OPTIONS(NSUInteger, AiCRightPopType) {
    AiCRightPopTypeFour = 0, // 展示四个
    AiCRightPopTypeTwo  = 1, // 展示两个
};


@interface BaseWKWebViewController : YPBaseController
<WKScriptMessageHandler,WKNavigationDelegate,WKUIDelegate,UIScrollViewDelegate>

@property (nonatomic, strong) WKWebViewConfiguration *webConfig;
@property (nonatomic, copy)   NSString *url;
@property (nonatomic, strong) WKWebView *webView;

@property (nonatomic, assign) AiCRightPopType popType;
/** 设置没有红点 */
- (void)setCancelRedView;
- (void)redViewShow:(BOOL)show;
//- (void)backButtonClick:(MHCRedButton *)btn;
- (void)showPop;

/** 修改URL  */
- (NSString *)getRealString;

- (void)customPopWithIcons:(NSArray *)icons titles:(NSArray *)titles clickBlock:(void (^)(NSString *title))popClickBlock;

@end

NS_ASSUME_NONNULL_END
