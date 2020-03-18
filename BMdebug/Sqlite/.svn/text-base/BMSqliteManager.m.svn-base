//
//  BMSqliteManager.m
//  BMdebug
//
//  Created by MiaoYe on 2019/1/8.
//  Copyright © 2019 Meikeo. All rights reserved.
//

#import "BMSqliteManager.h"
#import "BMNetworkManager.h"
#import "BMSignParams.h"
#import <sqlite3.h>
#import "BMSignUtil.h"


static sqlite3 *db = nil;
static NSString *sqlDesKey = @"aoieyru34n184uojdiocnabclakjnsjfAJFuwehfouhewhf2nj3brjqhfyquhefnqufhouphfqehfh";
@interface BMSqliteManager()
@property (nonatomic, assign) NSInteger readStart;      //当前开始读取的下标
@end

@implementation BMSqliteManager

+ (instancetype)sharedManager {
    static BMSqliteManager *sqliteManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sqliteManager = [[BMSqliteManager alloc]init];
        //设置数据库模式为串行模式 - 避免多线程冲突
        sqlite3_config(SQLITE_CONFIG_SERIALIZED);
        
        [sqliteManager createTable];
        sqliteManager.readStart = -1;
    });
    return sqliteManager;

}

//插入数据记录
- (BOOL)insertDataType:(BMReportType)reportType
                 token:(NSString *)token
               content:(NSString *)content
                APP_ID:(NSString *)app_id
              APP_NAME:(NSString *)app_name
           APP_VERSION:(NSString *)app_version
           SDK_VERSION:(NSString *)sdk_version
              KEY_HASH:(NSString *)key_hash{
    __block BOOL insResult = NO;
        //判断非法token
        NSNumber *tokenNum = [[BMNetworkManager sharedManager].tokenLegalDic objectForKey:token];
        if (tokenNum == nil || [tokenNum boolValue] == YES) {
            sqlite3 *newDB = [self openDB];
            sqlite3_stmt *statement = nil;
            //内容加密
            NSString *encryptContent = [BMSignUtil desEncryptWithKey:sqlDesKey for:content];
            NSString *sqlStr = [NSString stringWithFormat:@"INSERT INTO BYPASS_MONITOR(TYPE,TOKEN,CONTENT,APP_ID,APP_NAME,APP_VERSION,SDK_VERSION,KEY_HASH) VALUES('%d','%@','%@','%@','%@','%@','%@','%@');",reportType,token,encryptContent,app_id,app_name,app_version,sdk_version,key_hash];
            //检验合法性
            int result = sqlite3_prepare_v2(newDB, sqlStr.UTF8String, -1, &statement, NULL);
            if (result == SQLITE_OK) {
                //判断语句执行完毕
                if (sqlite3_step(statement) == SQLITE_DONE) {
                    NSLog(@"信息插入成功");
                    [[NSNotificationCenter defaultCenter]postNotificationName:BM_DEBUG_LOG object:nil userInfo:@{@"log":[NSString stringWithFormat:@"信息类型%d,内容%@入库成功",reportType,content]}];
                    insResult = YES;
                    [BMSignParams sharedParams].SqClean = NO;
                    
                }else {
                    insResult = NO;
                    NSLog(@"信息插入失败");
                    [[NSNotificationCenter defaultCenter]postNotificationName:BM_DEBUG_LOG object:nil userInfo:@{@"log":[NSString stringWithFormat:@"信息类型%d,内容%@入库失败",reportType,content]}];
                }
            }else {
                insResult = NO;
                NSLog(@"插入信息不合法");
                [[NSNotificationCenter defaultCenter]postNotificationName:BM_DEBUG_LOG object:nil userInfo:@{@"log":[NSString stringWithFormat:@"信息类型%d,内容%@入库失败",reportType,content]}];
            }
            
            sqlite3_finalize(statement);
            
            [[BMNetworkManager sharedManager] BM_checkAndReadSqliteForUp];
        }
     return insResult;
}

