//
//  TGSchoolInfoModel.h
//  TGParent
//
//  Created by Jtg_yao on 2019/8/16.
//  Copyright © 2019 jzg. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface TGSchoolInfoModel : NSObject

@property (nonatomic, copy) NSArray  *urlList;
@property (nonatomic, copy) NSString *urls;
@property (nonatomic, copy) NSArray  *admissionsGrades;
@property (nonatomic, copy) NSArray  *admissionsGradesStr;
@property (nonatomic, copy) NSString *admissionsString;
@property (nonatomic, copy) NSNumber *schoolID;
@property (nonatomic, copy) NSString *logoUrl;
@property (nonatomic, copy) NSString *schoolName;
@property (nonatomic, copy) NSNumber *nature;
@property (nonatomic, copy) NSString *phone;
@property (nonatomic, copy) NSString *address;
@property (nonatomic, copy) NSNumber *provinceId;
@property (nonatomic, copy) NSNumber *cityId;
@property (nonatomic, copy) NSNumber *areaId;
@property (nonatomic, copy) NSNumber *lon;
@property (nonatomic, copy) NSNumber *lat;
@property (nonatomic, copy) NSNumber *status;
@property (nonatomic, copy) NSString *content;
@property (nonatomic, copy) NSNumber *distance;
@property (nonatomic, copy) NSNumber *dateCreated;
@property (nonatomic, copy) NSNumber *lastUpdated;

@end

NS_ASSUME_NONNULL_END
