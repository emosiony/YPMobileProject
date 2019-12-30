//
//  PlayerView.h
//  CLPlayerDemo
//
//  Created by JmoVxia on 2016/11/1.
//  Copyright © 2016年 JmoVxia. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger,VideoFillMode){
    Resize = 0,          //拉伸占满整个播放器，不按原比例拉伸
    ResizeAspect,        //按原视频比例显示，是竖屏的就显示出竖屏的，两边留黑
    ResizeAspectFill,    //按照原比例拉伸占满整个播放器，但视频内容超出部分会被剪切
};

// 播放器的几种状态
typedef NS_ENUM(NSInteger, CLPlayerState) {
    CLPlayerStateFailed,     // 播放失败
    CLPlayerStateBuffering,  // 缓冲中
    CLPlayerStatePlaying,    // 播放中
    CLPlayerStateStopped,    // 停止播放
    CLPlayerStatePause       // 暂停播放
};

typedef void(^BackButtonBlock)(UIButton *button);
typedef void(^ShutDownButtonBlock)(UIButton *button);
typedef void(^ShareButtonBlock)(UIButton *button);

typedef void(^EndBolck)();
typedef void(^BeyondBlock)();

@interface CLPlayerView : UIView

/**视频url*/
@property (nonatomic,strong) NSURL *url;
/**旋转自动全屏，默认Yes*/
@property (nonatomic,assign) BOOL autoFullScreen;
/**重复播放，默认No*/
@property (nonatomic,assign) BOOL repeatPlay;
/**是否支持横屏，默认No*/
@property (nonatomic,assign) BOOL isLandscape;
/** 是否隐藏顶部按钮 */
@property (nonatomic,assign) BOOL isHiddenTopBar;
/** 加载进度 */
@property (nonatomic,assign) double progressValue;
/** 播发器的几种状态 */
@property (nonatomic,assign) CLPlayerState state;
/**拉伸方式，默认全屏填充*/
@property (nonatomic,assign) VideoFillMode fillMode;
/** 是否展示全屏点击按钮 */
@property (nonatomic,assign) BOOL isfillMode;
/**顶部工具条返回按钮*/
@property (nonatomic,strong) UIButton *backButton;
/**点击播放回调*/
@property (nonatomic,copy) void(^clickPalyBlock)();

/**播放*/
- (void)playVideo;
/**暂停*/
- (void)pausePlay;
/**返回按钮回调方法*/
- (void)backButton:(BackButtonBlock) backButton;
/**播放完成回调*/
- (void)endPlay:(EndBolck) end;
/**销毁播放器*/
- (void)destroyPlayer;

/**
 根据播放器所在位置计算偏移，添加在TableView上使用
 
 @param tableView tableView
 @param cell 播放器所在cell
 */
- (void)calculateScrollOffset:(UITableView *)tableView cell:(UITableViewCell *)cell;

- (void)setState:(CLPlayerState)state;

@end