- (BOOL)justInsertDataType:(BMReportType)reportType
                 token:(NSString *)token
               content:(NSString *)content
                APP_ID:(NSString *)app_id
              APP_NAME:(NSString *)app_name
           APP_VERSION:(NSString *)app_version
           SDK_VERSION:(NSString *)sdk_version
              KEY_HASH:(NSString *)key_hash{
    
    __block BOOL insResult = NO;
    
    //判断非法token
    NSNumber *tokenNum = [[BMNetworkManager sharedManager].tokenLegalDic objectForKey:token];
    if (tokenNum == nil || [tokenNum boolValue] == YES) {
        sqlite3 *newDB = [self openDB];
        sqlite3_stmt *statement = nil;
        NSString *sqlStr = [NSString stringWithFormat:@"INSERT INTO BYPASS_MONITOR(TYPE,TOKEN,CONTENT,APP_ID,APP_NAME,APP_VERSION,SDK_VERSION,KEY_HASH) VALUES('%d','%@','%@','%@','%@','%@','%@','%@');",reportType,token,content,app_id,app_name,app_version,sdk_version,key_hash];
        //检验合法性
        int result = sqlite3_prepare_v2(newDB, sqlStr.UTF8String, -1, &statement, NULL);
        if (result == SQLITE_OK) {
            //判断语句执行完毕
            if (sqlite3_step(statement) == SQLITE_DONE) {
                NSLog(@"信息插入成功");
                [[NSNotificationCenter defaultCenter]postNotificationName:BM_DEBUG_LOG object:nil userInfo:@{@"log":[NSString stringWithFormat:@"信息类型%d,内容%@入库成功",reportType,content]}];
                insResult = YES;
                [BMSignParams sharedParams].SqClean = NO;
                
            }else {
                insResult = NO;
                NSLog(@"信息插入失败");
                [[NSNotificationCenter defaultCenter]postNotificationName:BM_DEBUG_LOG object:nil userInfo:@{@"log":[NSString stringWithFormat:@"信息类型%d,内容%@入库失败",reportType,content]}];
            }
        }else {
            insResult = NO;
            NSLog(@"插入信息不合法");
            [[NSNotificationCenter defaultCenter]postNotificationName:BM_DEBUG_LOG object:nil userInfo:@{@"log":[NSString stringWithFormat:@"信息类型%d,内容%@入库失败",reportType,content]}];
        }
        
        sqlite3_finalize(statement);
    }
    
    return insResult;
}


//删除数据记录
- (void)deleteDataByID:(NSInteger)ID {
    sqlite3 *newDB = [self openDB];
    sqlite3_stmt *statement = nil;
    NSString *sqlStr = [NSString stringWithFormat:@"DELETE FROM BYPASS_MONITOR WHERE ID = %ld;",(long)ID];
        int result = sqlite3_prepare_v2(newDB, sqlStr.UTF8String, -1, &statement, NULL);
        if (result == SQLITE_OK) {
            if (sqlite3_step(statement) == SQLITE_DONE) {
                NSLog(@"删除第%ld条数据",ID);
            }
        } else {
            NSLog(@"删除操作不合法");
        }
        sqlite3_finalize(statement);
//    [self closeDB];
}

- (void)deleteDataByToken:(NSString *)token {
    sqlite3 *newDB = [self openDB];
    sqlite3_stmt *statement = nil;
    NSString *sqlStr = [NSString stringWithFormat:@"DELETE FROM BYPASS_MONITOR WHERE TOKEN = '%@';",token];
    int result = sqlite3_prepare_v2(newDB, sqlStr.UTF8String, -1, &statement, NULL);
    if (result == SQLITE_OK) {
        if (sqlite3_step(statement) == SQLITE_DONE) {
            NSLog(@"删除token = %@的数据",token);
            [[NSNotificationCenter defaultCenter]postNotificationName:BM_DEBUG_LOG object:nil userInfo:@{@"log":[NSString stringWithFormat:@"删除本地token = %@的数据",token]}];
        }
    } else {
        NSLog(@"删除操作不合法");
    }
    sqlite3_finalize(statement);
}



