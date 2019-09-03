//
//  TGGradeSelectView.h
//  TGVendor
//
//  Created by lwc on 2018/11/16.
//  Copyright © 2018年 jzg. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TGProductOptionModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface TGGradeSelectView : UIView

@property (strong, nonatomic) NSMutableArray *dataArray;                //数据数组
@property (assign, nonatomic) NSInteger horizontalInterval;             //水平间距
@property (assign, nonatomic) NSInteger verticalInterval;               //垂直间距
@property (assign, nonatomic) NSInteger preLineCount;                   //每行多少个
@property (assign, nonatomic) NSInteger preColumnCount;                 //每列多少个
@property (assign, nonatomic) BOOL isMoreChoose;                        //是否多选
@property (nonatomic,strong)  NSArray *muSelectList;

@property (nonatomic,copy) void(^didSelectItemBlock)(NSInteger index, BOOL isChoose, TGProductOptionModel * productOptionModel);

@end

NS_ASSUME_NONNULL_END
