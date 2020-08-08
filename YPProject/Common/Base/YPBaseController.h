//
//  YPBaseController.h
//  YPProject
//
//  Created by Jtg_yao on 2019/8/13.
//  Copyright © 2019 jzg. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIViewController+BackButtonHandler.h"

NS_ASSUME_NONNULL_BEGIN

@interface YPBaseController : UIViewController

/** 是否隐藏 navigationBar */
@property (nonatomic, assign) BOOL prefersNavigationBarHidden;
/** 隐藏 navigationBar 下 的线条 */
@property (nonatomic, assign) BOOL prefersNavigationBarBottomLineHidden;

/// 截图（Push/Pop Present/Dismiss 过度过程中的缩略图）主要用在过渡动画里面
@property (nonatomic, strong) UIView *snapshot;



/// iOS 13 样式 present
/// @param viewControllerToPresent presentController
/// @param flag 是否动画
/// @param completion 完成block
-(void)presentViewControllerIOS13:(UIViewController *)viewControllerToPresent animated:(BOOL)flag completion:(void (^)(void))completion;

@end

NS_ASSUME_NONNULL_END
