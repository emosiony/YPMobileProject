//
//  menuHeadView.h
//  FastlaneTest
//
//  Created by Jtg_yao on 2018/5/22.
//  Copyright © 2018年 YDP. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ItemMeau.h"

//商品筛选类型
typedef NS_ENUM(NSUInteger, TGMenuHeadType) {
    TGMenuHeadTypeUniversal,                    //综合排序
    TGMenuHeadTypeDistance,                     //距离排序
    TGMenuHeadTypeEvaluation,                   //好评优先
    TGMenuHeadTypeFilter                        //筛选
};

typedef void(^ClickBlock)(TGMenuHeadType type,BOOL isSelect);

@interface MenuHeadView : UIView

@property (strong, nonatomic) ItemMeau *filterItem;                 //筛选

/** 点击事件 */
@property (nonatomic,copy) ClickBlock clickBlock;

/** 更新 title */
-(void)upTitle:(NSString *)title index:(NSInteger)idx;

/** 取消所有选中 */
-(void)cancleAllChoose;

@end
