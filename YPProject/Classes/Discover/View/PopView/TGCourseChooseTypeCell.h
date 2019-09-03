//
//  TGCourseChooseTypeCell.h
//  TGVendor
//
//  Created by Jtg_yao on 2018/11/15.
//  Copyright © 2018年 jzg. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TGProductOptionModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface TGCourseChooseTypeCell : UICollectionViewCell

@property (strong, nonatomic) TGProductOptionModel *productOptionModel;
@property (weak, nonatomic) IBOutlet UILabel     *titleLabel;
@property (weak, nonatomic) IBOutlet UIImageView *chooseIcon;

@end

NS_ASSUME_NONNULL_END
