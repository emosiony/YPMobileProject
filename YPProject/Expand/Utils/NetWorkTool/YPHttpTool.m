//
//  YPHttpTool.m
//  YPProject
//
//  Created by Jtg_yao on 2019/8/13.
//  Copyright © 2019 jzg. All rights reserved.
//

#import "YPHttpTool.h"
#import "YPSessionManager.h"

#import <AFNetworking.h>

@implementation YPHttpTool

+(void)GET:(NSString *)URL params:(NSDictionary *)params complete:(void(^)(id data))complete failure:(void(^)(NSError *error))failure {
    
    NSAssert(strIsEmpty(URL), @"URL is nil");
    
    [self networkActivityState:YES];
    AFHTTPSessionManager *manager = [YPSessionManager shareManager].manager;
    [manager.requestSerializer setValue:@"application/x-www-form-urlencoded" forKey:@"Content-Type"]; // 表单方式

    [manager GET:URL parameters:params progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        complete ? complete(responseObject) : nil;
        [self networkActivityState:NO];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        failure ? failure(error) : nil;
        [self networkActivityState:NO];
    }];
}

+(void)POST:(NSString *)URL params:(NSDictionary *)params complete:(void(^)(id data))complete failure:(void(^)(NSError *error))failure {
    
    NSAssert(strIsEmpty(URL), @"URL is nil");
    
    [self networkActivityState:YES];
    AFHTTPSessionManager *manager = [YPSessionManager shareManager].manager;
    [manager.requestSerializer setValue:@"application/x-www-form-urlencoded" forKey:@"Content-Type"]; // 表单方式
    
    [manager POST:URL parameters:params progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        complete ? complete(responseObject) : nil;
        [self networkActivityState:NO];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        failure ? failure(error) : nil;
        [self networkActivityState:NO];
    }];
}

+(void)POSTJson:(NSString *)URL params:(NSDictionary *)params complete:(void(^)(id data))complete failure:(void(^)(NSError *error))failure {
    
    NSAssert(strIsEmpty(URL), @"URL is nil");
    
    [self networkActivityState:YES];
    AFHTTPSessionManager *manager = [YPSessionManager shareManager].manager;
    if (![URL hasPrefix:@"http"]) {
        URL = [[manager.baseURL absoluteString] stringByAppendingString:URL];
    }
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:URLFromString(URL) cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:30];
    [request setHTTPMethod:@"POST"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    [YPSessionManager setRequestHeaderCommonInfo:request];
    
    if (params != nil) {
        NSData *jsonData = [NSJSONSerialization dataWithJSONObject:params options:0 error:nil];
        NSString *jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
        [request setHTTPBody:[jsonString dataUsingEncoding:NSUTF8StringEncoding]];
    }
    
    NSURLSessionDataTask *task = [manager dataTaskWithRequest:request uploadProgress:nil downloadProgress:nil completionHandler:^(NSURLResponse * _Nonnull response, id  _Nullable responseObject, NSError * _Nullable error) {
        if (error) {
            failure ? failure(error) : nil;
        } else {
            complete ? complete(responseObject) : nil;
        }
        [self networkActivityState:NO];
    }];
    [task resume];
}

+(void)PUT:(NSString *)URL params:(NSDictionary *)params complete:(void(^)(id data))complete failure:(void(^)(NSError *error))failure {
    
    NSAssert(strIsEmpty(URL), @"URL is nil");
    
    [self networkActivityState:YES];
    AFHTTPSessionManager *manager = [YPSessionManager shareManager].manager;
    [manager.requestSerializer setValue:@"application/x-www-form-urlencoded" forKey:@"Content-Type"]; // 表单方式

    [manager PUT:URL parameters:params success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        complete ? complete(responseObject) : nil;
        [self networkActivityState:NO];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        failure ? failure(error) : nil;
        [self networkActivityState:NO];
    }];
}

+(void)PUTJson:(NSString *)URL params:(NSDictionary *)params complete:(void(^)(id data))complete failure:(void(^)(NSError *error))failure {
    
    NSAssert(strIsEmpty(URL), @"URL is nil");
    
    [self networkActivityState:YES];
    AFHTTPSessionManager *manager = [YPSessionManager shareManager].manager;

    if (![URL hasPrefix:@"http"]) {
        URL = [[manager.baseURL absoluteString] stringByAppendingString:URL];
    }
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:URLFromString(URL) cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:30];
    [request setHTTPMethod:@"PUT"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    [YPSessionManager setRequestHeaderCommonInfo:request];
    
    if (params != nil) {
        NSData *jsonData = [NSJSONSerialization dataWithJSONObject:params options:0 error:nil];
        NSString *jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
        [request setHTTPBody:[jsonString dataUsingEncoding:NSUTF8StringEncoding]];
    }
    
    NSURLSessionDataTask *task = [manager dataTaskWithRequest:request uploadProgress:nil downloadProgress:nil completionHandler:^(NSURLResponse * _Nonnull response, id  _Nullable responseObject, NSError * _Nullable error) {
        if (error) {
            failure ? failure(error) : nil;
        } else {
            complete ? complete(responseObject) : nil;
        }
        [self networkActivityState:NO];
    }];
    [task resume];
}

