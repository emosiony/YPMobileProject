//
//  ItemMeau.h
//  FastlaneTest
//
//  Created by Jtg_yao on 2018/5/22.
//  Copyright © 2018年 YDP. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface ItemMeau : UIView

/** 是否选中 */
@property (nonatomic,assign,getter=isSelect) BOOL select;

/** 普通状态 -- title */
@property (nonatomic,copy) NSString *normalTitle;

/** 选中状态 -- title */
@property (nonatomic,copy) NSString *selectTitle;

/** 普通状态 -- image */
@property (nonatomic,strong) UIImage *normalImage;

/** 选中状态 -- image */
@property (nonatomic,strong) UIImage *selectImage;

/** 普通状态 -- color */
@property (nonatomic,strong) UIColor *normalColor;

/** 选中状态 -- color */
@property (nonatomic,strong) UIColor *selectColor;

@property (nonatomic,copy) void(^itemClick)(BOOL isSelect);

-(void)titleNor:(NSString *)titleNor
       titleSel:(NSString *)titleSel;

-(void)imageNor:(UIImage  *)imageNor
       imageSel:(UIImage  *)imageSel;

-(void)colorNor:(UIColor  *)colorNor
       colorSel:(UIColor  *)colorSel;

-(void)titleNor:(NSString *)titleNor
       titleSel:(NSString *)titleSel
       imageNor:(UIColor  *)colorNor
       imageSel:(UIColor  *)colorSel;

-(void)titleNor:(NSString *)titleNor
       titleSel:(NSString *)titleSel
       imageNor:(UIImage  *)imageNor
       imageSel:(UIImage  *)imageSel
       colorNor:(UIColor *)colorNor
       colorSel:(UIColor *)colorSel;

+(id)ViewFromXIB;

@end
