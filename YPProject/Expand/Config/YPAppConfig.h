//
//  YPAppConfig.h
//  YPProject
//
//  Created by Jtg_yao on 2019/8/12.
//  Copyright © 2019 jzg. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface YPAppConfig : NSObject

/**
 全局配置 -- 需要手动配置
 1、比如说 全局 APP导航颜色、tabbar item 颜色、以及一些第三方等配置、全局背景颜色等
*/
-(void)setConfigInit;


#pragma mark -- 获取全局属性 -- 基本的配置
#pragma mark -- 导航栏
/** 全局导航栏颜色 */
@property (nonatomic, strong) UIColor *navBgColor;
/** 导航栏背景图片 */
@property (nonatomic, strong) UIColor *navBgImage;
/** title字体颜色 */
@property (nonatomic, strong) UIColor *navTitleColor;
/** title字体 大小 */
@property (nonatomic, strong) UIFont  *navTitleFont;
/** 返回按钮图片 */
@property (nonatomic, strong) UIImage *backImage;

#pragma mark -- controller
/** 控制器背景颜色 */
@property (nonatomic, strong) UIColor *viewBgColor;

#pragma mark -- 底部菜单栏
/** tabbar 背景图片 */
@property (nonatomic, strong) UIImage   *tabbarImage;
/** tabbar 背景颜色 */
@property (nonatomic, strong) UIColor   *tabbarBgColor;
/** tabbar 未选中颜色 */
@property (nonatomic, strong) UIColor   *tabbarItemNormalColor;
/** tabbar 选择颜色 */
@property (nonatomic, strong) UIColor   *tabbarItemSelectColor;

KSingleToolH(Instance);
@end

NS_ASSUME_NONNULL_END
