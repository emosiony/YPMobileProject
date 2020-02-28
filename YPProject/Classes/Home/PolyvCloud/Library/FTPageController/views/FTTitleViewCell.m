//
//  FTTitleViewCell.m
//  FTPageController
//
//  Created by ftao on 04/01/2018.
//  Copyright © 2018 easefun. All rights reserved.
//

#import "FTTitleViewCell.h"

@implementation FTTitleViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    self.clicked = NO;
}

/*
- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        CGFloat width = frame.size.width;
        CGFloat height = frame.size.height;
        
        _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, width, frame.size.height)];
        _titleLabel.textColor = [UIColor darkGrayColor];
        _titleLabel.font = [UIFont systemFontOfSize:16];
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        [self addSubview:_titleLabel];
        
        _indicatorView = [[UIView alloc] initWithFrame:CGRectMake((width - 30)/2., height - 3, 30, 3)];
        _indicatorView.backgroundColor = [UIColor colorWithRed:0x21/255.0 green:0x96/255.0 blue:0xf3/255.0 alpha:1.0];
        [self addSubview:_indicatorView];
        _indicatorView.hidden = YES;
    }
    return self;
}
*/

- (void)setClicked:(BOOL)clicked {
    _clicked = clicked;
    
    _indicatorView.hidden = !clicked;
    _titleLabel.textColor = clicked ? [UIColor colorWithRed:33/255.0 green:150/255.0 blue:243/255.0 alpha:1.0] : [UIColor darkGrayColor];
}

+ (CGFloat)cellWidth {
    return 90.0;
}

@end
