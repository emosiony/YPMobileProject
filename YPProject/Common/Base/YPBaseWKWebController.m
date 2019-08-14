
//
//  YPBaseWKWebController.m
//  YPProject
//
//  Created by Jtg_yao on 2019/8/14.
//  Copyright © 2019 jzg. All rights reserved.
//

#import "YPBaseWKWebController.h"
#import "DeviceInfo.h"

#define kSCRIPT_MESSAGE_NAME @"AppModel"

#define kDefault_Progress_HEIGHT  3
#define kDefault_Progress_Color   HEXColor(0x556281)

@interface YPBaseWKWebController ()

/** 进度条 */
@property (nonatomic, strong) UIProgressView *progressView;

@end

@implementation YPBaseWKWebController

- (void)dealloc {
    
    [self.webView removeObserver:self forKeyPath:@"loading"];
    [self.webView removeObserver:self forKeyPath:@"title"];
    [self.webView removeObserver:self forKeyPath:@"estimatedProgress"];
}

- (instancetype)init
{
    if (self = [super init]) {
        
        self.progressHeight = kDefault_Progress_HEIGHT;
        self.progressColor  = kDefault_Progress_Color;
        
        self.edgesForExtendedLayout = UIRectEdgeNone;
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self WKSetUpSubviews];
}

- (void)WKSetUpSubviews {
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self.view addSubview:self.progressView];
    [self.view addSubview:self.webView];
    
    [self.progressView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.mas_offset(self.view);
        make.height.mas_equalTo(self.progressHeight);
    }];
    
    [self.webView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.progressView.mas_bottom);
        make.left.bottom.right.mas_equalTo(self.view);
    }];
}

-(void)WKDataInit {
    
    if (@available(iOS 12.0, *)) {
        NSString *baseAgent = [self.webView valueForKey:@"applicationNameForUserAgent"];
        NSString *newUserAgent = [baseAgent stringByAppendingString:@"TGTeacher"];
        [self.webView setValue:newUserAgent forKey:@"applicationNameForUserAgent"];
    }
    
    __weak typeof(self) weakSelf = self;
    [self.webView evaluateJavaScript:@"navigator.userAgent" completionHandler:^(id _Nullable result, NSError * _Nullable error) {
        
        __strong typeof (weakSelf) strongSelf = weakSelf;
        NSString *userAgent = result;
        NSString *device    = [@" TGTeacher/" stringByAppendingFormat:@"%@ onApp/1", [DeviceInfo getAppSystemVersion]];
        if ([userAgent rangeOfString:device].location == NSNotFound) {
            userAgent = [userAgent stringByAppendingString:device];
        }
        
        NSDictionary *dictionary = [NSDictionary dictionaryWithObjectsAndKeys:userAgent, @"UserAgent", nil];
        if (@available(iOS 9.0 , *)) {
            [strongSelf.webView setCustomUserAgent:userAgent];
        } else {
            [strongSelf.webView setValue:userAgent forKey:@"applicationNameForUserAgent"];
        }
        [[NSUserDefaults standardUserDefaults] registerDefaults:dictionary];

        [strongSelf loadWebRequest];
    }];
}

