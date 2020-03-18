//
//  NSObject+BMProperty.h
//  BMExtensionExample
//
//  Created by BM Lee on 15/4/17.
//  Copyright (c) 2015年 小码哥. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BMExtensionConst.h"

@class BMProperty;

/**
 *  遍历成员变量用的block
 *
 *  @param property 成员的包装对象
 *  @param stop   YES代表停止遍历，NO代表继续遍历
 */
typedef void (^BMPropertiesEnumeration)(BMProperty *property, BOOL *stop);

/** 将属性名换为其他key去字典中取值 */
typedef NSDictionary * (^BMReplacedKeyFromPropertyName)(void);
typedef id (^BMReplacedKeyFromPropertyName121)(NSString *propertyName);
/** 数组中需要转换的模型类 */
typedef NSDictionary * (^BMObjectClassInArray)(void);
/** 用于过滤字典中的值 */
typedef id (^BMNewValueFromOldValue)(id object, id oldValue, BMProperty *property);

/**
 * 成员属性相关的扩展
 */
@interface NSObject (BMProperty)
#pragma mark - 遍历
/**
 *  遍历所有的成员
 */
+ (void)bm_enumerateProperties:(BMPropertiesEnumeration)enumeration;

#pragma mark - 新值配置
/**
 *  用于过滤字典中的值
 *
 *  @param newValueFormOldValue 用于过滤字典中的值
 */
+ (void)bm_setupNewValueFromOldValue:(BMNewValueFromOldValue)newValueFormOldValue;
+ (id)bm_getNewValueFromObject:(__unsafe_unretained id)object oldValue:(__unsafe_unretained id)oldValue property:(__unsafe_unretained BMProperty *)property;

#pragma mark - key配置
/**
 *  将属性名换为其他key去字典中取值
 *
 *  @param replacedKeyFromPropertyName 将属性名换为其他key去字典中取值
 */
+ (void)bm_setupReplacedKeyFromPropertyName:(BMReplacedKeyFromPropertyName)replacedKeyFromPropertyName;
/**
 *  将属性名换为其他key去字典中取值
 *
 *  @param replacedKeyFromPropertyName121 将属性名换为其他key去字典中取值
 */
+ (void)bm_setupReplacedKeyFromPropertyName121:(BMReplacedKeyFromPropertyName121)replacedKeyFromPropertyName121;

#pragma mark - array model class配置
/**
 *  数组中需要转换的模型类
 *
 *  @param objectClassInArray          数组中需要转换的模型类
 */
+ (void)bm_setupObjectClassInArray:(BMObjectClassInArray)objectClassInArray;
@end

@interface NSObject (BMPropertyDeprecated_v_2_5_16)
+ (void)enumerateProperties:(BMPropertiesEnumeration)enumeration BMExtensionDeprecated("请在方法名前面加上bm_前缀，使用bm_***");
+ (void)setupNewValueFromOldValue:(BMNewValueFromOldValue)newValueFormOldValue BMExtensionDeprecated("请在方法名前面加上bm_前缀，使用bm_***");
+ (id)getNewValueFromObject:(__unsafe_unretained id)object oldValue:(__unsafe_unretained id)oldValue property:(__unsafe_unretained BMProperty *)property BMExtensionDeprecated("请在方法名前面加上bm_前缀，使用bm_***");
+ (void)setupReplacedKeyFromPropertyName:(BMReplacedKeyFromPropertyName)replacedKeyFromPropertyName BMExtensionDeprecated("请在方法名前面加上bm_前缀，使用bm_***");
+ (void)setupReplacedKeyFromPropertyName121:(BMReplacedKeyFromPropertyName121)replacedKeyFromPropertyName121 BMExtensionDeprecated("请在方法名前面加上bm_前缀，使用bm_***");
+ (void)setupObjectClassInArray:(BMObjectClassInArray)objectClassInArray BMExtensionDeprecated("请在方法名前面加上bm_前缀，使用bm_***");
@end
