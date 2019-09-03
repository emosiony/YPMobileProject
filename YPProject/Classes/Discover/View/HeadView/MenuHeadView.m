//
//  menuHeadView.m
//  FastlaneTest
//
//  Created by Jtg_yao on 2018/5/22.
//  Copyright © 2018年 YDP. All rights reserved.
//

#import "MenuHeadView.h"
#import "UIButton+BackgroundColor.h"

@interface  MenuHeadView()

@property (strong, nonatomic) UIButton *universalItem;              //综合排序
@property (strong, nonatomic) UIButton *distanceItem;               //距离排序
//@property (strong, nonatomic) UIButton *evaluationItem;             //好评优先

@end

@implementation MenuHeadView

-(instancetype)initWithFrame:(CGRect)frame {
    
    if (self = [super initWithFrame:frame]) {
    
        [self initSubView];
        [self setupData];
    }
    return self;
}

-(void)initSubView {
    self.backgroundColor = [UIColor whiteColor];
    _universalItem = [self addButtonWithTitle:@"综合排序" tag:TGMenuHeadTypeUniversal];
    _universalItem.selected = YES;
    _distanceItem = [self addButtonWithTitle:@"距离排序" tag:TGMenuHeadTypeDistance];
//    _evaluationItem = [self addButtonWithTitle:@"好评优先" tag:TGMenuHeadTypeUniversal];
    
    [self addSubview:_universalItem];
    [self addSubview:_distanceItem];
//    [self addSubview:_evaluationItem];
    [self addSubview:self.filterItem];

//    NSArray *items = @[_universalItem, _distanceItem, _evaluationItem];
//    [items mas_distributeViewsAlongAxis:MASAxisTypeHorizontal
//                       withFixedSpacing:0
//                            leadSpacing:0
//                            tailSpacing:0];
    CGFloat itemW  = kScreenWidth / 5;
    // 设置array的垂直方向的约束
    [_universalItem mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.mas_equalTo(0);
        make.width.mas_equalTo(itemW);
    }];
    [_distanceItem mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.mas_equalTo(0);
        make.left.mas_equalTo(itemW);
        make.width.mas_equalTo(itemW);
    }];
//    [_evaluationItem mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.bottom.mas_equalTo(0);
//        make.left.mas_equalTo(2*itemW);
//        make.width.mas_equalTo(itemW);
//    }];
    [self.filterItem mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.right.bottom.mas_equalTo(0);
        make.width.mas_equalTo(80);
    }];
}

- (void)setupData {
    [_universalItem addTarget:self action:@selector(clickUniversalItem:) forControlEvents:UIControlEventTouchUpInside];
    [_distanceItem addTarget:self action:@selector(clickDistanceItem:) forControlEvents:UIControlEventTouchUpInside];
//    [_evaluationItem addTarget:self action:@selector(clickEvaluationItem:) forControlEvents:UIControlEventTouchUpInside];
    
    [RACObserve(_universalItem, selected) subscribeNext:^(NSNumber *selected) {
        if (selected.boolValue) {
            _universalItem.titleLabel.font = [UIFont systemFontOfSize:12 weight:UIFontWeightBold];
        } else {
            _universalItem.titleLabel.font = [UIFont systemFontOfSize:12 weight:UIFontWeightRegular];
        }
    }];
    [RACObserve(_distanceItem, selected) subscribeNext:^(NSNumber *selected) {
        if (selected.boolValue) {
            _distanceItem.titleLabel.font = [UIFont systemFontOfSize:12 weight:UIFontWeightBold];
        } else {
            _distanceItem.titleLabel.font = [UIFont systemFontOfSize:12 weight:UIFontWeightRegular];
        }
    }];
//    [RACObserve(_evaluationItem, selected) subscribeNext:^(NSNumber *selected) {
//        if (selected.boolValue) {
//            _evaluationItem.titleLabel.font = [UIFont systemFontOfSize:12 weight:UIFontWeightBold];
//        } else {
//            _evaluationItem.titleLabel.font = [UIFont systemFontOfSize:12 weight:UIFontWeightRegular];
//        }
//    }];
}

- (UIButton *)addButtonWithTitle:(NSString *)title tag:(NSInteger)tag {
    UIButton *button = [[UIButton alloc] init];
    button.tag = tag;
    button.titleLabel.font = [UIFont systemFontOfSize:12 weight:UIFontWeightRegular];
    [button setBackgroundColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [button setTitle:title forState:UIControlStateNormal];
    [button setTitleColor:HEXColor(0x999999) forState:UIControlStateNormal];
    [button setTitleColor:HEXColor(0x333333) forState:UIControlStateSelected];
    
    return button;
}

#pragma mark - Private

/** 更新 title */
- (void)upTitle:(NSString *)title index:(NSInteger)idx {
    ItemMeau *item = (ItemMeau *)[self viewWithTag:idx + 1];
    [item setNormalTitle:title];
    [item setSelectTitle:title];
    item.select = NO;
}

/** 取消所有选中 */
- (void)cancleAllChoose {
    self.filterItem.select = NO;
}

#pragma mark - EventResponse
/** 点击综合排序 */
- (void)clickUniversalItem:(UIButton *)button {
    if (!button.selected) {
        button.selected = YES;
        _distanceItem.selected = NO;
//        _evaluationItem.selected = NO;
        _clickBlock ? _clickBlock(TGMenuHeadTypeUniversal, YES) : nil;
    } else {
        return;
    }
}

/** 点击距离排序 */
- (void)clickDistanceItem:(UIButton *)button {
    BOOL isSelect = !button.selected;
    button.selected = isSelect;
    if (isSelect) {
        _universalItem.selected = NO;
//        _evaluationItem.selected = NO;
        _clickBlock ? _clickBlock(TGMenuHeadTypeDistance, YES) : nil;
    } else {
        _universalItem.selected = YES;
        _clickBlock ? _clickBlock(TGMenuHeadTypeUniversal, YES) : nil;
    }
}

/** 点击好评优先 */
- (void)clickEvaluationItem:(UIButton *)button {
    BOOL isSelect = !button.selected;
    button.selected = isSelect;
    
    if (isSelect) {
        _universalItem.selected = NO;
        _distanceItem.selected = NO;
        _clickBlock ? _clickBlock(TGMenuHeadTypeEvaluation, YES) : nil;
    } else {
        _universalItem.selected = YES;
        _clickBlock ? _clickBlock(TGMenuHeadTypeUniversal, YES) : nil;
    }
}

#pragma mark - getters
- (ItemMeau *)filterItem {
    if (!_filterItem) {
        _filterItem = [ItemMeau ViewFromXIB];
        _filterItem.tag = 1;
        [_filterItem titleNor:@"筛选"
                     titleSel:@"筛选"
                     imageNor:[UIImage imageNamed:@"home_filter_normal"]
                     imageSel:[UIImage imageNamed:@"home_filter_selected"]
                     colorNor:HEXColor(0x666666)
                     colorSel:HEXColor(0x58B8ED)];
        
        __weak typeof(self) weakSelf = self;
        _filterItem.itemClick = ^(BOOL isSelect) {
            weakSelf.clickBlock ? weakSelf.clickBlock(TGMenuHeadTypeFilter, isSelect) : nil;
        };
    }
    return _filterItem;
}

@end
