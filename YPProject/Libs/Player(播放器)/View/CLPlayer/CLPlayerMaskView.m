//
//  CLPlayerMaskView.m
//  CLPlayerDemo
//
//  Created by JmoVxia on 2017/2/24.
//  Copyright © 2017年 JmoVxia. All rights reserved.
//

#import "CLPlayerMaskView.h"
#import "CLSlider.h"

//间隙
#define Padding                 12 
//按钮间隙
#define btnPadding              8
//按钮宽度
#define btnWidth                40
//顶部间隙
#define topPadding              [UIApplication sharedApplication].statusBarFrame.size.height
//顶部工具条高度
#define ToolBarTopHeight        topPadding + 40
//底部工具条高度
#define ToolBarBottomHeight     40
//进度条颜色
#define ProgressColor           [UIColor whiteColor]
//缓冲颜色
#define ProgressTintColor       [UIColor lightGrayColor]
//播放完成颜色
#define PlayFinishColor         HEXColor(0x01A1ED)


@interface CLPlayerMaskView ()

@end

@implementation CLPlayerMaskView

- (void)dealloc{
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [[UIDevice currentDevice] endGeneratingDeviceOrientationNotifications];
}

-(instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self initViews];
    }
    return self;
}
- (void)initViews{
    [self addSubview:self.topToolBar];
    [self addSubview:self.bottomToolBar];
    [self addSubview:self.activity];
    [self.topToolBar addSubview:self.backButton];
//    [self.topToolBar addSubview:self.shutDownButton];
//    [self.topToolBar addSubview:self.shareButton];
    [self.bottomToolBar addSubview:self.playButton];
    [self.bottomToolBar addSubview:self.fullButton];
    [self.bottomToolBar addSubview:self.currentTimeLabel];
    [self.bottomToolBar addSubview:self.totalTimeLabel];
    [self.bottomToolBar addSubview:self.progress];
    [self.bottomToolBar addSubview:self.slider];
    [self addSubview:self.failButton];
    [self makeConstraints];
    
    UIColor *toolBgColor = [UIColor colorWithRed:0.00000f green:0.00000f blue:0.00000f alpha:0.50000f];
    self.topToolBar.backgroundColor    = toolBgColor;
    self.bottomToolBar.backgroundColor = toolBgColor;
    
    
    
    //开启和监听 设备旋转的通知（不开启的话，设备方向一直是UIInterfaceOrientationUnknown）
    if (![UIDevice currentDevice].generatesDeviceOrientationNotifications) {
        [[UIDevice currentDevice] beginGeneratingDeviceOrientationNotifications];
    }
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(handleDeviceOrientationChange:)
                                                name:UIDeviceOrientationDidChangeNotification object:nil];
}
#pragma mark - 约束
- (void)makeConstraints{
    
    //顶部工具条
    [self.topToolBar mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.equalTo(self);
        make.height.mas_equalTo(ToolBarTopHeight);
    }];
    //底部工具条
    [self .bottomToolBar mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self);
        make.height.mas_equalTo(ToolBarBottomHeight);
    }];
    //转子
    [self.activity mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self);
    }];
    //返回按钮
    [self.backButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(btnPadding);
        make.bottom.mas_equalTo(0);
        make.width.mas_equalTo(btnWidth);
        make.height.mas_equalTo(btnWidth);
    }];
    //关闭按钮
//    [self.shutDownButton mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.right.mas_equalTo(-50);
//        make.top.mas_equalTo(topPadding);
//        make.bottom.mas_equalTo(-btnPadding);
//        make.width.equalTo(self.backButton.mas_height);
//
//    }];
//    //分享按钮
//    [self.shareButton mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.right.mas_equalTo(-btnPadding);
//        make.top.mas_equalTo(topPadding);
//        make.bottom.mas_equalTo(-btnPadding);
//        make.width.equalTo(self.backButton.mas_height);
//
//    }];
    //播放按钮
    [self.playButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.mas_equalTo(0);
        make.bottom.mas_equalTo(0);
        make.width.mas_equalTo(ToolBarBottomHeight);
    }];
