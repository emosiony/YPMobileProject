//
//  YPBaseTabBarController.m
//  YPProject
//
//  Created by Jtg_yao on 2019/8/13.
//  Copyright © 2019 jzg. All rights reserved.
//

#import "YPBaseTabBarController.h"

#import "TransitionAnimation.h"
#import "TransitionController.h"

#import "YPBaseNavitionController.h"
#import "YPAppConfig.h"

#import "YPHomeViewController.h"
#import "YPDiscoverController.h"
#import "YPMineViewController.h"

@interface YPBaseTabBarController ()
<UITabBarControllerDelegate>

/** 拖动手势 */
@property (nonatomic,strong) UIPanGestureRecognizer *panGestureRecognizer;

@end

@implementation YPBaseTabBarController

- (void)viewDidLoad {
    [super viewDidLoad];

//    self.delegate = self;
//    [self.view addGestureRecognizer:self.panGestureRecognizer];
    
    [self setTabbarComfig];
    [self setTabBarMenuItems];
}

- (void)setTabBarMenuItems {
    
    [self addChildCtrl:[[YPHomeViewController alloc] init] title:@"爆料" image:@"tabbar_search" selectedImage:@"tabbar_search_sel"];
    [self addChildCtrl:[[YPDiscoverController alloc] init] title:@"发现" image:@"tabbar_search" selectedImage:@"tabbar_search_sel"];
    [self addChildCtrl:[[YPMineViewController alloc] init] title:@"知书" image:@"tabbar_classroom" selectedImage:@"tabbar_classroom_sel"];
}

-(void)setTabbarComfig {
    
    [[UITabBarItem appearance] setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[YPAppConfig shareInstance].tabbarItemNormalColor, NSForegroundColorAttributeName, nil] forState:UIControlStateNormal];
    [[UITabBarItem appearance] setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[YPAppConfig shareInstance].tabbarItemSelectColor, NSForegroundColorAttributeName,nil] forState:UIControlStateSelected];
    [self.tabBar setBackgroundColor:[YPAppConfig shareInstance].tabbarBgColor];
}

-(void)addChildCtrl:(UIViewController *)childCtrl
              title:(NSString *)title
              image:(NSString *)image
      selectedImage:(NSString *)selectedImage
{
    YPBaseNavitionController *nav = [[YPBaseNavitionController alloc] initWithRootViewController:childCtrl];
    [self addChildCtrlNav:nav title:title image:image selectedImage:selectedImage];
}
-(void)addChildCtrlNav:(UINavigationController *)childCtrlNav
                 title:(NSString *)title
                 image:(NSString *)image
         selectedImage:(NSString *)selectedImage
{
    childCtrlNav.tabBarItem.image = [[UIImage imageNamed:image] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    childCtrlNav.tabBarItem.selectedImage = [[UIImage imageNamed:selectedImage] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    childCtrlNav.title = title;
    [self addChildViewController:childCtrlNav];
}

#pragma mark -- 滑动手势
- (UIPanGestureRecognizer *)panGestureRecognizer{
    if (_panGestureRecognizer == nil){
        _panGestureRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panGestureRecognizer:)];
    }
    return _panGestureRecognizer;
}

- (void)panGestureRecognizer:(UIPanGestureRecognizer *)pan{
    if (self.transitionCoordinator) {
        return;
    }
    
    if (pan.state == UIGestureRecognizerStateBegan || pan.state == UIGestureRecognizerStateChanged){
        [self beginInteractiveTransitionIfPossible:pan];
    }
}

- (void)beginInteractiveTransitionIfPossible:(UIPanGestureRecognizer *)sender{
    CGPoint translation = [sender translationInView:self.view];
    if (translation.x > 0.f && self.selectedIndex > 0) {
        self.selectedIndex --;
    }
    else if (translation.x < 0.f && self.selectedIndex + 1 < self.viewControllers.count) {
        self.selectedIndex ++;
    }
    else {
        if (!CGPointEqualToPoint(translation, CGPointZero)) {
            sender.enabled = NO;
            sender.enabled = YES;
        }
    }
    
    [self.transitionCoordinator animateAlongsideTransitionInView:self.view animation:^(id<UIViewControllerTransitionCoordinatorContext>  _Nonnull context) {
        
    } completion:^(id<UIViewControllerTransitionCoordinatorContext>  _Nonnull context) {
        if ([context isCancelled] && sender.state == UIGestureRecognizerStateChanged){
            [self beginInteractiveTransitionIfPossible:sender];
        }
    }];
}

#pragma mark -- TabbarDelgate
- (id<UIViewControllerAnimatedTransitioning>)tabBarController:(UITabBarController *)tabBarController animationControllerForTransitionFromViewController:(UIViewController *)fromVC toViewController:(UIViewController *)toVC{
    // 打开注释 可以屏蔽点击item时的动画效果
    if (self.panGestureRecognizer.state == UIGestureRecognizerStateBegan || self.panGestureRecognizer.state == UIGestureRecognizerStateChanged) {
        NSArray *viewControllers = tabBarController.viewControllers;
        if ([viewControllers indexOfObject:toVC] > [viewControllers indexOfObject:fromVC]) {
            return [[TransitionAnimation alloc] initWithTargetEdge:UIRectEdgeLeft];
        }
        else {
            return [[TransitionAnimation alloc] initWithTargetEdge:UIRectEdgeRight];
        }
    }
    else{
        return nil;
    }
}

- (id<UIViewControllerInteractiveTransitioning>)tabBarController:(UITabBarController *)tabBarController interactionControllerForAnimationController:(id<UIViewControllerAnimatedTransitioning>)animationController{
    if (self.panGestureRecognizer.state == UIGestureRecognizerStateBegan || self.panGestureRecognizer.state == UIGestureRecognizerStateChanged) {
        return [[TransitionController alloc] initWithGestureRecognizer:self.panGestureRecognizer];
    }
    else {
        return nil;
    }
}

@end
