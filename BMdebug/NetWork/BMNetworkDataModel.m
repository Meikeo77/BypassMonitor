//
//  BMNetworkDataModel.m
//  BypassMonitor
//
//  Created by MiaoYe on 2019/1/7.
//  Copyright © 2019 Meikeo. All rights reserved.
//

#import "BMNetworkDataModel.h"

@implementation BMNetworkDataModel

@end

@implementation BMNetworkReq

- (id)initWithCoder:(NSCoder *)decoder {
    self = [super init];
    if (self) {
        [self mj_decode:decoder];
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)encoder {
    [self mj_encode:encoder];
}

- (id) init {
    self = [super init];
    if (self) {
        
    }
    return self;
}

@end

@implementation BMNetworkRsp
- (id)initWithCoder:(NSCoder *)decoder {
    self = [super init];
    if (self) {
        [self mj_decode:decoder];
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)encoder {
    [self mj_encode:encoder];
}

/**
 *  解析响应参数类 为 dictionary
 *
 *  @param param 参数
 */
- (id) networkResponseParamDictionary:(id)param{
    
    NSArray *arr = param;
    if (arr.count == 0) {
        return nil;
    }
    id item = [arr firstObject];
    if (![item isKindOfClass:[NSDictionary class]]) {
        return nil;
    }
    
    id itemData = [[self class]  mj_objectWithKeyValues:item];
    return itemData;
    
}


@end

#pragma mark - 请求头
/**
 *  请求头的包含体
 */
@implementation REQ_MSG_HDR
@end


/**
 *  返回数据的头部内容
 */
@implementation ANS_MSG_HDR
@end

