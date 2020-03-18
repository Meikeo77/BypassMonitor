//
//  BMPropertyKey.m
//  BMExtensionExample
//
//  Created by BM Lee on 15/8/11.
//  Copyright (c) 2015年 小码哥. All rights reserved.
//

#import "BMPropertyKey.h"

@implementation BMPropertyKey

- (id)valueInObject:(id)object
{
    if ([object isKindOfClass:[NSDictionary class]] && self.type == BMPropertyKeyTypeDictionary) {
        return object[self.name];
    } else if ([object isKindOfClass:[NSArray class]] && self.type == BMPropertyKeyTypeArray) {
        NSArray *array = object;
        NSUInteger index = self.name.intValue;
        if (index < array.count) return array[index];
        return nil;
    }
    return nil;
}
@end
