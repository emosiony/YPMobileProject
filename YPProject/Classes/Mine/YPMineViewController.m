//
//  YPMineViewController.m
//  YPProject
//
//  Created by Jtg_yao on 2019/8/12.
//  Copyright © 2019 jzg. All rights reserved.
//

#import "YPMineViewController.h"

#define Cell_ReuseIdentifier @"reuseIdentifier"

@interface YPMineViewController ()

@end

@implementation YPMineViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.navigationItem.title = @"Mine";
    self.emptyDesc = @"O(∩_∩)O哈哈~， 没数据啦";
    
    [self setEmptyDelegate];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(self.view);
    }];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:(UIBarButtonSystemItemPlay) target:self action:@selector(changeModalTransStyle)];    
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:Cell_ReuseIdentifier forIndexPath:indexPath];
    cell.textLabel.text   = [self.dataList objectAtIndex:indexPath.row];
    return cell;
}

- (void)changeModalTransStyle {
    
    [YPProgressHUD yp_showLoading];
    [YPProgressHUD yp_dismissHUDWithDelay:15.0];
}

@end
