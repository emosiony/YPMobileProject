//
//  NSError+Extension.h
//  YPProject
//
//  Created by Jtg_yao on 2019/8/14.
//  Copyright © 2019 jzg. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSError (Extension)

+(instancetype)errorCode:(NSInteger)code errorDesc:(NSString *)errorDesc;

@end

NS_ASSUME_NONNULL_END
