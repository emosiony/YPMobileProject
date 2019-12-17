//
//  TGHomeTopView.m
//  ScrollView嵌套悬停Demo
//
//  Created by Jtg_yao on 2019/8/21.
//  Copyright © 2019 谭高丰. All rights reserved.
//

#import "TGHomeTopView.h"
#import "Masonry.h"
#import "EllipsePageControl.h"
#import "TGHomeHeaderRecommendItem.h"
#import <SDCycleScrollView.h>

@interface TGHomeTopView ()
<UIScrollViewDelegate, EllipsePageControlDelegate>

@property (nonatomic,strong) SDCycleScrollView *topScrollView;

@property (nonatomic,strong) UIScrollView *menuScrollView;
@property (nonatomic,strong) EllipsePageControl *myPageControl;

@property (nonatomic,strong) SDCycleScrollView *bottomScrollView;

@property (nonatomic,strong) UIView *navLine;

@end

@implementation TGHomeTopView

- (instancetype)init
{
    self = [super init];
    if (self) {
        
        [self setUpSubviews];
    }
    return self;
}

-(void)setUpSubviews {
    
    [self addSubview:self.topScrollView];
    [self addSubview:self.menuScrollView];
    [self addSubview:self.myPageControl];
    [self addSubview:self.bottomScrollView];
    [self addSubview:self.navLine];

    [self.topScrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(Line_Margin);
        make.left.mas_equalTo(Line_Margin);
        make.right.mas_equalTo(-Line_Margin);
        make.height.mas_equalTo(TOP_SCROLL_HEIGHT);
    }];
    
    [self.menuScrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.topScrollView.mas_bottom).offset(Line_Margin);
        make.left.right.mas_equalTo(self.topScrollView);
        make.height.mas_equalTo(MENU_SCROLL_HEIGHT);
    }];
    [self.myPageControl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.menuScrollView.mas_bottom);
        make.left.right.mas_equalTo(self.topScrollView);
        make.height.mas_equalTo(5);
    }];
    
    [self.bottomScrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.myPageControl.mas_bottom).offset(Line_Margin);
        make.left.right.mas_equalTo(self.topScrollView);
        make.height.mas_equalTo(MENU_SCROLL_HEIGHT);
        make.bottom.mas_equalTo(-Line_Margin);
    }];
    
    [self.navLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.bottomScrollView.mas_bottom);
        make.left.right.mas_equalTo(self);
        make.height.mas_equalTo(Line_Margin);
        make.bottom.mas_equalTo(0);
    }];
}

-(void)setTopList:(NSArray *)topList menuList:(nonnull NSArray *)menuList bottomList:(nonnull NSArray *)bottomList {
    
    self.topList    = topList;
    self.menuList   = menuList;
    self.bottomList = bottomList;
}

-(void)setTopList:(NSArray *)topList {
    
    _topList = topList;
    NSMutableArray *adArr = [NSMutableArray array];
    for (NSDictionary *dic in _topList) {
        [adArr addObject:dic[@"thumb"]];
    }
    self.topScrollView.imageURLStringsGroup = adArr;
}

-(void)setMenuList:(NSArray *)menuList {
    
    [self.menuScrollView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    
    _menuList = menuList;
    
    if (_menuList.count) {
        
        for (NSInteger i = 0; i < _menuList.count; i++) {
            
            NSDictionary *info = [_menuList objectAtIndex:i];
            TGHomeHeaderRecommendItem *item = [TGHomeHeaderRecommendItem viewFromXIB];
            item.frame = CGRectMake(i * Item_Width, 0, Item_Width, self.bounds.size.height);
            item.dict = info;
            
            __weak typeof(self) weakSelf = self;
            item.recommendClick = ^(TGHomeHeaderRecommendItem * _Nonnull item, NSDictionary * _Nonnull info) {
                weakSelf.clickMenuBlock ? weakSelf.clickMenuBlock(info) : nil;
            };
            [self.menuScrollView addSubview:item];
        }
        
        
        self.myPageControl.hidden = _menuList.count < Menu_Page_Count;
        CGFloat width = self.bounds.size.width - 20;
        if (_menuList.count > Menu_Page_Count) {
            
            NSInteger num = _menuList.count/Menu_Page_Count + (_menuList.count % Menu_Page_Count ? 1 : 0);
            self.myPageControl.numberOfPages = num;
            self.menuScrollView.contentSize = CGSizeMake(width * num, self.menuScrollView.bounds.size.height);
            
            [self.myPageControl mas_updateConstraints:^(MASConstraintMaker *make) {
                make.height.mas_equalTo(0);
            }];
        } else {
            [self.myPageControl mas_updateConstraints:^(MASConstraintMaker *make) {
                make.height.mas_equalTo(5);
            }];
        }
    }
}

-(void)setBottomList:(NSArray *)bottomList {
    
    _bottomList = bottomList;
    NSMutableArray *adArr = [NSMutableArray array];
    for (NSDictionary *dic in _bottomList) {
        [adArr addObject:dic[@"thumb"]];
    }
    [self.bottomScrollView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(adArr.count ? MENU_SCROLL_HEIGHT : 0);
    }];
    self.bottomScrollView.imageURLStringsGroup = adArr;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (scrollView != self.menuScrollView) return;
    
    NSInteger page = scrollView.contentOffset.x / self.menuScrollView.bounds.size.width;
    
    if(page != self.myPageControl.currentPage)
    {
        self.myPageControl.currentPage = page;
    };
}

