//
//  BMRsaHelper.m
//  KWLQuotation
//
//  Created by taohanjun on 16/4/29.
//  Copyright © 2016年 kingwelan. All rights reserved.
//

#import "BMRsaHelper.h"
#import <Security/Security.h>
#import "BMSignParams.h"
#import "BMKeychainTool.h"

 #define RC_BUNDLE_NAME @"KwlStockResources"

@interface BMRsaHelper (){
    SecKeyRef publicKey;
}

@end


@implementation BMRsaHelper

+ (instancetype) sharedInstance{

    static dispatch_once_t t;
    static BMRsaHelper *rsaHelper;

    dispatch_once(&t, ^{
        rsaHelper = [[BMRsaHelper alloc] init];
        if(rsaHelper){
            
            [rsaHelper publicKeyInit];
        }
    });
    
    return rsaHelper;
}

+ (NSString*) klRsaEncryptString:(NSString*)string{
    
    BMRsaHelper *rsa = [BMRsaHelper sharedInstance];
    
    return [rsa rsaEncryptString:string];
}


-(void)dealloc{
    CFRelease(publicKey);
}

-(SecKeyRef) getPublicKey {
    return publicKey;
}

- (void) publicKeyInit{
    NSString *keyPath = [[ NSBundle mainBundle] pathForResource:@"public_key" ofType:@"der"];
    if([keyPath length] == 0) return;
    [self loadPublicKeyFromFile:keyPath];
}

-(void) loadPublicKeyFromFile: (NSString*) derFilePath{
    NSData *derData = [[NSData alloc] initWithContentsOfFile:derFilePath];
    if([derData length] == 0) return;
    
    [self loadPublicKeyFromData: derData];
}

-(void) loadPublicKeyFromData: (NSData*) derData{
    publicKey = [self getPublicKeyRefrenceFromeData: derData];
}

#pragma mark - Private Methods
- (SecKeyRef) getPublicKeyRefrenceFromeData: (NSData*)derData{
    
    SecCertificateRef myCertificate = SecCertificateCreateWithData(kCFAllocatorDefault, (__bridge CFDataRef)derData);
    SecPolicyRef myPolicy = SecPolicyCreateBasicX509();
    SecTrustRef myTrust;
    
    if(!myCertificate){
        CFRelease(myPolicy);
        return nil;
    }
    
    OSStatus status = SecTrustCreateWithCertificates(myCertificate,myPolicy,&myTrust);
    SecTrustResultType trustResult;
    
    if (status == noErr) {
        SecTrustEvaluate(myTrust, &trustResult);
    }
    
    SecKeyRef securityKey = SecTrustCopyPublicKey(myTrust);
    CFRelease(myCertificate);
    CFRelease(myPolicy);
    CFRelease(myTrust);
    return securityKey;
}


#pragma mark - Encrypt
- (NSString*) rsaEncryptString:(NSString*)string {
    NSData* data = [string dataUsingEncoding:NSUTF8StringEncoding];
    NSData* encryptedData = [self rsaEncryptData: data];
    if([encryptedData length] == 0) return nil;
    return [self bcdEncode:encryptedData];
}

// 加密的大小受限于SecKeyEncrypt函数，SecKeyEncrypt要求明文和密钥的长度一致，如果要加密更长的内容，需要把内容按密钥长度分成多份，然后多次调用SecKeyEncrypt来实现
- (NSData*) rsaEncryptData:(NSData*)data {
    
    SecKeyRef key = [self getPublicKey];
    
    if(!key)
        return nil;
    
    size_t cipherBufferSize = SecKeyGetBlockSize(key);
    uint8_t *cipherBuffer = malloc(cipherBufferSize * sizeof(uint8_t));
    size_t blockSize = cipherBufferSize - 11;       // 分段加密
    size_t blockCount = (size_t)ceil([data length] / (double)blockSize);
    NSMutableData *encryptedData = [[NSMutableData alloc] init] ;
    for (int i=0; i<blockCount; i++) {
        NSUInteger bufferSize = MIN(blockSize,[data length] - i * blockSize);
        NSData *buffer = [data subdataWithRange:NSMakeRange(i * blockSize, bufferSize)];
        OSStatus status = SecKeyEncrypt(key, kSecPaddingPKCS1, (const uint8_t *)[buffer bytes], [buffer length], cipherBuffer, &cipherBufferSize);
        if (status == noErr){
            NSData *encryptedBytes = [[NSData alloc] initWithBytes:(const void *)cipherBuffer length:cipherBufferSize];
            [encryptedData appendData:encryptedBytes];
        }else{
            if (cipherBuffer) {
                free(cipherBuffer);
            }
            return nil;
        }
    }
    if (cipherBuffer){
        free(cipherBuffer);
    }
    return encryptedData;
}


