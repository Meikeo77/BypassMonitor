//
//  BMKeychainTool.m
//  BMdebug
//
//  Created by MiaoYe on 2019/1/11.
//  Copyright © 2019 Meikeo. All rights reserved.
//

#import "BMKeychainTool.h"

NSString * const KEY_UDID_INSTEAD = @"com.kwl.BypassMonitor";
NSString * const KEY_PUBLIC_KEY = @"RSAUtil_PubKey";

@implementation BMKeychainTool

#pragma mark - 获取设备唯一标识码
+ (NSString *)getDeviceIDInKeychain {
    NSString *getUDIDInKeychain = (NSString *)[self load:KEY_UDID_INSTEAD];
    if (!getUDIDInKeychain ||[getUDIDInKeychain isEqualToString:@""]||[getUDIDInKeychain isKindOfClass:[NSNull class]]) {
        CFUUIDRef puuid = CFUUIDCreate( nil );
        CFStringRef uuidString = CFUUIDCreateString( nil, puuid );
        NSString * result = (NSString *)CFBridgingRelease(CFStringCreateCopy( NULL, uuidString));
        CFRelease(puuid);
        CFRelease(uuidString);
        [self save:KEY_UDID_INSTEAD data:result];
        getUDIDInKeychain = (NSString *)[self load:KEY_UDID_INSTEAD];
    }
    return getUDIDInKeychain;
}

+ (NSMutableDictionary *)getKeychainQuery:(NSString *)key {
    NSMutableDictionary *keychainQuery = [NSMutableDictionary dictionaryWithObjectsAndKeys:(id)kSecClassGenericPassword,(id)kSecClass,key,(id)kSecAttrService,key,(id)kSecAttrAccount,(id)kSecAttrAccessibleAfterFirstUnlock,(id)kSecAttrAccessible, nil];
    return keychainQuery;
}

+ (void)save:(NSString *)key data:(id)data {
    NSMutableDictionary *keychainQuery = [self getKeychainQuery:key];
    SecItemDelete((CFDictionaryRef)keychainQuery);
    [keychainQuery setObject:[NSKeyedArchiver archivedDataWithRootObject:data] forKey:(id)kSecValueData];
    SecItemAdd((CFDictionaryRef)keychainQuery, NULL);
}

+ (id)load:(NSString *)key {
    id ret = nil;
    NSMutableDictionary *keychainQuery = [self getKeychainQuery:key];
    [keychainQuery setObject:(id)kCFBooleanTrue forKey:(id)kSecReturnData];
    [keychainQuery setObject:(id)kSecMatchLimitOne forKey:(id)kSecMatchLimit];
    CFDataRef keyData = NULL;
    if (SecItemCopyMatching((CFDictionaryRef)keychainQuery, (CFTypeRef *)&keyData) == noErr) {
        @try {
            ret = [NSKeyedUnarchiver unarchiveObjectWithData:(__bridge NSData *)keyData];
        } @catch (NSException *e) {
            NSLog(@"Unarchive of %@ failed: %@", key, e);
        } @finally {
        }
    }
    if (keyData)
        CFRelease(keyData);
    return ret;
}

+ (void)delete:(NSString *)service {
    NSMutableDictionary *keychainQuery = [self getKeychainQuery:service];
    SecItemDelete((CFDictionaryRef)keychainQuery);
}

#pragma mark - 存储公钥
+ (BOOL)publicKeySave:(NSString *)publicString {
    //1. 找到PEM格式publickey的头部和尾部
    NSRange spos = [publicString rangeOfString:@"-----BEGIN PUBLIC KEY-----"];
    NSRange epos = [publicString rangeOfString:@"-----END PUBLIC KEY-----"];
    //2. 如果找到头部和尾部,那么截取头部尾部之间的部分 -- 真正的有用的public key部分
    if(spos.location != NSNotFound && epos.location != NSNotFound){
        NSUInteger s = spos.location + spos.length;
        NSUInteger e = epos.location;
        NSRange range = NSMakeRange(s, e-s);
        publicString = [publicString substringWithRange:range];
    }
    
    //3. 清理PEM格式publickey中的"\r","\n"," "等回车,换行,空格字符
    publicString = [publicString stringByReplacingOccurrencesOfString:@"\r" withString:@""];
    publicString = [publicString stringByReplacingOccurrencesOfString:@"\n" withString:@""];
    publicString = [publicString stringByReplacingOccurrencesOfString:@"\t" withString:@""];
    publicString = [publicString stringByReplacingOccurrencesOfString:@" "  withString:@""];
    
    //4. 一般PEM格式公钥字符串是通过base64编码以后的字符串,因此需要从中解码成原始二进制数据,解码以后是DER编码格式的
    NSData *data = [[NSData alloc]initWithBase64EncodedString:publicString options:NSDataBase64DecodingIgnoreUnknownCharacters];;
    //5. 清理DER格式的publickey的公钥头部信息 -- DER公钥满足ASN.1编码格式,具体参考TLV方式
    data = [self stripPublicKeyHeader:data];
    if(!data){
        return NO;
    }
    
    NSMutableDictionary *publicKey = [self makePublicKeyDictionary];
    [publicKey setObject:data forKey:(__bridge id)kSecValueData];//设置keychain的写入字段的类型kSecValueData
    SecItemDelete((__bridge CFDictionaryRef)publicKey);// 先查询keychain中是否有同tag的,直接删除
    //9. 将public key dict通过SecItemAdd添加到keychain中
    CFTypeRef persistKey = nil;
    OSStatus status = SecItemAdd((__bridge CFDictionaryRef)publicKey, &persistKey);
    if (persistKey != nil){
        CFRelease(persistKey);
    }
    if ((status != noErr) && (status != errSecDuplicateItem)) {
        return NO;
    }
    return YES;
}

