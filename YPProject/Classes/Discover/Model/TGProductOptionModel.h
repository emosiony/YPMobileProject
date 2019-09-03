//
//  TGProductOptionModel.h
//  TGParent
//
//  Created by lwc on 2018/12/4.
//  Copyright © 2018年 jzg. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface TGProductOptionModel : NSObject

@property (nonatomic,copy) NSNumber *id;
/** name */
@property (nonatomic,copy) NSString *name;
/** code */
@property (nonatomic,copy) NSString *code;
/** optionType */
@property (nonatomic,copy) NSString *optionType;
/** optionValue */
@property (nonatomic,copy) NSString *optionValue;
/** 父类 CODE */
@property (nonatomic,copy) NSString *parentAttributeOptionCode;
/** 父类 CODE */
@property (nonatomic,copy) NSString *attributeCode;
/** 单位课程费 */
@property (nonatomic,copy) NSNumber *stagePrice;

@property (nonatomic,assign,getter=isClick) BOOL click;             //是否可以点击
@property (nonatomic,assign,getter=isChoose) BOOL choose;           //是否选中
@property (assign, nonatomic) BOOL isIncludeMeals;                  //是否包括餐费
@property (nonatomic,copy) NSNumber *productAttributeId;
@end

NS_ASSUME_NONNULL_END