- (NSString*) bcdEncode:(NSData*)data{
    
    char *dd = (char *)[data bytes];
    int len = (int)[data length];
    
    NSMutableString *bcdString = [[NSMutableString alloc] init];
    
    char val;
    char tmpVal;
    
    for (int i = 0; i < len; i++) {
        val = (char) (((dd[i] & 0xf0) >> 4) & 0x0f);
        tmpVal = (char) (val > 9 ? val + 'A' - 10 : val + '0');
        [bcdString appendFormat:@"%c", tmpVal];
        
        val = (char) (dd[i] & 0x0f);
        tmpVal = (char) (val > 9 ? val + 'A' - 10 : val + '0');
        [bcdString appendFormat:@"%c", tmpVal];
    }
    
    return bcdString;
}


#pragma mark - 使用RSA public key(非证书)进行加密
/**
 使用RSA public key(非证书)进行加密
 @param str 需要加密的字符串
 @return 返回加密以后的字符串
 */
+ (NSString *)BMEncryptString:(NSString *)str {
    //1.调用核心方法将待加密的字符串转化成二进制数据,返回加密以后的二进制数据
    NSData *data = [self rsaEncryptData:[str dataUsingEncoding:NSUTF8StringEncoding]];
    //2.将二进制转换成hex进制字符串
    NSString *ret = [self convertDataToHexStr:data];
    
    return ret;
}

//将二进制数据转成hex类型
+ (NSString *)convertDataToHexStr:(NSData *)data {
    if (!data || [data length] == 0) {
        return @"";
    }
    NSMutableString *string = [[NSMutableString alloc] initWithCapacity:[data length]];
    
    [data enumerateByteRangesUsingBlock:^(const void *bytes, NSRange byteRange, BOOL *stop) {
        unsigned char *dataBytes = (unsigned char*)bytes;
        for (NSInteger i = 0; i < byteRange.length; i++) {
            NSString *hexStr = [NSString stringWithFormat:@"%x", (dataBytes[i]) & 0xff];
            if ([hexStr length] == 2) {
                [string appendString:hexStr];
            } else {
                [string appendFormat:@"0%@", hexStr];
            }
        }
    }];
    
    return string;
}

+ (NSData *)rsaEncryptData:(NSData *)data {
    if(!data){
        return nil;
    }
    
    SecKeyRef keyRef = [BMKeychainTool getPublicKeyRef];
    if(!keyRef){
        return nil;
    }
    //2.传入待加密二进制数据和SecKeyRef公钥对象
    return [self encryptData:data withKeyRef:keyRef];
}

