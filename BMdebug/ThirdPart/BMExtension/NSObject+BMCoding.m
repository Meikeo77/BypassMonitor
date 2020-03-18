//
//  NSObject+BMCoding.m
//  BMExtension
//
//  Created by BM on 14-1-15.
//  Copyright (c) 2014年 小码哥. All rights reserved.
//

#import "NSObject+BMCoding.h"
#import "NSObject+BMClass.h"
#import "NSObject+BMProperty.h"
#import "BMProperty.h"

@implementation NSObject (BMCoding)

- (void)bm_encode:(NSCoder *)encoder
{
    Class clazz = [self class];
    
    NSArray *allowedCodingPropertyNames = [clazz bm_totalAllowedCodingPropertyNames];
    NSArray *ignoredCodingPropertyNames = [clazz bm_totalIgnoredCodingPropertyNames];
    
    [clazz bm_enumerateProperties:^(BMProperty *property, BOOL *stop) {
        // 检测是否被忽略
        if (allowedCodingPropertyNames.count && ![allowedCodingPropertyNames containsObject:property.name]) return;
        if ([ignoredCodingPropertyNames containsObject:property.name]) return;
        
        id value = [property valueForObject:self];
        if (value == nil) return;
        [encoder encodeObject:value forKey:property.name];
    }];
}

- (void)bm_decode:(NSCoder *)decoder
{
    Class clazz = [self class];
    
    NSArray *allowedCodingPropertyNames = [clazz bm_totalAllowedCodingPropertyNames];
    NSArray *ignoredCodingPropertyNames = [clazz bm_totalIgnoredCodingPropertyNames];
    
    [clazz bm_enumerateProperties:^(BMProperty *property, BOOL *stop) {
        // 检测是否被忽略
        if (allowedCodingPropertyNames.count && ![allowedCodingPropertyNames containsObject:property.name]) return;
        if ([ignoredCodingPropertyNames containsObject:property.name]) return;
        
        id value = [decoder decodeObjectForKey:property.name];
        if (value == nil) { // 兼容以前的BMExtension版本
            value = [decoder decodeObjectForKey:[@"_" stringByAppendingString:property.name]];
        }
        if (value == nil) return;
        [property setValue:value forObject:self];
    }];
}
@end
