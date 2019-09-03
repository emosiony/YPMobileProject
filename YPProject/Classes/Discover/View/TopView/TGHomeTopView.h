//
//  TGHomeTopView.h
//  ScrollView嵌套悬停Demo
//
//  Created by Jtg_yao on 2019/8/21.
//  Copyright © 2019 谭高丰. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

static CGFloat Line_Margin = 10;

#define Menu_Page_Count 5

#define Item_Width  ((kScreenWidth - 2 * Line_Margin) / Menu_Page_Count)

#define TOP_SCROLL_HEIGHT    (kScreenWidth - 2 * Line_Margin)/3
#define MENU_SCROLL_HEIGHT   (((kScreenWidth - 2 * Line_Margin) / Menu_Page_Count - ((Menu_Page_Count - 1) * Line_Margin)) + 50)
#define BOTTOM_SCROLL_HEIGHT (kScreenWidth - 2 * Line_Margin) / 4.0

@interface TGHomeTopView : UIView

@property (nonatomic,copy) NSArray *topList;
@property (nonatomic,copy) NSArray *menuList;
@property (nonatomic,copy) NSArray *bottomList;

@property (nonatomic,copy) void(^clickCallBackBlock)(NSDictionary *info);
@property (nonatomic,copy) void(^clickMenuBlock)(NSDictionary *info);
-(void)setTopList:(NSArray *)topList menuList:(NSArray *)menuList bottomList:(NSArray *)bottomList;

/** 获取 真实 高度 */
-(CGFloat)getContentHeight;

@end

NS_ASSUME_NONNULL_END