/*
+ (SecKeyRef)addPublicKey:(NSString *)key{
    
    //1. 找到PEM格式publickey的头部和尾部
    NSRange spos = [key rangeOfString:@"-----BEGIN PUBLIC KEY-----"];
    NSRange epos = [key rangeOfString:@"-----END PUBLIC KEY-----"];
    //2. 如果找到头部和尾部,那么截取头部尾部之间的部分 -- 真正的有用的public key部分
    if(spos.location != NSNotFound && epos.location != NSNotFound){
        NSUInteger s = spos.location + spos.length;
        NSUInteger e = epos.location;
        NSRange range = NSMakeRange(s, e-s);
        key = [key substringWithRange:range];
    }
    
    //3. 清理PEM格式publickey中的"\r","\n"," "等回车,换行,空格字符
    key = [key stringByReplacingOccurrencesOfString:@"\r" withString:@""];
    key = [key stringByReplacingOccurrencesOfString:@"\n" withString:@""];
    key = [key stringByReplacingOccurrencesOfString:@"\t" withString:@""];
    key = [key stringByReplacingOccurrencesOfString:@" "  withString:@""];
    
    //4. 一般PEM格式公钥字符串是通过base64编码以后的字符串,因此需要从中解码成原始二进制数据,解码以后是DER编码格式的
    NSData *data = [[NSData alloc]initWithBase64EncodedString:key options:NSDataBase64DecodingIgnoreUnknownCharacters];;
    //5. 清理DER格式的publickey的公钥头部信息 -- DER公钥满足ASN.1编码格式,具体参考TLV方式
    data = [self stripPublicKeyHeader:data];
    if(!data){
        return nil;
    }
    
    //6. 将public_key 存入公钥
    
    //7. tag表示写入keychain的Tag标签,方便以后从keychain中读写这个公钥
    NSString *tag = @"RSAUtil_PubKey";
    NSData *d_tag = [NSData dataWithBytes:[tag UTF8String] length:[tag length]];
    
    //8. 先删除keychain中的tag同名的对应的key
    NSMutableDictionary *publicKey = [[NSMutableDictionary alloc] init];
    // kSecClass是表示keychain中存储的类型,常见的有kSecClassGenericPassword(一般密码),kSecClassInternetPassword(网络密码),kSecClassCertificate(证书),kSecClassKey(密钥),kSecClassIdentity(带私钥证书)等
    // 不同类型的钥匙串项对应的属性不同,这里使用的kSecClassKey(密钥),对应的属性有许多最重要的是kSecAttrKeyType,表示密钥的类型,这里使用的kSecAttrKeyTypeRSA;
    [publicKey setObject:(__bridge id) kSecClassKey forKey:(__bridge id)kSecClass];
    [publicKey setObject:(__bridge id) kSecAttrKeyTypeRSA forKey:(__bridge id)kSecAttrKeyType];
    [publicKey setObject:d_tag forKey:(__bridge id)kSecAttrApplicationTag];// 设置需要删除的带tag的密钥
    SecItemDelete((__bridge CFDictionaryRef)publicKey);// 先查询keychain中是否有同tag的,直接删除
    
    [publicKey setObject:data forKey:(__bridge id)kSecValueData];//设置keychain的写入字段的类型kSecValueData
    [publicKey setObject:(__bridge id) kSecAttrKeyClassPublic forKey:(__bridge id)
     kSecAttrKeyClass];//设置加密密钥类kSecAttrKeyClassPublic,kSecAttrKeyClassPrivate或者kSecAttrKeyClassSymmetric,这里是公钥
    [publicKey setObject:[NSNumber numberWithBool:YES] forKey:(__bridge id)
     kSecReturnPersistentRef];//设置是否返回持久型实例(CFDataRef)
    
    //9. 讲public key dict通过SecItemAdd添加到keychain中
    CFTypeRef persistKey = nil;
    OSStatus status = SecItemAdd((__bridge CFDictionaryRef)publicKey, &persistKey);
    if (persistKey != nil){
        CFRelease(persistKey);
    }
    if ((status != noErr) && (status != errSecDuplicateItem)) {
        return nil;
    }
    
    [publicKey removeObjectForKey:(__bridge id)kSecValueData];// 清理属性
    [publicKey removeObjectForKey:(__bridge id)kSecReturnPersistentRef];// 清理属性
    [publicKey setObject:[NSNumber numberWithBool:YES] forKey:(__bridge id)kSecReturnRef];//设置返回实例(SecKeychainItemRef, SecKeyRef, SecCertificateRef, SecIdentityRef, or CFDataRef)
    [publicKey setObject:(__bridge id) kSecAttrKeyTypeRSA forKey:(__bridge id)kSecAttrKeyType];// 这里其实原来已经添加过...
    
    //10. 从keychain中获取SecKeyRef对象
    SecKeyRef keyRef = nil;
    status = SecItemCopyMatching((__bridge CFDictionaryRef)publicKey, (CFTypeRef *)&keyRef);
    if(status != noErr){
        return nil;
    }
    return keyRef;
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
 */

/**
 使用SecKeyRef对象加密核心方法
 
 @param data 待加密二进制数据
 @param keyRef 密钥SecKeyRef对象
 @return RSA加密以后二进制数据
 */
+ (NSData *)encryptData:(NSData *)data withKeyRef:(SecKeyRef) keyRef{
    const uint8_t *srcbuf = (const uint8_t *)[data bytes];
    size_t srclen = (size_t)data.length;
    
    // 加密block_size
    size_t block_size = SecKeyGetBlockSize(keyRef) * sizeof(uint8_t);
    void *outbuf = malloc(block_size);
    size_t src_block_size = block_size - 11;
    
    NSMutableData *ret = [[NSMutableData alloc] init];
    for(int idx=0; idx<srclen; idx+=src_block_size){
        //NSLog(@"%d/%d block_size: %d", idx, (int)srclen, (int)block_size);
        size_t data_len = srclen - idx;
        if(data_len > src_block_size){
            data_len = src_block_size;
        }
        
        size_t outlen = block_size;
        OSStatus status = noErr;
        status = SecKeyEncrypt(keyRef,
                               kSecPaddingPKCS1,
                               srcbuf + idx,
                               data_len,
                               outbuf,
                               &outlen
                               );
        if (status != 0) {
            NSLog(@"SecKeyEncrypt fail. Error Code: %d", status);
            ret = nil;
            break;
        }else{
            [ret appendBytes:outbuf length:outlen];
        }
    }
    
    free(outbuf);
    CFRelease(keyRef);
    return ret;
}

@end


