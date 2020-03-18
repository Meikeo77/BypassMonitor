//
//  BMBaseModel.h
//  BypassMonitor
//
//  Created by MiaoYe on 2019/1/7.
//  Copyright © 2019 Meikeo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BMNetworkDataModel.h"


@interface BMBaseModel : NSObject
@end

#pragma mark - 请求公钥
@interface BMSignKeyReq : BMNetworkReq
@end

@interface BMSignKeyRsp : BMNetworkRsp
@property (nonatomic, strong) NSString *PUBLICE_KEY;       //公钥
@end

#pragma mark - 中台签入
@interface BMSystemSignInReq : BMNetworkReq
@property (nonatomic, strong) NSString *APP_ID;         //设备ID
@property (nonatomic, strong) NSString *DEVICE_TYPE;    //设备类型
@property (nonatomic, strong) NSString *DES_KEY;        //DES密钥, 该字段RSA加密
@property (nonatomic, strong) NSString *TOKEN;          //券商在申报业务时系统分配的一串标识码
@property (nonatomic, strong) NSString *KEY_HASH;       //boundid
@end

@interface BMSystemSignInRsp : BMNetworkRsp
@property (nonatomic, assign) NSInteger EFFECTIVE_TIME; //签入的有效期
@property (nonatomic, strong) NSString *COOKIE;       //cookie
@property (nonatomic, strong) NSString *SIGN_KEY;     //加密因子, 该字段RSA加密
@property (nonatomic, strong) NSString *DES_KEY;      //deskey
@end

#pragma mark - 数据上报模块
@interface BMReportReq : BMNetworkReq
@property (nonatomic, strong) NSString *TOKEN;               //渠道token
@property (nonatomic, strong) NSString *APP_NAME;            //APP名称
@property (nonatomic, strong) NSString *APP_ID;              //APP_id
@property (nonatomic, strong) NSString *SDK_VERISON;         //SDK版本号
@property (nonatomic, strong) NSString *APP_VERSION;         //APP版本号

@end

@interface BMReportRsp : BMNetworkRsp
@property (nonatomic, strong) NSString *MSG_CODE;
@property (nonatomic, strong) NSString *MSG_TEXT;
@property (nonatomic, strong) NSString *MSG_LEVEL;
@end

@interface BMDeviceReportReq : BMReportReq
@property (nonatomic, strong) NSString *DEVICE_TYPE;         //设备类型
@end

@interface BMBusinessReportReq : BMReportReq
@property (nonatomic, assign) BMBusinessType BUSINESS_TYPE;  //业务名称
@end

@interface BMPopupReportReq : BMReportReq
@property (nonatomic, strong) NSString *POPUP_TEXT;          //弹窗信息上报
@property (nonatomic, assign) BMActionType ACTION;         //客户操作动作@end
@end

@interface BMUrlReportReq : BMReportReq
@property (nonatomic, strong) NSString *URL;          //弹窗信息上报
@end



#pragma makr - 数据库数据模型
@interface BMSqliteInfoModel : NSObject
@property (nonatomic, assign) NSInteger index;
@property (nonatomic, assign) BMReportType reportType;
@property (nonatomic, strong) NSString *content;
@property (nonatomic, strong) NSString *token;

@property (nonatomic, strong) NSString *APP_NAME;            //APP名称
@property (nonatomic, strong) NSString *APP_ID;              //APP_id
@property (nonatomic, strong) NSString *SDK_VERISON;         //SDK版本号
@property (nonatomic, strong) NSString *APP_VERSION;         //APP版本号
@property (nonatomic, strong) NSString *KEY_HASH;            
@end

@interface BMSignNetModel : NSObject
@property (nonatomic, strong) NSString *TOKEN;
@property (nonatomic, strong) NSString *COOKIE;       //cookie
@property (nonatomic, strong) NSString *SIGN_KEY;     //加密因子, 该字段RSA加密
@property (nonatomic, strong) NSString *DES_KEY;      //deskey

@end


@interface BMChannelModel : NSObject
@property (nonatomic, strong) NSString *TOKEN;
@property (nonatomic, strong) NSString *APP_ID;
@property (nonatomic, strong) NSString *APP_VERSION;
@property (nonatomic, strong) NSString *SDK_VERSION;
@property (nonatomic, strong) NSString *APP_NAME;
@property (nonatomic, strong) NSString *KEY_HASH;

@end










