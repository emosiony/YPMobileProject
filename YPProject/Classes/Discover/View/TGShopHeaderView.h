//
//  TGShopHeaderView.h
//  TGParent
//
//  Created by 姚敦鹏 on 2018/3/31.
//  Copyright © 2018年 jzg. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TGShopHeaderView : UIView

@property (weak, nonatomic) IBOutlet UIView *bannerView;
@property (weak, nonatomic) IBOutlet UIImageView *localImg;
@property (weak, nonatomic) IBOutlet UILabel     *addressLabel;
@property (weak, nonatomic) IBOutlet UIImageView *doenImg;
@property (weak, nonatomic) IBOutlet UIButton    *QRCardButton;

@property (nonatomic,copy) void(^ClickBlock)(NSInteger idx);

@end
