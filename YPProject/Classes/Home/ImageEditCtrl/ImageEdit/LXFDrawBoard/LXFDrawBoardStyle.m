//
//  LXFDrawBoardStyle.m
//  LXFDrawBoard
//
//  Created by LXF on 2017/7/6.
//  Copyright © 2017年 LXF. All rights reserved.
//
//  GitHub: https://github.com/LinXunFeng
//  简书: http://www.jianshu.com/users/31e85e7a22a2

#import "LXFDrawBoardStyle.h"

@implementation LXFDrawBoardStyle

KSingleToolM(Manager);

- (CGFloat)lineWidth {
    
    if (_lineWidth <= 0) {
        _lineWidth = 2;
    }
    return _lineWidth;
}

- (UIColor *)lineColor {
    
    if (_lineColor == nil) {
        _lineColor = HEXColor(0xE8514A);
    }
    return _lineColor;
}

- (CGFloat)textSize {
    
    CGFloat textSize = 12 + self.lineWidth;
    return  textSize;
}

- (UIColor *)textColor {
    
    if (_textColor == nil) {
        _textColor = self.lineColor;
    }
    return _textColor;
}

@end