//查询条件数据
- (NSMutableArray *)queryData{
    __block NSMutableArray *resultArr = [[NSMutableArray alloc]init];
    NSInteger limitNum = 20;
    sqlite3 *newDB = [self openDB];
    sqlite3_stmt *statement = nil;
    NSString *sqlStr = [NSString stringWithFormat:@"SELECT * FROM BYPASS_MONITOR WHERE ID > %ld LIMIT %ld;",(long)_readStart,(long)limitNum];
        int result = sqlite3_prepare_v2(newDB, sqlStr.UTF8String, -1, &statement, NULL);
        if (result == SQLITE_OK) {
            //遍历查询结果
            while (sqlite3_step(statement) == SQLITE_ROW) {
                int ID = sqlite3_column_int(statement, 0);
                int TYPE = sqlite3_column_int(statement, 1);
                const unsigned char *CONTENT = sqlite3_column_text(statement, 2);
                const unsigned char *TOKEN = sqlite3_column_text(statement, 3);
                const unsigned char *APP_ID = sqlite3_column_text(statement, 4);
                const unsigned char *APP_NAME = sqlite3_column_text(statement, 5);
                const unsigned char *APP_VERSION = sqlite3_column_text(statement, 6);
                const unsigned char *SDK_VERSION = sqlite3_column_text(statement, 7);
                const unsigned char *KEY_HASH = sqlite3_column_text(statement, 8);
                
                //内容解密
                NSString *decryptContent = [BMSignUtil desDecryptWithKey:sqlDesKey for:[NSString stringWithUTF8String:(const char *)CONTENT]];
                
                BMSqliteInfoModel *model = [[BMSqliteInfoModel alloc]init];
                model.index = ID;
                model.reportType = TYPE;
                model.token = [NSString stringWithUTF8String:(const char *)TOKEN];
                model.content = decryptContent;
                model.APP_ID = [NSString stringWithUTF8String:(const char *)APP_ID];
                model.APP_NAME = [NSString stringWithUTF8String:(const char *)APP_NAME];
                model.APP_VERSION = [NSString stringWithUTF8String:(const char *)APP_VERSION];
                model.SDK_VERISON = [NSString stringWithUTF8String:(const char *)SDK_VERSION];
                model.KEY_HASH = [NSString stringWithUTF8String:(const char *)KEY_HASH];
                
                [resultArr addObject:model];
            }
        } else {
            NSLog(@"查询语句不合法");
        }
        sqlite3_finalize(statement);
        
        NSLog(@"当前查询到%ld条数据",resultArr.count);
    [[NSNotificationCenter defaultCenter]postNotificationName:BM_DEBUG_LOG object:nil userInfo:@{@"log":[NSString stringWithFormat:@"当前本地查询到%lu条数据",(unsigned long)resultArr.count]}];
        
        if (resultArr.count > 0) {
            [BMSignParams sharedParams].SendClean = NO;
            BMSqliteInfoModel *lastModel = resultArr.lastObject;
            _readStart = lastModel.index;
        }
        
        if (resultArr.count < limitNum) {
            [BMSignParams sharedParams].SqClean = YES;
            _readStart = -1;
        }
    return resultArr;
}


//打开或创建数据库
- (sqlite3 *)openDB {
    if (!db) {
        //获取数据库路径
        NSString *documentPath = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)[0];
        NSString *dbPath = [documentPath stringByAppendingPathComponent:BM_SQLIT_NAME];
//                NSLog(@"数据库路径 = %@",dbPath);
        int result = sqlite3_open([dbPath UTF8String], &db);
//        int thread = sqlite3_threadsafe();
        if (result == SQLITE_OK) {
            //            NSLog(@"数据库打开成功");
        }else {
            [self closeDB];
            NSLog(@"数据库打开失败");
        }
    }
    
    return db;
}

//关闭数据库
- (void)closeDB {
    if (db) {
        int result = sqlite3_close(db);
        if (result == SQLITE_OK) {
            db = nil;
            NSLog(@"数据库关闭成功");
        }else {
            NSLog(@"数据库关闭失败");
        }
    }
}

//创建表
- (void)createTable {
    sqlite3 *newDB = [self openDB];
    NSString *sqlStr = BM_SQ_CREATE_TABLE;
    char *error = NULL;
    int result = sqlite3_exec(newDB, sqlStr.UTF8String, NULL, NULL, &error);
    if (result == SQLITE_OK) {
        //        NSLog(@"创建表成功");
    }else {
        NSLog(@"创建表失败 = %s",error);
    }
    [self closeDB];
}

//删除表
- (void)dropTable {
    sqlite3 *newDB = [self openDB];
    NSString *sqlStr = BM_SQ_DROP_TABLE;
    char *error = NULL;
    int result = sqlite3_exec(newDB, sqlStr.UTF8String, NULL, NULL, &error);
    if (result == SQLITE_OK) {
        //        NSLog(@"删除表成功");
    }else {
        NSLog(@"删除表失败 = %s",error);
    }
    [self closeDB];
}


@end
