//
//  BypassMonitor.h
//  BypassMonitor
//
//  Created by MiaoYe on 2019/1/7.
//  Copyright © 2019 Meikeo. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface BypassMonitor : NSObject

//获取单例
+ (id)getInstanceWithToken:(NSString *)token;

//初始化
+ (void)initBM_Interface;

//提交业务
- (BOOL)commitBusinessByType:(BMBusinessType)businessType
                      APP_ID:(NSString *)app_id
                    APP_NAME:(NSString *)app_name
                 APP_VERSION:(NSString *)app_version
                 SDK_VERSION:(NSString *)sdk_version
                    KEY_HASH:(NSString *)key_hash;

//提交链接
- (BOOL)commitUrl:(NSString *)url
           APP_ID:(NSString *)app_id
         APP_NAME:(NSString *)app_name
      APP_VERSION:(NSString *)app_version
      SDK_VERSION:(NSString *)sdk_version
         KEY_HASH:(NSString *)key_hash;

//提交弹窗信息
- (BOOL)commitPopupContent:(NSString *)content
                actionType:(BMActionType)actionType
                    APP_ID:(NSString *)app_id
                  APP_NAME:(NSString *)app_name
               APP_VERSION:(NSString *)app_version
               SDK_VERSION:(NSString *)sdk_version
                  KEY_HASH:(NSString *)key_hash;





@end

NS_ASSUME_NONNULL_END
