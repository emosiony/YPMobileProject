//
//  TGPlayerView.m
//  TGParent
//
//  Created by lwc on 2018/8/23.
//  Copyright © 2018年 jzg. All rights reserved.
//

#import "TGPlayerView.h"
#import <AFNetworking.h>

@interface TGPlayerView()

@property (nonatomic,strong) CLPlayerView *playerView;

@end

@implementation TGPlayerView

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    
    [self initPlayer];
    
    return self;
}

- (void)initPlayer{
    [self addSubview:self.playerView];
}

#pragma mark - publish
- (void)play{
    if (_playerView.url.absoluteString.length > 0) {
        [_playerView playVideo];
        return;
    }
    NSURLSessionDownloadTask * downloadTask = [[AFHTTPSessionManager manager] downloadTaskWithRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:self.videoUrl]] progress:nil destination:^NSURL * _Nonnull(NSURL * _Nonnull targetPath, NSURLResponse * _Nonnull response) {
        //文件的全路径
        NSString *fullpath = [[NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:response.suggestedFilename];
        NSURL *fileUrl = [NSURL fileURLWithPath:fullpath];
        NSLog(@"%@\n%@",targetPath,fullpath);
        return fileUrl;
    } completionHandler:^(NSURLResponse * _Nonnull response, NSURL * _Nullable filePath, NSError * _Nullable error) {
        _playerView.url = filePath;
        //播放
        [_playerView playVideo];
        NSLog(@"%@",filePath);
    }];
    [downloadTask resume];
}

- (CLPlayerState)state{
    return _playerView.state;
}

- (void)stop{
    if (_playerView) {
        [_playerView pausePlay];
    }
}

- (void)destroyPlayer{
    [_playerView destroyPlayer];
    _playerView = nil;
}

#pragma mark - getters
- (CLPlayerView *)playerView{
    if (!_playerView) {
        _playerView = [[CLPlayerView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenWidth * 9/16)];
        _playerView.isHiddenTopBar = YES;
        //根据旋转自动支持全屏，默认支持
        _playerView.autoFullScreen = NO;
        //如果播放器所在页面支持横屏，需要设置为Yes，不支持不需要设置(默认不支持)
        _playerView.isLandscape    = NO;
        _playerView.isfillMode     = YES;
        //设置等比例全屏拉伸，多余部分会被剪切
        _playerView.fillMode = ResizeAspectFill;
        __weak typeof(self) weakSelf = self;
        //播放完成回调
        [_playerView endPlay:^{
            weakSelf.playEndBlock ? weakSelf.playEndBlock() : nil;
            NSLog(@"播放完成");
        }];
    }
    return _playerView;
}

- (void)dealloc {
    if (_playerView) {
        //销毁播放器
        [_playerView destroyPlayer];
        _playerView = nil;
    }
}

@end
