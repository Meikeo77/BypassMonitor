//
//  BMSignParams.m
//  BMtamps
//
//  Created by taohanjun on 2017/7/25.
//  Copyright © 2017年 xu. All rights reserved.
//

#import "BMSignParams.h"

@implementation BMSignParams


+ (instancetype)sharedParams {
    
    static BMSignParams *param = nil;
    static dispatch_once_t predicate;
    
    dispatch_once(&predicate, ^{
        param = [[self alloc] init];
    });
    
    return param;
}

- (id)init {
    self = [super init];
    if (self) {
        _SqClean = NO;
        _SendClean = YES;
    }
    return self;
}

@end
