//
//  TGShopHeaderView.m
//  TGParent
//
//  Created by 姚敦鹏 on 2018/3/31.
//  Copyright © 2018年 jzg. All rights reserved.
//

#import "TGShopHeaderView.h"

@interface TGShopHeaderView ()


@end

@implementation TGShopHeaderView

- (void)drawRect:(CGRect)rect {
//    self.backgroundColor = HEXCOLOR(0x01A1ED);
    self.localImg.userInteractionEnabled = YES;
    [self.localImg addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAddress)]];
    
    self.addressLabel.userInteractionEnabled = YES;
    [self.addressLabel addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAddress)]];
    
    self.doenImg.userInteractionEnabled = YES;
    [self.doenImg addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAddress)]];
}

- (void)tapAddress {
    self.ClickBlock ? self.ClickBlock(1) : nil;
}

- (IBAction)AQRCardAction:(UIButton *)sender {
    self.ClickBlock ? self.ClickBlock(2) : nil;
}

- (IBAction)clickSearchButton:(id)sender {
    self.ClickBlock ? self.ClickBlock(3) : nil;
}

@end
