//
//  YPFontColorView.h
//  YPProject
//
//  Created by 幸福e家 on 2020/2/16.
//  Copyright © 2020 jzg. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

/// 文字颜色工具条状态
typedef NS_OPTIONS(NSUInteger, YPFontColorStatus) {
    YPFontColorHidden       = 0,
    YPFontColorShowNormal   = 1,
    YPFontColorShowFont     = 2,
    YPFontColorShowColor    = 3
};


@interface YPFontColorView : UIView

@property (nonatomic, assign) YPFontColorStatus fontColorStatus;

@end

NS_ASSUME_NONNULL_END
