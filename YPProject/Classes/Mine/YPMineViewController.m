//
//  YPMineViewController.m
//  YPProject
//
//  Created by Jtg_yao on 2019/8/12.
//  Copyright © 2019 jzg. All rights reserved.
//

#import "YPMineViewController.h"

@interface YPMineViewController ()

@end

@implementation YPMineViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.navigationItem.title = @"Mine";
    self.emptyDesc = @"O(∩_∩)O哈哈~， 没数据啦";
    
    [self setEmptyDelegate];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
