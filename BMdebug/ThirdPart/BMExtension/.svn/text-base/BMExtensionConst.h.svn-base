
#ifndef __BMExtensionConst__H__
#define __BMExtensionConst__H__

#import <Foundation/Foundation.h>

// 信号量
#define BMExtensionSemaphoreCreate \
static dispatch_semaphore_t signalSemaphore; \
static dispatch_once_t onceTokenSemaphore; \
dispatch_once(&onceTokenSemaphore, ^{ \
    signalSemaphore = dispatch_semaphore_create(1); \
});

#define BMExtensionSemaphoreWait \
dispatch_semaphore_wait(signalSemaphore, DISPATCH_TIME_FOREVER);

#define BMExtensionSemaphoreSignal \
dispatch_semaphore_signal(signalSemaphore);

// 过期
#define BMExtensionDeprecated(instead) NS_DEPRECATED(2_0, 2_0, 2_0, 2_0, instead)

// 构建错误
#define BMExtensionBuildError(clazz, msg) \
NSError *error = [NSError errorWithDomain:msg code:250 userInfo:nil]; \
[clazz setBM_error:error];

// 日志输出
#ifdef DEBUG
#define BMExtensionLog(...) NSLog(__VA_ARGS__)
#else
#define BMExtensionLog(...)
#endif

/**
 * 断言
 * @param condition   条件
 * @param returnValue 返回值
 */
#define BMExtensionAssertError(condition, returnValue, clazz, msg) \
[clazz setBM_error:nil]; \
if ((condition) == NO) { \
    BMExtensionBuildError(clazz, msg); \
    return returnValue;\
}

#define BMExtensionAssert2(condition, returnValue) \
if ((condition) == NO) return returnValue;

/**
 * 断言
 * @param condition   条件
 */
#define BMExtensionAssert(condition) BMExtensionAssert2(condition, )

/**
 * 断言
 * @param param         参数
 * @param returnValue   返回值
 */
#define BMExtensionAssertParamNotNil2(param, returnValue) \
BMExtensionAssert2((param) != nil, returnValue)

/**
 * 断言
 * @param param   参数
 */
#define BMExtensionAssertParamNotNil(param) BMExtensionAssertParamNotNil2(param, )

/**
 * 打印所有的属性
 */
#define BMLogAllIvars \
-(NSString *)description \
{ \
    return [self bm_keyValues].description; \
}
#define BMExtensionLogAllProperties BMLogAllIvars

/**
 *  类型（属性类型）
 */
FOUNDATION_EXPORT NSString *const BMPropertyTypeInt;
FOUNDATION_EXPORT NSString *const BMPropertyTypeShort;
FOUNDATION_EXPORT NSString *const BMPropertyTypeFloat;
FOUNDATION_EXPORT NSString *const BMPropertyTypeDouble;
FOUNDATION_EXPORT NSString *const BMPropertyTypeLong;
FOUNDATION_EXPORT NSString *const BMPropertyTypeLongLong;
FOUNDATION_EXPORT NSString *const BMPropertyTypeChar;
FOUNDATION_EXPORT NSString *const BMPropertyTypeBOOL1;
FOUNDATION_EXPORT NSString *const BMPropertyTypeBOOL2;
FOUNDATION_EXPORT NSString *const BMPropertyTypePointer;

FOUNDATION_EXPORT NSString *const BMPropertyTypeIvar;
FOUNDATION_EXPORT NSString *const BMPropertyTypeMethod;
FOUNDATION_EXPORT NSString *const BMPropertyTypeBlock;
FOUNDATION_EXPORT NSString *const BMPropertyTypeClass;
FOUNDATION_EXPORT NSString *const BMPropertyTypeSEL;
FOUNDATION_EXPORT NSString *const BMPropertyTypeId;

#endif
