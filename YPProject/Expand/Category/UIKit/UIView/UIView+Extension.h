//
//  UIView+Extension.h
//  YPProject
//
//  Created by Jtg_yao on 2019/8/14.
//  Copyright © 2019 jzg. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIView (Extension)

@property (nonatomic, assign) CGPoint yp_origin;
@property (nonatomic, assign) CGFloat yp_x;
@property (nonatomic, assign) CGFloat yp_y;

@property (nonatomic, assign) CGPoint yp_center;
@property (nonatomic, assign) CGFloat yp_centerX;
@property (nonatomic, assign) CGFloat yp_centerY;

@property (nonatomic, assign) CGSize  yp_size;
@property (nonatomic, assign) CGFloat yp_width;
@property (nonatomic, assign) CGFloat yp_height;

@property (nonatomic, assign, readonly) CGFloat yp_maxX;
@property (nonatomic, assign, readonly) CGFloat yp_maxY;


+ (instancetype)viewFromXib;

- (void)removeAllSubviews;

@end

NS_ASSUME_NONNULL_END
