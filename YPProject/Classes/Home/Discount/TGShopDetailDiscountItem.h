//
//  TGShopDetailDiscountItem.h
//  TGParent
//
//  Created by Jtg_yao on 2019/12/9.
//  Copyright © 2019 jzg. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_OPTIONS(NSUInteger, DiscountItemShowType) {
    DiscountItemShowTypeClose       = 0, // 关闭
    DiscountItemShowTypeHidden      = 1, // 隐藏
    DiscountItemShowTypeOpen        = 2, // 打开
};

NS_ASSUME_NONNULL_BEGIN

@interface TGShopDetailDiscountItem : UIView

@property (nonatomic,copy) void(^tapOpenBlock)(DiscountItemShowType showType);

- (void)setTitle:(NSString *)title content:(NSString *)content showType:(DiscountItemShowType)showType;

@end

NS_ASSUME_NONNULL_END