//    //全屏按钮
//    if (_showFullButton) {
//        [self.fullButton mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.right.bottom.mas_equalTo(-btnPadding);
//            make.top.mas_equalTo(btnPadding);
//            make.width.mas_equalTo(ToolBarBottomHeight-btnPadding*2);
//        }];
//    }
    //当前播放时间
    [self.currentTimeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.playButton.mas_right).offset(Padding);
        make.width.mas_equalTo(35);
        make.centerY.equalTo(self.bottomToolBar);
    }];
    //总时间
    [self.totalTimeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-btnPadding);
        make.width.mas_equalTo(35);
        make.centerY.equalTo(self.bottomToolBar);
    }];
    //缓冲条
    [self.progress mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.currentTimeLabel.mas_right).offset(Padding);
        make.right.equalTo(self.totalTimeLabel.mas_left).offset(-Padding);
        make.height.mas_equalTo(2);
        make.centerY.equalTo(self.bottomToolBar);
    }];
    //滑杆
    [self.slider mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.progress);
    }];
    //失败按钮
    [self.failButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self);
    }];
}

-(void)setShowFullButton:(BOOL)showFullButton {
    
    _showFullButton = showFullButton;
    if (_showFullButton) {
        
        self.fullButton.hidden = NO;
        
        [self.fullButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.bottom.mas_equalTo(-btnPadding);
            make.top.mas_equalTo(btnPadding);
            make.width.mas_equalTo(ToolBarBottomHeight-btnPadding*2);
        }];
        
        //总时间
        [self.totalTimeLabel mas_updateConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self.fullButton.mas_left).offset(-Padding);
        }];
    } else {
        self.fullButton.hidden = YES;
        //总时间
        [self.totalTimeLabel mas_updateConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(-btnPadding);
        }];
    }
}

