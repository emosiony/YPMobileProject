
//
//  YPAppConfig.m
//  YPProject
//
//  Created by Jtg_yao on 2019/8/12.
//  Copyright © 2019 jzg. All rights reserved.
//

#import "YPAppConfig.h"

#define View_bg_Color       HEXColor(0xF3F3F3)
#define Nav_bg_Color        HEXColor(0x008FF2)
#define Bar_bg_Color        HEXColor(0xFFFFFF)
#define Bar_back_image      [UIImage imageNamed:@"back"]

#define BarItem_normalColor HEXColor(0x8C8C8C)
#define BarItem_selectColor HEXColor(0x333333)

#define Nav_Title_Font      [UIFont boldSystemFontOfSize:18.0f]
#define Nav_Title_Color     HEXColor(0xFFFFFF)

@implementation YPAppConfig

-(void)setConfigInit {
    
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
    
    [self setNavitionAndTabbarConfig];
    [self svpProgressInit];
}

// 设置 navigationBar 和 Tabbar
-(void)setNavitionAndTabbarConfig {
    
}

// 设置 SVPProgress 
-(void)svpProgressInit {
    [YPProgressHUD yp_hudDefaultInit];
}

#pragma mark -- Getter
-(UIColor *)navBgColor {
    if (_navBgColor == nil) {
        _navBgColor = Nav_bg_Color;
    }
    return _navBgColor;
}

-(UIFont *)navTitleFont {
    if (_navTitleFont == nil) {
        _navTitleFont = Nav_Title_Font;
    }
    return _navTitleFont;
}

-(UIColor *)navTitleColor {
    if (_navTitleColor == nil) {
        _navTitleColor = Nav_Title_Color;
    }
    return _navTitleColor;
}

- (UIImage *)backImage {
    if (_backImage == nil) {
        _backImage = Bar_back_image;
    }
    return _backImage;
}

-(UIColor *)viewBgColor {
    if (_viewBgColor == nil) {
        _viewBgColor = View_bg_Color;
    }
    return _viewBgColor;
}

-(UIColor *)tabbarBgColor {
    if (_tabbarBgColor == nil) {
        _tabbarBgColor = Bar_bg_Color;
    }
    return _tabbarBgColor;
}

-(UIColor *)tabbarItemNormalColor {
    if (_tabbarItemNormalColor == nil) {
        _tabbarItemNormalColor = BarItem_normalColor;
    }
    return _tabbarItemNormalColor;
}

-(UIColor *)tabbarItemSelectColor {
    if (_tabbarItemSelectColor == nil) {
        _tabbarItemSelectColor = BarItem_selectColor;
    }
    return _tabbarItemSelectColor;
}

KSingleToolM(Instance);
@end
