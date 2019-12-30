//
//  YPAppBaseInfo.m
//  YPProject
//
//  Created by Jtg_yao on 2019/12/30.
//  Copyright © 2019 jzg. All rights reserved.
//

#import "YPAppBaseInfo.h"

NSString *const kLoginStatus   = @"kLoginStatus";
NSString *const kLoginUserInfo = @"kLoginUserInfo";

@interface YPAppBaseInfo ()

@end

@implementation YPAppBaseInfo

KSingleToolM(shareManager);

- (void)setLoginStatus:(BOOL)loginStatus {
    
    [[NSUserDefaults standardUserDefaults] setBool:loginStatus forKey:kLoginStatus];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    if (loginStatus == NO) {
        [self clearUserInfo];
    }
}

- (BOOL)isLoginStatus {
    
    BOOL isLogin = [[NSUserDefaults standardUserDefaults] boolForKey:kLoginStatus];
    
    if (isLogin) {
        NSData *data = [[NSUserDefaults standardUserDefaults] valueForKey:kLoginUserInfo];
        if (data == nil || data.length == 0) { // 清除信息
            [[NSUserDefaults standardUserDefaults] setValue:nil forKey:kLoginUserInfo];
            isLogin = NO;
        } else {
            NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
            if (dict == nil || ![dict isKindOfClass:[NSDictionary class]]) { // 清除信息
                [[NSUserDefaults standardUserDefaults] setValue:nil forKey:kLoginUserInfo];
                isLogin = NO;
            } else {
                _userInfo = [YPUserInfo mj_objectWithKeyValues:dict];
            }
        }
    }
    
    return isLogin;
}

- (void)saveUserInfo:(NSDictionary *)userDict {
    
    NSData *data = [NSJSONSerialization dataWithJSONObject:userDict options:0 error:nil];
    [[NSUserDefaults standardUserDefaults] setObject:data forKey:kLoginUserInfo];
    
    _userInfo = [YPUserInfo mj_objectWithKeyValues:userDict];
}

- (void)clearUserInfo {
    
    [[NSUserDefaults standardUserDefaults] setValue:nil forKey:kLoginUserInfo];
    [[NSUserDefaults standardUserDefaults] synchronize];
    _userInfo = nil;
}

@end

@implementation YPUserInfo


@end
