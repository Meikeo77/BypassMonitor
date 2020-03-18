//
//  BMNetworkDataItem.h
//  BypassMonitor
//
//  Created by MiaoYe on 2019/1/7.
//  Copyright © 2019 Meikeo. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

typedef void(^BMNetSuccessBlock)(id returnData);
typedef void(^BMNetFailureBlock)(NSError *error);

@interface BMNetworkDataItem : NSObject

@property (nonatomic, strong) NSURLSessionTask *netTask;

/**  业务码 */
@property (nonatomic, readonly) NSString *netCode;
/**  UrlRequest */
@property (nonatomic, readonly) NSURLRequest *netRequest;
/**  超时时间 */
@property (nonatomic, assign, readonly) NSTimeInterval netTimeout;
/**  参数 */
@property (nonatomic, readonly) id netParam;

//同步请求
-(void)networkWithCodeSync:(NSString *)netCode
                 parameters:(id)params
                   success:(BMNetSuccessBlock)successBlock
                   failure:(BMNetFailureBlock)failureBlock;


@end

NS_ASSUME_NONNULL_END
