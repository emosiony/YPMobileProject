//
//  BaseWKWebViewController.m
//  HobbyCollection
//
//  Created by mac on 2020/5/28.
//  Copyright © 2020 djm. All rights reserved.
//

#import "BaseWKWebViewController.h"
//#import "HCPopView.h"
#import "UINavigationController+FDFullscreenPopGesture.h"
//#import "HCBannerPushService.h"
//#import "WeakScriptMessageDelegate.h"
//#import <Bugly/Bugly.h>
//#import "HCWebShareModel.h"

@interface BaseWKWebViewController ()
//<AiCWkWebViewJsHandlerDelegate>

/** 进度条 */
@property (nonatomic, strong) UIProgressView *progressView;

//@property (nonatomic, strong) MHCRedButton *closeBtn;


@property (nonatomic, strong) NSArray *popIcons;
@property (nonatomic, strong) NSArray *popTitles;
@property (nonatomic, copy) void (^popClickBlock)(NSString *title);

//@property (nonatomic, strong) AiCWkWebViewJsHandler *JSHandler;


@end

@implementation BaseWKWebViewController

- (void)dealloc {
    
    @try {
        [self removeScriptMessageAll];
        //移除所以的回调
        [self.webView evaluateJavaScript:@"JKEventHandler.removeAllCallBacks();" completionHandler:^(id _Nullable data, NSError *_Nullable error) {
            NSLog(@"JKEventHandler.removeAllCallBacks() \n data >> %@ \n error >> %@", data, error);
        }];//删除所有的回调事件
        
        self.webView.navigationDelegate  = nil;
        self.webView.UIDelegate          = nil;
        self.webView.scrollView.delegate = nil;
        
        [[NSNotificationCenter defaultCenter] removeObserver:self];
    } @catch (NSException *exception) {
//        [Bugly reportException:exception];
    } @finally {
        
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setNavigation];
    [self setupSubView];
    [self addWebViewOberver];
    [self loadWebViewRequest];
}

- (void)setupSubView {
    
    self.webView.navigationDelegate  = self;
    self.webView.UIDelegate          = self;
    self.webView.scrollView.delegate = self;
    
    [self.view addSubview:self.progressView];
    [self.view addSubview:self.webView];
    
    [self.progressView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(self.view);
        make.top.mas_equalTo(self.view);
        make.height.mas_equalTo(2.0f);
    }];
    
    [self.webView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.progressView.mas_bottom);
        make.left.right.bottom.mas_equalTo(self.view);
    }];
}

- (void)setNavigation {
    
    self.fd_interactivePopDisabled = YES;
    
//    MHCRedButton *closeBtn = [MHCRedButton buttonWithFrame:CGRectZero tag:10];
//    [closeBtn setImage:KIMAGE(@"noclose") forState:UIControlStateNormal];
//    [closeBtn addTarget:self action:@selector(closeClick) forControlEvents:UIControlEventTouchUpInside];
//    [self.navigationBAr addSubview:closeBtn];
//    self.closeBtn = closeBtn;
//
//    [closeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.mas_equalTo(self.navigationBAr.backButton.mas_right);
//        make.centerY.mas_equalTo(self.navigationBAr.backButton);
//        make.width.height.mas_equalTo(30);
//    }];
//
//    CGFloat orginX = self.navigationBAr.backButton.MaxX + 30;
//    [self.navigationBAr.titleLabel setFrame:CGRectMake(orginX, self.navigationBAr.titleLabel.mj_y, kScreenWidth - orginX * 2, self.navigationBAr.titleLabel.mj_h)];
//
//    if (self.popType == AiCRightPopTypeTwo) {
//
//        WEAKSELF
//        [self rightButtonActionIntercept:@[@0] adjustmentButton:^(NSArray<MHCRedButton *> *buttons) {
//
//        } newAction:^(MHCRedButton *button) {
//            [weakSelf backButtonClick:button];
//        }];
//        NSArray *images = @[@"share", @"refresh"];
//        NSArray *titles = @[@"分享", @"刷新"];
//
//        [self customPopWithIcons:images titles:titles clickBlock:^(NSString *title) {
//            if ([title isEqualToString:@"分享"]) {
//                [[AiCWkWebViewJsHandler shareHandler] webViewShareShow];
//            }
//            if ([title isEqualToString:@"刷新"]) {
//                [weakSelf clearWKWebViewCache];
//                [weakSelf.webView reloadFromOrigin];
//            }
//        }];
//    } else if (self.popType == AiCRightPopTypeFour) {
//
//        //最近本形式
//        self.popIcons = @[@"news", @"shome", @"question", @"proposed", @"numuMy"];
//        self.popTitles = @[@"消息", @"首页", @"帮助",  @"我要反馈", @"我的爱藏"];
//
//        //修改右边按钮
//        WEAKSELF
//        [self setRightButtonImage:nil clickBlock:^(UIButton *button) {
//            if (button.tag == 2) {
//                [weakSelf showPop];
//            }
//        }];
//    }
//
//    if (self.navigationController.viewControllers.count <= 1) {
//
//        BOOL hidden = self.webView.backForwardList.backList.count <= 1;
//        self.navigationBAr.backButton.hidden = hidden;
//        self.closeBtn.hidden = hidden;
//    }
//
    [self addNotification];
//    [self redViewShow:kUser.isRedShow];
//
//    _JSHandler = [AiCWkWebViewJsHandler shareHandler];
//    _JSHandler.delegate = self;
}

