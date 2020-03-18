//
//  BMBaseModel.m
//  BypassMonitor
//
//  Created by MiaoYe on 2019/1/7.
//  Copyright © 2019 Meikeo. All rights reserved.
//

#import "BMBaseModel.h"
#import "BMKeychainTool.h"
#import "BMSignParams.h"

@implementation BMBaseModel
@end

@implementation BMSignKeyReq
@end

@implementation BMSignKeyRsp
@end

@implementation BMSystemSignInReq
- (id)init {
    self = [super init];
    if (self) {
//        _APP_ID = [BMSignParams sharedParams].app_id; //[BMKeychainTool getDeviceIDInKeychain];
        _DEVICE_TYPE = @"ios";
    }
    return self;
}
@end

@implementation BMSystemSignInRsp
@end

@implementation BMSqliteInfoModel
@end

@implementation BMReportReq
- (id)init {
    self = [super init];
    if (self) {
//        _APP_NAME = [BMCommonTool getAppName];
//        _APP_VERSION = [BMCommonTool getBundleVersion];
//        _APP_ID = [BMKeychainTool getDeviceIDInKeychain];;
//        _SDK_VERISON = @"1.0";
    }
    return self;
}
@end

@implementation BMReportRsp
@end

@implementation BMSignNetModel
@end

@implementation BMDeviceReportReq
@end

@implementation BMBusinessReportReq
@end

@implementation BMPopupReportReq
@end

@implementation BMUrlReportReq
@end

@implementation BMChannelModel
- (id)init {
    self = [super init];
    if (self) {
        _TOKEN = @"";
        _APP_ID = @"";
        _APP_NAME = @"";
        _APP_VERSION = @"";
        _SDK_VERSION = @"";
        _KEY_HASH = @"";
    }
    return self;
}
@end