-(void)loadWebRequest {
    
    NSURL *url = [NSURL URLWithString:_url];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
//    NSString *cookie = [self readCurrentCookie];
//    [request addValue:cookie forHTTPHeaderField:@"Cookie"];
    [request addValue:@"iphone" forHTTPHeaderField:@"device"];
    [request addValue:@"1" forHTTPHeaderField:@"hasOpenUrl"];
    [request addValue:@"TGTeacher" forHTTPHeaderField:@"port"];
    [self.webView loadRequest:request];
    
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

#pragma mark - KVO
- (void)observeValueForKeyPath:(NSString *)keyPath
                      ofObject:(id)object
                        change:(NSDictionary<NSString *,id> *)change
                       context:(void *)context
{
    if ([keyPath isEqualToString:@"title"]) {
        
        NSString *webTitle = [change objectForKey:NSKeyValueChangeNewKey];
        webTitle = strIsEmpty(webTitle) ? (strIsEmpty(self.title) ? @"" : self.title) : webTitle;
        self.title = webTitle;
    } else if ([keyPath isEqualToString:@"loading"]) {
        [self.view setNeedsUpdateConstraints];
        [self.view updateConstraintsIfNeeded];
        [UIView animateWithDuration:0.5 animations:^{
            [self.view layoutIfNeeded];
        }];
    }  else if ([keyPath isEqualToString:@"estimatedProgress"]) {
        
        double progress = [[change objectForKey:NSKeyValueChangeNewKey] doubleValue];
        self.progressView.progress = progress;
        [self.view setNeedsUpdateConstraints];
        [self.view updateConstraintsIfNeeded];
        
        if (progress >= 1.0f) {
           
            __weak typeof(self) weakSelf = self;
            [UIView animateWithDuration:0.8 animations:^{
                [weakSelf.view layoutIfNeeded];
            } completion:^(BOOL finished) {
                weakSelf.progressView.hidden = YES;
                weakSelf.progressView.transform = CGAffineTransformMakeScale(1.0f, 1.0f);
                [weakSelf.view setNeedsUpdateConstraints];
                [weakSelf.view updateConstraintsIfNeeded];
            }];
        } else {
            if (self.progressView.isHidden) {
                __weak typeof(self) weakSelf = self;
                [UIView animateWithDuration:0.25 animations:^{
                    [weakSelf.view layoutIfNeeded];
                } completion:^(BOOL finished) {
                    weakSelf.progressView.hidden = NO; 
                    [weakSelf.progressView mas_updateConstraints:^(MASConstraintMaker *make) {
                        make.height.mas_equalTo(weakSelf.progressHeight);
                    }];
                    [weakSelf.view setNeedsUpdateConstraints];
                    [weakSelf.view updateConstraintsIfNeeded];
                }];
            }
        }
    }
}

#pragma mark -- Action
- (void)backPrevious{
    if (self.webView.canGoBack) {
        [self.webView goBack];
    }else{
        [self.navigationController popViewControllerAnimated:YES];
    }
}

- (void)backNative{
    [self.navigationController popViewControllerAnimated:YES];
}


#pragma mark -- Delegate


#pragma mark - WKScriptMessageHandler
- (void)userContentController:(WKUserContentController *)userContentController
      didReceiveScriptMessage:(WKScriptMessage *)message {
    if ([message.name isEqualToString:@"AppModel"]) {
        DLog(@"%@", message.body);
        if ([message.body[@"method"]isEqualToString:@"navBackClick"]) {
            [self backPrevious];
        } else if ([message.body[@"method"]isEqualToString:@"navDismissClick"]) {
            [self dismissViewControllerAnimated:YES completion:nil];
        }
    } else {
        DLog(@"%@", message.body);
    }
}

#pragma mark - WKNavigationDelegate
// 在JS端调用alert函数时，会触发此代理方法。
// JS端调用alert时所传的数据可以通过message拿到
// 在原生得到结果后，需要回调JS，是通过completionHandler回调
- (void)webView:(WKWebView *)webView runJavaScriptAlertPanelWithMessage:(NSString *)message initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(void))completionHandler {
    NSLog(@"%s", __FUNCTION__);
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:message preferredStyle:UIAlertControllerStyleAlert];
    [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        completionHandler();
    }]];
    
    [self presentViewController:alert animated:YES completion:NULL];
    NSLog(@"%@", message);
}

// JS端调用confirm函数时，会触发此方法
// 通过message可以拿到JS端所传的数据
// 在iOS端显示原生alert得到YES/NO后
// 通过completionHandler回调给JS端
- (void)webView:(WKWebView *)webView runJavaScriptConfirmPanelWithMessage:(NSString *)message initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(BOOL result))completionHandler {
    NSLog(@"%s", __FUNCTION__);
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:message preferredStyle:UIAlertControllerStyleAlert];
    [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        completionHandler(YES);
    }]];
    [alert addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        completionHandler(NO);
    }]];
    [self presentViewController:alert animated:YES completion:NULL];
    
    NSLog(@"%@", message);
}

// JS端调用prompt函数时，会触发此方法
// 要求输入一段文本
// 在原生输入得到文本内容后，通过completionHandler回调给JS
- (void)webView:(WKWebView *)webView runJavaScriptTextInputPanelWithPrompt:(NSString *)prompt defaultText:(nullable NSString *)defaultText initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(NSString * __nullable result))completionHandler {
    NSLog(@"%s", __FUNCTION__);
    
    NSLog(@"%@", prompt);
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
// 请求开始前，会先调用此代理方法
// 与UIWebView的
// - (BOOL)webView:(UIWebView *)webView
// shouldStartLoadWithRequest:(NSURLRequest *)request
// navigationType:(UIWebViewNavigationType)navigationType;
// 类型，在请求先判断能不能跳转（请求）
- (void)webView:(WKWebView *)webView decidePolicyForNavigationAction:(WKNavigationAction *)navigationAction decisionHandler:(void (^)(WKNavigationActionPolicy))decisionHandler {
    NSLog(@"%s,", __FUNCTION__);
    NSLog(@"decidePolicyForNavigationResponse == %@, %@", [webView.URL absoluteString], navigationAction.request.URL.absoluteString);
    
    NSString * url = navigationAction.request.URL.absoluteString;
    if ([url hasPrefix:@"sms:"] ||
        [url hasPrefix:@"tel:"] ||
        [url containsString:@"//itunes.apple.com/"]) {
        UIApplication * app = [UIApplication sharedApplication];
//        if ([url hasPrefix:kOUT_CALL_HOST]) {
//            [TGAppCallManager callOutFromInfo:url complete:self.reloadCurrentBlock];
//        } else
        if ([app canOpenURL:[NSURL URLWithString:url]]) {
            [app openURL:[NSURL URLWithString:url]];
        } else {
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:url] options:[NSDictionary dictionary] completionHandler:nil];
        }
        decisionHandler(WKNavigationActionPolicyCancel);
    } else {
        decisionHandler(WKNavigationActionPolicyAllow);
    }
}