- (void)loadWebViewRequest {
    
    self.url = [self getRealString];
    
    NSString *urlStr = nil;
//    if ([self.url hasChineseString]) {
//        if (iOS9Later) {
//            urlStr = [self.url stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
//        } else {
//            urlStr = [self.url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
//        }
//    } else {
        urlStr = self.url;
//    }

    NSURL *url = [NSURL URLWithString:urlStr];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url
                                                           cachePolicy:NSURLRequestUseProtocolCachePolicy
                                                       timeoutInterval:10.0];
    
    NSString *cookieStr = [self readCurrentCookies];
    NSDictionary *headFields = request.allHTTPHeaderFields;
    NSString *cookie = headFields[@"user_id"];
    if (cookie == nil && cookieStr != nil && cookieStr.length > 0) {
        
        cookieStr = [cookieStr stringByAppendingFormat:@";path=/"];
        [request addValue:cookieStr forHTTPHeaderField:@"Cookie"];
        
        NSString *cookieSource = [NSString stringWithFormat:@"document.cookie = '%@';", cookieStr];
        WKUserScript *cookieScript = [[WKUserScript alloc] initWithSource:cookieSource injectionTime:WKUserScriptInjectionTimeAtDocumentStart forMainFrameOnly:NO];
        //添加Cookie
        [self.webView.configuration.userContentController addUserScript:cookieScript];
    }
    [self.webView loadRequest:request];
}

- (NSString *)getRealString {
    
    return self.url;
}

#pragma mark - KVO
- (void)addWebViewOberver {
    
    // 添加KVO监听
    [self.webView addObserver:self
                   forKeyPath:@"loading"
                      options:NSKeyValueObservingOptionNew
                      context:nil];
    [self.webView addObserver:self
                   forKeyPath:@"title"
                      options:NSKeyValueObservingOptionNew
                      context:nil];
    [self.webView addObserver:self
                   forKeyPath:@"estimatedProgress"
                      options:NSKeyValueObservingOptionNew
                      context:nil];
}

