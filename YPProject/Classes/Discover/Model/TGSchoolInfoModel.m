
//
//  TGSchoolInfoModel.m
//  TGParent
//
//  Created by Jtg_yao on 2019/8/16.
//  Copyright © 2019 jzg. All rights reserved.
//

#import "TGSchoolInfoModel.h"

@implementation TGSchoolInfoModel

+(NSDictionary *)mj_replacedKeyFromPropertyName {
    return @{@"schoolID" : @"id"};
}

-(void)setAdmissionsGradesStr:(NSArray *)admissionsGradesStr {
    
    _admissionsGradesStr = admissionsGradesStr;
    
    if (_admissionsGradesStr.count) {
        _admissionsString = [_admissionsGradesStr componentsJoinedByString:@"  "];
    }
}

@end