// 在响应完成时，会回调此方法
// 如果设置为不允许响应，web内容就不会传过来
- (void)webView:(WKWebView *)webView decidePolicyForNavigationResponse:(WKNavigationResponse *)navigationResponse decisionHandler:(void (^)(WKNavigationResponsePolicy))decisionHandler {
    decisionHandler(WKNavigationResponsePolicyAllow);
    NSLog(@"%s,", __FUNCTION__);
    NSLog(@"decidePolicyForNavigationResponse == %@,", [webView.URL absoluteString]);
}

// 开始导航跳转时会回调
- (void)webView:(WKWebView *)webView didStartProvisionalNavigation:(null_unspecified WKNavigation *)navigation {
    NSLog(@"%s", __FUNCTION__);
    NSLog(@"didStartProvisionalNavigation == %@,", [webView.URL absoluteString]);
}


// 接收到重定向时会回调
- (void)webView:(WKWebView *)webView didReceiveServerRedirectForProvisionalNavigation:(null_unspecified WKNavigation *)navigation {
    NSLog(@"%s %@", __FUNCTION__, webView.URL.absoluteString);
}

// 导航失败时会回调
- (void)webView:(WKWebView *)webView didFailProvisionalNavigation:(null_unspecified WKNavigation *)navigation withError:(NSError *)error {
    NSLog(@"%s", __FUNCTION__);
    if (error.code == NSURLErrorNotConnectedToInternet) {
        NSString *errorDesc = [self errorTipHandleWithCode:error.code];
        [SVProgressHUD showErrorWithStatus:errorDesc];
        dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC));
        dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
            [SVProgressHUD dismiss];
            [self.navigationController popViewControllerAnimated:YES];
        });
    }
}


#pragma mark -- Getter
-(WKWebViewConfiguration *)webConfig {
    
    if (_webConfig == nil) {
        
        _webConfig = [[WKWebViewConfiguration alloc] init];
        // 设置偏好设置
        _webConfig.preferences = [[WKPreferences alloc] init];
        // 默认为0 兼容IOS11
        //config.preferences.minimumFontSize = 10;
        // 默认认为YES
        _webConfig.preferences.javaScriptEnabled = YES;
        // 在iOS上默认为NO，表示不能自动通过窗口打开
        _webConfig.preferences.javaScriptCanOpenWindowsAutomatically = NO;
        // web内容处理池，由于没有属性可以设置，也没有方法可以调用，不用手动创建
        _webConfig.processPool = [[WKProcessPool alloc] init];
        // 通过JS与webview内容交互
        _webConfig.userContentController = [[WKUserContentController alloc] init];
        // 注入JS对象名称AppModel，当JS通过AppModel来调用时，
        // 我们可以在WKScriptMessageHandler代理中接收到
        [_webConfig.userContentController addScriptMessageHandler:self name:kSCRIPT_MESSAGE_NAME];
    }
    return _webConfig;
}

- (WKWebView *)webView {
    
    if(_webView == nil) {
        
        _webView = [[WKWebView alloc] initWithFrame:CGRectZero
                                      configuration:self.webConfig];
        _webView.navigationDelegate = self;
        _webView.UIDelegate = self;
        _webView.scrollView.delegate = self;
    }
    return _webView;
}

- (UIProgressView *)progressView {
    
    if(_progressView == nil) {
        
        _progressView = [[UIProgressView alloc] initWithProgressViewStyle:UIProgressViewStyleBar];
        _progressView.tintColor      = self.progressColor;
        _progressView.trackTintColor = HEXColor(0xF1F1F1);
    }
    return _progressView;
}

@end
