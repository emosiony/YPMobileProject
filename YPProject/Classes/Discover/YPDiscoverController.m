//
//  YPDiscoverController.m
//  YPProject
//
//  Created by Jtg_yao on 2019/9/3.
//  Copyright © 2019 jzg. All rights reserved.
//

#import "YPDiscoverController.h"
#import <SDCycleScrollView.h>
#import "WMPageController.h"

#import "YPArtScrollView.h"
#import "TGShopHeaderView.h"

#import "TGHomeShopController.h"
#import "TGHomeSchoolController.h"

#import "TGHomeTopView.h"

#define ShopHeaderView_Height  kStatusAndNavBarH
#define Banner_Scroll_Height  (kScreenWidth * 9/16)

@interface YPDiscoverController ()
<UIScrollViewDelegate,WMPageControllerDelegate>

@property (nonatomic, strong) WMPageController *pageController;
@property (nonatomic, strong) YPArtScrollView *contentScollView;

/** 头部定位 搜索 扫描 */
@property (strong, nonatomic) TGShopHeaderView *shopHeaderView;
@property (nonatomic, strong) TGHomeTopView *bannerView;
@property (nonatomic, strong) UIView *contentView;

@property (nonatomic, assign) BOOL canScroll;   // 最底部的scrollView是否能滚动的标志

@property (nonatomic, copy) NSArray *titles;

/** 定位 状态 */
@property (nonatomic,assign) TGHomeLocationState locationState;

@end

@implementation YPDiscoverController


- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = YES;
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageWithColor:[UIColor clearColor]] forBarMetrics:UIBarMetricsDefault];
    [self.navigationController.navigationBar setBarStyle:UIBarStyleDefault];
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    self.navigationController.navigationBarHidden = NO;
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageWithColor:HEXColor(0x01A1ED)] forBarMetrics:UIBarMetricsDefault];
    [self.navigationController.navigationBar setBarStyle:UIBarStyleBlack];
    
    [self hiddenAllPopView];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.titles = @[@"附近门店",@"附近学校"];
    self.canScroll = YES;
    
    if (@available(iOS 11.0, *)) {
        self.contentScollView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    } else {
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    
    // 接收底部视图离开顶端的通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(acceptMsg:) name:kHomeLeaveTopNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(acceptMsg:) name:kHomeScrollTop_Notice object:nil];
    
    [self setupView];
    [self addSubviewContraints];
    [self loadBaseDataSource];
}

- (void)setupView {
    
    [self.view addSubview:self.shopHeaderView];
    [self.view addSubview:self.contentScollView];
    // 添加上方视图
    [self.contentScollView addSubview:self.bannerView];
    // 添加底部视图
    [self.contentScollView addSubview:self.contentView];
    
    // 添加底部内容视图
    [self.contentView addSubview:self.pageController.view];
    
    [self.bannerView setClickCallBackBlock:^(NSDictionary * _Nonnull info) {
        NSLog(@"scroll info == %@", info);
    }];
    
    [self.bannerView setClickMenuBlock:^(NSDictionary * _Nonnull info) {
        NSLog(@"menu info == %@", info);
    }];
    
    __weak typeof(self) weakSelf = self;
    self.contentScollView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        
        weakSelf.locationState = TGHomeLocationStateSuccess;
        
        if ([weakSelf.pageController.currentViewController isKindOfClass:[TGHomeShopController class]] ||
            [weakSelf.pageController.currentViewController isKindOfClass:[TGHomeSchoolController class]]) {
            
            TGHomeBaseViewController *baseChildVC = (TGHomeBaseViewController *)weakSelf.pageController.currentViewController;
            [baseChildVC loadDataAfterLocation:weakSelf.locationState withMjHeader:weakSelf.contentScollView.mj_header];
        }
    }];
}

