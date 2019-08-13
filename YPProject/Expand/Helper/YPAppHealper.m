//
//  YPAppHealper.m
//  YPProject
//
//  Created by Jtg_yao on 2019/8/12.
//  Copyright © 2019 jzg. All rights reserved.
//

#import "YPAppHealper.h"
#import "YPBaseTabBarController.h"
#import "YPLoginViewController.h"
#import "YPBaseNavitionController.h"

@implementation YPAppHealper

-(void)resetWidowMainController {
    
    AppDelegate *app = [AppDelegate shareDelegate];
    if ([self isLogin]) {
        app.window.rootViewController = [[YPBaseTabBarController alloc] init];
    } else {
        YPLoginViewController *loginVC = [[YPLoginViewController alloc] init];
        app.window.rootViewController = [[YPBaseNavitionController alloc] initWithRootViewController:loginVC];
    }
}

-(BOOL)isLogin {
    
    return YES;
}

KSingleToolM(Instance);
@end
