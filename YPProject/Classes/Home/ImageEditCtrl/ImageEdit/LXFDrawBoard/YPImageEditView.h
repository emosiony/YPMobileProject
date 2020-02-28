//
//  YPImageEditView.h
//  YPProject
//
//  Created by 幸福e家 on 2020/2/15.
//  Copyright © 2020 jzg. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YPFontColorView.h"

NS_ASSUME_NONNULL_BEGIN

@interface YPImageEditView : UIView

@property (nonatomic, assign) YPFontColorStatus fontColorStatus;
@property (nonatomic, copy) NSMutableArray *photos;

@end

NS_ASSUME_NONNULL_END
