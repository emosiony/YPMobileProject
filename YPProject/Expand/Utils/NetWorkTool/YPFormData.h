//
//  YPFormData.h
//  YPProject
//
//  Created by Jtg_yao on 2019/8/13.
//  Copyright © 2019 jzg. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface YPFormData : NSObject

/** 文件 二进制 数据 */
@property (nonatomic,copy) NSData   *data;
/** 参数名 */
@property (nonatomic,copy) NSString *name;
/** 文件 名 */
@property (nonatomic,copy) NSString *fileName;
/** 文件类型 */
@property (nonatomic,copy) NSString *mimeType;

@end

NS_ASSUME_NONNULL_END
