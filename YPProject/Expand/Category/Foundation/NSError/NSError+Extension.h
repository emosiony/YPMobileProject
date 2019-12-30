//
//  NSError+Extension.h
//  YPProject
//
//  Created by Jtg_yao on 2019/8/14.
//  Copyright © 2019 jzg. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSError (Extension)

+(instancetype)errorCode:(NSInteger)code errorDesc:(NSString *)errorDesc;

/** 网络请求 失败 的 error 解析 */
+(instancetype)errorWithErrorCode:(NSError *)error;

//网络请求错误函数
+(NSString *)errorTipHandleWithCode:(NSError *)error;

@end

NS_ASSUME_NONNULL_END
