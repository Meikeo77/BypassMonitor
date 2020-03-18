//
//  BMSignUtil.h
//  BMtamps
//
//  Created by taohanjun on 2017/7/18.
//  Copyright © 2017年 xu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BMSignUtil : NSObject


/**
 获取类的属性列表，字符串的数组

 @param myClass class
 @return 字符串的数组
 */
+ (NSArray*) getPropertyListOfClass:(Class) myClass;

/**
 mj_keyValues在某些时候会闪退，用于替换这个接口，返回一个对象的dic，只支持单层数据模型
 @param param 数据对象
 @return 对象的数据dic，不支持嵌套数据模型
 */
+ (NSDictionary *) keyValuesOfParam:(id)param;

/**MD5签名*/
+ (NSString *) md5HexDigest:(NSString*)sourceStr;

/**字符串排序*/
+ (NSArray*) stringSort:(NSArray*)sourceArr;

/** 获取一个时间戳+8位随机数的串*/
+ (NSString*) seriaString;

/**des加密*/
+ (NSString *)desEncryptWithKey:(NSString *)key for:(NSString*)srcStr;

+ (NSString *)desDecryptWithKey:(NSString *)key for:(NSString*)srcStr;
@end
