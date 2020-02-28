//
//  YPFontColorView.m
//  YPProject
//
//  Created by 幸福e家 on 2020/2/16.
//  Copyright © 2020 jzg. All rights reserved.
//

#import "YPFontColorView.h"
#import "UIButton+LXMImagePosition.h"
#import "YPFontSizeView.h"
#import "YPColorManagerView.h"

@interface YPFontColorView ()

/** 文字颜色选择 view */
@property (nonatomic, strong) UIView *fontColorNormalView;
@property (nonatomic, strong) UIButton *fontButton;
@property (nonatomic, strong) UIButton *colorButton;

/** 文字大小 view */
@property (nonatomic, strong) YPFontSizeView *fontView;
/** 颜色选择 view */
@property (nonatomic, strong) YPColorManagerView *colorView;

@end

@implementation YPFontColorView

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self setupSubView];
    }
    return self;
}

- (void)setupSubView {
    
    [self addSubview:self.fontColorNormalView];
    [self.fontColorNormalView addSubview:self.fontButton];
    [self.fontColorNormalView addSubview:self.colorButton];

    [self addSubview:self.fontView];
    [self addSubview:self.colorView];
    
    
    [self.fontColorNormalView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(self);
    }];
    
    [self.fontButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self.fontColorNormalView.mas_centerX).offset(-30);
        make.top.bottom.mas_equalTo(self.fontColorNormalView);
        make.width.mas_equalTo(60);
    }];
    
    [self.colorButton mas_makeConstraints:^(MASConstraintMaker *make) {
         make.left.mas_equalTo(self.fontColorNormalView.mas_centerX).offset(30);
         make.top.bottom.mas_equalTo(self.fontColorNormalView);
         make.width.mas_equalTo(60);
     }];
    
    [self.fontView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(self);
    }];
    
    [self.colorView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(self);
    }];
    
    
    [self setNeedsLayout];
    [self layoutIfNeeded];
    
    [self.fontButton setImagePosition:(LXMImagePositionLeft) spacing:8];
    [self.colorButton setImagePosition:(LXMImagePositionLeft) spacing:8];
}

- (void)setFontColorStatus:(YPFontColorStatus)fontColorStatus {
    
    _fontColorStatus = fontColorStatus;
    switch (_fontColorStatus) {
        case YPFontColorHidden:
            self.hidden = YES;
            break;
        case YPFontColorShowNormal:
            self.hidden       = NO;
            self.fontColorNormalView.hidden = NO;
            self.fontView.hidden            = YES;
            self.colorView.hidden           = YES;
            break;
        case YPFontColorShowFont:
            self.hidden       = NO;
            self.fontColorNormalView.hidden = YES;
            self.fontView.hidden            = NO;
            self.colorView.hidden           = YES;
            break;
        case YPFontColorShowColor:
            self.hidden       = NO;
            self.fontColorNormalView.hidden = YES;
            self.fontView.hidden            = YES;
            self.colorView.hidden           = NO;
            break;
        default:
            break;
    }
}

#pragma mark -- Click
- (void)fontClick:(UIButton *)sender {
    
    self.fontColorStatus = YPFontColorShowFont;
}

- (void)colorClick:(UIButton *)sender {
    
    self.fontColorStatus = YPFontColorShowColor;
}

#pragma mark -- Getter
-(UIView *)fontColorNormalView {
    
    if (_fontColorNormalView == nil) {
        _fontColorNormalView = [[UIView alloc] init];
    }
    return _fontColorNormalView;
}


-(UIButton *)fontButton {
    
    if (_fontButton == nil) {
        _fontButton = [UIButton buttonWithType:(UIButtonTypeCustom)];
        [_fontButton setTitle:@"大小" forState:(UIControlStateNormal)];
        [_fontButton setTitleColor:HEXColor(0x5D5D5D) forState:(UIControlStateNormal)];
        [_fontButton setImage:[UIImage imageNamed:@"icon_hb"] forState:(UIControlStateNormal)];
        [_fontButton addTarget:self action:@selector(fontClick:) forControlEvents:(UIControlEventTouchUpInside)];
        _fontButton.titleLabel.font = [UIFont systemFontOfSize:12];
    }
    return _fontButton;
}

-(UIButton *)colorButton {
    
    if (_colorButton == nil) {
        _colorButton = [UIButton buttonWithType:(UIButtonTypeCustom)];
        [_colorButton setTitle:@"颜色" forState:(UIControlStateNormal)];
        [_colorButton setTitleColor:HEXColor(0x5D5D5D) forState:(UIControlStateNormal)];
        [_colorButton setImage:[UIImage imageNamed:@"icon_ys"] forState:(UIControlStateNormal)];
        [_colorButton addTarget:self action:@selector(colorClick:) forControlEvents:(UIControlEventTouchUpInside)];
        _colorButton.titleLabel.font = [UIFont systemFontOfSize:12];
    }
    return _colorButton;
}

-(YPFontSizeView *)fontView {
    
    if (_fontView == nil) {
        _fontView = [YPFontSizeView viewFromXib];
        
        WeakSelf();
        [_fontView setTapBackClick:^{
            weakself.fontColorStatus = YPFontColorShowNormal;
        }];
    }
    return _fontView;
}

-(YPColorManagerView *)colorView {
    
    if (_colorView == nil) {
        _colorView = [YPColorManagerView viewFromXib];
        WeakSelf();
        [_colorView setTapBackClick:^{
            weakself.fontColorStatus = YPFontColorShowNormal;
        }];
    }
    return _colorView;
}


@end
