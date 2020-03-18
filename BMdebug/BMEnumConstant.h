//
//  BMEnumConstant.h
//  BypassMonitor
//
//  Created by MiaoYe on 2019/1/7.
//  Copyright © 2019 Meikeo. All rights reserved.
//

#ifndef BMEnumConstant_h
#define BMEnumConstant_h

//网络信息
typedef  NS_ENUM(NSInteger, BMNetworkState) {
    
    BMNState_Unknown                    = -1, //未知网络
    BMNState_NotReachable               = 0, //断网
    BMNState_ReachableViaWWAN           = 1, //手机网络
    BMNState_ReachableViaWiFi           = 2, //wifi网络
};

//错误信息
typedef  NS_ENUM(u_int64_t, BMNetworkErrors) {
    BMNError_UrlNotFound                = 1990, //没有找到URL
    BMNError_RespondBadParam            = 1991, //坏的响应参数
    BMNError_RespondNotFound            = 1992, //没有找到响应的解析函数
    BMNError_MakeRequestParamBad        = 112,  //请求参数处理失败，请稍后重试
};

//服务类型
typedef NS_ENUM(NSInteger, BMBusinessType) {
   BMBusinessType_Open_StockA_Account             = 1,    //开户
   BMBusinessType_StockA_Trade                    = 2,    //交易
   BMBusinessType_Financial_Transfer              = 3,    //银证转账
   BMBusinessType_Open_Financial_Account          = 4,    //理财帐户开户
   BMBusinessType_Treasury_Bonds                  = 5,    //国债逆回购
   BMBusinessType_Advertise                       = 6,    //广告
   BMBusinessType_Other                           = 7,    //其他
};

//操作类型
typedef NS_ENUM(NSInteger, BMActionType) {
    BMActionType_YES            = 0,    //是
    BMActionType_NO             = 1,    //否
    BMActionType_Cancel         = 2,    //取消
};

//接口类型
typedef NS_ENUM(int, BMReportType) {
    BMReportType_Channel        = 1,    //业务采集
    BMReportType_Popup          = 2,    //弹窗提示采集
    BMReportType_Url            = 3,    //url采集
};


#endif /* BMEnumConstant_h */
