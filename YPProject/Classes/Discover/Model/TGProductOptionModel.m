//
//  TGProductOptionModel.m
//  TGParent
//
//  Created by lwc on 2018/12/4.
//  Copyright © 2018年 jzg. All rights reserved.
//

#import "TGProductOptionModel.h"

@implementation TGProductOptionModel
@synthesize id;

- (void)mj_keyValuesDidFinishConvertingToObject{
    _click = YES;
    _choose = NO;
}

@end
