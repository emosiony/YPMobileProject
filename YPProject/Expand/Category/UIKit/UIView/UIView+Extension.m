//
//  UIView+Extension.m
//  YPProject
//
//  Created by Jtg_yao on 2019/8/14.
//  Copyright © 2019 jzg. All rights reserved.
//

#import "UIView+Extension.h"

@implementation UIView (Extension)

-(void)setYp_origin:(CGPoint)yp_origin
{
    CGRect frame = self.frame;
    frame.origin = yp_origin;
    self.frame   = frame;
}

- (CGPoint)yp_origin
{
    return self.frame.origin;
}

-(void)setYp_x:(CGFloat)yp_x
{
    CGRect frame   = self.frame;
    frame.origin.x = yp_x;
    self.frame     = frame;
}

- (CGFloat)yp_x
{
    return self.frame.origin.x;
}

-(void)setYp_y:(CGFloat)yp_y
{
    CGRect frame   = self.frame;
    frame.origin.y = yp_y;
    self.frame     = frame;
}

- (CGFloat)yp_y
{
    return self.frame.origin.y;
}

-(void)setYp_center:(CGPoint)yp_center
{
    self.center = yp_center;
}

- (CGPoint)yp_center
{
    return self.center;
}

-(void)setYp_centerX:(CGFloat)yp_centerX
{
    CGPoint ypCenter = self.center;
    ypCenter.x       = yp_centerX;
    self.center      = ypCenter;
}

- (CGFloat)yp_centerX
{
    return self.center.x;
}

-(void)setYp_centerY:(CGFloat)yp_centerY
{
    CGPoint ypCenter = self.center;
    ypCenter.y       = yp_centerY;
    self.center      = ypCenter;
}

- (CGFloat)yp_centerY
{
    return self.center.y;
}

- (void)setYp_size:(CGSize)yp_size
{
    CGRect frame = self.frame;
    frame.size   = yp_size;
    self.frame   = frame;
}

- (CGSize)yp_size
{
    return self.frame.size;
}

- (void)setYp_width:(CGFloat)yp_width
{
    CGRect frame     = self.frame;
    frame.size.width = yp_width;
    self.frame       = frame;
}

- (CGFloat)yp_width
{
    return self.frame.size.width;
}

-(void)setYp_height:(CGFloat)yp_height
{
    CGRect frame      = self.frame;
    frame.size.height = yp_height;
    self.frame        = frame;
}

-(CGFloat)yp_height
{
    return self.frame.size.height;
}

-(CGFloat)yp_maxX
{
    return CGRectGetMaxX(self.frame);
}

- (CGFloat)yp_maxY
{
    return CGRectGetMaxY(self.frame);
}

-(instancetype)viewFromXib
{
    return [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass([self class]) owner:nil options:nil] lastObject];
}

- (void)removeAllSubviews
{
    [self.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
}

@end
