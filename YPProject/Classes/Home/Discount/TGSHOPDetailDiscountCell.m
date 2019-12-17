//
//  TGSHOPDetailDiscountCell.m
//  YPProject
//
//  Created by Jtg_yao on 2019/12/9.
//  Copyright © 2019 jzg. All rights reserved.
//

#import "TGSHOPDetailDiscountCell.h"

@interface TGSHOPDetailDiscountCell ()

@property (nonatomic,assign) ShopDDisShowType showType;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *contentLabel;
@property (weak, nonatomic) IBOutlet UIButton *iconImage;

@end

@implementation TGSHOPDetailDiscountCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    LayerBorderRadius(self.titleLabel, 3, 0.5, HEXColor(0xFFB18F));
}

- (void)setTitle:(NSString *)title content:(NSString *)content showType:(ShopDDisShowType)showType {
    
    self.titleLabel.text   = [NSString stringWithFormat:@" %@ ", title];
    self.contentLabel.text = content;
    
    self.showType = showType;
    switch (showType) {
        case ShopDDisShowTypeOpen:
            self.iconImage.selected = YES;
            self.iconImage.hidden = NO;
            break;
        case ShopDDisShowTypeClose:
            self.iconImage.selected = NO;
            self.iconImage.hidden = NO;
            break;
        case ShopDDisShowTypeOnece:
            self.iconImage.selected = NO;
            self.iconImage.hidden = YES;
            break;
        default:
            break;
    }
}

- (IBAction)selectClick:(UIButton *)sender {
    
    self.tapOpenClick ? self.tapOpenClick(self.showType) : nil;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
