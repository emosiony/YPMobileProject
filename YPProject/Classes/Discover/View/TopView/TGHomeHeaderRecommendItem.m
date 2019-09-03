//
//  TGHomeHeaderRecommendItem.m
//  TGParent
//
//  Created by Jtg_yao on 2019/7/8.
//  Copyright © 2019 jzg. All rights reserved.
//

#import "TGHomeHeaderRecommendItem.h"

@interface TGHomeHeaderRecommendItem ()

@property (weak, nonatomic) IBOutlet UIImageView *iconImage;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

@end

@implementation TGHomeHeaderRecommendItem

-(void)awakeFromNib {
    
    [super awakeFromNib];
    self.userInteractionEnabled = YES;
    
    [self addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapClick)]];
}

-(void)tapClick {
    self.recommendClick ? self.recommendClick(self, self.dict) : nil;
}

- (void)setDict:(NSDictionary *)dict {
    
    _dict = dict;
    NSURL *URL = [NSURL URLWithString:[dict objectForKey:@"thumb"]];
    [_iconImage sd_setImageWithURL:URL];
    _titleLabel.text = [dict objectForKey:@"title"];
}

+(instancetype)viewFromXIB {
    return [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass([self class]) owner:nil options:nil] lastObject];
}

@end
