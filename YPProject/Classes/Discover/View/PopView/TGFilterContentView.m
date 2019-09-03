//
//  TGFilterContentView.m
//  TGParent
//
//  Created by Jtg_yao on 2019/4/2.
//  Copyright © 2019年 jzg. All rights reserved.
//

#import "TGFilterContentView.h"

#define titleViewHeight 27

@interface TGFilterContentView ()

@property (nonatomic,copy)    NSArray *title;

@property (nonatomic,assign) NSInteger selectIndex;

@property (strong, nonatomic) UIView *titleView;
@property (strong, nonatomic) TGGradeSelectView *gradeSelectView;

@end

@implementation TGFilterContentView

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self setUpSubView];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setUpSubView];
    }
    return self;
}

-(void)setUpSubView {
    
    [self addSubview:self.titleView];
    
    [self addSubview:self.gradeSelectView];
    
    [self.titleView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(10);
        make.left.mas_equalTo(15);
        make.right.mas_equalTo(-15);
        make.height.mas_equalTo(titleViewHeight);
    }];
    
    [self.gradeSelectView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.bottom.right.mas_equalTo(self);
        make.top.mas_equalTo(self.titleView.mas_bottom).offset(5);
    }];
}

-(void)setHorizontalInterval:(NSInteger)horizontalInterval {
    
    _horizontalInterval = horizontalInterval;
    _gradeSelectView.horizontalInterval = _horizontalInterval;
}

-(void)setVerticalInterval:(NSInteger)verticalInterval {
    
    _verticalInterval = verticalInterval;
    _gradeSelectView.verticalInterval   = _verticalInterval;
}

-(void)setPreLineCount:(NSInteger)preLineCount {
    
    _preLineCount = preLineCount;
    _gradeSelectView.preLineCount       = _preLineCount;
}

-(void)setIsMoreChoose:(BOOL)isMoreChoose {
    
    _isMoreChoose = isMoreChoose;
    _gradeSelectView.isMoreChoose       = _isMoreChoose;
}

-(void)setPreColumnCount:(NSInteger)preColumnCount {
    
    _preColumnCount = preColumnCount;
    _gradeSelectView.preColumnCount     = _preColumnCount;

}

-(UIView *)titleView {
    
    if (_titleView == nil) {
        _titleView = [[UIView alloc] init];
        _titleView.userInteractionEnabled = YES;
    }
    return _titleView;
}

-(TGGradeSelectView *)gradeSelectView {
    
    if (_gradeSelectView == nil) {
        _gradeSelectView = [[TGGradeSelectView alloc] init];
        
        WeakSelf();
        _gradeSelectView.didSelectItemBlock = ^(NSInteger index, BOOL isChoose, TGProductOptionModel * _Nonnull productOptionModel) {
            weakself.selectBlock ? weakself.selectBlock(self.selectIndex, index, isChoose, productOptionModel) : nil;
        };
    }
    return _gradeSelectView;
}

-(void)setTitle:(NSArray *)title dataArray:(NSMutableArray *)dataArray{
    
    self.selectIndex = 0;
    
    self.title = title;
    self.dataArray = dataArray;
}

-(void)setTitle:(NSArray *)title {
    
    _title = title;
    
    CGFloat width = 0;
    for (NSString *tipText in title) {
        
        NSInteger index  = [title indexOfObject:tipText];
        UIFont   *font   = index == self.selectIndex ? [UIFont boldSystemFontOfSize:14] : [UIFont systemFontOfSize:14];
        CGFloat tipWidth = [tipText textSizeIn:CGSizeMake((kScreenWidth - 30), 17) font:font].width + 5;

        UILabel *titleLabel  = (UILabel *)[self.titleView viewWithTag:40 + index];
        if (titleLabel == nil) {
            titleLabel = [[UILabel alloc] init];
            [titleLabel addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapTitleClick:)]];
            titleLabel.textColor = HEXColor(0x666666);
            titleLabel.text      = tipText;
            titleLabel.tag       = 40 + index;
            titleLabel.userInteractionEnabled = YES;
            [self.titleView addSubview:titleLabel];
        }
        titleLabel.font      = font;
        titleLabel.contentMode = UIViewContentModeTop;
        titleLabel.frame     = CGRectMake(width, 0, tipWidth, titleViewHeight);
        
        width += tipWidth + 10;
    }
}

-(void)setDataArray:(NSMutableArray *)dataArray {
    
    if (dataArray.count <= self.selectIndex) {
        self.selectIndex = 0;
    }
    
    _dataArray = dataArray;
    self.gradeSelectView.dataArray = [_dataArray objectAtIndex:self.selectIndex];
}

-(void)tapTitleClick:(UITapGestureRecognizer *)tap {
    
    NSInteger index = tap.view.tag - 40;
    if (self.selectIndex == index) {
        return;
    }
    
    self.selectIndex = index;
    self.title = self.title;
    self.dataArray = self.dataArray;
}

-(void)setSelectBlock:(SelectItemBlock)selectBlock {
    
    _selectBlock = selectBlock;
}

@end
