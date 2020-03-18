//
//  BMNetworkDataItem.m
//  BypassMonitor
//
//  Created by MiaoYe on 2019/1/7.
//  Copyright © 2019 Meikeo. All rights reserved.
//

#import "BMNetworkDataItem.h"
#import "BMNetworkDataModel.h"
#import "BMSignParams.h"
#import "BMSignUtil.h"
#import "BMRsaHelper.h"
#import "BMKeychainTool.h"

@interface BMNetworkDataItem ()
/**  响应model */
@property (nonatomic, strong) id responseClass;

/**  成功Block */
@property (nonatomic, strong) BMNetSuccessBlock successBlock;
/**  失败Block */
@property (nonatomic, strong) BMNetFailureBlock failureBlock;

@property (nonatomic, strong) NSString *app_only;

@end

@implementation BMNetworkDataItem

- (id)init {
    self = [super init];
    if (self) {
        _app_only = [BMKeychainTool getDeviceIDInKeychain];
    }
    return self;
}

- (void)networkWithCodeSync:(NSString *)netCode parameters:(id)params success:(BMNetSuccessBlock)successBlock failure:(BMNetFailureBlock)failureBlock {
    _netCode = netCode;
    _successBlock = successBlock;
    _failureBlock = failureBlock;
    //处理请求参数
    [self networkRequestParamSetting:params];
    if (!_netParam) {
        [self failureWithErrCode:BMNError_MakeRequestParamBad andErrMessage:@"请求参数处理失败，请稍后重试"];
        return;
    }
    
    [self networkRequest];
    //进行数据通讯
    [self networkGoSync];
}

//开始同步请求
- (void)networkGoSync{
    
    dispatch_semaphore_t semaphore = dispatch_semaphore_create(0);
    NSURLRequest *httpRequest = _netRequest;
    NSURLSession *urlSession = [NSURLSession sharedSession];
    
    self.netTask = [urlSession dataTaskWithRequest:httpRequest completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error){
        
        if(error){
            if ([error code] == NSURLErrorCancelled) {
                dispatch_semaphore_signal(semaphore);
                return ;
            }
            [self failureWithErrCode:BMNError_RespondBadParam andErrMessage:@"网络异常，请稍后再试"];
            dispatch_semaphore_signal(semaphore);
            return;
        }
        
        [self responseParamParse:data];
        dispatch_semaphore_signal(semaphore);
    }];
    
    [self.netTask resume];
    
    // 5～6秒请求没回来，会导致crash
    // 原来的代码：dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);
    dispatch_time_t  fourSeconds = dispatch_time(DISPATCH_TIME_NOW, 5 * NSEC_PER_SEC);
    dispatch_semaphore_wait(semaphore, fourSeconds);
}

//请求初始化
- (void) networkRequest{
    NSMutableURLRequest *urlRequest = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:BM_RequestURL(_netCode)] cachePolicy:NSURLRequestReloadIgnoringCacheData timeoutInterval:20];
    [urlRequest setHTTPMethod:@"POST"];
    [urlRequest setHTTPBody:_netParam];
    [urlRequest addValue:@"gzip,deflate" forHTTPHeaderField:@"Accept-Encoding"];
    _netRequest = urlRequest;
}

//格式化 请求参数
- (void)networkRequestParamSetting:(BMNetworkDataModel *)param {
    REQ_MSG_HDR *reqHeader = [[REQ_MSG_HDR alloc] init];
    reqHeader.VERSION   = @"1.0";
    reqHeader.SIGN_TYPE = @"MD5";
    //精确到微妙
    NSTimeInterval times = [[NSDate date] timeIntervalSince1970];
    NSString *serial = [NSString stringWithFormat:@"%ld%u%@",(long)(times*1000*1000),arc4random()%10000,_app_only];
    reqHeader.SERIAL = [BMSignUtil md5HexDigest:serial];
    
    if ([_netCode isEqualToString:BM_NetCode_GetPublicKey] || [_netCode isEqualToString:BM_NetCode_SysSignIn]) {
        reqHeader.COOKIE = @"";
        reqHeader.SIGN = @"";
    }else {
        if ([BMSignParams sharedParams].COOKIE.length == 0)
            return;
        reqHeader.COOKIE = [BMSignParams sharedParams].COOKIE;
        
        //签名
        NSString *headerSignSrc = [NSString stringWithFormat:@"COOKIE=%@&SERIAL=%@&SIGN_TYPE=%@&VERSION=%@", reqHeader.COOKIE,reqHeader.SERIAL,reqHeader.SIGN_TYPE,reqHeader.VERSION];
        NSString *dataSignSrc = [self srcStrOfData:param];
        
        NSString *key = [BMSignParams sharedParams].SIGN_KEY;
        //拼接签名串
        NSString *signSrc = [NSString stringWithFormat:@"%@&%@&key=%@", headerSignSrc,dataSignSrc,key];
        NSString *signedStr = [BMSignUtil md5HexDigest:signSrc];
        reqHeader.SIGN = signedStr;
    }
    
    //拼接请求报文
    NSString* a2 = [reqHeader.mj_keyValues mj_JSONString];
    NSString* a1 = [param.mj_keyValues mj_JSONString];
    
    if(!param){
        a1 = @"null";
    }
    NSString *parStr = [NSString stringWithFormat:@"{\"REQUESTS\":[{\"REQ_COMM_DATA\":%@,\"REQ_MSG_HDR\":%@}]}", a1, a2];
//    NSLog(@"请求数据 - %@",parStr);
    
    parStr = [BMSignUtil desEncryptWithKey:[BMSignParams sharedParams].desKey for:parStr];
    if(!parStr){
        return;
    }
    
    if(!([_netCode isEqualToString:BM_NetCode_GetPublicKey] || [_netCode isEqualToString:BM_NetCode_SysSignIn])){
        parStr = [NSString stringWithFormat:@"%@|%@", [BMSignParams sharedParams].COOKIE,parStr];
    }
    
    _netParam = [parStr dataUsingEncoding: NSUTF8StringEncoding];

}

