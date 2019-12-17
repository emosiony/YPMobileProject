//
//  TGSHOPDetailDiscountCell.h
//  YPProject
//
//  Created by Jtg_yao on 2019/12/9.
//  Copyright © 2019 jzg. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_OPTIONS(NSUInteger, ShopDDisShowType) {
    ShopDDisShowTypeClose       = 0,
    ShopDDisShowTypeOnece       = 1,
    ShopDDisShowTypeOpen        = 2,
};

@interface TGSHOPDetailDiscountCell : UITableViewCell

@property (nonatomic,copy) void(^tapOpenClick)(ShopDDisShowType);
- (void)setTitle:(NSString *)title content:(NSString *)content showType:(ShopDDisShowType)showType;

@end

NS_ASSUME_NONNULL_END
