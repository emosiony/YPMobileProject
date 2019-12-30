//
//  YPAppBaseInfo.h
//  YPProject
//
//  Created by Jtg_yao on 2019/12/30.
//  Copyright © 2019 jzg. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

UIKIT_EXTERN NSString *const kLoginStatus;
UIKIT_EXTERN NSString *const kLoginUserInfo;

@class YPUserInfo;

@interface YPAppBaseInfo : NSObject

/** 用户信息 */
@property (nonatomic, strong) YPUserInfo *userInfo;

/** 登录状态 */
@property (nonatomic, assign, getter=isLoginStatus) BOOL loginStatus;

KSingleToolH(shareManager);


/// 保存用户信息
- (void)saveUserInfo:(NSDictionary *)userDict;

/// 清除用户信息
- (void)clearUserInfo;

@end

@interface YPUserInfo : NSObject

@property (nonatomic, copy) NSString *userName;
@property (nonatomic, copy) NSString *password;
@property (nonatomic, copy) NSString *headUrl;

@end

NS_ASSUME_NONNULL_END
