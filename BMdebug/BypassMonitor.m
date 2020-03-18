//
//  BypassMonitor.m
//  BypassMonitor
//
//  Created by MiaoYe on 2019/1/7.
//  Copyright © 2019 Meikeo. All rights reserved.
//

#import "BypassMonitor.h"
#import "BMNetworkManager.h"
#import "BMSignParams.h"
#import "BMRsaHelper.h"
#import "BMSignUtil.h"
#import "BMKeychainTool.h"
#import "BMSqliteManager.h"
@interface BypassMonitor ()
@property (nonatomic, strong) NSString *currentToken;
@end

@implementation BypassMonitor

+ (id)getInstanceWithToken:(NSString *)token {
    static BypassMonitor *bypassMonitor = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        bypassMonitor = [[BypassMonitor alloc]init];
    });
    bypassMonitor.currentToken = token;
    return bypassMonitor;
}

+ (void)initBM_Interface {
    
    //获取公钥
    if (![BMKeychainTool getPublicKeyRef]) {
        [[BMNetworkManager sharedManager] BM_getPublicKeyWithResult:^(BOOL result) {
            if (result) {
                NSLog(@"获取公钥成功");
            }
        }];
    };
    
    [[BMNetworkManager sharedManager] BM_checkAndReadSqliteForUp];

}

//提交业务
- (BOOL)commitBusinessByType:(BMBusinessType)businessType
                      APP_ID:(NSString *)app_id
                    APP_NAME:(NSString *)app_name
                 APP_VERSION:(NSString *)app_version
                 SDK_VERSION:(NSString *)sdk_version
                    KEY_HASH:(NSString *)key_hash{
    
    return [[BMSqliteManager sharedManager] insertDataType:BMReportType_Channel
                                                     token:_currentToken
                                                   content:[NSString stringWithFormat:@"%ld",businessType]
                                                    APP_ID:app_id
                                                  APP_NAME:app_name
                                               APP_VERSION:app_version
                                               SDK_VERSION:sdk_version
                                                  KEY_HASH:key_hash];
}

//提交链接
- (BOOL)commitUrl:(NSString *)url
           APP_ID:(NSString *)app_id
         APP_NAME:(NSString *)app_name
      APP_VERSION:(NSString *)app_version
      SDK_VERSION:(NSString *)sdk_version
         KEY_HASH:(NSString *)key_hash {
    
    return [[BMSqliteManager sharedManager] insertDataType:BMReportType_Url
                                                     token:_currentToken
                                                   content:url
                                                    APP_ID:app_id
                                                  APP_NAME:app_name
                                               APP_VERSION:app_version
                                               SDK_VERSION:sdk_version
                                                  KEY_HASH:key_hash];
}
//提交弹窗信息
- (BOOL)commitPopupContent:(NSString *)content
                actionType:(BMActionType)actionType
                    APP_ID:(NSString *)app_id
                  APP_NAME:(NSString *)app_name
               APP_VERSION:(NSString *)app_version
               SDK_VERSION:(NSString *)sdk_version
                  KEY_HASH:(NSString *)key_hash{
    return [[BMSqliteManager sharedManager] insertDataType:BMReportType_Popup
                                                     token:_currentToken
                                                   content:[NSString stringWithFormat:@"%ld,%@",actionType,content]
                                                    APP_ID:app_id
                                                  APP_NAME:app_name
                                               APP_VERSION:app_version
                                               SDK_VERSION:sdk_version
                                                  KEY_HASH:key_hash];
}

@end