//普通字符串转换为十六进制的。
- (NSString *)hexStringFromString:(NSString *)string{
    NSData *myD = [string dataUsingEncoding:NSUTF8StringEncoding];
    Byte *bytes = (Byte *)[myD bytes];
    //下面是Byte 转换为16进制。
    NSString *hexStr=@"";
    for(int i=0;i<[myD length];i++)
    {
        NSString *newHexStr = [NSString stringWithFormat:@"%x",bytes[i]&0xff];///16进制数
        if([newHexStr length]==1)
            hexStr = [NSString stringWithFormat:@"%@0%@",hexStr,newHexStr];
        else
            hexStr = [NSString stringWithFormat:@"%@%@",hexStr,newHexStr];
    }
    return hexStr;
}

#pragma mark - 响应参数处理
- (void)responseParamParse:(id)responseObject{
    
    NSData *rspData = responseObject;
    NSString *dataStr = [[NSString alloc] initWithData:rspData encoding:NSUTF8StringEncoding];
    
    //检查返回密文是否加密
    NSString *first = [dataStr substringToIndex:1];
    if (![first isEqualToString:@"{"]) {
         dataStr = [BMSignUtil desDecryptWithKey:[BMSignParams sharedParams].desKey for:dataStr];
    }
    
    if (!dataStr) {
        [self failureWithErrCode:BMNError_RespondBadParam andErrMessage:@"返回值解密失败"];
        return;
    }
    
//    NSLog(@"rspData === %@", dataStr);

    NSError *err;
    NSDictionary *responseDic =  [NSJSONSerialization JSONObjectWithData:[dataStr dataUsingEncoding:NSUTF8StringEncoding] options: NSJSONReadingMutableContainers error:&err];
    if(err || !responseDic){
        [self failureWithErrCode:BMNError_RespondBadParam andErrMessage:@"网络异常，请稍后再试"];
        return;
    }
    
    if(![responseDic isKindOfClass:[NSDictionary class]]){
        [self failureWithErrCode:BMNError_RespondBadParam andErrMessage:@"网络异常，请稍后再试"];
        return;
    }
    
    id asn = [responseDic objectForKey:@"ANSWERS"];
    if([asn isKindOfClass:[NSArray class]]){
        
        [self responseAnswersParse:asn];
    }else {
        [self failureWithErrCode:BMNError_RespondBadParam andErrMessage:@"网络异常，请稍后再试"];
    }
    
}

- (void)responseAnswersParse:(NSArray *)ansArr{
    
    if(![ansArr isKindOfClass:[NSArray class]]){
        [self failureWithErrCode:BMNError_RespondBadParam andErrMessage:@"网络异常，请稍后再试"];
        return;
    }
    
    if([ansArr count] == 0) {
        [self failureWithErrCode:BMNError_RespondBadParam andErrMessage:@"网络异常，请稍后再试"];
        return;
    }
    
    id subDic = [ansArr objectAtIndex:0];
    
    if(![subDic isKindOfClass:[NSDictionary class]]){
        [self failureWithErrCode:BMNError_RespondBadParam andErrMessage:@"网络异常，请稍后再试"];
        return;
    }
    
    id ansMsgHdrDic = [subDic objectForKey:@"ANS_MSG_HDR"];
    if(![ansMsgHdrDic isKindOfClass:[NSDictionary class]]){
        [self failureWithErrCode:BMNError_RespondBadParam andErrMessage:@"网络异常，请稍后再试"];
        return;
    }
    
    //解析头 - 判断接口返回结果
    if(![self responseHeaderParse:ansMsgHdrDic]) return;
    
    id ansCommData = [subDic objectForKey:@"ANS_COMM_DATA"];
    
    if([ansCommData isKindOfClass:[NSNull class]]) {
        [self successWithData:nil];
        return;
    }
    
    if (![ansCommData isKindOfClass:[NSArray class]]) {
        [self failureWithErrCode:BMNError_RespondBadParam andErrMessage:@"网络异常，请稍后再试"];
        return;
    }
    
    if([ansCommData count] == 0) {
        [self successWithData:nil];
        return;
    }
    
    id paraData = ansCommData;
    id secData = [ansCommData firstObject];
    if([secData isKindOfClass:[NSArray class]]){
        paraData = secData;
    }
    
    //检查是否有响应解析类
    BOOL bok = [self networkResponseClass];
    if (!bok) {
        [self failureWithErrCode:BMNError_RespondNotFound andErrMessage:@"没有找到响应解析类"];
        return;
    }
    
    //解析数据
    [self responseDataParase:paraData];
    
}