- (void)observeValueForKeyPath:(NSString *)keyPath
                      ofObject:(id)object
                        change:(NSDictionary<NSString *,id> *)change
                       context:(void *)context {
    
    if ([keyPath isEqualToString:@"loading"]) {
        [self.view setNeedsUpdateConstraints];
        [self.view updateConstraintsIfNeeded];

    } else if ([keyPath isEqualToString:@"title"]) {
        NSString *webTitle = [change objectForKey:NSKeyValueChangeNewKey];
//        webTitle = SCIsBlank(webTitle) ? (SCIsBlank(self.title) ? @"" : self.title) : webTitle;
        self.title = webTitle;
    } else if ([keyPath isEqualToString:@"estimatedProgress"]) {
        double progress = [[change objectForKey:NSKeyValueChangeNewKey] doubleValue];
        NSLog(@"estimatedProgress == %lf",progress);
        self.progressView.progress = progress;
        if (progress >= 1.0f) {
            WeakSelf();
            [UIView animateWithDuration:0.5f
                                  delay:0.3f
                                options:UIViewAnimationOptionCurveEaseOut
                             animations:^{
                [weakself.progressView setAlpha:0.0f];
                [weakself.progressView mas_updateConstraints:^(MASConstraintMaker *make) {
                    make.height.mas_equalTo(0);
                }];
            } completion:^(BOOL finished) {
                [weakself.progressView setProgress:0.0f animated:NO];
            }];
        } else {
            [self.progressView setAlpha:1.0f];
            [self.progressView mas_updateConstraints:^(MASConstraintMaker *make) {
                make.height.mas_equalTo(2.0f);
            }];
        }
    }
}

- (void)removeScriptMessageAll {

    [self.webView removeObserver:self forKeyPath:@"loading"];
    [self.webView removeObserver:self forKeyPath:@"title"];
    [self.webView removeObserver:self forKeyPath:@"estimatedProgress"];
    
//    [self.webView.configuration.userContentController removeScriptMessageHandlerForName:kWKJS_LoginHandler_NAME];
//    [self.webView.configuration.userContentController removeScriptMessageHandlerForName:kWKJS_OutLoginHandler_NAME];
//    [self.webView.configuration.userContentController removeScriptMessageHandlerForName:kWKJS_ShareHandler_NAME];
//    [self.webView.configuration.userContentController removeScriptMessageHandlerForName:kWKJS_ExitWebHandler_NAME];
//    [self.webView.configuration.userContentController removeScriptMessageHandlerForName:kWKJS_AppNative_NAME];
}

#pragma mark -- WKUIDelegate
- (void)webViewDidClose:(WKWebView *)webView {
    NSLog(@"%s", __FUNCTION__);
}

// 20200327 WebView JavaScript丢失了对iOS JSContext名称空间（对象）的引用
-(void)webViewDidFinishLoad:(WKWebView *)view {
    
    [view valueForKeyPath:@"documentView.webView.mainFrame.javaScriptContext"]; // Undocumented access to WebView's JSContext
}

#pragma mark - WKScriptMessageHandler
- (void)userContentController:(WKUserContentController *)userContentController
      didReceiveScriptMessage:(WKScriptMessage *)message {
 
//    WEAKSELF
//    [self.JSHandler webViewReceiveScriptMessage:self.webView message:message complete:^(NSString * _Nonnull msgName, id  _Nonnull anything) {
//        if ([msgName isEqualToString:kWKJS_LoginHandler_NAME]) {
//            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//                [weakSelf loadWebViewRequest];
//            });
//        }
//        else if ([msgName isEqualToString:kWKJS_ShareHandler_NAME]) {
//            BOOL show = [(NSString *) anything intValue] == 1;
//            weakSelf.navigationBAr.rightMenuButton.hidden = !show;
//        }
//    }];
}

#pragma mark - WKNavigationDelegate
// 在JS端调用alert函数时，会触发此代理方法。
// JS端调用alert时所传的数据可以通过message拿到
// 在原生得到结果后，需要回调JS，是通过completionHandler回调
- (void)webView:(WKWebView *)webView runJavaScriptAlertPanelWithMessage:(NSString *)message initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(void))completionHandler {
    
    NSLog(@"%s \n message >> %@", __FUNCTION__, message);
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:message preferredStyle:UIAlertControllerStyleAlert];
    [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        completionHandler();
    }]];
    
    [self presentViewController:alert animated:YES completion:NULL];
}

