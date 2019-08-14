//
//  UIColor+Extension.h
//  YPProject
//
//  Created by Jtg_yao on 2019/8/14.
//  Copyright © 2019 jzg. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN


@interface UIColor (Extension)

/**
 *  @brief  渐变颜色
 *
 *  @param c1     开始颜色
 *  @param c2     结束颜色
 *  @param height 渐变高度
 *
 *  @return 渐变颜色
 */
+ (UIColor*)gradientFromColor:(UIColor*)c1 toColor:(UIColor*)c2 withHeight:(int)height;

/** 颜色 例如 0x333333 */
+ (UIColor *)colorWithHex:(UInt32)hex;
+ (UIColor *)colorWithHex:(UInt32)hex andAlpha:(CGFloat)alpha;

/** 颜色 例如 #333333 */
+ (UIColor *)colorWithHexString:(NSString *)hexString;
- (NSString *)HEXString;

+ (UIColor *)colorWithWholeRed:(CGFloat)red
                         green:(CGFloat)green
                          blue:(CGFloat)blue
                         alpha:(CGFloat)alpha;

+ (UIColor *)colorWithWholeRed:(CGFloat)red
                         green:(CGFloat)green
                          blue:(CGFloat)blue;

/**
 *  @brief  随机颜色
 *
 *  @return UIColor
 */
+ (UIColor *)randomColor;

@end

NS_ASSUME_NONNULL_END
