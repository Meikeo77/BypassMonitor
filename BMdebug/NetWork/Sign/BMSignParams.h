//
//  BMSignParams.h
//  BMtamps
//
//  Created by taohanjun on 2017/7/25.
//  Copyright © 2017年 xu. All rights reserved.
//

#import <Foundation/Foundation.h>


/**
 保存一些签名加解密和接口请求必须缓存的一些参数
 */
@interface BMSignParams : NSObject

+ (instancetype) sharedParams;

@property (atomic, assign) BOOL SqClean;   //数据库空

@property (atomic, assign) BOOL SendClean; //发送队列空

@property (nonatomic, strong) NSString *app_id;

/** 签入接口返回的入参，双方约定好的key，后续的协议文本用这个key加密 */
@property (nonatomic, strong) NSString *desKey;

/** 签入接口返回的COOKIE，后面每条协议都需要带着 */
@property (nonatomic, strong) NSString *COOKIE;

/** 签入接口返回的SIGN_KEY，后面每条协议的签名都需要用到 */
@property (nonatomic, strong) NSString *SIGN_KEY;

@end
