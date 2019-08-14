//
//  YPBaseWKWebController.h
//  YPProject
//
//  Created by Jtg_yao on 2019/8/14.
//  Copyright © 2019 jzg. All rights reserved.
//

#import "YPBaseController.h"
#import <WebKit/WebKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface YPBaseWKWebController : YPBaseController
<WKScriptMessageHandler,WKNavigationDelegate,WKUIDelegate,UIScrollViewDelegate>

@property (nonatomic, strong) WKWebViewConfiguration *webConfig;
@property (nonatomic, strong) WKWebView *webView;

@property (nonatomic, copy) NSString *url;

@property (nonatomic, strong) UIColor *progressColor;
@property (nonatomic, assign) CGFloat progressHeight;

@property (nonatomic, strong) UIBarButtonItem *backItem;
@property (nonatomic, strong) UIBarButtonItem *closeItem;

@end

NS_ASSUME_NONNULL_END
