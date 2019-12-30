//
//  NSString+URLParams.h
//  YPProject
//
//  Created by Jtg_yao on 2019/12/30.
//  Copyright © 2019 jzg. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSString (URLParams)

- (NSDictionary *)getURLParames:(NSString *)url;

@end

NS_ASSUME_NONNULL_END
