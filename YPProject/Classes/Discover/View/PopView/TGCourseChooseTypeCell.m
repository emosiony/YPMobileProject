//
//  TGCourseChooseTypeCell.m
//  TGVendor
//
//  Created by Jtg_yao on 2018/11/15.
//  Copyright © 2018年 jzg. All rights reserved.
//

#import "TGCourseChooseTypeCell.h"

@implementation TGCourseChooseTypeCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setProductOptionModel:(TGProductOptionModel *)productOptionModel {
    _productOptionModel = productOptionModel;
    
    _titleLabel.text = productOptionModel.name;
    _chooseIcon.hidden = YES;
    
    [self updateUI:productOptionModel.isClick choose:productOptionModel.isChoose];
}

- (void)updateUI:(BOOL)isClick choose:(BOOL)isChoose {
    if (isClick) {
        _chooseIcon.hidden = !isChoose;
        if (isChoose) {
            LayerBorderRadius(self, 3.0f, 1.0f, HEXColor(0x01A1ED));
            _titleLabel.textColor = HEXColor(0x01A1ED);
        } else {
            LayerBorderRadius(self, 3.0f, 1.0f, HEXColor(0xdddddd));
            _titleLabel.textColor = HEXColor(0x333333);
        }
    } else {
        LayerBorderRadius(self, 3.0f, 1.0f, HEXColor(0xCCCCCC));
        _titleLabel.textColor = HEXColor(0xCCCCCC);
    }
}

@end