-(void)addSubviewContraints {
    
    [self.shopHeaderView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.right.mas_equalTo(self.view);
        make.height.mas_equalTo(ShopHeaderView_Height);
    }];
    
    [self.contentScollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.shopHeaderView.mas_bottom);
        make.left.bottom.right.mas_equalTo(self.view);
    }];
    
    [self.bannerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.right.mas_equalTo(self.contentScollView);
        make.height.mas_equalTo([self.bannerView getContentHeight]);
    }];
    
    [self.contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(self.contentScollView);
        make.height.mas_equalTo(kScreenHeight-kStatusAndNavBarH);
        
        make.left.right.bottom.mas_equalTo(self.contentScollView);
        make.top.mas_equalTo(self.bannerView.mas_bottom);
    }];
    
    self.pageController.viewFrame = CGRectMake(0, 0, kScreenWidth, kScreenHeight-kStatusAndNavBarH);
}


#pragma mark - notification
-(void)acceptMsg : (NSNotification *)notification {
    
    if ([notification.name isEqualToString:kHomeLeaveTopNotification]) {
        
        NSDictionary *userInfo = notification.userInfo;
        NSString *canScroll = userInfo[@"canScroll"];
        self.canScroll = [canScroll isEqualToString:@"1"];
    } else if ([notification.name isEqualToString:kHomeScrollTop_Notice]) {
        [self.contentScollView setContentOffset:CGPointMake(0, [self.bannerView getContentHeight])];
    }
}


#pragma mark - UIScrollViewDelegate

-(void)scrollViewDidScroll:(UIScrollView *)scrollView {
    
    if (scrollView != self.contentScollView) return;
    
    CGFloat maxOffsetY = [self.bannerView getContentHeight];   // 最大偏移
    CGFloat offsetY = scrollView.contentOffset.y;
    NSLog(@"偏移量:===%f", offsetY);
    
    if (offsetY >= maxOffsetY) {
        scrollView.contentOffset = CGPointMake(0, maxOffsetY);
        // 告诉底部内容视图能进行滑动了
        [[NSNotificationCenter defaultCenter] postNotificationName:kHomeGoTopNotification object:nil userInfo:@{@"canScroll":@"1"}];
        self.canScroll = NO; // 自己不能滑动了
    }
    
    if (self.canScroll == NO) {
        [scrollView setContentOffset:CGPointMake(0, maxOffsetY)];
    }
}

#pragma mark -- click
/** 选择地址 */
-(void)chooseAddress {
    [self hiddenAllPopView];
    NSLog(@"chooseAddress");
}

/** 二维码拍照 */
-(void)QRCardAction {
    [self hiddenAllPopView];
    NSLog(@"QRCardAction");
}

/** 搜索 */
-(void)searchAction {
    
    [self hiddenAllPopView];
    NSLog(@"searchAction");
}

-(void)setCanScroll:(BOOL)canScroll {
    
    _canScroll = canScroll;
    self.contentScollView.showsVerticalScrollIndicator = _canScroll;
}

-(void)hiddenAllPopView {
    
    if ([self.pageController.currentViewController isKindOfClass:[TGHomeShopController class]]) {
        
        TGHomeShopController *shopPage = (TGHomeShopController *)self.pageController.currentViewController;
        [shopPage hiddenPagePopView];
    }
}

-(NSArray *)getItemsWidth {
    
    NSMutableArray *widths = [NSMutableArray array];
    for (NSString *value in self.titles) {
        CGFloat width = [value textSizeIn:CGSizeMake(kScreenWidth, MAXFLOAT) font:[UIFont systemFontOfSize:18]].width + 10;
        [widths addObject:[NSNumber numberWithDouble:width]];
    }
    return widths;
}

#pragma mark Private
/**
 计算字符串长度
 
 @param string string
 @param font font
 @return 字符串长度
 */
- (CGFloat)getWidthWithString:(NSString *)string font:(UIFont *)font {
    NSDictionary *attrs = @{NSFontAttributeName : font};
    return [string boundingRectWithSize:CGSizeMake(0, 0) options:NSStringDrawingUsesLineFragmentOrigin attributes:attrs context:nil].size.width;
}

