//
//  BMNetworkManager.m
//  BypassMonitor
//
//  Created by MiaoYe on 2019/1/7.
//  Copyright © 2019 Meikeo. All rights reserved.
//

#import "BMNetworkManager.h"
#import "BMSignParams.h"
#import "BMRsaHelper.h"
#import "BMSignUtil.h"
#import "BypassMonitor.h"
#import "BMSqliteManager.h"
#import "BMKeychainTool.h"


static dispatch_once_t onceDevice;

@interface BMNetworkManager ()
@property (nonatomic, strong) NSMutableArray *sendList;
@property (nonatomic, strong) NSOperationQueue *queueSend;
@property (nonatomic, strong) NSString *currenToken;
@end

@implementation BMNetworkManager

+ (instancetype)sharedManager {
    static BMNetworkManager *sharedManger = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedManger = [[self alloc]init];
        sharedManger.queueSend = [[NSOperationQueue alloc]init];
        sharedManger.queueSend.maxConcurrentOperationCount = 1;
        [sharedManger.queueSend addObserver:sharedManger forKeyPath:@"operations" options:0 context:NULL];
        sharedManger.signNetDic = [[NSMutableDictionary alloc]init];
        sharedManger.tokenLegalDic = [[NSMutableDictionary alloc]init];
    });
    return sharedManger;
}

- (BMNetworkDataItem *)netWorkWithCodeSync:(NSString *)netCode parameters:(id)params success:(BMNetSuccessBlock) successBlock fail:(BMNetFailureBlock) failureBlock{
    
    BMNetworkDataItem *netItem = [[BMNetworkDataItem alloc] init];
    [netItem networkWithCodeSync:netCode parameters:params success:successBlock failure:failureBlock];
    return netItem;
}

