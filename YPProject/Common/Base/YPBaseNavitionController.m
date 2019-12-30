//
//  YPBaseNavitionController.m
//  YPProject
//
//  Created by Jtg_yao on 2019/8/13.
//  Copyright © 2019 jzg. All rights reserved.
//

#import "YPBaseNavitionController.h"
#import "YPAppConfig.h"
#import "UIViewController+WLBackButton.h"

@interface YPBaseNavitionController ()
<UIGestureRecognizerDelegate,UINavigationControllerDelegate>

/** 当前 controller */
@property(nonatomic,weak) UIViewController * currentShowVC;

@end

@implementation YPBaseNavitionController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self setUpNavitems];
    [self setupNavigationBarTheme];
}

-(id)initWithRootViewController:(UIViewController *)rootViewController {
    
    YPBaseNavitionController *nvc= [super initWithRootViewController:rootViewController];
    self.interactivePopGestureRecognizer.delegate = self;
    nvc.delegate = self;
    
    return nvc;
}

-(void)navigationController:(UINavigationController *)navigationController didShowViewController:(UIViewController* )viewController animated:(BOOL)animated {
    
    if (navigationController.viewControllers.count == 1)
        self.currentShowVC = Nil;
    else
        self.currentShowVC = viewController;
}

-(BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer {
    
    if (gestureRecognizer == self.interactivePopGestureRecognizer) {
        return (self.currentShowVC == self.topViewController);
    }
    return YES;
}

-(UIViewController *)popViewControllerAnimated:(BOOL)animated
{
    if (self.viewControllers.count > 1) {
        self.tabBarController.tabBar.hidden=YES;
    }else{
        self.tabBarController.tabBar.hidden=NO;
    }
    
    return [super popViewControllerAnimated:animated];
}

- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    // 第一个 控制器 不需要隐藏tabbar
    if (self.viewControllers.count > 0) {
        
        viewController.hidesBottomBarWhenPushed = YES;
        self.tabBarController.tabBar.hidden=YES;
    }else{
        
        self.tabBarController.tabBar.hidden=NO;
    }
    
    [super pushViewController:viewController animated:animated];
}

- (NSArray *)popToViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    // 第一个 控制器 不需要隐藏tabbar
    if (self.viewControllers.count > 2) {
        
        [self.tabBarController.tabBar setHidden:YES];
    } else {
        
        [self.tabBarController.tabBar setHidden:NO];
    }
    
    return [super popToViewController:viewController animated:animated];
}

- (NSArray *)popToRootViewControllerAnimated:(BOOL)animated
{
    [self.tabBarController.tabBar setHidden:NO];
    
    return [super popToRootViewControllerAnimated:animated];
}

- (BOOL)tabBarController:(UITabBarController *)tabBarController shouldSelectViewController:(UIViewController *)viewController
{
    UIViewController *selected = [tabBarController selectedViewController];
    if ([selected isEqual:viewController])
    {
        return NO;
    }
    return YES;
}

-(void)setUpNavitems{
    UIImage *backButtonImage = [[YPAppConfig shareInstance].backImage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    self.navigationBar.backIndicatorImage = backButtonImage;
    self.navigationBar.backIndicatorTransitionMaskImage = backButtonImage;
}

#pragma mark - 设置navbar的字体和背景
- (void)setupNavigationBarTheme {
    //设置全局navBar字体颜色与背景颜色
    UINavigationBar *navBar = [UINavigationBar appearance];
    //设置字体颜色
    NSDictionary *attrNavBar = @{NSFontAttributeName : [YPAppConfig shareInstance].navTitleFont, NSForegroundColorAttributeName : [YPAppConfig shareInstance].navTitleColor};
    [navBar setTitleTextAttributes:attrNavBar];
    //设置背景颜色 首页导航透明
    //    [navBar lt_setBackgroundColor:[UIColor whiteColor]];
    //设置背景颜色一般的方法
    [navBar setBarTintColor:[YPAppConfig shareInstance].navBgColor];
    if ([UIDevice currentDevice].systemVersion.integerValue >= 8.0) {
        [navBar setTranslucent:NO];
    }
}

-(void)presentViewController:(UIViewController *)viewControllerToPresent animated:(BOOL)flag completion:(void (^)(void))completion {
    
    if (@available(iOS 13, *)) {
        viewControllerToPresent.modalPresentationStyle = UIModalPresentationFullScreen;
    }
    
    [super presentViewController:viewControllerToPresent animated:flag completion:completion];
}

@end
