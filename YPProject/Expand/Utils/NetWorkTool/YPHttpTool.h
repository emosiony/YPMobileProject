//
//  YPHttpTool.h
//  YPProject
//
//  Created by Jtg_yao on 2019/8/13.
//  Copyright © 2019 jzg. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "YPFormData.h"

NS_ASSUME_NONNULL_BEGIN

@interface YPHttpTool : NSObject

#pragma mark -- GET
/**
 GET -- JSON
 
 @param URL URL
 @param params 参数
 @param complete 成功
 @param failure 失败
 */
+(void)GET:(NSString *)URL params:(NSDictionary *)params complete:(void(^)(id data))complete failure:(void(^)(NSError *error))failure;


#pragma mark -- POST
/**
 POST -- JSON
 
 @param URL URL
 @param params 参数
 @param complete 成功
 @param failure 失败
 */
+(void)POST:(NSString *)URL params:(NSDictionary *)params complete:(void(^)(id data))complete failure:(void(^)(NSError *error))failure;

/**
 POST -- JSON
 
 @param URL URL
 @param params 参数
 @param complete 成功
 @param failure 失败
 */
+(void)POSTJson:(NSString *)URL params:(NSDictionary *)params complete:(void(^)(id data))complete failure:(void(^)(NSError *error))failure;


#pragma mark -- PUT
/**
 PUT
 
 @param URL URL
 @param params 参数
 @param complete 成功
 @param failure 失败
 */
+(void)PUT:(NSString *)URL params:(NSDictionary *)params complete:(void(^)(id data))complete failure:(void(^)(NSError *error))failure;

/**
 PUT -- JSON
 
 @param URL URL
 @param params 参数
 @param complete 成功
 @param failure 失败
 */
+(void)PUTJson:(NSString *)URL params:(NSDictionary *)params complete:(void(^)(id data))complete failure:(void(^)(NSError *error))failure;

#pragma mark -- DELETE
/**
 DELETE
 
 @param URL URL
 @param params 参数
 @param complete 成功
 @param failure 失败
 */
+(void)DELETE:(NSString *)URL params:(NSDictionary *)params complete:(void(^)(id data))complete failure:(void(^)(NSError *error))failure;

/**
 DELETE -- JSON
 
 @param URL url
 @param params 参数
 @param complete 成功
 @param failure 失败
 */
+(void)DELETEJson:(NSString *)URL params:(NSDictionary *)params complete:(void(^)(id data))complete failure:(void(^)(NSError *error))failure;


#pragma mark -- UPLoad
/**
 上传
 
 @param URL url
 @param params 参数
 @param uploadData 上传的数据格式
 @param progress    上传进度
 @param complete 成功
 @param failure 失败
 */
+(void)UPLOAD:(NSString *)URL params:(NSDictionary *)params uploadData:(YPFormData *)uploadData progress:(void(^)(NSProgress *uploadProgress))progress complete:(void(^)(id data))complete failure:(void(^)(NSError *error))failure;

/**
 上传 -- 多图
 
 @param URL url
 @param params      参数
 @param uploadDatas 上传的数据格式
 @param progress    上传进度
 @param complete    成功
 @param failure     失败
 */
+(void)UPLOADMore:(NSString *)URL params:(NSDictionary *)params uploadDatas:(NSArray<YPFormData *> *)uploadDatas progress:(void(^)(NSProgress *uploadProgress))progress complete:(void (^)(id _Nonnull))complete failure:(void (^)(NSError * _Nonnull))failure;

/** 取消所有 网络请求 */
+(void)cancelAllTask;

@end

NS_ASSUME_NONNULL_END
