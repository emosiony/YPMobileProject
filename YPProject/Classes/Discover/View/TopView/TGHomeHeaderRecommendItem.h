//
//  TGHomeHeaderRecommendItem.h
//  TGParent
//
//  Created by Jtg_yao on 2019/7/8.
//  Copyright © 2019 jzg. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface TGHomeHeaderRecommendItem : UIView

@property (nonatomic,copy) NSDictionary *dict;
@property (nonatomic,copy) void(^recommendClick)(TGHomeHeaderRecommendItem *item, NSDictionary *info);

+(instancetype)viewFromXIB;

@end

NS_ASSUME_NONNULL_END