#pragma mark -  获取rsa加密所需的公钥seckeyref对象
+ (SecKeyRef)getPublicKeyRef {
    
    NSMutableDictionary *publicKey = [self makePublicKeyDictionary];
    [publicKey removeObjectForKey:(__bridge id)kSecValueData];// 清理属性
    [publicKey removeObjectForKey:(__bridge id)kSecReturnPersistentRef];// 清理属性
    [publicKey setObject:[NSNumber numberWithBool:YES] forKey:(__bridge id)kSecReturnRef];//设置返回实例(SecKeychainItemRef, SecKeyRef, SecCertificateRef, SecIdentityRef, or CFDataRef)
    
    //从keychain中获取SecKeyRef对象
    SecKeyRef keyRef = nil;
    OSStatus status = SecItemCopyMatching((__bridge CFDictionaryRef)publicKey, (CFTypeRef *)&keyRef);
    if(status != noErr){
        return nil;
    }
    return keyRef;
}

#pragma mark - 私有方法
+ (NSMutableDictionary *)makePublicKeyDictionary {
    //创建keychain获取属性类型
    NSData *d_tag = [NSData dataWithBytes:[KEY_PUBLIC_KEY UTF8String] length:[KEY_PUBLIC_KEY length]];
    NSMutableDictionary *publicKey = [[NSMutableDictionary alloc] init];
    
    // kSecClass是表示keychain中存储的类型,常见的有kSecClassGenericPassword(一般密码),kSecClassInternetPassword(网络密码),kSecClassCertificate(证书),kSecClassKey(密钥),kSecClassIdentity(带私钥证书)等
    // 不同类型的钥匙串项对应的属性不同,这里使用的kSecClassKey(密钥),对应的属性有许多最重要的是kSecAttrKeyType,表示密钥的类型,这里使用的kSecAttrKeyTypeRSA;
    
    [publicKey setObject:(__bridge id) kSecClassKey forKey:(__bridge id)kSecClass];
    [publicKey setObject:(__bridge id) kSecAttrKeyTypeRSA forKey:(__bridge id)kSecAttrKeyType];
    // 设置需要删除的带tag的密钥
    [publicKey setObject:d_tag forKey:(__bridge id)kSecAttrApplicationTag];
    //设置加密密钥类kSecAttrKeyClassPublic,kSecAttrKeyClassPrivate或者kSecAttrKeyClassSymmetric,这里是公钥
    [publicKey setObject:(__bridge id) kSecAttrKeyClassPublic forKey:(__bridge id)
     kSecAttrKeyClass];
    //设置是否返回持久型实例(CFDataRef)
    [publicKey setObject:[NSNumber numberWithBool:YES] forKey:(__bridge id)
     kSecReturnPersistentRef];
    
    return publicKey;
}

+ (NSData *)stripPublicKeyHeader:(NSData *)d_key{
    // Skip ASN.1 public key header
    if (d_key == nil) return(nil);
    
    unsigned long len = [d_key length];
    if (!len) return(nil);
    
    unsigned char *c_key = (unsigned char *)[d_key bytes];
    unsigned int  idx     = 0;
    
    //1.此时密钥一定是0x30开头的,或者说第一个字节一定是30(16进制)
    if (c_key[idx++] != 0x30) return(nil);
    
    //2.第二个字节一定是81或者82,81代表长度用1byte表示，82代表长度用2byte表示（此字节部分tag后不存在
    if (c_key[idx] > 0x80) idx += c_key[idx] - 0x80 + 1;
    else idx++;
    
    //3. 默认使用PKCS1填充格式,使用公共的头部数据填充:300d06092a864886f70d0101010500
    // PKCS #1 rsaEncryption szOID_RSA_RSA
    static unsigned char seqiod[] =
    { 0x30,   0x0d, 0x06, 0x09, 0x2a, 0x86, 0x48, 0x86, 0xf7, 0x0d, 0x01, 0x01,
        0x01, 0x05, 0x00 };
    if (memcmp(&c_key[idx], seqiod, 15)) return(nil);
    
    idx += 15;
    
    //4. 然后这里又是一个TLV格式,和开始类似0382010d
    if (c_key[idx++] != 0x03) return(nil);
    
    if (c_key[idx] > 0x80) idx += c_key[idx] - 0x80 + 1;
    else idx++;
    
    //5. 这里需要补充00,具体参考我的其他博客
    if (c_key[idx++] != '\0') return(nil);
    
    //6. 返回的就是TLV中的value值,就是最后的内容
    return ([NSData dataWithBytes:&c_key[idx] length:len - idx]);
}

@end
