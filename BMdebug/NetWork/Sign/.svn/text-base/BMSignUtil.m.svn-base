//
//  BMSignUtil.m
//  BMtamps
//
//  Created by taohanjun on 2017/7/18.
//  Copyright © 2017年 xu. All rights reserved.
//
#import <Foundation/Foundation.h>
#import <CommonCrypto/CommonCrypto.h>
#import <CommonCrypto/CommonHMAC.h>

#import "BMSignUtil.h"

#define kPaddingMode kCCOptionPKCS7Padding

@implementation BMSignUtil

//取某类的所有属性，包括了父类的属性
+ (NSArray*) getPropertyListOfClass:(Class) myClass{
    
    NSMutableArray *propertyNameList = [[NSMutableArray alloc] init];
    
    Class objClass = myClass;
    do{
        unsigned int count;
        objc_property_t *propertyList = class_copyPropertyList(objClass, &count);
        for (unsigned int i = 0; i < count; i++) {
            const char *propertyName = property_getName(propertyList[i]);
            [propertyNameList addObject: [NSString stringWithUTF8String:propertyName]];
        }
        
        objClass = [objClass superclass];
    }while (objClass != [NSObject class]);
    
    return propertyNameList;
}

+ (NSDictionary *) keyValuesOfParam:(id)param{
    
    if(!param) return nil;
    
    __block NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
    NSArray *paramKeys = [BMSignUtil getPropertyListOfClass:[param class]];
    
    [paramKeys enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        NSString *keyStr = obj;
        NSString *valueStr = [param valueForKey:keyStr];
        if(valueStr){
            [dic setValue:valueStr forKey:keyStr];
        }
    }];
    
    return dic;
}

+ (NSString *) md5HexDigest:(NSString*)sourceStr{
    const char *original_str = [sourceStr UTF8String];
    unsigned char result[CC_MD5_DIGEST_LENGTH];
    CC_MD5(original_str, (CC_LONG)strlen(original_str), result);
    NSMutableString *hash = [NSMutableString string];
    for (int i = 0; i < 16; i++)
        [hash appendFormat:@"%02X", result[i]];
    return [hash lowercaseString];
}

//字符串排序
+ (NSArray*) stringSort:(NSArray*)sourceArr{
    return [sourceArr sortedArrayUsingSelector:@selector(compare:)];
}

+ (NSString*) seriaString{
    NSTimeInterval times = [[NSDate date] timeIntervalSince1970];
    return [NSString stringWithFormat:@"%ld%0u",(long)(times*1000*1000),arc4random()%100000000];
}

//des
/*
 DES加密 key为NSString形式
 */
+ (NSString *)desEncryptWithKey:(NSString *)key for:(NSString*)srcStr{
    
    if(([key length] == 0) || ([srcStr length] == 0)){
        return nil;
    }
    
    NSData *desKey = [key dataUsingEncoding:NSUTF8StringEncoding];
    NSData *srcData = [srcStr dataUsingEncoding:NSUTF8StringEncoding];
    if(([desKey length] == 0) || ([srcData length] == 0)){
        return nil;
    }
    
    NSData *resultData = [BMSignUtil desEncryptWithDataKey:desKey for:srcData];
    if(!resultData){
        return nil;
    }
    
    uint8_t* a = (uint8_t*)[resultData bytes];
    NSMutableString *hash = [NSMutableString string];
    for (int i = 0; i < resultData.length; i++){
        [hash appendFormat:@"%02x", a[i]];
    }
    return hash;
}


// DES加密 key为NSData形式 结果返回NSData
+ (NSData *)desEncryptWithDataKey:(NSData *)key for:(NSData*)srcData{
    return [self desEncryptOrDecrypt:kCCEncrypt data:srcData dataKey:key mode:kPaddingMode | kCCOptionECBMode];
}

#pragma mark - DES解密

+ (NSString *)desDecryptWithKey:(NSString *)key for:(NSString*)srcStr{
    
    if(([key length] == 0) || ([srcStr length] == 0)){
        return nil;
    }
    
    NSString *command = [srcStr stringByReplacingOccurrencesOfString:@" " withString:@""];
    NSMutableData *data= [[NSMutableData alloc] init];
    unsigned char whole_byte;
    char byte_chars[3] = {'\0','\0','\0'};
    int i;
    for (i=0; i < [command length]/2; i++) {
        byte_chars[0] = [command characterAtIndex:i*2];
        byte_chars[1] = [command characterAtIndex:i*2+1];
        whole_byte = strtol(byte_chars, NULL, 16);
        [data appendBytes:&whole_byte length:1];
    }
    
    NSData *desKey = [key dataUsingEncoding:NSUTF8StringEncoding];
    
    if(([data length] == 0) || ([desKey length] == 0)){
        NSLog(@"desDecryptWithKey error desKey==nil || data==nil");
        return nil;
    }
    
    NSData *resultData = [BMSignUtil desDecryptWithData:data dataKey:desKey];
    if(!resultData){
        NSLog(@"desDecryptWithKey error resultData==nil");
        return nil;
    }
    
    return [[NSString alloc] initWithData:resultData encoding:NSUTF8StringEncoding];
}

+ (NSData *)desDecryptWithData:(NSData *)data dataKey:(NSData *)key {
    return [BMSignUtil desEncryptOrDecrypt:kCCDecrypt data:data dataKey:key mode:kPaddingMode | kCCOptionECBMode];
}

+ (NSData *)desEncryptOrDecrypt:(CCOperation)option data:(NSData *)data dataKey:(NSData *)key mode:(int)mode{
    
    if((![data isKindOfClass:[NSData class]]) || (![key isKindOfClass:[NSData class]])){
        return nil;
    }
    
    // setup output buffer
    size_t bufferSize = [data length] + kCCBlockSizeDES;
    void *buffer = malloc(bufferSize);
    if(!buffer){
        NSLog(@"desEncryptOrDecrypt:内存分配失败");
        return nil;
    }
    
    // do encrypt
    size_t encryptedSize = 0;
    CCCryptorStatus cryptStatus = CCCrypt(option,
                                          kCCAlgorithmDES,
                                          mode,
                                          [key bytes],     // Key
                                          kCCKeySizeDES,    // kCCKeySizeAES
                                          NULL,            // IV
                                          [data bytes],
                                          [data length],
                                          buffer,
                                          bufferSize,
                                          &encryptedSize);
    
    NSData *resultData = nil;
    if (cryptStatus == kCCSuccess) {
        if(buffer){
            resultData = [NSData dataWithBytes:buffer length:encryptedSize];
        }
        
    } else {
        NSLog(@"DES operation error:%d", (int)cryptStatus);
        
        //2018-06-26 这个throw会触发crash，暂时屏蔽了。
//        @throw [NSException exceptionWithName:@"Encrypt"
//                                       reason:@"Encrypt Error!"
//                                     userInfo:nil];
    }
    
    free(buffer);
    buffer = nil;
    return resultData;
}
 


@end
