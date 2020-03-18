//
//  NSObject+BMProperty.m
//  BMExtensionExample
//
//  Created by BM Lee on 15/4/17.
//  Copyright (c) 2015年 小码哥. All rights reserved.
//

#import "NSObject+BMProperty.h"
#import "NSObject+BMKeyValue.h"
#import "NSObject+BMCoding.h"
#import "NSObject+BMClass.h"
#import "BMProperty.h"
#import "BMFoundation.h"
#import <objc/runtime.h>

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wundeclared-selector"
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"

static const char BMReplacedKeyFromPropertyNameKey = '\0';
static const char BMReplacedKeyFromPropertyName121Key = '\0';
static const char BMNewValueFromOldValueKey = '\0';
static const char BMObjectClassInArrayKey = '\0';

static const char BMCachedPropertiesKey = '\0';

@implementation NSObject (Property)

+ (NSMutableDictionary *)propertyDictForKey:(const void *)key
{
    static NSMutableDictionary *replacedKeyFromPropertyNameDict;
    static NSMutableDictionary *replacedKeyFromPropertyName121Dict;
    static NSMutableDictionary *newValueFromOldValueDict;
    static NSMutableDictionary *objectClassInArrayDict;
    static NSMutableDictionary *cachedPropertiesDict;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        replacedKeyFromPropertyNameDict = [NSMutableDictionary dictionary];
        replacedKeyFromPropertyName121Dict = [NSMutableDictionary dictionary];
        newValueFromOldValueDict = [NSMutableDictionary dictionary];
        objectClassInArrayDict = [NSMutableDictionary dictionary];
        cachedPropertiesDict = [NSMutableDictionary dictionary];
    });
    
    if (key == &BMReplacedKeyFromPropertyNameKey) return replacedKeyFromPropertyNameDict;
    if (key == &BMReplacedKeyFromPropertyName121Key) return replacedKeyFromPropertyName121Dict;
    if (key == &BMNewValueFromOldValueKey) return newValueFromOldValueDict;
    if (key == &BMObjectClassInArrayKey) return objectClassInArrayDict;
    if (key == &BMCachedPropertiesKey) return cachedPropertiesDict;
    return nil;
}

#pragma mark - --私有方法--
+ (id)propertyKey:(NSString *)propertyName
{
    BMExtensionAssertParamNotNil2(propertyName, nil);
    
    __block id key = nil;
    // 查看有没有需要替换的key
    if ([self respondsToSelector:@selector(bm_replacedKeyFromPropertyName121:)]) {
        key = [self bm_replacedKeyFromPropertyName121:propertyName];
    }
    // 兼容旧版本
    if ([self respondsToSelector:@selector(replacedKeyFromPropertyName121:)]) {
        key = [self performSelector:@selector(replacedKeyFromPropertyName121) withObject:propertyName];
    }
    
    // 调用block
    if (!key) {
        [self bm_enumerateAllClasses:^(__unsafe_unretained Class c, BOOL *stop) {
            BMReplacedKeyFromPropertyName121 block = objc_getAssociatedObject(c, &BMReplacedKeyFromPropertyName121Key);
            if (block) {
                key = block(propertyName);
            }
            if (key) *stop = YES;
        }];
    }
    
    // 查看有没有需要替换的key
    if ((!key || [key isEqual:propertyName]) && [self respondsToSelector:@selector(bm_replacedKeyFromPropertyName)]) {
        key = [self bm_replacedKeyFromPropertyName][propertyName];
    }
    // 兼容旧版本
    if ((!key || [key isEqual:propertyName]) && [self respondsToSelector:@selector(replacedKeyFromPropertyName)]) {
        key = [self performSelector:@selector(replacedKeyFromPropertyName)][propertyName];
    }
    
    if (!key || [key isEqual:propertyName]) {
        [self bm_enumerateAllClasses:^(__unsafe_unretained Class c, BOOL *stop) {
            NSDictionary *dict = objc_getAssociatedObject(c, &BMReplacedKeyFromPropertyNameKey);
            if (dict) {
                key = dict[propertyName];
            }
            if (key && ![key isEqual:propertyName]) *stop = YES;
        }];
    }
    
    // 2.用属性名作为key
    if (!key) key = propertyName;
    
    return key;
}

+ (Class)propertyObjectClassInArray:(NSString *)propertyName
{
    __block id clazz = nil;
    if ([self respondsToSelector:@selector(bm_objectClassInArray)]) {
        clazz = [self bm_objectClassInArray][propertyName];
    }
    // 兼容旧版本
    if ([self respondsToSelector:@selector(objectClassInArray)]) {
        clazz = [self performSelector:@selector(objectClassInArray)][propertyName];
    }
    
    if (!clazz) {
        [self bm_enumerateAllClasses:^(__unsafe_unretained Class c, BOOL *stop) {
            NSDictionary *dict = objc_getAssociatedObject(c, &BMObjectClassInArrayKey);
            if (dict) {
                clazz = dict[propertyName];
            }
            if (clazz) *stop = YES;
        }];
    }
    
    // 如果是NSString类型
    if ([clazz isKindOfClass:[NSString class]]) {
        clazz = NSClassFromString(clazz);
    }
    return clazz;
}

#pragma mark - --公共方法--
+ (void)bm_enumerateProperties:(BMPropertiesEnumeration)enumeration
{
    // 获得成员变量
    NSArray *cachedProperties = [self properties];
    
    // 遍历成员变量
    BOOL stop = NO;
    for (BMProperty *property in cachedProperties) {
        enumeration(property, &stop);
        if (stop) break;
    }
}

