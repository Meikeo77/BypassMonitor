//
//  NSObject+BMClass.m
//  BMExtensionExample
//
//  Created by BM Lee on 15/8/11.
//  Copyright (c) 2015年 小码哥. All rights reserved.
//

#import "NSObject+BMClass.h"
#import "NSObject+BMCoding.h"
#import "NSObject+BMKeyValue.h"
#import "BMFoundation.h"
#import <objc/runtime.h>

static const char BMAllowedPropertyNamesKey = '\0';
static const char BMIgnoredPropertyNamesKey = '\0';
static const char BMAllowedCodingPropertyNamesKey = '\0';
static const char BMIgnoredCodingPropertyNamesKey = '\0';

@implementation NSObject (BMClass)

+ (NSMutableDictionary *)classDictForKey:(const void *)key
{
    static NSMutableDictionary *allowedPropertyNamesDict;
    static NSMutableDictionary *ignoredPropertyNamesDict;
    static NSMutableDictionary *allowedCodingPropertyNamesDict;
    static NSMutableDictionary *ignoredCodingPropertyNamesDict;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        allowedPropertyNamesDict = [NSMutableDictionary dictionary];
        ignoredPropertyNamesDict = [NSMutableDictionary dictionary];
        allowedCodingPropertyNamesDict = [NSMutableDictionary dictionary];
        ignoredCodingPropertyNamesDict = [NSMutableDictionary dictionary];
    });
    
    if (key == &BMAllowedPropertyNamesKey) return allowedPropertyNamesDict;
    if (key == &BMIgnoredPropertyNamesKey) return ignoredPropertyNamesDict;
    if (key == &BMAllowedCodingPropertyNamesKey) return allowedCodingPropertyNamesDict;
    if (key == &BMIgnoredCodingPropertyNamesKey) return ignoredCodingPropertyNamesDict;
    return nil;
}

+ (void)bm_enumerateClasses:(BMClassesEnumeration)enumeration
{
    // 1.没有block就直接返回
    if (enumeration == nil) return;
    
    // 2.停止遍历的标记
    BOOL stop = NO;
    
    // 3.当前正在遍历的类
    Class c = self;
    
    // 4.开始遍历每一个类
    while (c && !stop) {
        // 4.1.执行操作
        enumeration(c, &stop);
        
        // 4.2.获得父类
        c = class_getSuperclass(c);
        
        if ([BMFoundation isClassFromFoundation:c]) break;
    }
}

+ (void)bm_enumerateAllClasses:(BMClassesEnumeration)enumeration
{
    // 1.没有block就直接返回
    if (enumeration == nil) return;
    
    // 2.停止遍历的标记
    BOOL stop = NO;
    
    // 3.当前正在遍历的类
    Class c = self;
    
    // 4.开始遍历每一个类
    while (c && !stop) {
        // 4.1.执行操作
        enumeration(c, &stop);
        
        // 4.2.获得父类
        c = class_getSuperclass(c);
    }
}

#pragma mark - 属性黑名单配置
+ (void)bm_setupIgnoredPropertyNames:(BMIgnoredPropertyNames)ignoredPropertyNames
{
    [self bm_setupBlockReturnValue:ignoredPropertyNames key:&BMIgnoredPropertyNamesKey];
}

+ (NSMutableArray *)bm_totalIgnoredPropertyNames
{
    return [self bm_totalObjectsWithSelector:@selector(bm_ignoredPropertyNames) key:&BMIgnoredPropertyNamesKey];
}

#pragma mark - 归档属性黑名单配置
+ (void)bm_setupIgnoredCodingPropertyNames:(BMIgnoredCodingPropertyNames)ignoredCodingPropertyNames
{
    [self bm_setupBlockReturnValue:ignoredCodingPropertyNames key:&BMIgnoredCodingPropertyNamesKey];
}

+ (NSMutableArray *)bm_totalIgnoredCodingPropertyNames
{
    return [self bm_totalObjectsWithSelector:@selector(bm_ignoredCodingPropertyNames) key:&BMIgnoredCodingPropertyNamesKey];
}

#pragma mark - 属性白名单配置
+ (void)bm_setupAllowedPropertyNames:(BMAllowedPropertyNames)allowedPropertyNames;
{
    [self bm_setupBlockReturnValue:allowedPropertyNames key:&BMAllowedPropertyNamesKey];
}

+ (NSMutableArray *)bm_totalAllowedPropertyNames
{
    return [self bm_totalObjectsWithSelector:@selector(bm_allowedPropertyNames) key:&BMAllowedPropertyNamesKey];
}

#pragma mark - 归档属性白名单配置
+ (void)bm_setupAllowedCodingPropertyNames:(BMAllowedCodingPropertyNames)allowedCodingPropertyNames
{
    [self bm_setupBlockReturnValue:allowedCodingPropertyNames key:&BMAllowedCodingPropertyNamesKey];
}

+ (NSMutableArray *)bm_totalAllowedCodingPropertyNames
{
    return [self bm_totalObjectsWithSelector:@selector(bm_allowedCodingPropertyNames) key:&BMAllowedCodingPropertyNamesKey];
}

#pragma mark - block和方法处理:存储block的返回值
+ (void)bm_setupBlockReturnValue:(id (^)(void))block key:(const char *)key
{
    if (block) {
        objc_setAssociatedObject(self, key, block(), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    } else {
        objc_setAssociatedObject(self, key, nil, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    
    // 清空数据
    BMExtensionSemaphoreCreate
    BMExtensionSemaphoreWait
    [[self classDictForKey:key] removeAllObjects];
    BMExtensionSemaphoreSignal
}

+ (NSMutableArray *)bm_totalObjectsWithSelector:(SEL)selector key:(const char *)key
{
    BMExtensionSemaphoreCreate
    BMExtensionSemaphoreWait
    
    NSMutableArray *array = [self classDictForKey:key][NSStringFromClass(self)];
    if (array == nil) {
        // 创建、存储
        [self classDictForKey:key][NSStringFromClass(self)] = array = [NSMutableArray array];
        
        if ([self respondsToSelector:selector]) {
    #pragma clang diagnostic push
    #pragma clang diagnostic ignored "-Warc-performSelector-leaks"
            NSArray *subArray = [self performSelector:selector];
    #pragma clang diagnostic pop
            if (subArray) {
                [array addObjectsFromArray:subArray];
            }
        }
        
        [self bm_enumerateAllClasses:^(__unsafe_unretained Class c, BOOL *stop) {
            NSArray *subArray = objc_getAssociatedObject(c, key);
            [array addObjectsFromArray:subArray];
        }];
    }
    
    BMExtensionSemaphoreSignal
    
    return array;
}
@end
