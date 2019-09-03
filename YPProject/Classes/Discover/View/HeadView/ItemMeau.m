//
//  ItemMeau.m
//  FastlaneTest
//
//  Created by Jtg_yao on 2018/5/22.
//  Copyright © 2018年 YDP. All rights reserved.
//

#import "ItemMeau.h"

#define NorImage [UIImage imageNamed:@"down"]
#define SelImage [UIImage imageNamed:@"home_up"]

@interface ItemMeau ()

@property (weak, nonatomic) IBOutlet UIButton *titleButton;
@property (weak, nonatomic) IBOutlet UIImageView *rightImg;

@end

@implementation ItemMeau

-(void)awakeFromNib {
    
    [super awakeFromNib];
    [self addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapItem)]];
    [self.titleButton addTarget:self action:@selector(tapItem) forControlEvents:(UIControlEventTouchUpInside)];
    [self.titleButton addObserver:self forKeyPath:@"selected" options:(NSKeyValueObservingOptionNew) context:nil];
    
    self.normalImage = self.normalImage == nil ? NorImage : self.normalImage;
    self.selectImage = self.selectImage == nil ? SelImage : self.selectImage;
}

-(void)setSelect:(BOOL)select {
    _select = select;
    _titleButton.selected = select;
}

-(void)titleNor:(NSString *)titleNor
       titleSel:(NSString *)titleSel
{
    self.normalTitle = titleNor;
    self.selectTitle = titleSel;
}

-(void)imageNor:(UIImage *)imageNor
       imageSel:(UIImage *)imageSel
{
    self.normalImage = imageNor;
    self.selectImage = imageSel;
}

-(void)colorNor:(UIColor *)colorNor
       colorSel:(UIColor *)colorSel
{
    self.normalColor = colorNor;
    self.selectColor = colorSel;
}

-(void)titleNor:(NSString *)titleNor
       titleSel:(NSString *)titleSel
       imageNor:(UIColor  *)colorNor
       imageSel:(UIColor  *)colorSel
{
    self.normalTitle = titleNor;
    self.selectTitle = titleSel;
    self.normalColor = colorNor;
    self.selectColor = colorSel;
}

-(void)titleNor:(NSString *)titleNor
       titleSel:(NSString *)titleSel
       imageNor:(UIImage  *)imageNor
       imageSel:(UIImage  *)imageSel
       colorNor:(UIColor *)colorNor
       colorSel:(UIColor *)colorSel
{
    self.normalTitle = titleNor;
    self.selectTitle = titleSel;
    self.normalImage = imageNor;
    self.selectImage = imageSel;
    self.normalColor = colorNor;
    self.selectColor = colorSel;
}

-(void)setNormalImage:(UIImage *)normalImage {
    _normalImage = normalImage;
}

-(void)setSelectImage:(UIImage *)selectImage {
    _selectImage = selectImage;
}

-(void)setNormalTitle:(NSString *)normalTitle {
    _normalTitle = normalTitle;
    [self.titleButton setTitle:_normalTitle forState:(UIControlStateNormal)];
}

-(void)setSelectTitle:(NSString *)selectTitle {
    _selectTitle = selectTitle;
    [self.titleButton setTitle:_selectTitle forState:(UIControlStateSelected)];
}

-(void)setNormalColor:(UIColor *)normalColor {
    _normalColor = normalColor;
    [self.titleButton setTitleColor:_normalColor forState:(UIControlStateNormal)];
}

-(void)setSelectColor:(UIColor *)selectColor {
    _selectColor = selectColor;
    [self.titleButton setTitleColor:_selectColor forState:(UIControlStateSelected)];
}

-(void)tapItem {
    
    BOOL isSelcted = !self.titleButton.isSelected;
    self.titleButton.selected = YES;
    self.itemClick ? self.itemClick(isSelcted) : nil;
}

-(void )observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context {
    
    if (object == self.titleButton) {
        
        BOOL isSelected = [[change objectForKey:NSKeyValueChangeNewKey] boolValue];
        self.rightImg.image = isSelected ? self.selectImage : self.normalImage;
        _select = isSelected;
    }
}

+(id)ViewFromXIB {
    
    ItemMeau *item = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass(self) owner:self options:nil] lastObject];
    return item;
}

@end
