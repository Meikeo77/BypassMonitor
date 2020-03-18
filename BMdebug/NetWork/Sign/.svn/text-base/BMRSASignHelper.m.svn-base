//
//  BMRSASignHelper.m
//  KwlVideoSDKDemo
//
//  Created by taohanjun on 2017/7/6.
//  Copyright © 2017年 taohanjun. All rights reserved.
//

#import "BMRSASignHelper.h"
#import <Security/Security.h>
#import <CommonCrypto/CommonCrypto.h>

@interface BMRSASignHelper ()

@property(nonatomic,copy) NSString* privateKeyPem;
@property(nonatomic,assign,readonly) SecKeyRef   privateKey;

@end


@implementation BMRSASignHelper

+ (instancetype)sharedHelper {
    
    static BMRSASignHelper *hlp = nil;
    static dispatch_once_t predicate;
    
    dispatch_once(&predicate, ^{
        hlp = [[self alloc] init];
        [hlp loadPrivateKey];
    });
    
    return hlp;
    
}

+ (NSString*) signMsg:(NSString*)msg{
    BMRSASignHelper *h = [BMRSASignHelper sharedHelper];
    
    NSData *data = [msg dataUsingEncoding:NSUTF8StringEncoding];
    NSString *sginedData = [h signData:data];

    return sginedData;
}

#pragma mark - 加载私钥
//加载sign-private.pem
- (void) loadPrivateKey{
    
    //path
    NSString * bundlePath = [[ NSBundle mainBundle] pathForResource: @ "KwlOpenSDKResource" ofType :@ "bundle"];
    NSBundle *resourceBundle = [NSBundle bundleWithPath:bundlePath];
    NSString *path = [resourceBundle pathForResource:@"sign-private" ofType:@"pem"];
    
    //private key
    NSError* error = nil;
    self.privateKeyPem = [NSString stringWithContentsOfFile:path encoding:NSUTF8StringEncoding error:&error];
    
    //
//    NSError* keyError = nil;
    
    NSData* keyData = [self dataTrimFromPrivatePem:self.privateKeyPem];
    SecKeyRef private = [self privateKeyFromData:keyData andTag:@"vkrsa.privatekey"];
    
    _privateKey = private;
    
}

- ( SecKeyRef)privateKeyFromData:(NSData*)data andTag:(NSString*)tag{
    NSData *tagData = [NSData dataWithBytes:[tag UTF8String] length:[tag length]];
    
    //删除KeyChainItem，必须指定两项 kSecAttrApplicationTag 和 kSecClass
    NSMutableDictionary* deleteDic = [NSMutableDictionary new];
    [deleteDic setObject:tagData forKey:(__bridge id)kSecAttrApplicationTag];
    [deleteDic setObject:(__bridge id) kSecClassKey forKey:(__bridge id)kSecClass];
    SecItemDelete((__bridge CFDictionaryRef)deleteDic);
    
    //添加KeyChainItem
    NSMutableDictionary *addDic = [[NSMutableDictionary alloc] init];
    //密钥数据
    [addDic setObject:data forKey:(__bridge id)kSecValueData];
    //key chain item tag
    [addDic setObject:tagData forKey:(__bridge id)kSecAttrApplicationTag];
    [addDic setObject:(__bridge id) kSecClassKey forKey:(__bridge id)kSecClass];
    //密钥种类为RSA密钥
    [addDic setObject:(__bridge id) kSecAttrKeyTypeRSA forKey:(__bridge id)kSecAttrKeyType];
    
    //密钥类型不需要指定，亲测，公钥和私钥都可以用
    //[addDic setObject:(__bridge id) kSecAttrKeyClassPublic forKey:(__bridge id) kSecAttrKeyClass];
    [addDic setObject:(__bridge id) kSecAttrKeyClassPrivate forKey:(__bridge id) kSecAttrKeyClass];
    
    [addDic setObject:[NSNumber numberWithBool:YES] forKey:(__bridge id)kSecReturnRef];
    
    
    SecKeyRef keyRef = nil;
    OSStatus status = SecItemAdd((__bridge CFDictionaryRef)addDic, (CFTypeRef *)&keyRef);
    if(status == errSecSuccess)
    {
        return keyRef;
    }else{
        return nil;
    }
}


