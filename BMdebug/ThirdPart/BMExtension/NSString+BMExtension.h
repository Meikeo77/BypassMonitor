//
//  NSString+BMExtension.h
//  BMExtensionExample
//
//  Created by BM Lee on 15/6/7.
//  Copyright (c) 2015年 小码哥. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BMExtensionConst.h"

@interface NSString (BMExtension)
/**
 *  驼峰转下划线（loveYou -> love_you）
 */
- (NSString *)bm_underlineFromCamel;
/**
 *  下划线转驼峰（love_you -> loveYou）
 */
- (NSString *)bm_camelFromUnderline;
/**
 * 首字母变大写
 */
- (NSString *)bm_firstCharUpper;
/**
 * 首字母变小写
 */
- (NSString *)bm_firstCharLower;

- (BOOL)bm_isPureInt;

- (NSURL *)bm_url;
@end

@interface NSString (BMExtensionDeprecated_v_2_5_16)
- (NSString *)underlineFromCamel BMExtensionDeprecated("请在方法名前面加上bm_前缀，使用bm_***");
- (NSString *)camelFromUnderline BMExtensionDeprecated("请在方法名前面加上bm_前缀，使用bm_***");
- (NSString *)firstCharUpper BMExtensionDeprecated("请在方法名前面加上bm_前缀，使用bm_***");
- (NSString *)firstCharLower BMExtensionDeprecated("请在方法名前面加上bm_前缀，使用bm_***");
- (BOOL)isPureInt BMExtensionDeprecated("请在方法名前面加上bm_前缀，使用bm_***");
- (NSURL *)url BMExtensionDeprecated("请在方法名前面加上bm_前缀，使用bm_***");
@end
