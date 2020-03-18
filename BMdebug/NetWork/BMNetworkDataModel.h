//
//  BMNetworkDataModel.h
//  BypassMonitor
//
//  Created by MiaoYe on 2019/1/7.
//  Copyright © 2019 Meikeo. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface BMNetworkDataModel : NSObject

@end

#pragma mark - 请求响应基类
/**
 *  请求头基类
 */
@interface BMNetworkReq : NSObject

@end


/**
 *  响应头基类
 */
@interface BMNetworkRsp : NSObject

/**
 *  解析响应参数类 为 dictionary
 *
 *  @param param 参数
 */
- (id) networkResponseParamDictionary:(id)param;

@end



#pragma mark - 请求头

/**
 *  请求头的包含体
 */
@interface REQ_MSG_HDR : BMNetworkDataModel
//@property (nonatomic, strong) NSString *TIME_STAMP;       //请求时间戳
@property (nonatomic, strong) NSString *SERIAL;           //请求号，由客户端保证唯一性
@property (nonatomic, strong) NSString *VERSION;     //当前固定为1.0，
@property (nonatomic, strong) NSString *SIGN;        //SIGN 签名，T000001 T000002 送空，
@property (nonatomic, strong) NSString *SIGN_TYPE;   //MD5
@property (nonatomic, strong) NSString *COOKIE;      //T000002返回的，T000001 T000002 送空
@end


/**
 *  返回数据的头部内容
 */
@interface ANS_MSG_HDR : BMNetworkDataModel
@property (nonatomic, strong) NSString *MSG_TEXT;
@property (nonatomic, strong) NSString *MSG_CODE;
@property (nonatomic, strong) NSString *MSG_LEVEL;
@end



