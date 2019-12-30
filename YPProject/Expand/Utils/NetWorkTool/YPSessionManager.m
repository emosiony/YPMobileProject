


//
//  YPSessionManager.m
//  YPProject
//
//  Created by Jtg_yao on 2019/8/13.
//  Copyright © 2019 jzg. All rights reserved.
//

#import "YPSessionManager.h"
#import <AFNetworking.h>
#import "DeviceInfo.h"

#define Default_TimeOutInterval 30.0f

static YPSessionManager *_install;

@implementation YPSessionManager

+(instancetype)shareManager {
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _install = [[self alloc] init];
    });
    return _install;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        _manager = [[AFHTTPSessionManager alloc] initWithBaseURL:URLFromString(kBaseURL)];
        [self setManagerHeaderInfo:_manager];
    }
    return self;
}

-(void)setManagerHeaderInfo:(AFHTTPSessionManager *)manager {
    
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript",@"text/html",nil];
    
    [manager.requestSerializer willChangeValueForKey:@"timeoutInterval"];
    manager.requestSerializer.timeoutInterval = Default_TimeOutInterval;
    [manager.requestSerializer didChangeValueForKey:@"timeoutInterval"];
    
    [manager.requestSerializer setValue:[DeviceInfo getDeviceIDFA] forHTTPHeaderField:@"adid"];            // 广告IDFA
    [manager.requestSerializer setValue:@"appstore" forHTTPHeaderField:@"channel"];                        // 渠道
    [manager.requestSerializer setValue:[DeviceInfo getDeviceIDFV] forHTTPHeaderField:@"deviceid"];        // IDFV
    [manager.requestSerializer setValue:[DeviceInfo getDeviceType] forHTTPHeaderField:@"phone-type"];      // 手机型号
    [manager.requestSerializer setValue:@"1" forHTTPHeaderField:@"platform"];                              // 平台类型 1:iOS 2:Android
    
    NSString *user_agent = [[DeviceInfo getAppBundleID] stringByAppendingFormat:@"/%@ (iPhone;iOS%@;%@;%@;%@)", [DeviceInfo getAppSystemVersion], [DeviceInfo getDeviceSystemVersion], [DeviceInfo getDeviceType], [DeviceInfo getDeviceScale], @"AppStore"];
    [manager.requestSerializer setValue:user_agent forHTTPHeaderField:@"User-Agent"];
    [manager.requestSerializer setValue:[DeviceInfo getAppSystemVersion] forHTTPHeaderField:@"version"];
}

+(void)setRequestHeaderCommonInfo:(NSMutableURLRequest *)request {
    
    [request willChangeValueForKey:@"timeoutInterval"];
    request.timeoutInterval = Default_TimeOutInterval;
    [request didChangeValueForKey:@"timeoutInterval"];
    
    [request setValue:[DeviceInfo getDeviceIDFA] forHTTPHeaderField:@"adid"];            // 广告IDFA
    [request setValue:@"appstore" forHTTPHeaderField:@"channel"];                        // 渠道
    [request setValue:[DeviceInfo getDeviceIDFV] forHTTPHeaderField:@"deviceid"];        // IDFV
    [request setValue:[DeviceInfo getDeviceType] forHTTPHeaderField:@"phone-type"];      // 手机型号
    [request setValue:@"1" forHTTPHeaderField:@"platform"];                              // 平台类型 1:iOS 2:Android
    
    NSString *user_agent = [[DeviceInfo getAppBundleID] stringByAppendingFormat:@"/%@ (iPhone;iOS%@;%@;%@;%@)", [DeviceInfo getAppSystemVersion], [DeviceInfo getDeviceSystemVersion], [DeviceInfo getDeviceType], [DeviceInfo getDeviceScale], @"AppStore"];
    [request setValue:user_agent forHTTPHeaderField:@"User-Agent"];
    [request setValue:[DeviceInfo getAppSystemVersion] forHTTPHeaderField:@"version"];
}

@end
