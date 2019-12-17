//
//  TGShopDetailDiscountView.m
//  TGParent
//
//  Created by Jtg_yao on 2019/12/9.
//  Copyright © 2019 jzg. All rights reserved.
//

#import "TGShopDetailDiscountView.h"
#import "TGShopDetailDiscountItem.h"

#define Item_Tag 800

@interface TGShopDetailDiscountView ()

@property (nonatomic,strong) NSMutableArray *items;

@property (nonatomic,strong) UIView *itemView;
@property (nonatomic,strong) UILabel *tipLabel;

@end

@implementation TGShopDetailDiscountView

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self setupSubView];
    }
    return self;
}

- (void)awakeFromNib {
    
    [super awakeFromNib];
    [self setupSubView];
}

- (void)setupSubView {
    
    self.backgroundColor = HEXColor(0x123321);
    LayerBorderRadius(self, 0, 1, HEXColor(0x123456));
    
    [self addSubview:self.itemView];
    [self addSubview:self.tipLabel];
    
    [self.itemView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.mas_equalTo(self);
        make.bottom.mas_equalTo(self.tipLabel.mas_top).offset(-5);
    }];
    
    [self.tipLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.itemView.mas_bottom).offset(5);
        make.left.right.bottom.mas_equalTo(self);
    }];
    
    self.discountArray = @[@{}, @{}, @{}];
}

- (void)setDiscountArray:(NSArray *)discountArray {
    
    _discountArray = discountArray;
    
    if (_discountArray.count > 1) {
        self.showType = TGShopDDisShowTypeClose;
    } else if (_discountArray.count == 1) {
        self.showType = TGShopDDisShowTypeOnece;
    }
    
    [self setDiscountItems];
}

- (void)setDiscountItems {
    
    [self.itemView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    [self.items removeAllObjects];
    
    NSArray *showArray = self.discountArray;
    if (self.showType == TGShopDDisShowTypeClose) {
        showArray = [self.discountArray subarrayWithRange:NSMakeRange(0, 1)];
    }
    
    [showArray enumerateObjectsUsingBlock:^(NSDictionary * _Nonnull dict, NSUInteger idx, BOOL * _Nonnull stop) {
        
        TGShopDetailDiscountItem *item = [TGShopDetailDiscountItem viewFromXib];
        item.tag = Item_Tag + idx;
        
        DiscountItemShowType showType = DiscountItemShowTypeHidden;
        if (self.discountArray.count > 1 && self.showType == TGShopDDisShowTypeClose) {
            if (idx == 0) {
                showType = DiscountItemShowTypeClose;
            } else if (idx == self.discountArray.count - 1) {
                showType = DiscountItemShowTypeOpen;
            } else {
                showType = DiscountItemShowTypeHidden;
            }
        } else {
            showType = DiscountItemShowTypeHidden;
        }
        [item setTitle:@"新生专享" content:@"满100元减50元，满100元减50元，满100元减50元，满10减2,满100元减50元，满100元减50元，满100元减50元，满10减2,满100元减50元，满100元减50元，满100元减50元，满10减2" showType:showType];
        
        [item setTapOpenBlock:^(DiscountItemShowType showType) {
            if (showType == DiscountItemShowTypeClose) {
                self.showType = TGShopDDisShowTypeOpen;
            } else {
                self.showType = TGShopDDisShowTypeClose;
            }
            [self setDiscountItems];
        }];
        
        [self.itemView addSubview:item];
        [self.items addObject:item];
        
        if (idx == 0) {
            [item mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.left.right.mas_equalTo(self.itemView);
                if (showArray.count == 1) {
                    make.bottom.mas_equalTo(self.itemView.mas_bottom);
                }
            }];
        } else {
            TGShopDetailDiscountItem *frontItem = (TGShopDetailDiscountItem *)[self.items objectAtIndex:idx - 1];
            
            [item mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.mas_equalTo(frontItem.mas_bottom).offset(5);
                make.left.right.mas_equalTo(frontItem);
                if (showArray.count - 1 == idx) {
                    make.bottom.mas_equalTo(self.itemView.mas_bottom);
                }
            }];
        }
    }];
    
    [self layoutIfNeeded];
    
    if (self.items.count) {
        
        [self.tipLabel sizeToFit];
        
        TGShopDetailDiscountItem *lastItem = (TGShopDetailDiscountItem *)[self.items lastObject];
        [self.itemView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(lastItem.mj_y + lastItem.mj_h + 5);
        }];
        
        [self mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(lastItem.mj_y + lastItem.mj_h + 10 + self.tipLabel.mj_h);
        }];
    }
}

- (NSMutableArray *)items {
    
    if (_items == nil) {
        _items = [NSMutableArray array];
    }
    return _items;
}

- (UIView *)itemView {
    
    if (_itemView == nil) {
        _itemView = [[UIView alloc] init];
    }
    return _itemView;
}

- (UILabel *)tipLabel {
    
    if (_tipLabel == nil) {
        _tipLabel = [[UILabel alloc] init];
        _tipLabel.text = @"下单时自动计算出最大补贴进行结算，享此补贴时将不会获赠今币";
        _tipLabel.textColor = HEXColor(0x999999);
        _tipLabel.numberOfLines = 0;
        _tipLabel.font = [UIFont systemFontOfSize:10];
    }
    return _tipLabel;
}

@end
