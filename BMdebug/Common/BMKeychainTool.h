//
//  BMKeychainTool.h
//  BMdebug
//
//  Created by MiaoYe on 2019/1/11.
//  Copyright © 2019 Meikeo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Security/Security.h>


@interface BMKeychainTool : NSObject
/** 获取设备唯一标识码*/
+ (NSString *)getDeviceIDInKeychain;

/** 存储公钥*/
+ (BOOL)publicKeySave:(NSString *)publicString;

/** 获取rsa加密所需的公钥seckeyref对象*/
+ (SecKeyRef)getPublicKeyRef;
@end