+(void)DELETE:(NSString *)URL params:(NSDictionary *)params complete:(void(^)(id data))complete failure:(void(^)(NSError *error))failure {

    NSAssert(strIsEmpty(URL), @"URL is nil");

    [self networkActivityState:YES];
    AFHTTPSessionManager *manager = [YPSessionManager shareManager].manager;
    [manager.requestSerializer setValue:@"application/x-www-form-urlencoded" forKey:@"Content-Type"]; // 表单方式
    
    [manager DELETE:URL parameters:params success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        complete ? complete(responseObject) : nil;
        [self networkActivityState:NO];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        failure ? failure(error) : nil;
        [self networkActivityState:NO];
    }];
}

+(void)DELETEJson:(NSString *)URL params:(NSDictionary *)params complete:(void(^)(id data))complete failure:(void(^)(NSError *error))failure {
    
    NSAssert(strIsEmpty(URL), @"URL is nil");
    
    [self networkActivityState:YES];
    AFHTTPSessionManager *manager = [YPSessionManager shareManager].manager;
    
    if (![URL hasPrefix:@"http"]) {
        URL = [[manager.baseURL absoluteString] stringByAppendingString:URL];
    }
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:URLFromString(URL) cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:30];
    [request setHTTPMethod:@"DELETE"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    [YPSessionManager setRequestHeaderCommonInfo:request];
    
    if (params != nil) {
        NSData *jsonData = [NSJSONSerialization dataWithJSONObject:params options:0 error:nil];
        NSString *jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
        [request setHTTPBody:[jsonString dataUsingEncoding:NSUTF8StringEncoding]];
    }
    
    NSURLSessionDataTask *task = [manager dataTaskWithRequest:request uploadProgress:nil downloadProgress:nil completionHandler:^(NSURLResponse * _Nonnull response, id  _Nullable responseObject, NSError * _Nullable error) {
        if (error) {
            failure ? failure(error) : nil;
        } else {
            complete ? complete(responseObject) : nil;
        }
        [self networkActivityState:NO];
    }];
    [task resume];
}

+ (void)UPLOAD:(NSString *)URL params:(NSDictionary *)params uploadData:(YPFormData *)uploadData progress:(void(^)(NSProgress *uploadProgress))progress complete:(void (^)(id _Nonnull))complete failure:(void (^)(NSError * _Nonnull))failure {
    
    
    NSAssert(strIsEmpty(URL), @"URL is nil");
    
    [self networkActivityState:YES];
    AFHTTPSessionManager *manager = [YPSessionManager shareManager].manager;
    [manager POST:URL parameters:params constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        [formData appendPartWithFileData:uploadData.data name:uploadData.name fileName:uploadData.fileName mimeType:uploadData.mimeType];
    } progress:progress success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        complete ? complete(responseObject) : nil;
        [self networkActivityState:NO];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        failure ? failure(error) : nil;
        [self networkActivityState:NO];
    }];
}

+ (void)UPLOADMore:(NSString *)URL params:(NSDictionary *)params uploadDatas:(NSArray<YPFormData *> *)uploadDatas progress:(void(^)(NSProgress *uploadProgress))progress complete:(void (^)(id _Nonnull))complete failure:(void (^)(NSError * _Nonnull))failure {
    
    NSAssert(strIsEmpty(URL), @"URL is nil");
    
    [self networkActivityState:YES];
    AFHTTPSessionManager *manager = [YPSessionManager shareManager].manager;
    [manager POST:URL parameters:params constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        for (YPFormData *uploadData in uploadDatas) {
            [formData appendPartWithFileData:uploadData.data name:uploadData.name fileName:uploadData.fileName mimeType:uploadData.mimeType];
        }
    } progress:progress success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        complete ? complete(responseObject) : nil;
        [self networkActivityState:NO];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        failure ? failure(error) : nil;
        [self networkActivityState:NO];
    }];
}

+(void)cancelAllTask {
    
    AFHTTPSessionManager *manager = [YPSessionManager shareManager].manager;
    [manager.operationQueue cancelAllOperations];
}

#pragma mark -- private
+(void)networkActivityState:(BOOL)isvisible {
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:isvisible];
    });
}

@end
