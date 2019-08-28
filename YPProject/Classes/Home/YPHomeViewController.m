

//
//  YPHomeViewController.m
//  YPProject
//
//  Created by Jtg_yao on 2019/8/12.
//  Copyright © 2019 jzg. All rights reserved.
//

#import "YPHomeViewController.h"
#import "YPBaseWKWebController.h"

@interface YPHomeViewController ()

@end

@implementation YPHomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"Fighting";
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:(UIBarButtonSystemItemPlay) target:self action:@selector(pushPage)];
}

-(void)pushPage {
    
    YPBaseWKWebController *page = [[YPBaseWKWebController alloc] init];
//    page.hiddenNavigationBar = YES;
    page.url = @"http://baidu.com";
    page.hiddenNavigationBarShowImage = YES;
    [self.navigationController pushViewController:page animated:YES];
}

@end