#pragma mark - 懒加载
//顶部工具条
- (UIView *) topToolBar{
    if (_topToolBar == nil){
        _topToolBar = [[UIView alloc] init];
        _topToolBar.userInteractionEnabled = YES;
    }
    return _topToolBar;
}
//底部工具条
- (UIView *) bottomToolBar{
    if (_bottomToolBar == nil){
        _bottomToolBar = [[UIView alloc] init];
        _bottomToolBar.userInteractionEnabled = YES;
    }
    return _bottomToolBar;
}
//转子
- (UIActivityIndicatorView *) activity{
    if (_activity == nil){
        _activity = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
        [_activity startAnimating];
    }
    return _activity;
}
//返回按钮
- (UIButton *) backButton{
    if (_backButton == nil){
        _backButton = [[UIButton alloc] init];
        [_backButton setImage:[UIImage imageNamed:@"icon_close_white"] forState:UIControlStateNormal];
        [_backButton setImage:[UIImage imageNamed:@"icon_close_white"] forState:UIControlStateHighlighted];
        [_backButton addTarget:self action:@selector(backButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _backButton;
}
////关闭按钮
//- (UIButton *) shutDownButton{
//    if (_shutDownButton == nil){
//        _shutDownButton = [[UIButton alloc] init];
//        [_shutDownButton setImage:[UIImage imageNamed:@"back_normal"] forState:UIControlStateNormal];
//        [_shutDownButton setImage:[UIImage imageNamed:@"back_normal"] forState:UIControlStateSelected];
//        [_shutDownButton addTarget:self action:@selector(shutDownButtonAction:) forControlEvents:UIControlEventTouchUpInside];
//    }
//    return _shutDownButton;
//}
////分享按钮
//- (UIButton *) shareButton{
//    if (_shareButton == nil){
//        _shareButton = [[UIButton alloc] init];
//        [_shareButton setImage:[UIImage imageNamed:@"back_normal"] forState:UIControlStateNormal];
//        [_shareButton setImage:[UIImage imageNamed:@"back_normal"] forState:UIControlStateSelected];
//        [_shareButton addTarget:self action:@selector(shareButtonAction:) forControlEvents:UIControlEventTouchUpInside];
//    }
//    return _shareButton;
//}
//播放按钮
- (UIButton *) playButton{
    if (_playButton == nil){
        _playButton = [[UIButton alloc] init];
        [_playButton setImage:[UIImage imageNamed:@"CLPlayBtn"] forState:UIControlStateNormal];
        [_playButton setImage:[UIImage imageNamed:@"CLPauseBtn"] forState:UIControlStateSelected];
        [_playButton addTarget:self action:@selector(playButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _playButton;
}
//全屏按钮
- (UIButton *) fullButton{
    if (_fullButton == nil){
        _fullButton = [[UIButton alloc] init];
        [_fullButton setImage:[self getPictureWithName:@"CLMaxBtn"] forState:UIControlStateNormal];
        [_fullButton setImage:[self getPictureWithName:@"CLMinBtn"] forState:UIControlStateSelected];
        [_fullButton addTarget:self action:@selector(fullButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _fullButton;
}
//当前播放时间
- (UILabel *) currentTimeLabel{
    if (_currentTimeLabel == nil){
        _currentTimeLabel = [[UILabel alloc] init];
        _currentTimeLabel.textColor = [UIColor whiteColor];
        _currentTimeLabel.font      = [UIFont systemFontOfSize:12];
        _currentTimeLabel.text      = @"00:00";
        _currentTimeLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _currentTimeLabel;
}
//总时间
- (UILabel *) totalTimeLabel{
    if (_totalTimeLabel == nil){
        _totalTimeLabel = [[UILabel alloc] init];
        _totalTimeLabel.textColor = [UIColor whiteColor];
        _totalTimeLabel.font      = [UIFont systemFontOfSize:12];
        _totalTimeLabel.text      = @"00:00";
        _totalTimeLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _totalTimeLabel;
}
//缓冲条
- (UIProgressView *) progress{
    if (_progress == nil){
        _progress = [[UIProgressView alloc] init];
        _progress.trackTintColor = ProgressColor;
        _progress.progressTintColor = ProgressTintColor;
    }
    return _progress;
}
//滑动条
- (CLSlider *) slider{
    if (_slider == nil){
        _slider = [[CLSlider alloc] init];
        // slider开始滑动事件
        [_slider addTarget:self action:@selector(progressSliderTouchBegan:) forControlEvents:UIControlEventTouchDown];
        // slider滑动中事件
        [_slider addTarget:self action:@selector(progressSliderValueChanged:) forControlEvents:UIControlEventValueChanged];
        // slider结束滑动事件
        [_slider addTarget:self action:@selector(progressSliderTouchEnded:) forControlEvents:UIControlEventTouchUpInside | UIControlEventTouchCancel | UIControlEventTouchUpOutside];
        //左边颜色
        _slider.minimumTrackTintColor = PlayFinishColor;
        //右边颜色
        _slider.maximumTrackTintColor = [UIColor clearColor];
    }
    return _slider;
}
//加载失败按钮
- (UIButton *) failButton
{
    if (_failButton == nil) {
        _failButton = [[UIButton alloc] init];
        _failButton.hidden = YES;
        [_failButton setTitle:@"加载失败,点击重试" forState:UIControlStateNormal];
        [_failButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _failButton.titleLabel.font = [UIFont systemFontOfSize:14.0];
        _failButton.backgroundColor = [UIColor colorWithRed:0.00000f green:0.00000f blue:0.00000f alpha:0.50000f];
        [_failButton addTarget:self action:@selector(failButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _failButton;
}

#pragma mark - 按钮点击事件
//返回按钮
- (void)backButtonAction:(UIButton *)button{
    if (_delegate && [_delegate respondsToSelector:@selector(cl_backButtonAction:)]) {
        [_delegate cl_backButtonAction:button];
    }else{
        NSLog(@"没有实现代理或者没有设置代理人");
    }
}
//分享按钮
//- (void)shutDownButtonAction:(UIButton *)button{
//    button.selected = !button.selected;
//    if (_delegate && [_delegate respondsToSelector:@selector(cl_shutDownButtonAction:)]) {
//        [_delegate cl_shutDownButtonAction:button];
//    }else{
//        NSLog(@"没有实现代理或者没有设置代理人");
//    }
//}
////分享按钮shutDownButton
//- (void)shareButtonAction:(UIButton *)button{
//    button.selected = !button.selected;
//    if (_delegate && [_delegate respondsToSelector:@selector(cl_shareButtonAction:)]) {
//        [_delegate cl_shareButtonAction:button];
//    }else{
//        NSLog(@"没有实现代理或者没有设置代理人");
//    }
//}
//播放按钮
- (void)playButtonAction:(UIButton *)button{
    button.selected = !button.selected;
    if (_delegate && [_delegate respondsToSelector:@selector(cl_playButtonAction:)]) {
        [_delegate cl_playButtonAction:button];
    }else{
        NSLog(@"没有实现代理或者没有设置代理人");
    }
}
//全屏按钮
- (void)fullButtonAction:(UIButton *)button{
    button.selected = !button.selected;
    if (_delegate && [_delegate respondsToSelector:@selector(cl_fullButtonAction:)]) {
        [_delegate cl_fullButtonAction:button];
    }else{
        NSLog(@"没有实现代理或者没有设置代理人");
    }
}
//失败按钮
- (void)failButtonAction:(UIButton *)button{
    self.failButton.hidden = YES;
    [self.activity startAnimating];
    if (_delegate && [_delegate respondsToSelector:@selector(cl_failButtonAction:)]) {
        [_delegate cl_failButtonAction:button];
    }else{
        NSLog(@"没有实现代理或者没有设置代理人");
    }
}
#pragma mark - 滑杆
//开始滑动
- (void)progressSliderTouchBegan:(CLSlider *)slider{
    if (_delegate && [_delegate respondsToSelector:@selector(cl_progressSliderTouchBegan:)]) {
        [_delegate cl_progressSliderTouchBegan:slider];
    }else{
        NSLog(@"没有实现代理或者没有设置代理人");
    }
}
//滑动中
- (void)progressSliderValueChanged:(CLSlider *)slider{
    if (_delegate && [_delegate respondsToSelector:@selector(cl_progressSliderValueChanged:)]) {
        [_delegate cl_progressSliderValueChanged:slider];
    }else{
        NSLog(@"没有实现代理或者没有设置代理人");
    }
}
//滑动结束
- (void)progressSliderTouchEnded:(CLSlider *)slider{
    if (_delegate && [_delegate respondsToSelector:@selector(cl_progressSliderTouchEnded:)]) {
        [_delegate cl_progressSliderTouchEnded:slider];
    }else{
        NSLog(@"没有实现代理或者没有设置代理人");
    }
}
#pragma mark - 获取资源图片
- (UIImage *)getPictureWithName:(NSString *)name{
    NSBundle *bundle = [NSBundle bundleWithPath:[[NSBundle mainBundle] pathForResource:@"CLPlayer" ofType:@"bundle"]];
    NSString *path   = [bundle pathForResource:name ofType:@"png"];
    return [UIImage imageWithContentsOfFile:path];
}

//设备方向改变的处理
- (void)handleDeviceOrientationChange:(NSNotification *)notification{
    UIDeviceOrientation deviceOrientation = [UIDevice currentDevice].orientation;
    switch (deviceOrientation) {
            
        case UIDeviceOrientationUnknown:
            NSLog(@"未知方向");
            break;
        case UIDeviceOrientationFaceUp:
//            NSLog(@"屏幕朝上平躺");
            break;
        case UIDeviceOrientationFaceDown:
//            NSLog(@"屏幕朝下平躺");
            break;
        case UIDeviceOrientationLandscapeLeft:
//            NSLog(@"屏幕向左横置");
        case UIDeviceOrientationLandscapeRight:
//            NSLog(@"屏幕向右橫置");
            [self.topToolBar mas_updateConstraints:^(MASConstraintMaker *make) {
                make.height.mas_equalTo(44);
            }];
            break;
        case UIDeviceOrientationPortrait:
//            NSLog(@"屏幕直立");
        case UIDeviceOrientationPortraitUpsideDown:
//            NSLog(@"屏幕直立，上下顛倒");
            [self.topToolBar mas_updateConstraints:^(MASConstraintMaker *make) {
                make.height.mas_equalTo(ToolBarTopHeight);
            }];
            break;
        default:
            NSLog(@"无法辨识");
            break;
    }
}

@end