-(void)ellipsePageControlClick:(EllipsePageControl *)pageControl index:(NSInteger)clickIndex {
    
    [self.menuScrollView setContentOffset:CGPointMake(clickIndex * (self.menuScrollView.bounds.size.width), 0) animated:YES];
}

#pragma mark -- Getter
- (SDCycleScrollView *)topScrollView{
    if (!_topScrollView) {
        _topScrollView = [[SDCycleScrollView alloc] init];
        _topScrollView.frame = CGRectMake(Line_Margin, Line_Margin, kScreenWidth - 2*Line_Margin, TOP_SCROLL_HEIGHT);
        
        _topScrollView.userInteractionEnabled       = YES;
        _topScrollView.autoScrollTimeInterval       = 5.0f;
        _topScrollView.bannerImageViewContentMode   = UIViewContentModeScaleAspectFill;
        _topScrollView.pageControlAliment           = SDCycleScrollViewPageContolAlimentCenter;
        _topScrollView.backgroundColor              = HEXColor(0xF3F3F3);
        
        _topScrollView.layer.cornerRadius           = 3.0f;
        _topScrollView.layer.masksToBounds          = YES;
        
        _topScrollView.pageControlDotSize           = CGSizeMake(5, 5);
        _topScrollView.currentPageDotColor          = HEXColor(0x01A1ED);
        _topScrollView.pageDotColor                 = HEXColor(0xcccccc);
        _topScrollView.pageControlStyle             = SDCycleScrollViewPageContolStyleClassic;
        _topScrollView.placeholderImage             = [UIImage imageNamed:@"banner_default:3"];
        
        __weak typeof(self) weakSelf = self;
        _topScrollView.clickItemOperationBlock = ^(NSInteger currentIndex) {
            if (self.topList.count <= currentIndex) return;
            weakSelf.clickCallBackBlock ? weakSelf.clickCallBackBlock([weakSelf.topList objectAtIndex:currentIndex]) : nil;
        };
    }
    return _topScrollView;
}

/** 滚动 */
-(UIScrollView *)menuScrollView {
    
    if (_menuScrollView == nil) {
        _menuScrollView = [[UIScrollView alloc] init];
        
        _menuScrollView.showsHorizontalScrollIndicator = NO;
        _menuScrollView.showsVerticalScrollIndicator   = NO;
        _menuScrollView.keyboardDismissMode            = UIScrollViewKeyboardDismissModeOnDrag;
        _menuScrollView.backgroundColor                = HEXColor(0xFFFFFF);
        _menuScrollView.pagingEnabled                  = YES;
        _menuScrollView.bounces                        = NO;
        _menuScrollView.delegate                       = self;
    }
    return _menuScrollView;
}

-(EllipsePageControl *)myPageControl {
    
    if (_myPageControl == nil) {
        _myPageControl = [[EllipsePageControl alloc] init];
        _myPageControl.frame =  CGRectMake(0, 0, kScreenWidth, 5);
        _myPageControl.userInteractionEnabled = YES;
        _myPageControl.delegate      = self;
        _myPageControl.currentColor  = HEXColor(0x009FE8);
        _myPageControl.otherColor    = HEXColor(0xCCCCCC);
        _myPageControl.controlSpacing = 8.0f;
        _myPageControl.hidden         = YES;
    }
    return _myPageControl;
}

- (SDCycleScrollView *)bottomScrollView{
    if (!_bottomScrollView) {
        
        _bottomScrollView = [[SDCycleScrollView alloc] initWithFrame:CGRectMake(Line_Margin, 0, kScreenWidth - 2 * Line_Margin, BOTTOM_SCROLL_HEIGHT)];
        
        _bottomScrollView.userInteractionEnabled        = YES;
        _bottomScrollView.autoScroll                    = NO;
        _bottomScrollView.pageControlDotSize            = CGSizeMake(5, 5);
        _bottomScrollView.currentPageDotColor           = HEXColor(0x01A1ED);
        _bottomScrollView.pageDotColor                  = HEXColor(0xcccccc);
        _bottomScrollView.backgroundColor               = HEXColor(0xFFFFFF);
        _bottomScrollView.bannerImageViewContentMode    = UIViewContentModeScaleAspectFill;
        _bottomScrollView.pageControlStyle              = SDCycleScrollViewPageContolStyleClassic;
        _bottomScrollView.pageControlAliment            = SDCycleScrollViewPageContolAlimentCenter;
        _bottomScrollView.placeholderImage              = [UIImage imageNamed:@"banner_default:3"];
        
        __weak typeof(self) weakSelf = self;
        _bottomScrollView.clickItemOperationBlock = ^(NSInteger currentIndex) {
            if (self.bottomList.count <= currentIndex) return;
            weakSelf.clickCallBackBlock ? weakSelf.clickCallBackBlock([weakSelf.bottomList objectAtIndex:currentIndex]) : nil;
        };
    }
    return _bottomScrollView;
}

-(UIView *)navLine {
    
    if (_navLine == nil) {
        _navLine = [[UIView alloc] init];
        _navLine.backgroundColor = HEXColor(0xF3F3F3);
    }
    return _navLine;
}

-(CGFloat)getContentHeight {
    
    CGFloat contentHeight = Line_Margin + TOP_SCROLL_HEIGHT + Line_Margin + MENU_SCROLL_HEIGHT + Line_Margin + BOTTOM_SCROLL_HEIGHT + Line_Margin + Line_Margin;
    contentHeight += self.menuList.count > Menu_Page_Count ? 5.0f : 0.0f;
    contentHeight -= self.bottomList.count > 0 ? 0 : (BOTTOM_SCROLL_HEIGHT + Line_Margin);
    return contentHeight;
}

@end
