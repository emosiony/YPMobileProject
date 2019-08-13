//
//  AppDelegate.h
//  YPProject
//
//  Created by Jtg_yao on 2019/8/12.
//  Copyright © 2019 jzg. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (nonatomic,strong) UIViewController *topViewController;
/** 这个属性标识屏幕是否允许旋转 */
@property (nonatomic,assign)BOOL allowRotation;

+(AppDelegate *)shareDelegate;

@end

