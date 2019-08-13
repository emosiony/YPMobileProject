//
//  YPSessionManager.h
//  YPProject
//
//  Created by Jtg_yao on 2019/8/13.
//  Copyright © 2019 jzg. All rights reserved.
//

#import <Foundation/Foundation.h>

@class AFHTTPSessionManager;

NS_ASSUME_NONNULL_BEGIN

@interface YPSessionManager : NSObject

@property (nonatomic,strong,readonly) AFHTTPSessionManager *manager;

+(instancetype)shareManager;
+(void)setRequestHeaderCommonInfo:(NSMutableURLRequest *)request;

@end

NS_ASSUME_NONNULL_END
