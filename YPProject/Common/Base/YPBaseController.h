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
@property (nonatomic,assign) BOOL hiddenNavigationBar;
/** 隐藏 navigationBar 下 的线条 */
@property (nonatomic,assign) BOOL hiddenNavigationBarShowImage;

@end

NS_ASSUME_NONNULL_END
