//
//  TGHomeShopNewCell.m
//  TGParent
//
//  Created by Jtg_yao on 2019/7/9.
//  Copyright © 2019 jzg. All rights reserved.
//

#import "TGHomeShopNewCell.h"

@interface TGHomeShopNewCell ()

@property (weak, nonatomic) IBOutlet UIImageView *shopIcon;
@property (weak, nonatomic) IBOutlet UILabel *shopName;

@property (weak, nonatomic) IBOutlet UIView *shopTipView;
@property (weak, nonatomic) IBOutlet UILabel *shopTipLabel;

@property (weak, nonatomic) IBOutlet UIView *tagView;

@property (weak, nonatomic) IBOutlet UIView *bottomView;
@property (weak, nonatomic) IBOutlet UIView *shopTypeView;
@property (weak, nonatomic) IBOutlet UILabel *shopTypeLabel;
@property (weak, nonatomic) IBOutlet UILabel *addressLabel;
@property (weak, nonatomic) IBOutlet UILabel *disLabel;

@end

@implementation TGHomeShopNewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    ViewRadius(self.shopIcon, 6.0f);
    ViewRadius(self.shopTypeView, 3.0f);
}

-(void)setModel:(TGShopInfoModel *)model {
    
    _model = model;
    
    [self.shopIcon sd_setImageWithURL:HostURLImage(_model.logo) placeholderImage:SHOP_ICON_DEFAULT];
    self.shopName.text = _model.name;
    
    if (!strIsEmpty(_model.distance)) {
        CGFloat distance = [_model.distance floatValue];
        NSString *disStr;
        if (distance > 1000) {
            distance = distance/1000;
            disStr = [NSString stringWithFormat:@"%.1fkm",distance];
        } else {
            disStr = [NSString stringWithFormat:@"%.1fm",distance];
        }
        self.disLabel.text = disStr;
    }
    
    self.shopTipView.hidden = strIsEmpty(_model.mainTag);
    self.shopTipLabel.text  = _model.mainTag;
    self.addressLabel.text  = _model.address;
    self.shopTypeLabel.text = _model.shopType;
    
    self.tagView.hidden = _model.subTagList.count <= 0;
    if (_model.subTagList.count) {
        
        CGFloat height = [UIFont systemFontOfSize:14].lineHeight + 5;
        
        [_tagView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.shopName.mas_bottom).offset(8.0f);
            make.left.right.mas_equalTo(self.shopName);
            make.height.mas_equalTo(height);
        }];
        
        [_bottomView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.tagView.mas_bottom).offset(8.0f);
            make.left.right.mas_equalTo(self.shopName);
            make.bottom.mas_equalTo(self).offset(-10);
        }];
        
        [self.tagView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
        WeakSelf();
        [_model.subTagList enumerateObjectsUsingBlock:^(NSString * _Nonnull string, NSUInteger idx, BOOL * _Nonnull stop) {
            [weakself setLabel:idx withText:string];
        }];
    } else {
        [_bottomView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.shopName.mas_bottom).offset(8.0f);
            make.left.right.mas_equalTo(self.shopName);
            make.bottom.mas_equalTo(self).offset(-10);
        }];
    }
}

-(void)setSchool:(TGSchoolInfoModel *)school {
    
    _school = school;
    
    [self.shopIcon sd_setImageWithURL:HostURLImage(_school.logoUrl) placeholderImage:SHOP_ICON_DEFAULT];
    self.shopName.text = _school.schoolName;
    
    if (!strIsEmpty(_school.distance.stringValue)) {
        CGFloat distance = [_school.distance floatValue];
        NSString *disStr;
        if (distance > 1000) {
            distance = distance/1000;
            disStr = [NSString stringWithFormat:@"%.1fkm",distance];
        } else {
            disStr = [NSString stringWithFormat:@"%.1fm",distance];
        }
        self.disLabel.text = disStr;
    }
    
    self.shopTipView.hidden = YES;
    self.addressLabel.text  = _school.address;
    NSString *type = _school.nature.integerValue == 0 ? @"公立" : @"私立";
    self.shopTypeLabel.text = type;
    self.tagView.hidden = YES;
    
    [_bottomView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.shopName.mas_bottom).offset(8.0f);
        make.left.right.mas_equalTo(self.shopName);
        make.bottom.mas_equalTo(self).offset(-10);
    }];
}

-(void)setLabel:(NSInteger)idx withText:(NSString *)name {
    
    NSUInteger tag = 1 + idx;
    UILabel *oldLabel = [self.tagView viewWithTag:tag - 1];
    CGFloat maxX = oldLabel == nil || ![oldLabel isKindOfClass:[UILabel class]] ? 0 : MaxX(oldLabel);
    if (maxX >= kScreenWidth - 100) {
        return;
    }
    
    CGFloat width = [name textSizeIn:CGSizeMake(kScreenWidth - 100, MAXFLOAT) font:[UIFont systemFontOfSize:10]].width + 10;
    if (maxX + width > kScreenWidth - 15) {
        return;
    }
    
    UILabel *newLabel = [UILabel new];
    [self.tagView addSubview:newLabel];
    [newLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.mas_equalTo(self.tagView);
        make.width.mas_equalTo(width);
        if (oldLabel == nil || ![oldLabel isKindOfClass:[UILabel class]]) {
            make.left.mas_equalTo(_tagView);
        } else {
            make.left.mas_equalTo(oldLabel.mas_right).mas_offset(8);
        }
    }];
    
    newLabel.font = [UIFont systemFontOfSize:10];
    newLabel.numberOfLines = 1;
    newLabel.tag  = tag;
    newLabel.text = name;
    newLabel.textAlignment = NSTextAlignmentCenter;
    
    newLabel.textColor = HEXColor(0xFF882B);;
    ViewRadius(newLabel, 3);
    newLabel.layer.borderWidth = 1;
    newLabel.layer.borderColor = HEXColor(0xFFC598).CGColor;
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
