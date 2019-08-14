

//
//  YPHomeViewController.m
//  YPProject
//
//  Created by Jtg_yao on 2019/8/12.
//  Copyright © 2019 jzg. All rights reserved.
//

#import "YPHomeViewController.h"
#import "YPMineViewController.h"

@interface YPHomeViewController ()

@end

@implementation YPHomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"Fighting";
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:(UIBarButtonSystemItemPlay) target:self action:@selector(pushPage)];
}

-(void)pushPage {
    
    YPMineViewController *page = [[YPMineViewController alloc] initWithStyle:(UITableViewStyleGrouped)];
//    page.hiddenNavigationBar = YES;
    page.hiddenNavigationBarShowImage = YES;
    [self.navigationController pushViewController:page animated:YES];
}

@end
