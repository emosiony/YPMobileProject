//
//  TGSafeInfoView.h
//  YPProject
//
//  Created by Jtg_yao on 2019/9/9.
//  Copyright © 2019 jzg. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_OPTIONS(NSUInteger, TGSafeShowType) {
    TGSafeShowType_showSafe       = 0,  // 安全包界面展示 -- 隐藏头部 提示 和 选择按钮
    TGSafeShowType_showCourseNor  = 1,  // 购买界面展示  -- 未购买 隐藏头部提示 不隐藏选择按钮
    TGSafeShowType_showCourseBuy  = 2,  // 购买界面展示  -- 已购买 不隐藏头部提示 隐藏选择按钮
    TGSafeShowType_showCourseSel  = 3,  // 隐藏所有（只展示头部，隐藏头部的提示）
};

typedef void(^NumChange)(double num);
typedef void(^ChooseBlock)(BOOL isSelect);
typedef void(^TapBlock)(NSString *url);
typedef void(^NumWarmBlock)(BOOL isAdd);
typedef void(^UpdateHeight)(CGFloat safeHeight);

@interface TGSafeInfoView : UIView

@property (nonatomic,assign) double minNum;     // 最小值
@property (nonatomic,assign) double maxNum;     // 最大值
@property (nonatomic,assign) double currentNum; // 当前值

@property (nonatomic,assign) TGSafeShowType showType; // 展示类型

/** 输入信息 */
@property (nonatomic,copy) NSDictionary *inputInfo;

@property (nonatomic,copy) NumChange numChangeBlock;
@property (nonatomic,copy) ChooseBlock chooseBlock;
@property (nonatomic,copy) TapBlock tapExplainBlock;
@property (nonatomic,copy) NumWarmBlock numWarmBlock;
@property (nonatomic,copy) UpdateHeight updateHeight;

-(void)setNumChangeBlock:(NumChange _Nonnull)numChangeBlock
             chooseBlock:(ChooseBlock _Nonnull)chooseBlock
         tapExplainBlock:(TapBlock _Nonnull)tapExplainBlock
            numWarmBlock:(NumWarmBlock _Nonnull)numWarmBlock
            updateHeight:(UpdateHeight _Nonnull)updateHeight;

@end

NS_ASSUME_NONNULL_END
