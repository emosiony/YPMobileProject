//
//  HomeBaseViewController.h
//  ScrollView嵌套悬停Demo
//
//  Created by Jtg_yao on 2019/8/22.
//  Copyright © 2019 谭高丰. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

/****进入置顶通知****/
#define kHomeGoTopNotification               @"Home_Go_Top"
/****离开置顶通知****/
#define kHomeLeaveTopNotification            @"Home_Leave_Top"
/** 通知父类 可以 滚动了 */
#define kHomeScrollTop_Notice                @"homeScrollTop_Notice"

/** 枚举 - 首页 定位 状态 */
typedef NS_OPTIONS(NSUInteger, TGHomeLocationState) {
    TGHomeLocationStateIng           = 0, // 定位中
    TGHomeLocationStateFail          = 1, // 定位失败
    TGHomeLocationStateSuccess       = 2, // 定位成功
};


@interface TGHomeBaseViewController : UIViewController

@property (nonatomic, assign) BOOL canScroll;

/** 首页定位状态 */
@property (nonatomic, assign) TGHomeLocationState locationState;

-(void)loadDataAfterLocation:(TGHomeLocationState)locationState withMjHeader:(MJRefreshHeader *)mj_header;

@end

NS_ASSUME_NONNULL_END
