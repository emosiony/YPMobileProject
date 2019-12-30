//
//  CLPlayerViewController.m
//  AllFunctionSet
//
//  Created by 姚敦鹏 on 2017/8/24.
//  Copyright © 2017年 Encifang. All rights reserved.
//

#import "CLPlayerViewController.h"
#import "UINavigationController+FDFullscreenPopGesture.h"
#import "CLPlayerView.h"
#import "NSString+Common.h"
#import <AFNetworking.h>

@interface CLPlayerViewController ()

@property (atomic, strong) NSURL *url;
@property (nonatomic,weak) CLPlayerView *playerView;
@property (strong, nonatomic) NSURLSessionDownloadTask *downloadTask;

@end

@implementation CLPlayerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self initPlayView];
}

- (void)viewWillAppear:(BOOL)animated{ 
    [super viewWillAppear:animated];
    self.fd_interactivePopDisabled = YES;
    [self.playerView playVideo];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    self.fd_interactivePopDisabled = NO;
    [self.playerView pausePlay];
}

- (void)initPlayView {
    
    CLPlayerView *playerView = [[CLPlayerView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)];
    _playerView = playerView;
    [self.view addSubview:_playerView];
    
    //根据旋转自动支持全屏，默认支持
    _playerView.autoFullScreen = NO;
    //如果播放器所在页面支持横屏，需要设置为Yes，不支持不需要设置(默认不支持)
    _playerView.isLandscape    = NO;
    //设置等比例全屏拉伸，多余部分会被剪切
    _playerView.fillMode = ResizeAspect;
    
    __weak typeof(self) weakSelf = self;
    //返回按钮点击事件回调
    [_playerView backButton:^(UIButton *button) {
        [SVProgressHUD dismiss];
        [weakSelf.downloadTask cancel];
        
        [weakSelf.navigationController popViewControllerAnimated:YES];
        [weakSelf dismissViewControllerAnimated:YES completion:nil];
        
        //销毁播放器
        [weakSelf.playerView destroyPlayer];
        weakSelf.playerView = nil;
    }];
    
    //下载失败，点击播放重试
    [_playerView setClickPalyBlock:^{
        if (weakSelf.url.absoluteString.length == 0) {
            [weakSelf downLoadAndPlay];
        }
    }];
    [self setPlayStart];
}

-(void)setPlayStart {
    
    NSString *url = [self getLocalVideoURL:self.videoUrl];
    if (strIsEmpty(url)) {
        if ([_videoUrl hasPrefix:@"http"]) {
            if (![AFNetworkReachabilityManager sharedManager].isReachableViaWiFi) {
                [_playerView setProgressValue:0];
                [SVProgressHUD showImage:nil status:@"您正在使用非WiFi网络，播放将消耗您的流量"];
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    [SVProgressHUD dismiss];
                    [self downLoadAndPlay];
                });
            } else {
                [self downLoadAndPlay];
            }
        } else {
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                _url = [NSURL fileURLWithPath:self.videoUrl];
                _playerView.url = _url;
                //播放
                [_playerView playVideo];
            });
        }
    } else {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            _url = [NSURL fileURLWithPath:url];
            _playerView.url = _url;
            //播放
            [_playerView playVideo];
        });
    }
}

-(void)downLoadAndPlay {
    [_playerView setProgressValue:0];
    
    _downloadTask = [[AFHTTPSessionManager manager] downloadTaskWithRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:self.videoUrl]] progress:^(NSProgress * _Nonnull downloadProgress) {
        [_playerView setProgressValue:downloadProgress.fractionCompleted];
    } destination:^NSURL * _Nonnull(NSURL * _Nonnull targetPath, NSURLResponse * _Nonnull response) {
        //文件的全路径
        NSString *fullpath = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject] stringByAppendingPathComponent:response.suggestedFilename];
        if (![[fullpath lastPathComponent] hasSuffix:@"."]) {
            fullpath = [fullpath stringByAppendingFormat:@".mp4"];
        }
        NSURL *fileUrl = [NSURL fileURLWithPath:fullpath];
        NSLog(@"%@\n%@",targetPath,fullpath);
        return fileUrl;
    } completionHandler:^(NSURLResponse * _Nonnull response, NSURL * _Nullable filePath, NSError * _Nullable error) {
        [_playerView setProgressValue:1.0f];
        //手动取消
        if (error.code == -999) return;
        
        if (error) {
            [SVProgressHUD showErrorWithStatus:@"网络繁忙，请检查重试"];
            [_playerView pausePlay];
        }else{
            
            [self saveLocalVideoURL:filePath.path hostVideoURL:self.videoUrl];
            _playerView.url = filePath;
            _url = filePath;
            //播放
            [_playerView playVideo];
            NSLog(@"%@",filePath);
        }
    }];
    [_downloadTask resume];
}

- (void)dealloc {
    //销毁播放器
    [_playerView destroyPlayer];
    _playerView = nil;
}

- (NSString *)getLocalVideoURL:(NSString *)hostVideoURL {
    
    NSString *hostURLMD5 = [hostVideoURL md5];
    NSString *videoUrl = [[NSUserDefaults standardUserDefaults] objectForKey:hostURLMD5];
    if (videoUrl.length > 0) {
        NSData *data = [NSData dataWithContentsOfFile:videoUrl];
        if (data == nil || data.length <= 0) {
            return @"";
        }
        return videoUrl;
    }else{
        return @"";
    }
}


- (void)saveLocalVideoURL:(NSString *)localURL hostVideoURL:(NSString *)hostVideoURL {
    
    NSString *hostURLMD5 = [hostVideoURL md5];
    [[NSUserDefaults standardUserDefaults] setObject:localURL forKey:hostURLMD5];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