- (NSData*) dataTrimFromPrivatePem:(NSString*)key{
    
    NSRange spos = [key rangeOfString:@"-----BEGIN PRIVATE KEY-----"];
    NSRange epos = [key rangeOfString:@"-----END PRIVATE KEY-----"];
    if(spos.location != NSNotFound && epos.location != NSNotFound){
        NSUInteger s = spos.location + spos.length;
        NSUInteger e = epos.location;
        NSRange range = NSMakeRange(s, e-s);
        key = [key substringWithRange:range];
    }
    key = [key stringByReplacingOccurrencesOfString:@"\r" withString:@""];
    key = [key stringByReplacingOccurrencesOfString:@"\n" withString:@""];
    key = [key stringByReplacingOccurrencesOfString:@"\t" withString:@""];
    key = [key stringByReplacingOccurrencesOfString:@" "  withString:@""];
    
    // This will be base64 encoded, decode it.
    NSData *data = [self base64_decode:key];
    data = [self stripPrivateKeyHeader:data];
    if(!data){
        return nil;
    }
    return data;
}

- (NSData *) base64_decode:(NSString*)str{
    //    它们将“+/”改为“_-”
    str = [str stringByReplacingOccurrencesOfString:@"-" withString:@"/"];
    str = [str stringByReplacingOccurrencesOfString:@"_" withString:@"+"];
    NSData *data = [[NSData alloc] initWithBase64EncodedString:str options:NSDataBase64DecodingIgnoreUnknownCharacters];
    return data;
}

- (NSData *)stripPrivateKeyHeader:(NSData *)d_key{
    // Skip ASN.1 private key header
    if (d_key == nil) return(nil);
    
    unsigned long len = [d_key length];
    if (!len) return(nil);
    
    unsigned char *c_key = (unsigned char *)[d_key bytes];
    unsigned int  idx	 = 22; //magic byte at offset 22
    
    if (0x04 != c_key[idx++]) return nil;
    
    //calculate length of the key
    unsigned int c_len = c_key[idx++];
    int det = c_len & 0x80;
    if (!det) {
        c_len = c_len & 0x7f;
    } else {
        int byteCount = c_len & 0x7f;
        if (byteCount + idx > len) {
            //rsa length field longer than buffer
            return nil;
        }
        unsigned int accum = 0;
        unsigned char *ptr = &c_key[idx];
        idx += byteCount;
        while (byteCount) {
            accum = (accum << 8) + *ptr;
            ptr++;
            byteCount--;
        }
        c_len = accum;
    }
    
    // Now make a new NSData from this buffer
    return [d_key subdataWithRange:NSMakeRange(idx, c_len)];
}


//sha256
- (NSString*) signData:(NSData*)data{

    // 消息摘要
    NSData *digest = nil;

    unsigned char md[CC_SHA256_DIGEST_LENGTH] = {0};
    CC_SHA256(data.bytes, (CC_LONG)data.length, md);
    digest = [NSData dataWithBytes:md length:CC_SHA256_DIGEST_LENGTH];
    
    const uint8_t *dataToSign = digest.bytes;
    size_t dataToSignLen = digest.length;
    
    size_t sigLen = SecKeyGetBlockSize(_privateKey);
    uint8_t *sig = malloc(sigLen * sizeof(uint8_t));
//    NSData *outData = nil;
    if (sig) {
        bzero(sig, sigLen);
//        memset(sig, 0x0, sigLen);
        // 对消息摘要进行签名
        OSStatus status = SecKeyRawSign(_privateKey, kSecPaddingPKCS1SHA256, dataToSign, dataToSignLen, sig, &sigLen);
        if (status == errSecSuccess) {
//            outData = [NSData dataWithBytes:(const void *)sig
//                                     length:sigLen];
            
            NSMutableString *hash = [NSMutableString string];
            for (int i = 0; i < sigLen; i++)
                [hash appendFormat:@"%02X", sig[i]];
            return [hash lowercaseString];
            
            
        }
        free(sig);
        sig = NULL;
    }
    
    return nil;
}

@end
