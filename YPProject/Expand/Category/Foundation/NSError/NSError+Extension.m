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

+(instancetype)errorWithErrorCode:(NSError *)error {
    
    NSString *domain = @"com.MyCompany.MyApplication.ErrorDomain";
    NSString *desc = [self errorTipHandleWithCode:error];
    NSDictionary *userInfo = @{ NSLocalizedDescriptionKey : desc };
    
    NSError *newError = [self errorWithDomain:domain
                                         code:error
                                     userInfo:userInfo];
    return newError;
}

//网络请求错误函数
+(NSString *)errorTipHandleWithCode:(NSError *)error {
    
    NSString *errorDesc = nil;
    switch (error.code) {
        case NSURLErrorNotConnectedToInternet:{//无网络连接
            errorDesc = @"请检查网络是否连接正常";
        } break;
        case NSURLErrorTimedOut:{//网络超时
            errorDesc = @"网络连接超时";
        } break;
        default:{
            errorDesc = @"网络繁忙，请稍候再试";
        } break;
    }
    return errorDesc;
}

@end
