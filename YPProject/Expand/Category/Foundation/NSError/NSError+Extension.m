//
//  NSError+Extension.m
//  YPProject
//
//  Created by Jtg_yao on 2019/8/14.
//  Copyright © 2019 jzg. All rights reserved.
//

#import "NSError+Extension.h"

@implementation NSError (Extension)

+(instancetype)errorCode:(NSInteger)code errorDesc:(NSString *)errorDesc {
    
    NSString *domain = @"com.Application.ErrorDomain";
    errorDesc = errorDesc.length <= 0 ? @"未知错误" : errorDesc;
    NSDictionary *userInfo = @{ NSLocalizedDescriptionKey : errorDesc };
    
    return [NSError errorWithDomain:domain
                               code:code
                           userInfo:userInfo];
}

@end
