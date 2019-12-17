//
//  TGShopDetailDiscountItem.m
//  TGParent
//
//  Created by Jtg_yao on 2019/12/9.
//  Copyright © 2019 jzg. All rights reserved.
//

#import "TGShopDetailDiscountItem.h"

@interface TGShopDetailDiscountItem ()

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *contentLabel;
@property (weak, nonatomic) IBOutlet UIButton *clickButton;

@property (nonatomic,assign) DiscountItemShowType showType;

@end

@implementation TGShopDetailDiscountItem

- (void)awakeFromNib {
    
    [super awakeFromNib];
    
    LayerBorderRadius(self.titleLabel, 3, 0.5, HEXColor(0xFFB18F));
}

- (void)setTitle:(NSString *)title content:(NSString *)content showType:(DiscountItemShowType)showType {
    
    self.titleLabel.text   = [NSString stringWithFormat:@" %@ ", title];
    self.contentLabel.text = content;
    self.showType = showType;
    
    [self layoutIfNeeded];
}

- (void)setShowType:(DiscountItemShowType)showType {
    
    _showType = showType;
    
    if (_showType == DiscountItemShowTypeHidden) {
        [self.clickButton setHidden:YES];
    } else {
        [self.clickButton setHidden:NO];
        self.clickButton.selected = _showType == DiscountItemShowTypeOpen;
    }
}

- (IBAction)clickAction:(UIButton *)sender {
    
    DiscountItemShowType showType = sender.isSelected ? DiscountItemShowTypeOpen : DiscountItemShowTypeClose;
    self.tapOpenBlock ? self.tapOpenBlock(showType) : nil;
}


@end