-(void)loadBaseDataSource {
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setValue:@(1) forKey:@"page"];
    [params setValue:@(20) forKey:@"pageSize"];
    
    [params setValue:@(23.135309) forKey:@"lat"];
    [params setValue:@(113.269043) forKey:@"lon"];
    
    [YPProgressHUD yp_showDIYLoading];
    [YPHttpTool GET:@"/search/shop/home-location-index/" params:params complete:^(id  _Nonnull data) {
        
        NSDictionary *dict = [[data objectForKey:@"result"] objectForKey:@"basic"];
        NSArray *topList    = [dict objectForKey:@"adList"];
        NSArray *menuList   = [dict objectForKey:@"navList"];
        NSArray *bottomList = [dict objectForKey:@"adListV2"];
        
        
        [self.bannerView setTopList:topList menuList:menuList bottomList:bottomList];
        [self.bannerView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo([self.bannerView getContentHeight]);
        }];
        
        TGHomeBaseViewController *baseChildVC = (TGHomeBaseViewController *)self.pageController.currentViewController;
        [baseChildVC loadDataAfterLocation:self.locationState withMjHeader:self.contentScollView.mj_header];
        
        [YPProgressHUD yp_dismissHUD];
    } failure:^(NSError * _Nonnull error) {
        [YPProgressHUD yp_showErrorHUDWithTitle:error.localizedDescription];
    }];
}

#pragma mark -- Getter
- (TGShopHeaderView *)shopHeaderView {
    if (!_shopHeaderView) {
        _shopHeaderView = [TGShopHeaderView viewFromXib];
        _shopHeaderView.frame = CGRectMake(0, 0, kScreenWidth, ShopHeaderView_Height);
        
        __weak typeof(self) weakSelf = self;
        [_shopHeaderView setClickBlock:^(NSInteger idx) {
            switch (idx) {
                case 1:
                    [weakSelf chooseAddress];
                    break;
                case 2:
                    [weakSelf QRCardAction];
                    break;
                case 3:
                    [weakSelf searchAction];
                    break;
                default:
                    break;
            }
        }];
    }
    return _shopHeaderView;
}

// 最底层的scrollView
- (YPArtScrollView *)contentScollView {
    if (!_contentScollView) {
        _contentScollView = [[YPArtScrollView alloc] init];
        _contentScollView.delegate = self;
        _contentScollView.showsVerticalScrollIndicator = YES;
    }
    return _contentScollView;
}

// 顶部视图
- (TGHomeTopView *)bannerView {
    if (!_bannerView) {
        _bannerView = [[TGHomeTopView alloc] init];
        _bannerView.backgroundColor = [UIColor whiteColor];
    }
    return _bannerView;
}
// 底部视图
- (UIView *)contentView {
    if (!_contentView) {
        _contentView = [[UIView alloc] init];
        _contentView.backgroundColor = [UIColor yellowColor];
    }
    return _contentView;
}

// 底部内容视图
- (WMPageController *)pageController {
    if (!_pageController) {
        // ChildTableViewController子视图
        _pageController = [[WMPageController alloc] initWithViewControllerClasses:@[[TGHomeShopController class], [TGHomeSchoolController class]] andTheirTitles:self.titles];
        _pageController.menuViewStyle      = WMMenuViewStyleLine;
        _pageController.progressWidth      = 35;
        _pageController.titleSizeNormal    = 18;
        _pageController.titleSizeSelected  = 18;
        _pageController.itemsWidths        = [self getItemsWidth];
        _pageController.itemMargin         = 15;
        _pageController.menuViewLayoutMode = WMMenuViewLayoutModeLeft;
        _pageController.titleColorNormal   = HEXColor(333333);
        _pageController.titleColorSelected = HEXColor(333333);
        _pageController.progressColor      = HEXColor(0xFF4E00);
        _pageController.delegate           = self;
        
        _pageController.menuHeight      = 44;
        _pageController.menuBGColor     = HEXColor(0xFFFFFF);

    }
    return _pageController;
}

@end
