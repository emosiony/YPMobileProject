//
//  TGFilterContentView.h
//  TGParent
//
//  Created by Jtg_yao on 2019/4/2.
//  Copyright © 2019年 jzg. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TGGradeSelectView.h"
#import "TGProductOptionModel.h"

NS_ASSUME_NONNULL_BEGIN

typedef void(^SelectItemBlock)(NSInteger titleIndex, NSInteger index, BOOL isChoose, TGProductOptionModel * productOptionModel);

@interface TGFilterContentView : UIView

//@property (nonatomic,copy)    NSArray *title;
@property (strong, nonatomic) NSMutableArray *dataArray;                //数据数组
@property (assign, nonatomic) NSInteger horizontalInterval;             //水平间距
@property (assign, nonatomic) NSInteger verticalInterval;               //垂直间距
@property (assign, nonatomic) NSInteger preLineCount;                   //每行多少个
@property (assign, nonatomic) NSInteger preColumnCount;                 //每列多少个
@property (assign, nonatomic) BOOL isMoreChoose;                        //是否多选

@property (nonatomic,copy) SelectItemBlock selectBlock;

-(void)setTitle:(NSArray *)title
      dataArray:(NSMutableArray *)dataArray;

//-(void)setDataArray:(NSMutableArray *)dataArray
//        selectBlock:(SelectItemBlock)selectBlock;

@end

NS_ASSUME_NONNULL_END