//解析头
- (BOOL) responseHeaderParse:(NSDictionary*)ansMsgHdrDic{
    
    ANS_MSG_HDR* hdr = [[ANS_MSG_HDR class] mj_objectWithKeyValues:ansMsgHdrDic];
    if(!hdr){
        [self failureWithErrCode:BMNError_RespondBadParam andErrMessage:@"服务器应答数据解析错误"];
        return NO;
    }
    //返回出错的情况下，直接返回，不继续解析
    if(![hdr.MSG_CODE isEqualToString:@"0"]){
        
        [self failureWithErrCode:[hdr.MSG_CODE longLongValue] andErrMessage:hdr.MSG_TEXT];
        return NO;
    }
    
    return YES;
}

//判断是否是列表中的接口 并且返回函数是那种类型
- (BOOL)networkResponseClass{
    
    NSArray *sepArr = [_netCode componentsSeparatedByString:@"."];
    NSString *keyStr = [sepArr lastObject];
    NSDictionary *dict = nil;
    
    BOOL bOK = NO;
    if ([[self.networkRespondDict allKeys] containsObject:keyStr]) {
        dict = self.networkRespondDict;
        bOK = YES;
    }
    
    if (bOK) {
        _responseClass = dict[keyStr];
    }
    return bOK;
}


- (void) responseDataParase:(NSArray*)dataArr{
    //数据解析
    BMNetworkRsp *rsp = [[[_responseClass class] alloc] init];
    id item = nil;
    item = [rsp networkResponseParamDictionary:dataArr];
    [self successWithData:item];
}

#pragma mark - 解析数据对应的model

- (NSDictionary*) networkRespondDict {
    
    return @{
             BM_NetCode_GetPublicKey   :   [BMSignKeyRsp class],
             BM_NetCode_SysSignIn      :   [BMSystemSignInRsp class],
             BM_NetCode_ChannelReport  :   [BMReportRsp class],
             BM_NetCode_PopupReport    :   [BMReportRsp class],
             BM_NetCode_UrlReport      :   [BMReportRsp class],
            };
}


#pragma mark - 数据返回
/**
 *  数据返回成功
 *
 *  @param succData 数据成功信息
 */
- (void)successWithData:(id)succData{
    _successBlock(succData);
}

/**
 *  数据返回失败
 *
 *  @param errCode 错误码
 *  @param errMsg  错误信息
 */
- (void)failureWithErrCode:(BMNetworkErrors)errCode andErrMessage:(NSString *)errMsg{
    
    NSString *errStr = errMsg; //[BMUtil BMDealErrorWithString:errMsg];
    
    NSDictionary *userInfo = [NSDictionary dictionaryWithObject:errStr  forKey:NSLocalizedDescriptionKey];
    NSError *error = [NSError errorWithDomain:BMNetworkErrorDomain code:errCode userInfo:userInfo];
    if(_failureBlock){
        _failureBlock(error);
    }
}


//请求参数排序
- (NSString *) srcStrOfData:(BMNetworkDataModel *)param{
    
    //1、原始报文先组出来，然后生成NSDictionary
    NSDictionary *string2dic = param.mj_keyValues;
    
    if(!string2dic){
        return @"";
    }
    
    //2、排序
    NSArray *propertyNameList = string2dic.allKeys;
    NSArray *stringSortedArr = [BMSignUtil stringSort:propertyNameList];
    
    //3、重新排序
    NSMutableString *muStr = [[NSMutableString alloc] init];
    for(int i = 0; i < stringSortedArr.count; i++){
        if(muStr.length > 0 ) [muStr appendString:@"&"];
        
        NSString *keyStr = stringSortedArr[i];
        NSString *valStr = keyStr ? [string2dic objectForKey:keyStr] : nil;
        
        if(keyStr && valStr){
            [muStr appendFormat:@"%@=%@", keyStr, valStr];
        }
        
    }
    
    return muStr;
}


#pragma mark url校验
+ (BOOL)isUrl:(NSString*)urlStr{
    NSString* regex = @"http(s)?:\\/\\/([\\w-]+\\.)+[\\w-]+(:[\\w-]+)?(\\/[\\w- .\\/?%&=]*)?";
    NSPredicate *    pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    return [pred evaluateWithObject:urlStr];
}




@end
