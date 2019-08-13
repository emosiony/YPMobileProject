//
//  YPReachability.m
//  project
//
//  Created by 姚敦鹏 on 2018/10/13.
//  Copyright © 2018年 rocHome. All rights reserved.
//

#import "YPReachability.h"

static YPReachability *instance;

@implementation YPReachability

+ (instancetype)shareInstall {
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[YPReachability alloc] init];
        [instance updateInterfaceWithReachability:instance.conn];
    });
    return instance;
}

+ (instancetype)allocWithZone:(struct _NSZone *)zone {
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [super allocWithZone:zone];
    });
    return instance;
}

- (id)copyWithZone:(NSZone *)zone
{
    return instance;
}

- (void)dealloc
{
    [self.conn stopNotifier];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)starMonitorNetwork {
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateNetStatus:) name:kReachabilityChangedNotification object:nil];
    [self.conn startNotifier];
}

- (void)stopMonitorNetwork {
    [self.conn stopNotifier];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kReachabilityChangedNotification object:nil];
}

- (void)updateNetStatus:(NSNotification *)notify {
    
    Reachability *curReach = [notify object];
    NSParameterAssert([curReach isKindOfClass:[Reachability class]]);
    [self updateInterfaceWithReachability:curReach];
}

- (void)updateInterfaceWithReachability:(Reachability *)reachability {
    
    if (reachability == self.conn) {
        NetworkStatus netStatus = [reachability currentReachabilityStatus];
        switch (netStatus) {
            case ReachableViaWiFi: {
                self.netStatus = YPNetworkStatusWifi;
                self.hasNet    = YES;
            }   break;
            case ReachableViaWWAN: {
                self.netStatus = YPNetworkStatusFlow;
                self.netStatus = YES;
            }   break;
            case NotReachable: {
                self.netStatus = YPNetworkStatusNone;
                self.hasNet    = NO;
            }   break;
            default: {
                self.netStatus = YPNetworkStatusUnkown;
                self.hasNet    = NO;
            }   break;
        }
        
        DLog(@"=========== netStatus == %ld =============",self.netStatus);
    }
}

-(Reachability *)conn {
    
    if (_conn == nil) {
        NSString *netName = @"www.apple.com";
        _conn = [Reachability reachabilityWithHostName:netName];
    }
    return _conn;
}

@end
