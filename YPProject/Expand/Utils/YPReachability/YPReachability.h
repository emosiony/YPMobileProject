//
//  YPReachability.h
//  project
//
//  Created by 姚敦鹏 on 2018/10/13.
//  Copyright © 2018年 rocHome. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Reachability.h>

typedef NS_OPTIONS(NSUInteger, YPNetworkStatus) {
    YPNetworkStatusNone     = 0,   // 无法联网
    YPNetworkStatusWifi     = 1,   // wifi
    YPNetworkStatusFlow     = 2,   // 2G、3G、4G
    YPNetworkStatusUnkown   = 3,   // 未知
};

@interface YPReachability : NSObject

// 网络对象
@property (nonatomic,strong) Reachability *conn;
/** 网络状态 */
@property (nonatomic,assign) YPNetworkStatus netStatus;
/** 是否有网络 */
@property (nonatomic,assign,getter=isHasNet) BOOL hasNet;

+ (instancetype)shareInstall;

- (void)starMonitorNetwork;
- (void)stopMonitorNetwork;
@end
