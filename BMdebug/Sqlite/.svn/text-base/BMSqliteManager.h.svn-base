//
//  BMSqliteManager.h
//  BMdebug
//
//  Created by MiaoYe on 2019/1/8.
//  Copyright © 2019 Meikeo. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface BMSqliteManager : NSObject

+ (instancetype)sharedManager;

- (BOOL)insertDataType:(BMReportType)reportType
                 token:(NSString *)token
               content:(NSString *)content
                APP_ID:(NSString *)app_id
              APP_NAME:(NSString *)app_name
           APP_VERSION:(NSString *)app_version
           SDK_VERSION:(NSString *)sdk_version
              KEY_HASH:(NSString *)key_hash;

- (BOOL)justInsertDataType:(BMReportType)reportType
                     token:(NSString *)token
                   content:(NSString *)content
                    APP_ID:(NSString *)app_id
                  APP_NAME:(NSString *)app_name
               APP_VERSION:(NSString *)app_version
               SDK_VERSION:(NSString *)sdk_version
                  KEY_HASH:(NSString *)key_hash;

//查询条件数据
- (NSMutableArray *)queryData;

- (void)deleteDataByID:(NSInteger)ID;

- (void)deleteDataByToken:(NSString *)token;

- (void)closeDB;

@end

NS_ASSUME_NONNULL_END
