//
//  BMNetworkManager.h
//  BypassMonitor
//
//  Created by MiaoYe on 2019/1/7.
//  Copyright © 2019 Meikeo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BMEnumConstant.h"
#import "BMNetworkDataItem.h"

typedef void(^BMSignResultBlock)(BOOL result);

@interface BMNetworkManager : NSObject

//网络状态
@property (nonatomic, assign) BMNetworkState netStatus;

@property (nonatomic, strong) BMNetworkDataItem *currentNetItem;

@property (nonatomic, assign) NSInteger requestCount;

@property (nonatomic, strong) NSMutableDictionary *signNetDic;

//非法token字典
@property (nonatomic, strong) NSMutableDictionary *tokenLegalDic;

+ (instancetype)sharedManager;

/**
 同步网络连接
 */
- (BMNetworkDataItem *)netWorkWithCodeSync:(NSString *)netCode parameters:(id)params success:(BMNetSuccessBlock) successBlock fail:(BMNetFailureBlock) failureBlock;

/**
 查取传 入口
 */
- (void)BM_checkAndReadSqliteForUp;

/**
 获取公钥
 */
- (void)BM_getPublicKeyWithResult:(BMSignResultBlock)result;

/**
 系统签入
 */
- (void)BM_SystemSignInWithToken:(NSString *)token
                        KEY_HASH:(NSString *)key_hash
                          APP_ID:(NSString *)app_id
                          result:(BMSignResultBlock)result;

/**
 数据上报接口
 */
- (void)BM_uploadInfoModel:(BMSqliteInfoModel *)infoModel;

@end

