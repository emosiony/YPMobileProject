//
//  TGShopFilterView.h
//  TGParent
//
//  Created by lwc on 2018/12/4.
//  Copyright © 2018年 jzg. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TGProductOptionModel.h"

NS_ASSUME_NONNULL_BEGIN

typedef void(^TGClickBlock)();
typedef void(^TGClickConfirmBlock)(TGProductOptionModel * selectedManagedModel, TGProductOptionModel * selectedMealsModel, TGProductOptionModel *coachModel, TGProductOptionModel *interestModel, TGProductOptionModel *onceCoachModel, TGProductOptionModel *onceInterestModel);

@interface TGShopFilterView : UIView

@property (nonatomic,copy) TGClickBlock resetBlock;
@property (nonatomic,copy) TGClickBlock cancelBlock;
@property (nonatomic,copy) TGClickConfirmBlock confirmBlock;

- (void)setResetBlock:(TGClickBlock )resetBlock
          cancelBlock:(TGClickBlock )cancelBlock
         confirmBlock:(TGClickConfirmBlock )confirmBlock;

- (void)setSelectedManagedModel:(TGProductOptionModel *)managedModel
                     mealsModel:(TGProductOptionModel *)mealsModel
                     coachModel:(TGProductOptionModel *)coachModel
                  interestModel:(TGProductOptionModel *)interestModel
                 onceCoachModel:(TGProductOptionModel *)onceCoachModel
              onceInterestModel:(TGProductOptionModel *)onceInterestModel;

/** 显示 */
- (void)show;
/** 隐藏 */
- (void)hiddenFilter;

@end

NS_ASSUME_NONNULL_END
