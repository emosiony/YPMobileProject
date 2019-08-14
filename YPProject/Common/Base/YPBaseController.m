
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
    
    if (self.hiddenNavigationBar) {
        [self.navigationController setNavigationBarHidden:YES];
    }
    
    if (self.hiddenNavigationBarShowImage) {
        self.navigationController.navigationBar.shadowImage = [UIImage imageWithColor:[UIColor clearColor]];
    }
}

-(void)viewWillDisappear:(BOOL)animated {
    if (self.hiddenNavigationBar) {
        [self.navigationController setNavigationBarHidden:NO];
    }
    
    if (self.hiddenNavigationBarShowImage) {
        self.navigationController.navigationBar.shadowImage = [UIImage imageWithColor:RGB(212, 212, 212)];
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

@end
