//
//  NSString+NimRegex.m
//  NIM
//
//  Created by MiaoYe on 2016/11/25.
//  Copyright © 2016年 Kingwelan. All rights reserved.
//

#import "NSString+NimRegex.h"

@implementation NSString (NimRegex)
/**
 @brief 检查手机号码
 */
-(BOOL)checkPhoneNumInput
{
    
    NSString * str = @"^((13[0-9])|(147)|(15[^4,\\D])|(18[0-9])|(17[0-9]))\\d{8}$";
    NSPredicate *regextestStr = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", str];
    return  [regextestStr evaluateWithObject:self];
    
}
/**
 @brief 检查邮箱
 */
-(BOOL) checkEmailInput
{
    NSString * str = @"\\b([a-zA-Z0-9%_.+\\-]+)@([a-zA-Z0-9.\\-]+?\\.[a-zA-Z]{2,6})\\b";
    NSPredicate *regextestStr = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", str];
    return  [regextestStr evaluateWithObject:self];
}

/**
 @brief 验证是否数字和英文字母组成
 */
- (BOOL)checkIsNumberAndCharacter{
    
    NSString * str = @"^(?![0-9]+$)(?![a-zA-Z]+$)[0-9A-Za-z]{6,15}$";
    NSPredicate *regextestStr = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", str];
    return  [regextestStr evaluateWithObject:self];
    
}

/**
 @brief 验证是中英文组成
 */
- (BOOL)checkChineseAndEnglish
{
    NSString * str = @"^[A-Za-z\u4e00-\u9fa5]+$";
    NSPredicate *regextestStr = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", str];
    return  [regextestStr evaluateWithObject:self];
}
/**
 @brief 验证是中英文数组组成
 */
- (BOOL)checkChineseAndEnglishaAndDigital
{
    NSString * str = @"^[A-Za-z0-9\u4e00-\u9fa5]+$";
    NSPredicate *regextestStr = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", str];
    return  [regextestStr evaluateWithObject:self];
}

/*
 @brief 判断是不是中文
 */
- (BOOL)checkISChinese{
    NSString *str = @"^[\u4E00-\u9FA5]*$";
    NSPredicate *regextestStr = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", str];
    return  [regextestStr evaluateWithObject:self];
}
/**
 @brief 删除空格
 */
-(NSString*)deleteSpace{
    NSString *trimmedString = [self stringByTrimmingCharactersInSet:
                               [NSCharacterSet whitespaceAndNewlineCharacterSet]];
    if (trimmedString) {
        return trimmedString;
    }else{
        return nil;
    }
}


/**
 @brief //匹配整数
 */
- (BOOL)checkIsNumber
{
    NSString * str = @"^[0-9]*$";
    NSPredicate *regextestStr = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", str];
    return  [regextestStr evaluateWithObject:self];
}


//首字母开头
- (BOOL)isLetterStart
{
    //(^[A-Za-z0-9]{6,20}$)
    NSString* regex = @"^[a-zA-Z][a-zA-Z0-9_]{5,16}$";
    NSPredicate *	pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    
    return [pred evaluateWithObject:self];
}

- (BOOL)isPassword
{
    //NSString *		regex = @"(^[A-Za-z0-9]{6,20}$)";
    NSString *regex = @"^(?![a-zA-Z]+$)(?!\\d+$)(?![\\W_]+$)\\S{6,15}$";
    NSPredicate *	pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    
    return [pred evaluateWithObject:self];
}

/**
 @brief 校验身份证格式
 */
- (BOOL)checkUserIdCard
{
    NSString *pattern = @"(^[0-9]{15}$)|([0-9]{17}([0-9]|X)$)";
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", pattern];
    return [pred evaluateWithObject:self];
}

/**
 @brrief 校验输入金额
 */
- (BOOL)checkInputMoney {
    
    NSString *pattern = @"^[0-9]+(.[0-9]{2})?$ ";
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", pattern];
    return [pred evaluateWithObject:self];
    
}

/**
 @brrief 校验表情
 */
- (BOOL)judgeFace {
    
    __block BOOL isEomji = NO;
    [self enumerateSubstringsInRange:NSMakeRange(0, [self length]) options:NSStringEnumerationByComposedCharacterSequences usingBlock:
     ^(NSString *substring, NSRange substringRange, NSRange enclosingRange, BOOL *stop) {
         const unichar hs = [substring characterAtIndex:0];
         if (0xd800 <= hs && hs <= 0xdbff) {
             if (substring.length > 1) {
                 const unichar ls = [substring characterAtIndex:1];
                 const int uc = ((hs - 0xd800) * 0x400) + (ls - 0xdc00) + 0x10000;
                 if (0x1d000 <= uc && uc <= 0x1f77f) {
                     isEomji = YES;
                 }
             }
         } else if (substring.length > 1) {
             const unichar ls = [substring characterAtIndex:1];
             if (ls == 0x20e3) {
                 isEomji = YES;
             }
         } else {
             if (0x2100 <= hs && hs <= 0x27ff && hs != 0x263b) {
                 isEomji = YES;
             } else if (0x2B05 <= hs && hs <= 0x2b07) {
                 isEomji = YES;
             } else if (0x2934 <= hs && hs <= 0x2935) {
                 isEomji = YES;
             } else if (0x3297 <= hs && hs <= 0x3299) {
                 isEomji = YES;
             } else if (hs == 0xa9 || hs == 0xae || hs == 0x303d || hs == 0x3030 || hs == 0x2b55 || hs == 0x2b1c || hs == 0x2b1b || hs == 0x2b50|| hs == 0x231a ) {
                 isEomji = YES;
             }
         }
     }];
    return isEomji;
}


@end
