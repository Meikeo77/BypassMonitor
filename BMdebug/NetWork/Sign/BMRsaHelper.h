//
//  BMRsaHelper.h
//  KWLQuotation
//
//  Created by taohanjun on 16/4/29.
//  Copyright © 2016年 kingwelan. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BMRsaHelper : NSObject

/**
 *  rsa加密
 *
 *  @param string 要加密的文本
 *
 *  @return 加密后文本的bcd串
 */
+ (NSString*) klRsaEncryptString:(NSString*)string;


/**
 使用RSA public key(非证书)进行加密
 @param str 需要加密的字符串
 @return 返回加密以后的字符串
 */
+ (NSString *)BMEncryptString:(NSString *)str;


//将二进制数据转成hex类型
+ (NSString *)convertDataToHexStr:(NSData *)data;

@end
