//
//  YPColorManagerView.m
//  YPProject
//
//  Created by 幸福e家 on 2020/2/16.
//  Copyright © 2020 jzg. All rights reserved.
//

#import "YPColorManagerView.h"
#import "LXFDrawBoardStyle.h"

@interface YPColorManagerView ()

@property (weak, nonatomic) IBOutlet UIView *lineView2;
@property (weak, nonatomic) IBOutlet UIView *lineView3;
@property (weak, nonatomic) IBOutlet UIView *lineView4;
@property (weak, nonatomic) IBOutlet UIView *lineView5;
@property (weak, nonatomic) IBOutlet UIView *lineView6;
@property (weak, nonatomic) IBOutlet UIView *lineView7;

@property (nonatomic, strong) UIView *selectLineView;
@property (nonatomic, strong) LXFDrawBoardStyle *boardStyle;

@end
@implementation YPColorManagerView


- (void)awakeFromNib {
    
    [super awakeFromNib];
    
    ViewRadius(self.lineView2, CGRectGetHeight(self.lineView2.frame)
               /2);
    ViewRadius(self.lineView3, CGRectGetHeight(self.lineView3.frame)
               /2);
    ViewRadius(self.lineView4, CGRectGetHeight(self.lineView4.frame)
               /2);
    ViewRadius(self.lineView5, CGRectGetHeight(self.lineView5.frame)
               /2);
    ViewRadius(self.lineView6, CGRectGetHeight(self.lineView6.frame)
               /2);
    LayerBorderRadius(self.lineView7, CGRectGetHeight(self.lineView7.frame)
                      /2, 0.5, HEXColor(0x333333));

    self.selectLineView = self.lineView2;
    
    WeakSelf();
    [RACObserve(self, selectLineView) subscribeNext:^(id  _Nullable x) {
        for (NSInteger i = 0; i < 6; i++) {
            UIView *view = [weakself viewWithTag:12 + i];
 
            if (view == weakself.selectLineView) {
                [view mas_updateConstraints:^(MASConstraintMaker *make) {
                    make.height.width.mas_equalTo(18);
                }];
                ViewRadius(view, 9);
            } else {
                [view mas_updateConstraints:^(MASConstraintMaker *make) {
                     make.height.width.mas_equalTo(14);
                }];
                ViewRadius(view, 7);
            }
        }
    }];
    
    self.boardStyle = [LXFDrawBoardStyle shareManager];
    
    [RACObserve(self.boardStyle, lineColor) subscribeNext:^(id  _Nullable x) {
        for (NSInteger i = 0; i < 6; i++) {
            UIView *view = [weakself viewWithTag:12 + i];
            if (CGColorEqualToColor(weakself.boardStyle.lineColor.CGColor, view.backgroundColor.CGColor)) {
                self.selectLineView = view;
            }
        }
    }];
}

- (IBAction)selectClick:(UIButton *)sender {
    
    UIView *view = [self viewWithTag:sender.tag - 10];
    self.selectLineView = view;
    
    self.boardStyle.lineColor = view.backgroundColor;
    self.boardStyle.textColor = view.backgroundColor;
}

- (IBAction)bakcClick:(id)sender {
    self.tapBackClick ? self.tapBackClick() : nil;
}

@end
