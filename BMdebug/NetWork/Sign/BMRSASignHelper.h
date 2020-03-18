//
//  BMRSASignHelper.h
//  KwlVideoSDKDemo
//
//  Created by taohanjun on 2017/7/6.
//  Copyright © 2017年 taohanjun. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BMRSASignHelper : NSObject

/**sha256，私钥签名*/
+ (NSString*) signMsg:(NSString*)msg;

@end
