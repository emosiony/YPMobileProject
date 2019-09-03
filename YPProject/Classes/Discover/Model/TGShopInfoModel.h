//
//  TGShopInfoModel.h
//  TGParent
//
//  Created by 姚敦鹏 on 2018/4/8.
//  Copyright © 2018年 jzg. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TGShopInfoModel : NSObject

/** 门店id */
@property (strong, nonatomic) NSNumber *ID;

/** 地址 */
@property (nonatomic,copy) NSString *address;

/** 距离 */
@property (nonatomic,copy) NSString *distance;

/** ecode */
@property (nonatomic,copy) NSString *entCode;

/** 商家图标 */
@property (nonatomic,copy) NSString *logo;

/** 商家名称 */
@property (nonatomic,copy) NSString *name;

/** 信息汇总 */
@property (nonatomic,copy) NSDictionary *entRanking;

/** 评价评分 */
@property (nonatomic,copy) NSString *avg_comm;

/** 评分 */
@property (copy, nonatomic) NSString *average_score;

/** 评分 */
@property (nonatomic,copy) NSNumber *averageScore;

/** 托管类型 */
@property (nonatomic,copy) NSArray *courseList;

/** 产品list */
@property (strong, nonatomic) NSArray *productList;

/** 是否展示更多 */
@property (assign, nonatomic) BOOL isShowMore;

/** eId */
@property (strong, nonatomic) NSNumber *uId;

/** 商家电话 */
@property (copy, nonatomic) NSString *phone;

/** 代理商id */
@property (strong, nonatomic) NSNumber *agentId;

@property (strong, nonatomic) NSNumber *lon;
@property (strong, nonatomic) NSNumber *lat;
/** 主标签 */
@property (nonatomic,copy) NSString *mainTag;
@property (nonatomic,copy) NSString *shopType;
/** 副标签 */
@property (nonatomic,copy) NSString *subTags;
@property (nonatomic,copy) NSArray *subTagList;
@end
