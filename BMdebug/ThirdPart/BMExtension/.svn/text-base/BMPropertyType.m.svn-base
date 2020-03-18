//
//  BMPropertyType.m
//  BMExtension
//
//  Created by BM on 14-1-15.
//  Copyright (c) 2014年 小码哥. All rights reserved.
//

#import "BMPropertyType.h"
#import "BMExtension.h"
#import "BMFoundation.h"
#import "BMExtensionConst.h"

@implementation BMPropertyType

+ (instancetype)cachedTypeWithCode:(NSString *)code
{
    BMExtensionAssertParamNotNil2(code, nil);
    
    static NSMutableDictionary *types;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        types = [NSMutableDictionary dictionary];
    });
    
    BMExtensionSemaphoreCreate
    BMExtensionSemaphoreWait
    BMPropertyType *type = types[code];
    if (type == nil) {
        type = [[self alloc] init];
        type.code = code;
        types[code] = type;
    }
    BMExtensionSemaphoreSignal
    return type;
}

#pragma mark - 公共方法
- (void)setCode:(NSString *)code
{
    _code = code;
    
    BMExtensionAssertParamNotNil(code);
    
    if ([code isEqualToString:BMPropertyTypeId]) {
        _idType = YES;
    } else if (code.length == 0) {
        _KVCDisabled = YES;
    } else if (code.length > 3 && [code hasPrefix:@"@\""]) {
        // 去掉@"和"，截取中间的类型名称
        _code = [code substringWithRange:NSMakeRange(2, code.length - 3)];
        _typeClass = NSClassFromString(_code);
        _fromFoundation = [BMFoundation isClassFromFoundation:_typeClass];
        _numberType = [_typeClass isSubclassOfClass:[NSNumber class]];
        
    } else if ([code isEqualToString:BMPropertyTypeSEL] ||
               [code isEqualToString:BMPropertyTypeIvar] ||
               [code isEqualToString:BMPropertyTypeMethod]) {
        _KVCDisabled = YES;
    }
    
    // 是否为数字类型
    NSString *lowerCode = _code.lowercaseString;
    NSArray *numberTypes = @[BMPropertyTypeInt, BMPropertyTypeShort, BMPropertyTypeBOOL1, BMPropertyTypeBOOL2, BMPropertyTypeFloat, BMPropertyTypeDouble, BMPropertyTypeLong, BMPropertyTypeLongLong, BMPropertyTypeChar];
    if ([numberTypes containsObject:lowerCode]) {
        _numberType = YES;
        
        if ([lowerCode isEqualToString:BMPropertyTypeBOOL1]
            || [lowerCode isEqualToString:BMPropertyTypeBOOL2]) {
            _boolType = YES;
        }
    }
}
@end