#pragma mark - 查取传 入口
- (void)BM_checkAndReadSqliteForUp {
    if(![BMSignParams sharedParams].SqClean && [BMSignParams sharedParams].SendClean) {
        _sendList = [[BMSqliteManager sharedManager] queryData];
        if (_sendList.count > 0) {
            for (int i = 0; i < _sendList.count;i++) {
                BMSqliteInfoModel *model = _sendList[i];
                NSInvocationOperation *opSend = [[NSInvocationOperation alloc]initWithTarget:self selector:@selector(BM_uploadInfoModel:) object:model];

                [self.queueSend addOperation:opSend];
            }
        }else {
            [[BMSqliteManager sharedManager] closeDB];
            dispatch_once(&onceDevice, ^{
                dispatch_async(dispatch_get_global_queue(0, 0), ^{
                    [self commitDeviceInfo];
                });
            });
        }
        
    }else if ([BMSignParams sharedParams].SqClean && [BMSignParams sharedParams].SendClean) {
        [[BMSqliteManager sharedManager] closeDB];
        dispatch_once(&onceDevice, ^{
            dispatch_async(dispatch_get_global_queue(0, 0), ^{
                [self commitDeviceInfo];
            });
        });
    }
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context {
    if (object == _queueSend && [keyPath isEqualToString:@"operations"]) {
        if (_queueSend.operations.count == 0) {
            NSLog(@"上传完毕,开始读");
            [BMSignParams sharedParams].SendClean = YES;
            [self BM_checkAndReadSqliteForUp];
        }
    }
}

- (void)commitDeviceInfo {
    NSString *token = @"CqGUebc53i9zJc8U7Zd";
    [BMSignParams sharedParams].desKey = BM_INIT_DESKEY;
    [[BMNetworkManager sharedManager] BM_SystemSignInWithToken:token
                                                      KEY_HASH:@""
                                                        APP_ID:@""
                                                        result:^(BOOL result) {
           if (result) {
            //上传设备信息
            BMDeviceReportReq *req = [[BMDeviceReportReq alloc]init];
            req.TOKEN = token;
            req.DEVICE_TYPE = @"ios";
            req.APP_VERSION = @"1.0";
            req.APP_NAME = @"旁路监测demo";
            req.APP_ID = @"";
            req.SDK_VERISON = @"";
            BMSignNetModel *signModel = [[BMNetworkManager sharedManager].signNetDic objectForKey:token];
            [BMSignParams sharedParams].desKey = signModel.DES_KEY;
            [BMSignParams sharedParams].SIGN_KEY = signModel.SIGN_KEY;
            [BMSignParams sharedParams].COOKIE = signModel.COOKIE;
            
            [[BMNetworkManager sharedManager] netWorkWithCodeSync:BM_NetCode_DeviceReport parameters:req success:^(id  _Nonnull returnData) {
                NSLog(@"****设备信息上传成功****");
                [[NSNotificationCenter defaultCenter]postNotificationName:BM_DEBUG_LOG object:nil userInfo:@{@"log":[NSString stringWithFormat:@"##设备信息上报成功"]}];
            } fail:^(NSError * _Nonnull error) {
                NSLog(@"****设备信息上传失败****");
                [[NSNotificationCenter defaultCenter]postNotificationName:BM_DEBUG_LOG object:nil userInfo:@{@"log":[NSString stringWithFormat:@"##设备信息上报失败"]}];
            }];
        }
    }];
}

#pragma mark - 上报数据接口
- (void)BM_uploadInfoModel:(BMSqliteInfoModel *)infoModel {
   
    //判断签入
    BMSignNetModel *signModel = [_signNetDic objectForKey:infoModel.token];
    if (signModel == nil) {
        //签入
        [BMSignParams sharedParams].desKey = BM_INIT_DESKEY;
        [self BM_SystemSignInWithToken:infoModel.token
                              KEY_HASH:infoModel.KEY_HASH
                                APP_ID:infoModel.APP_ID
                                result:^(BOOL result) {
            if (result) {
                //重新上传
                [self BM_uploadInfoModel:infoModel];
            }
        }];
    }else {
        [BMSignParams sharedParams].desKey = signModel.DES_KEY;
        [BMSignParams sharedParams].SIGN_KEY = signModel.SIGN_KEY;
        [BMSignParams sharedParams].COOKIE = signModel.COOKIE;
        
        //上传记录
        NSString *netUrl;
        id reportReq = nil;
        
        switch (infoModel.reportType) {
            case BMReportType_Channel:
            {
                BMBusinessReportReq *req = [[BMBusinessReportReq alloc]init];
                req.BUSINESS_TYPE = [infoModel.content intValue];
                req.TOKEN = infoModel.token;
                req.APP_VERSION = infoModel.APP_VERSION;
                req.SDK_VERISON = infoModel.SDK_VERISON;
                req.APP_NAME = infoModel.APP_NAME;
                req.APP_ID = infoModel.APP_ID;
                netUrl = BM_NetCode_ChannelReport;
                reportReq = req;
            }
                break;
            case BMReportType_Popup:
            {
                NSArray *popArr = [infoModel.content componentsSeparatedByString:@","];
                BMPopupReportReq *req = [[BMPopupReportReq alloc]init];
                req.POPUP_TEXT = popArr.lastObject;
                req.ACTION = [popArr.firstObject intValue];
                req.TOKEN = infoModel.token;
                req.APP_VERSION = infoModel.APP_VERSION;
                req.SDK_VERISON = infoModel.SDK_VERISON;
                req.APP_NAME = infoModel.APP_NAME;
                req.APP_ID = infoModel.APP_ID;
                netUrl = BM_NetCode_PopupReport;
                reportReq = req;
            }
                break;
            case BMReportType_Url:
            {
                BMUrlReportReq *req = [[BMUrlReportReq alloc]init];
                req.URL = infoModel.content;
                req.TOKEN = infoModel.token;
                req.APP_VERSION = infoModel.APP_VERSION;
                req.SDK_VERISON = infoModel.SDK_VERISON;
                req.APP_NAME = infoModel.APP_NAME;
                req.APP_ID = infoModel.APP_ID;
                netUrl = BM_NetCode_UrlReport;
                reportReq = req;
            }
                
                break;
            default:
                break;
        }
        
        __weak typeof(self) weakSelf = self;
        _currentNetItem = [[BMNetworkManager sharedManager] netWorkWithCodeSync:netUrl parameters:reportReq success:^(id  _Nonnull returnData) {
            //设置token合法
            [weakSelf.tokenLegalDic setObject:[NSNumber numberWithBool:YES] forKey:infoModel.token];
            
            //上传成功 删除上传对象 删除数据库记录
            [weakSelf.sendList removeObject:infoModel];
            [[BMSqliteManager sharedManager] deleteDataByID:infoModel.index];
            
            [[NSNotificationCenter defaultCenter]postNotificationName:BM_DEBUG_LOG object:nil userInfo:@{@"log":[NSString stringWithFormat:@"数据上报成功content:%@",infoModel.content]}];
            
        } fail:^(NSError * _Nonnull error) {
            //上传失败，删除上传对象
            [weakSelf.sendList removeObject:infoModel];
            //特殊错误处理
            [self BM_errorConditionManagerModel:reportReq Fail:error];
            NSLog(@"数据上报失败code：%ld msg:%@",error.code,error.localizedDescription);
            [[NSNotificationCenter defaultCenter]postNotificationName:BM_DEBUG_LOG object:nil userInfo:@{@"log":[NSString stringWithFormat:@"数据上报失败code：%ld ,msg:%@, content:%@",error.code,error.localizedDescription,infoModel.content]}];
        }];
    }
}

#pragma mark - 上传数据返回错误处理
- (void)BM_errorConditionManagerModel:(BMSqliteInfoModel *)infoModel Fail:(NSError *)error {
    NSInteger errCode = error.code;
    switch (errCode) {
        case -900000:
        case -900008:
        {
            //解密失败、安全认证失败 需 停止上传
            [self cancelNetWork];
        }
            break;
        case -900006:
        {
            //token 因原因被禁 需 删除数据，并禁止写入
            [self deleteSendListByToken:infoModel.token];
            //删除数据库相同token 数据
            [[BMSqliteManager sharedManager]deleteDataByToken:infoModel.token];
            [_tokenLegalDic setObject:[NSNumber numberWithBool:NO] forKey:infoModel.token];
        }
            break;
        case -900007:
        case -900009:
        {
            //cookie失效、验签失败 需 重新签入
            [self BM_SystemSignInWithToken:infoModel.token
                                  KEY_HASH:infoModel.KEY_HASH
                                    APP_ID:infoModel.APP_ID
                                    result:^(BOOL result) {
                if (result == YES) {
                    [self BM_checkAndReadSqliteForUp];
                }
            }];
        }
            break;
            
        case -900010:
        case -900011:
        case -900013:
        {
            //非法操作、token错误、签入失败 需 删除对应token数据
            [[BMSqliteManager sharedManager] deleteDataByToken:infoModel.token];
        }
            break;
        case -900012:
        {
            //公钥错误 - 重新请求公钥
            [self BM_getPublicKeyWithResult:^(BOOL result) {
                if (result) {
                    [self BM_SystemSignInWithToken:infoModel.token
                                          KEY_HASH:infoModel.KEY_HASH
                                            APP_ID:infoModel.APP_ID
                                            result:^(BOOL result) {
                        
                    }];
                }
            }];
        }
            break;
            
        default:
            
            break;
    }
}

- (void)deleteSendListByToken:(NSString *)token {
    for (int i = 0 ; i < _sendList.count; i ++) {
        BMSqliteInfoModel *model = _sendList[i];
        if ([model.token isEqualToString:token]) {
            [_sendList removeObject:model];
        }
    }
}

/**
 取消上传请求，清空上传队列
 */
- (void)cancelNetWork {
    [_currentNetItem.netTask cancel];
    [_queueSend cancelAllOperations];
    [_sendList removeAllObjects];
    [BMSignParams sharedParams].SendClean = YES;
}

#pragma mark - 私有方法
/**
 请求公钥
 */
- (void)BM_getPublicKeyWithResult:(BMSignResultBlock)result {
    [BMSignParams sharedParams].desKey = BM_INIT_DESKEY;
    //请求公钥
    BMSignKeyReq *req = [[BMSignKeyReq alloc] init];
    
    NSLog(@"请求公钥 begin");
    [[BMNetworkManager sharedManager] netWorkWithCodeSync:BM_NetCode_GetPublicKey parameters:req success:^(id returnData) {
        NSLog(@"请求公钥成功");
        [[NSNotificationCenter defaultCenter]postNotificationName:BM_DEBUG_LOG object:nil userInfo:@{@"log":[NSString stringWithFormat:@"请求公钥成功"]}];
        BMSignKeyRsp *rsp = (BMSignKeyRsp *)returnData;
        //保存公钥到keychain
        [BMKeychainTool publicKeySave:rsp.PUBLICE_KEY];
        result(YES);
    
    } fail:^(NSError *error) {
        NSLog(@"请求公钥失败 error:%@", error.localizedDescription);
        [[NSNotificationCenter defaultCenter]postNotificationName:BM_DEBUG_LOG object:nil userInfo:@{@"log":[NSString stringWithFormat:@"请求公钥失败 error:%@", error.localizedDescription]}];
        result(NO);
    }];
}

/**
 系统签入
 */
- (void)BM_SystemSignInWithToken:(NSString *)token
                        KEY_HASH:(NSString *)key_hash
                          APP_ID:(NSString *)app_id
                          result:(BMSignResultBlock)result {
    //请求系统签入
    __weak typeof(self) weakSelf = self;
    BMSystemSignInReq *signReq = [[BMSystemSignInReq alloc]init];
    NSString *desKey =  [NSString stringWithFormat:@"%0u",arc4random()%100000000];
    signReq.DES_KEY = [BMRsaHelper BMEncryptString:desKey];
    signReq.TOKEN = token;
    signReq.KEY_HASH = key_hash;
    signReq.APP_ID = app_id;
    
    NSLog(@"token = %@ 签入begin",token);
    [self netWorkWithCodeSync:BM_NetCode_SysSignIn parameters:signReq success:^(id  _Nonnull returnData) {
        
        BMSystemSignInRsp *signRsp = (BMSystemSignInRsp *)returnData;
        
        //记录签入记录
        BMSignNetModel *signModel = [[BMSignNetModel alloc]init];
        signModel.DES_KEY = [BMSignUtil desDecryptWithKey:desKey for:signRsp.DES_KEY];
        signModel.SIGN_KEY = [BMSignUtil desDecryptWithKey:desKey for:signRsp.SIGN_KEY];
        signModel.COOKIE = signRsp.COOKIE;
        [weakSelf.signNetDic setObject:signModel forKey:token];
        
        //记录签入合法token
        [weakSelf.tokenLegalDic setObject:[NSNumber numberWithBool:YES] forKey:token];
        NSLog(@"token = %@ ** 签入成功",token);
        [[NSNotificationCenter defaultCenter]postNotificationName:BM_DEBUG_LOG object:nil userInfo:@{@"log":[NSString stringWithFormat:@"token = %@ ** 签入成功",token]}];
        
        result(YES);
        
    } fail:^(NSError * _Nonnull error) {
        NSLog(@"token = %@ ** 签入失败 error:%@",token, error.localizedDescription);
        [[NSNotificationCenter defaultCenter]postNotificationName:BM_DEBUG_LOG object:nil userInfo:@{@"log":[NSString stringWithFormat:@"token = %@ ** 签入失败 error:%@",token, error.localizedDescription]}];
        
        BMSqliteInfoModel *req = [[BMSqliteInfoModel alloc]init];
        req.token = token;
        [self BM_errorConditionManagerModel:req Fail:error];
        result(NO);
    }];
}

@end