// JS端调用confirm函数时，会触发此方法
// 通过message可以拿到JS端所传的数据
// 在iOS端显示原生alert得到YES/NO后
// 通过completionHandler回调给JS端
- (void)webView:(WKWebView *)webView runJavaScriptConfirmPanelWithMessage:(NSString *)message initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(BOOL result))completionHandler {
    
    NSLog(@"%s \n message >> %@", __FUNCTION__, message);
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:message preferredStyle:UIAlertControllerStyleAlert];
    [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        completionHandler(YES);
    }]];
    [alert addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        completionHandler(NO);
    }]];
    [self presentViewController:alert animated:YES completion:NULL];
}

// JS端调用prompt函数时，会触发此方法
// 要求输入一段文本
// 在原生输入得到文本内容后，通过completionHandler回调给JS
- (void)webView:(WKWebView *)webView runJavaScriptTextInputPanelWithPrompt:(NSString *)prompt defaultText:(nullable NSString *)defaultText initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(NSString * __nullable result))completionHandler {
    
    NSLog(@"%s \n prompt >> %@", __FUNCTION__, prompt);
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"textinput" message:@"JS调用输入框" preferredStyle:UIAlertControllerStyleAlert];
    [alert addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
        textField.textColor = [UIColor redColor];
    }];
    
    [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        completionHandler([[alert.textFields lastObject] text]);
    }]];
    [self presentViewController:alert animated:YES completion:NULL];
}

#pragma mark - WKNavigationDelegate
// 类型，在请求先判断能不能跳转（请求）
- (void)webView:(WKWebView *)webView decidePolicyForNavigationAction:(WKNavigationAction *)navigationAction decisionHandler:(void (^)(WKNavigationActionPolicy))decisionHandler {
    
    NSLog(@" %s %s decidePolicyForNavigationResponse >>> %@", __FILE__, __FUNCTION__, navigationAction.request.URL.absoluteString);
    NSString *strRequest = [navigationAction.request.URL.absoluteString stringByRemovingPercentEncoding];
//    if ([HCBannerPushService webJumpWithStr:strRequest]) {
//        // 拦截点击链接
//        decisionHandler(WKNavigationActionPolicyCancel);
//    } else {
//
//
//        if (self.navigationController.viewControllers.count <= 1) {
//            BOOL hidden = self.webView.backForwardList.backList.count <= 0;
//            self.navigationBAr.backButton.hidden = hidden;
//            self.closeBtn.hidden = hidden;
//        }
//
        // 允许跳转
        decisionHandler(WKNavigationActionPolicyAllow);
        // self.navigationBAr.rightMenuButton.hidden=YES;//隐藏右上角分享按钮
//    }
}

// 在响应完成时，会回调此方法
// 如果设置为不允许响应，web内容就不会传过来
- (void)webView:(WKWebView *)webView decidePolicyForNavigationResponse:(WKNavigationResponse *)navigationResponse decisionHandler:(void (^)(WKNavigationResponsePolicy))decisionHandler {
    
    decisionHandler(WKNavigationResponsePolicyAllow);
    NSLog(@"%s decidePolicyForNavigationResponse >>> %@", __FUNCTION__, webView.URL.absoluteString);
}

// 开始导航跳转时会回调
- (void)webView:(WKWebView *)webView didStartProvisionalNavigation:(null_unspecified WKNavigation *)navigation {
    
    NSLog(@"%s didStartProvisionalNavigation >>> %@", __FUNCTION__, webView.URL.absoluteString);
}

// 接收到重定向时会回调
- (void)webView:(WKWebView *)webView didReceiveServerRedirectForProvisionalNavigation:(null_unspecified WKNavigation *)navigation {
    
    NSLog(@"%s %@", __FUNCTION__, webView.URL.absoluteString);
}

// 导航失败时会回调
- (void)webView:(WKWebView *)webView didFailProvisionalNavigation:(null_unspecified WKNavigation *)navigation withError:(NSError *)error {
    
    NSLog(@"%s", __FUNCTION__);
    if (error.code == NSURLErrorNotConnectedToInternet) {
//        NSString *errorDesc = [NSError errorTipHandleWithCode:error.code];
        [SVProgressHUD showErrorWithStatus:error.localizedDescription];
        dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC));
        dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
            [self.navigationController popViewControllerAnimated:YES];
        });
    } else if (error.code != 102) {
//        kNetWork;
    }
}

