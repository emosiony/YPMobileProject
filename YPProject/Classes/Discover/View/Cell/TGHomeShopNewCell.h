//
//  TGHomeShopNewCell.h
//  TGParent
//
//  Created by Jtg_yao on 2019/7/9.
//  Copyright © 2019 jzg. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TGShopInfoModel.h"
#import "TGSchoolInfoModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface TGHomeShopNewCell : UITableViewCell

@property (nonatomic,strong) TGShopInfoModel *model;
@property (nonatomic,strong) TGSchoolInfoModel *school;

/** 设置位置 */
- (void)setDistance:(NSNumber *)lon lat:(NSNumber *)lat;

@end

NS_ASSUME_NONNULL_END