#pragma mark - 公共方法
+ (NSMutableArray *)properties
{
    NSMutableArray *cachedProperties = [self propertyDictForKey:&BMCachedPropertiesKey][NSStringFromClass(self)];
    
    if (cachedProperties == nil) {
        BMExtensionSemaphoreCreate
        BMExtensionSemaphoreWait
        
        if (cachedProperties == nil) {
            cachedProperties = [NSMutableArray array];
            
            [self bm_enumerateClasses:^(__unsafe_unretained Class c, BOOL *stop) {
                // 1.获得所有的成员变量
                unsigned int outCount = 0;
                objc_property_t *properties = class_copyPropertyList(c, &outCount);
                
                // 2.遍历每一个成员变量
                for (unsigned int i = 0; i<outCount; i++) {
                    BMProperty *property = [BMProperty cachedPropertyWithProperty:properties[i]];
                    // 过滤掉Foundation框架类里面的属性
                    if ([BMFoundation isClassFromFoundation:property.srcClass]) continue;
                    property.srcClass = c;
                    [property setOriginKey:[self propertyKey:property.name] forClass:self];
                    [property setObjectClassInArray:[self propertyObjectClassInArray:property.name] forClass:self];
                    [cachedProperties addObject:property];
                }
                
                // 3.释放内存
                free(properties);
            }];
            
            [self propertyDictForKey:&BMCachedPropertiesKey][NSStringFromClass(self)] = cachedProperties;
        }
        
        BMExtensionSemaphoreSignal
    }
    
    return cachedProperties;
}

#pragma mark - 新值配置
+ (void)bm_setupNewValueFromOldValue:(BMNewValueFromOldValue)newValueFormOldValue
{
    objc_setAssociatedObject(self, &BMNewValueFromOldValueKey, newValueFormOldValue, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

+ (id)bm_getNewValueFromObject:(__unsafe_unretained id)object oldValue:(__unsafe_unretained id)oldValue property:(BMProperty *__unsafe_unretained)property{
    // 如果有实现方法
    if ([object respondsToSelector:@selector(bm_newValueFromOldValue:property:)]) {
        return [object bm_newValueFromOldValue:oldValue property:property];
    }
    // 兼容旧版本
    if ([self respondsToSelector:@selector(newValueFromOldValue:property:)]) {
        return [self performSelector:@selector(newValueFromOldValue:property:)  withObject:oldValue  withObject:property];
    }
    
    // 查看静态设置
    __block id newValue = oldValue;
    [self bm_enumerateAllClasses:^(__unsafe_unretained Class c, BOOL *stop) {
        BMNewValueFromOldValue block = objc_getAssociatedObject(c, &BMNewValueFromOldValueKey);
        if (block) {
            newValue = block(object, oldValue, property);
            *stop = YES;
        }
    }];
    return newValue;
}

#pragma mark - array model class配置
+ (void)bm_setupObjectClassInArray:(BMObjectClassInArray)objectClassInArray
{
    [self bm_setupBlockReturnValue:objectClassInArray key:&BMObjectClassInArrayKey];
    
    BMExtensionSemaphoreCreate
    BMExtensionSemaphoreWait
    [[self propertyDictForKey:&BMCachedPropertiesKey] removeAllObjects];
    BMExtensionSemaphoreSignal
}

#pragma mark - key配置
+ (void)bm_setupReplacedKeyFromPropertyName:(BMReplacedKeyFromPropertyName)replacedKeyFromPropertyName
{
    [self bm_setupBlockReturnValue:replacedKeyFromPropertyName key:&BMReplacedKeyFromPropertyNameKey];
    
    BMExtensionSemaphoreCreate
    BMExtensionSemaphoreWait
    [[self propertyDictForKey:&BMCachedPropertiesKey] removeAllObjects];
    BMExtensionSemaphoreSignal
}

+ (void)bm_setupReplacedKeyFromPropertyName121:(BMReplacedKeyFromPropertyName121)replacedKeyFromPropertyName121
{
    objc_setAssociatedObject(self, &BMReplacedKeyFromPropertyName121Key, replacedKeyFromPropertyName121, OBJC_ASSOCIATION_COPY_NONATOMIC);
    
    BMExtensionSemaphoreCreate
    BMExtensionSemaphoreWait
    [[self propertyDictForKey:&BMCachedPropertiesKey] removeAllObjects];
    BMExtensionSemaphoreSignal
}
@end

@implementation NSObject (BMPropertyDeprecated_v_2_5_16)
+ (void)enumerateProperties:(BMPropertiesEnumeration)enumeration
{
    [self bm_enumerateProperties:enumeration];
}

+ (void)setupNewValueFromOldValue:(BMNewValueFromOldValue)newValueFormOldValue
{
    [self bm_setupNewValueFromOldValue:newValueFormOldValue];
}

+ (id)getNewValueFromObject:(__unsafe_unretained id)object oldValue:(__unsafe_unretained id)oldValue property:(__unsafe_unretained BMProperty *)property
{
    return [self bm_getNewValueFromObject:object oldValue:oldValue property:property];
}

+ (void)setupReplacedKeyFromPropertyName:(BMReplacedKeyFromPropertyName)replacedKeyFromPropertyName
{
    [self bm_setupReplacedKeyFromPropertyName:replacedKeyFromPropertyName];
}

+ (void)setupReplacedKeyFromPropertyName121:(BMReplacedKeyFromPropertyName121)replacedKeyFromPropertyName121
{
    [self bm_setupReplacedKeyFromPropertyName121:replacedKeyFromPropertyName121];
}

+ (void)setupObjectClassInArray:(BMObjectClassInArray)objectClassInArray
{
    [self bm_setupObjectClassInArray:objectClassInArray];
}
@end

#pragma clang diagnostic pop
