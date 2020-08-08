
//
//  YPBaseController.m
//  YPProject
//
//  Created by Jtg_yao on 2019/8/13.
//  Copyright © 2019 jzg. All rights reserved.
//

#import "YPBaseController.h"

@interface YPBaseController ()

@end

@implementation YPBaseController

-(void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    
    if (self.prefersNavigationBarHidden) {
        [self.navigationController setNavigationBarHidden:self.prefersNavigationBarHidden animated:YES];
    }
    
    if (self.prefersNavigationBarBottomLineHidden) {
        self.navigationController.navigationBar.shadowImage = [UIImage imageWithColor:[UIColor clearColor]];
    }
}

-(void)viewWillDisappear:(BOOL)animated {
    
    [super viewWillDisappear:animated];

    
    if (self.prefersNavigationBarHidden) {
        [self.navigationController setNavigationBarHidden:self.prefersNavigationBarHidden animated:YES];
    }
    
    if (self.prefersNavigationBarBottomLineHidden) {
        self.navigationController.navigationBar.shadowImage = [UIImage imageWithColor:RGB(212, 212, 212)];
    }
    
    // 截图
    if (self.isMovingFromParentViewController) {
        self.snapshot = [self.navigationController.view snapshotViewAfterScreenUpdates:NO];
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
 
    self.navigationController.navigationBar.translucent = NO; // 导航栏不通明
    // 不允许 viewController 自动调整，我们自己布局；如果设置为YES，视图会自动下移 64 像
    self.automaticallyAdjustsScrollViewInsets = NO;
//    self.edgesForExtendedLayout = UIRectEdgeAll;
    
    self.view.backgroundColor = [UIColor whiteColor];
}

-(void)presentViewController:(UIViewController *)viewControllerToPresent animated:(BOOL)flag completion:(void (^)(void))completion {
    
    if (@available(iOS 13, *)) {
        viewControllerToPresent.modalPresentationStyle = UIModalPresentationFullScreen;
    }
    
    [super presentViewController:viewControllerToPresent animated:flag completion:completion];
}

-(void)presentViewControllerIOS13:(UIViewController *)viewControllerToPresent animated:(BOOL)flag completion:(void (^)(void))completion {
    
    [super presentViewController:viewControllerToPresent animated:flag completion:completion];
}

@end