// 页面内容到达main frame时回调
- (void)webView:(WKWebView *)webView didCommitNavigation:(null_unspecified WKNavigation *)navigation {
    NSLog(@"%s", __FUNCTION__);
}

// 导航完成时，会回调（也就是页面载入完成了）
- (void)webView:(WKWebView *)webView didFinishNavigation:(null_unspecified WKNavigation *)navigation {
    
    NSLog(@"%s", __FUNCTION__);
    __weak typeof(self) weakSelf = self;
    [webView evaluateJavaScript:@"document.title" completionHandler:^(id _Nullable response, NSError * _Nullable error) {
        if ([response isKindOfClass:[NSString class]]) {
            NSString *title = self.title == nil ? response : self.title;
            weakSelf.title = title;
        }
    }];
    
    //禁止长按图片弹窗
    [self.webView evaluateJavaScript:@"document.documentElement.style.webkitTouchCallout='none';" completionHandler:nil];
    [self.webView evaluateJavaScript:@"document.documentElement.style.webkitUserSelect='none';" completionHandler:nil];
}

// 导航失败时会回调
- (void)webView:(WKWebView *)webView didFailNavigation:(null_unspecified WKNavigation *)navigation withError:(NSError *)error {
    
    return;
}

//内存过大时，会出现白屏
- (void)webViewWebContentProcessDidTerminate:(WKWebView *)webView {
    [webView reload];    //刷新就好了
}

#pragma mark -- navigationClick
//- (void)backButtonClick:(MHCRedButton *)btn {
//
//    if ([self.webView canGoBack]) {
//        [self.webView goBack];
//
//        if (self.navigationController.viewControllers.count <= 1) {
//            BOOL hidden = self.webView.backForwardList.backList.count <= 1;
//            self.navigationBAr.backButton.hidden = hidden;
//            self.closeBtn.hidden = hidden;
//        }
//    } else {
//        [self closeClick];
//    }
//}

- (void)closeClick {
    
    if (self.navigationController.viewControllers.count <= 1) {
        if (self.webView.backForwardList.backList.count) {
            WKBackForwardListItem *item = self.webView.backForwardList.backList.firstObject;
            [self.webView goToBackForwardListItem:item];
        } else {
            [self.navigationController popViewControllerAnimated:YES];
        }
    } else {
        [self.navigationController popViewControllerAnimated:YES];
    }
    
    if (self.navigationController.viewControllers.count <= 1) {
//        self.navigationBAr.backButton.hidden = YES;
//        self.closeBtn.hidden = YES;
    }
}

#pragma mark - 红点的显示与通知
- (void)addNotification {

//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(notificationRun:) name:NFXred object:nil];
}

- (void)notificationRun:(NSNotification *)ntf {
    
    BOOL show = [ntf.object floatValue];
    [self redViewShow:show];
}

- (void)redViewShow:(BOOL)show {
    // 显示导航右侧按钮红点
//    [self MenuButtonShowRedView:show];
}

/** 设置没有红点 */
- (void)setCancelRedView {
    [self redViewShow:NO];
//    [[NSNotificationCenter defaultCenter] removeObserver:self name:NFXred object:nil];
}

- (void)showPop{
//    [HCPopView showWithIcons:self.popIcons titles:self.popTitles clickBlock:self.popClickBlock];
}

- (void)customPopWithIcons:(NSArray *)icons titles:(NSArray *)titles clickBlock:(void (^)(NSString *title))popClickBlock{
    
    self.popClickBlock = popClickBlock;
    self.popIcons = icons;
    self.popTitles = titles;
}

#pragma mark -- AiCWkWebViewJsHandlerDelegate
//- (HCWebShareModel *)getDelfaultShareModel {
//
//    HCWebShareModel *shareModel = [[HCWebShareModel alloc] init];
//    shareModel.title = self.navigationBAr.titleLabel.text;
//    shareModel.desc  = @"";
//    shareModel.link  = [self.webView.URL absoluteString];
//    shareModel.imgUrl = @"http://img.airmb.com/static_file/common/20190813090121.png";
//
//    return shareModel;
//}

