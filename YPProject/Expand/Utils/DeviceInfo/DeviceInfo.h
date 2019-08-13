//
//  DeviceInfo.h
//  TGVendor
//
//  Created by Jtg_yao on 2018/5/4.
//  Copyright © 2018年 jzg. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DeviceInfo : NSObject

#pragma mark -- App 信息

/** App Name */
+ (NSString *)getAppCurName;

/** app 版本号 */
+ (NSString *)getAppSystemVersion;

+ (NSInteger)ai_build;

#pragma mark -- 设备

/** 设备版本号 */
+ (NSString *)getDeviceSystemVersion;

/** 地方型号  （国际化区域名称） */
+ (NSString *)getDeviceLocalModel;

/** 设备唯一广告标志 */
+ (NSString *)getDeviceIDFA;

/** 设备唯一标识符*/
+ (NSString *)getDeviceIDFV;

/** 获取设备类型 */
+(NSString *)getDevicePhoneType;

/** 设置型号 iphone xxx */
+ (NSString*)getDeviceType;

/** 设备物理尺寸 */
+ (NSString *)getDeviceSize;

/** 设备分辨率 */
+ (NSString *)getDeviceScale;

/** 获取设备运营商 */
+ (NSString *)getCarrierName;

@end
