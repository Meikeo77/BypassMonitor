//
//  BMCommonTool.m
//  BMdebug
//
//  Created by MiaoYe on 2019/1/11.
//  Copyright © 2019 Meikeo. All rights reserved.
//

#import "BMCommonTool.h"

@implementation BMCommonTool
+ (NSString *)getSysBundleId {
    NSDictionary *infoDic = [[NSBundle mainBundle] infoDictionary];
    return [infoDic objectForKey:@"CFBundleIdentifier"];
}

+ (NSString *)getAppName {
    NSDictionary *infoDic = [[NSBundle mainBundle] infoDictionary];
    return [infoDic objectForKey:@"CFBundleDisplayName"];
}

+ (NSString *)getBundleVersion {
    NSDictionary *infoDic = [[NSBundle mainBundle] infoDictionary];
    return [infoDic objectForKey:@"CFBundleVersion"];
}

@end
