

//
//  YPHomeViewController.m
//  YPProject
//
//  Created by Jtg_yao on 2019/8/12.
//  Copyright © 2019 jzg. All rights reserved.
//

#import "YPHomeViewController.h"
#import "YPBaseWKWebController.h"
#import <SDCycleScrollView.h>
#import "TGSafeInfoView.h"

#import "YPModalController.h"

#define Banner_Scroll_Height  (kScreenWidth * 9/16)

@interface YPHomeViewController ()
<SDCycleScrollViewDelegate>

@property (nonatomic,strong) SDCycleScrollView *bannerScroll;
@property (nonatomic,strong) TGSafeInfoView *safeView;

@end

@implementation YPHomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"Fighting";
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:(UIBarButtonSystemItemPlay) target:self action:@selector(pushPage)];
    
    self.view.backgroundColor = HEXColor(0xF3F3F3);
    [self.view addSubview:self.bannerScroll];
    [self.view addSubview:self.safeView];

    [self.bannerScroll mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.mas_equalTo(self.view);
        make.height.mas_equalTo(Banner_Scroll_Height);
    }];
    
    [self.safeView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.bannerScroll.mas_bottom).offset(10);
        make.left.right.mas_equalTo(self.view);
        make.height.mas_equalTo(self.safeView.mj_h);
    }];
    
    __weak typeof(self) weakSelf = self;
    [self.safeView setNumChangeBlock:^(double num) {
        NSLog(@"num === %lf", num);
    } chooseBlock:^(BOOL isSelect) {
        weakSelf.safeView.showType = isSelect ? TGSafeShowType_showCourseSel : TGSafeShowType_showCourseNor;
    } tapExplainBlock:^(NSString * _Nonnull url) {
        [[[UIAlertView alloc] initWithTitle:@"提示" message:url delegate:nil cancelButtonTitle:@"知道了" otherButtonTitles:nil] show];
    } numWarmBlock:^(BOOL isAdd) {
        NSString *msg = isAdd ? @"不能超过可投时效" : @"不能小于1个月";
        [[[UIAlertView alloc] initWithTitle:@"提示" message:msg delegate:nil cancelButtonTitle:@"知道了" otherButtonTitles:nil] show];
    } updateHeight:^(CGFloat safeHeight) {
        [weakSelf.safeView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(safeHeight);
        }];
    }];
}

-(void)pushPage {
    

    YPModalController *modalVC = [[YPModalController alloc] init];
    [self presentViewController:modalVC animated:YES completion:nil];
}

-(SDCycleScrollView *)bannerScroll {
    
    if (_bannerScroll == nil) {
        
        _bannerScroll = [SDCycleScrollView cycleScrollViewWithFrame:CGRectMake(0, 0, kScreenWidth, Banner_Scroll_Height) delegate:self placeholderImage:[UIImage imageWithColor:HEXColor(0x123456)]];
        
        _bannerScroll.autoScrollTimeInterval = 5.0f;
        _bannerScroll.bannerImageViewContentMode = UIViewContentModeScaleAspectFill;
        _bannerScroll.pageControlAliment     = SDCycleScrollViewPageContolAlimentCenter;
        
        _bannerScroll.pageControlDotSize  = CGSizeMake(5, 5);
        _bannerScroll.currentPageDotColor = HEXColor(0x01A1ED);
        _bannerScroll.pageDotColor        = HEXColor(0xcccccc);
        _bannerScroll.pageControlStyle    = SDCycleScrollViewPageContolStyleAnimated;
        
        _bannerScroll.localizationImageNamesGroup = @[[UIImage imageWithColor:HEXColor(0x123456)], [UIImage imageWithColor:HEXColor(0xF3F3F3)] , [UIImage imageWithColor:HEXColor(0x123321)]];
        
        __weak typeof(self) weakSelf = self;
        _bannerScroll.clickItemOperationBlock = ^(NSInteger currentIndex) {
            NSLog(@"click index == %zd", currentIndex);
            YPBaseWKWebController *page = [[YPBaseWKWebController alloc] init];
            page.url = @"http://baidu.com";
            page.hiddenNavigationBarShowImage = YES;
            [weakSelf.navigationController pushViewController:page animated:YES];
        };
    }
    return _bannerScroll;
}

-(TGSafeInfoView *)safeView {
    
    if (_safeView == nil) {
        _safeView = [TGSafeInfoView viewFromXib];
        _safeView.minNum   = 1.0f;
        _safeView.maxNum   = 99.0f;
        _safeView.showType = TGSafeShowType_showCourseNor;
    }
    return _safeView;
}

@end
