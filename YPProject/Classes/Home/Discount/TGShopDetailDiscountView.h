//
//  TGShopDetailDiscountView.h
//  TGParent
//
//  Created by Jtg_yao on 2019/12/9.
//  Copyright © 2019 jzg. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_OPTIONS(NSUInteger, TGShopDDisShowType) {
    TGShopDDisShowTypeClose       = 0,
    TGShopDDisShowTypeOnece       = 1,
    TGShopDDisShowTypeOpen        = 2,
};

@interface TGShopDetailDiscountView : UIView

@property (nonatomic,copy) NSArray *discountArray;
@property (nonatomic,assign) TGShopDDisShowType showType;

@end

NS_ASSUME_NONNULL_END
