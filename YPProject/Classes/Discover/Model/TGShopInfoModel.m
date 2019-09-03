//
//  TGShopInfoModel.m
//  TGParent
//
//  Created by 姚敦鹏 on 2018/4/8.
//  Copyright © 2018年 jzg. All rights reserved.
//

#import "TGShopInfoModel.h"

@implementation TGShopInfoModel

-(void)mj_keyValuesDidFinishConvertingToObject {
    
//    if (_entRanking != nil) {
//        _avg_comm = _entRanking[@"avg_overall"];
//    } else {
//        _entRanking = @{};
//        _avg_comm = @"4";
//    }
    
    NSString * score = strIsEmpty([_averageScore stringValue]) ? _average_score : [_averageScore stringValue];
    _avg_comm = strIsEmpty(score) ? @"4" : score;
    _isShowMore = NO;
}

+(NSString *)getTableName{
    return NSStringFromClass([self class]);
}

+(NSArray *)getPrimaryKeyUnionArray{
    return @[@"entCode"];
}

+ (NSDictionary *)mj_objectClassInArray{
    return @{
             @"productList" : @"TGShopCourseModel",
             };
}

+ (NSDictionary *)mj_replacedKeyFromPropertyName {
    return @{ @"ID" : @"id"};
}

-(void)setSubTags:(NSString *)subTags {
    
    _subTags = subTags;
    if (!strIsEmpty(_subTags)) {
        _subTagList = [subTags componentsSeparatedByString:@","];
    }
}

@end
