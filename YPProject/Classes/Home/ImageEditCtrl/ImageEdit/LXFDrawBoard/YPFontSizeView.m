//
//  YPFontSizeView.m
//  YPProject
//
//  Created by 幸福e家 on 2020/2/16.
//  Copyright © 2020 jzg. All rights reserved.
//

#import "YPFontSizeView.h"
#import "LXFDrawBoardStyle.h"

@interface YPFontSizeView ()

@property (weak, nonatomic) IBOutlet UIView *lineView2;
@property (weak, nonatomic) IBOutlet UIView *lineView3;
@property (weak, nonatomic) IBOutlet UIView *lineView4;
@property (weak, nonatomic) IBOutlet UIView *lineView5;
@property (weak, nonatomic) IBOutlet UIView *lineView6;

@property (nonatomic, strong) UIView *selectLineView;
@property (nonatomic, strong) LXFDrawBoardStyle *boardStyle;

@end

@implementation YPFontSizeView

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

    self.selectLineView = self.lineView2;
    
    WeakSelf();
    [RACObserve(self, selectLineView) subscribeNext:^(id  _Nullable x) {
        for (NSInteger i = 0; i < 5; i++) {
            UIView *view = [weakself viewWithTag:12 + i];
            view.backgroundColor = HEXColor(0x5D5D5D);
        }
        if (weakself.selectLineView != nil) {
            weakself.selectLineView.backgroundColor = HEXColor(0x446BFD);
        }
    }];
    
    self.boardStyle = [LXFDrawBoardStyle shareManager];
    
    [RACObserve(self, boardStyle) subscribeNext:^(id  _Nullable x) {
        UIView *view = [weakself viewWithTag:10 + weakself.boardStyle.lineWidth];
        if (view != nil) {
            weakself.selectLineView = view;
        }
    }];
    
    [RACObserve(self.boardStyle, lineWidth) subscribeNext:^(id  _Nullable x) {
        UIView *view = [weakself viewWithTag:10 + weakself.boardStyle.lineWidth];
        if (view != nil) {
            weakself.selectLineView = view;
        }
    }];
}

- (IBAction)selectClick:(UIButton *)sender {
    
    UIView *view = [self viewWithTag:sender.tag - 10];
    self.selectLineView = view;
    
    self.boardStyle.lineWidth = sender.tag - 20;
}

- (IBAction)bakcClick:(id)sender {
    self.tapBackClick ? self.tapBackClick() : nil;
}


@end
