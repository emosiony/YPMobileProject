

//
//  HomeBaseViewController.m
//  ScrollView嵌套悬停Demo
//
//  Created by Jtg_yao on 2019/8/22.
//  Copyright © 2019 谭高丰. All rights reserved.
//

#import "TGHomeBaseViewController.h"

@interface TGHomeBaseViewController ()

@end

@implementation TGHomeBaseViewController

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewDidLoad {
    [super viewDidLoad];

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(acceptMsg:) name:kHomeGoTopNotification object:nil];
}

#pragma mark - notification

-(void)acceptMsg:(NSNotification *)notification {
    NSString *notificationName = notification.name;
    if ([notificationName isEqualToString:kHomeGoTopNotification]) {
        NSDictionary *userInfo = notification.userInfo;
        NSString *canScroll = userInfo[@"canScroll"];
        if ([canScroll isEqualToString:@"1"]) {
            self.canScroll = YES;   // 如果滑动到了顶部TableView就能滑动了
        }
    }
}

#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    
    if (_canScroll == YES) {
        [[NSNotificationCenter defaultCenter] postNotificationName:kHomeLeaveTopNotification object:nil userInfo:@{@"canScroll":@"0"}];  // 告诉其他滚动视图不能滚动了
    }else{
        [scrollView setContentOffset:CGPointMake(0, 0)];
    }
    
    CGFloat offsetY = scrollView.contentOffset.y;
    NSLog(@"TableView的偏移量：%f", offsetY);
    if (offsetY < 0) {
        [[NSNotificationCenter defaultCenter] postNotificationName:kHomeLeaveTopNotification object:nil userInfo:@{@"canScroll":@"1"}]; // 告诉其他滚动视图能滚动了
        _canScroll = NO;
    }
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
