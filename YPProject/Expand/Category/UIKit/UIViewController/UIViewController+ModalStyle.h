//
//  UIViewController+ModalStyle.h
//  YPProject
//
//  Created by Jtg_yao on 2019/9/29.
//  Copyright © 2019 jzg. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIViewController (ModalStyle)


/**
 设置 模态类型
 NO：iOS 13 模式 UIModalPresentationAutomatic
 YES: UIModalPresentationFullScreen
 */
@property (nonatomic,assign) BOOL yp_automaticallySetModalPresentationStyle;

+(BOOL)yp_automaticallySetModalPresentationStyle;

@end

NS_ASSUME_NONNULL_END