#pragma mark -- private
// cookies
- (NSString *)readCurrentCookies {
    
//    NSString *cookieStr = [HCUserDefaults objectForKey:@"user_login_web_cookie"];
    return @"";
}

// 清理clearWKWebViewCache缓存
- (void)clearWKWebViewCache {
    
    if ([[[UIDevice currentDevice]systemVersion]intValue ] >= 9.0) {
        NSArray * types =@[WKWebsiteDataTypeMemoryCache,WKWebsiteDataTypeDiskCache]; // 9.0之后才有的
        NSSet *websiteDataTypes = [NSSet setWithArray:types];
        NSDate *dateFrom = [NSDate dateWithTimeIntervalSince1970:0];
        [[WKWebsiteDataStore defaultDataStore] removeDataOfTypes:websiteDataTypes modifiedSince:dateFrom completionHandler:^{
        }];
    }else{
        NSString *libraryPath = [NSSearchPathForDirectoriesInDomains(NSLibraryDirectory,NSUserDomainMask,YES) objectAtIndex:0];
        NSString *cookiesFolderPath = [libraryPath stringByAppendingString:@"/Cookies"];
        NSLog(@"%@", cookiesFolderPath);
        NSError *errors;
        [[NSFileManager defaultManager] removeItemAtPath:cookiesFolderPath error:&errors];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark -- Lazy Load
- (WKWebView *)webView {
    
    if (_webView == nil) {
        _webView = [[WKWebView alloc] initWithFrame:CGRectZero configuration:self.webConfig];
    }
    return _webView;
}

- (WKWebViewConfiguration *)webConfig {
    
    if (_webConfig == nil) {
        _webConfig = [[WKWebViewConfiguration alloc] init];
        // 设置偏好设置
        _webConfig.preferences = [[WKPreferences alloc] init];
        // 允许 JavaScript 交互
        _webConfig.preferences.javaScriptEnabled = YES;
        //_webConfig.preferences.minimumFontSize   = 10;
        // 在iOS上默认为NO，表示不能自动通过窗口打开
        _webConfig.preferences.javaScriptCanOpenWindowsAutomatically = NO;
        
        // web内容处理池，由于没有属性可以设置，也没有方法可以调用，不用手动创建
        _webConfig.processPool = [[WKProcessPool alloc] init];
        
//        WeakScriptMessageDelegate *weakScriptMessageDelegate = [[WeakScriptMessageDelegate alloc] initWithDelegate:self];
        // 通过JS与webview内容交互
        _webConfig.userContentController = [[WKUserContentController alloc] init];
        // 注入JS对象名称AppModel，当JS通过AppModel来调用时，
        // 我们可以在WKScriptMessageHandler代理中接收到
        // 添加注入js方法, oc与js端对应实现
//        [_webConfig.userContentController addScriptMessageHandler:weakScriptMessageDelegate name:kWKJS_LoginHandler_NAME];
//        [_webConfig.userContentController addScriptMessageHandler:weakScriptMessageDelegate name:kWKJS_OutLoginHandler_NAME];
//        [_webConfig.userContentController addScriptMessageHandler:weakScriptMessageDelegate name:kWKJS_ShareHandler_NAME];
//        [_webConfig.userContentController addScriptMessageHandler:weakScriptMessageDelegate name:kWKJS_ExitWebHandler_NAME];
//        [_webConfig.userContentController addScriptMessageHandler:weakScriptMessageDelegate name:kWKJS_AppNative_NAME];
    }
    return _webConfig;
}

- (UIProgressView *)progressView {
    
    if(_progressView == nil){
        _progressView = [[UIProgressView alloc] initWithProgressViewStyle:UIProgressViewStyleBar];
        _progressView.tintColor      = HEXColor(0xF5F5F5);
        _progressView.trackTintColor = HEXColor(0xF1F1F1);
    }
    return _progressView;
}

@end
