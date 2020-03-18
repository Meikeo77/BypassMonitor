//
//  NSObject+BMCoding.h
//  BMExtension
//
//  Created by BM on 14-1-15.
//  Copyright (c) 2014年 小码哥. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BMExtensionConst.h"

/**
 *  Codeing协议
 */
@protocol BMCoding <NSObject>
@optional
/**
 *  这个数组中的属性名才会进行归档
 */
+ (NSArray *)bm_allowedCodingPropertyNames;
/**
 *  这个数组中的属性名将会被忽略：不进行归档
 */
+ (NSArray *)bm_ignoredCodingPropertyNames;
@end

@interface NSObject (BMCoding) <BMCoding>
/**
 *  解码（从文件中解析对象）
 */
- (void)bm_decode:(NSCoder *)decoder;
/**
 *  编码（将对象写入文件中）
 */
- (void)bm_encode:(NSCoder *)encoder;
@end

/**
 归档的实现
 */
#define BMCodingImplementation \
- (id)initWithCoder:(NSCoder *)decoder \
{ \
if (self = [super init]) { \
[self bm_decode:decoder]; \
} \
return self; \
} \
\
- (void)encodeWithCoder:(NSCoder *)encoder \
{ \
[self bm_encode:encoder]; \
}

#define BMExtensionCodingImplementation BMCodingImplementation
