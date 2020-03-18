//
//  NSString+NimCaculate.m
//  NIM
//
//  Created by MiaoYe on 2016/11/25.
//  Copyright © 2016年 Kingwelan. All rights reserved.
//

#import "NSString+NimCaculate.h"

@implementation NSString (NimCaculate)

- (NSUInteger)numberOfLines {
    return [[self componentsSeparatedByString:@"\n"] count] + 1;
}

- (NSData *) NimToUtf8Data{
    return [self dataUsingEncoding:NSUTF8StringEncoding allowLossyConversion:YES];
}

- (NSDate *) NimTodate{
    NSTimeZone * local = [NSTimeZone localTimeZone];
    
    NSString * format = @"yyyy-MM-dd HH:mm:ss";
    NSString * text = [(NSString *)self substringToIndex:format.length];
    
    NSDateFormatter * dateFormatter = [[NSDateFormatter alloc] init] ;
    [dateFormatter setDateFormat:format];
    [dateFormatter setTimeZone:[NSTimeZone timeZoneForSecondsFromGMT:0]];
    
    return [NSDate dateWithTimeInterval:(3600 + [local secondsFromGMT])
                              sinceDate:[dateFormatter dateFromString:text]];
}

- (NSDictionary*) NimJsonStrToDictionary{
    NSError* error;
    return [NSJSONSerialization JSONObjectWithData:[self NimToUtf8Data]
                                           options:NSJSONReadingAllowFragments error:&error];
}

- (BOOL)NimEmpty{
    return [self length] > 0 ? NO : YES;
}

- (BOOL)NimNotEmpty{
    return [self length] > 0 ? YES : NO;
}

- (BOOL)NimIfContainsString:(NSString*)subString{
    return !NSEqualRanges([self rangeOfString:subString], NSMakeRange(NSNotFound, 0));
}

- (CGSize) NimSizeWithFont:(UIFont *)font inSize:(CGSize)rectSize {
    NSMutableAttributedString *attributedStr = [[NSMutableAttributedString alloc] initWithString:self attributes:@{NSFontAttributeName:font}];
    
    return [attributedStr boundingRectWithSize:rectSize options:(NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading) context:nil].size;
}

- (CGSize) NimSizeWithFontSize:(CGFloat)font inSize:(CGSize)rectSize{
    
    NSMutableAttributedString *attributedStr = [[NSMutableAttributedString alloc] initWithString:self attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:font]}];
    
    return [attributedStr boundingRectWithSize:rectSize options:(NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading) context:nil].size;
    
    /* 另一种方法
     UITextView *textView = [[UITextView alloc] init];
     textView.text = self;
     CGSize bestSize = [textView sizeThatFits:rectSize];
     */
}

- (CGSize) NimSizeWithFont:(UIFont*)font inSize:(CGSize)rectSize lineSpacing:(CGFloat)lineSpace{
    
    NSMutableAttributedString *attrString = [self attributedStringFromStingWithFont:font withLineSpacing:lineSpace];
    
    return [attrString boundingRectWithSize:rectSize options:(NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading) context:nil].size;
}

- (CGSize)NimTextSizeWithAttributes:(NSDictionary *)attributes{
    CGSize textSize = [self boundingRectWithSize:CGSizeMake(100, 100) options:NSStringDrawingTruncatesLastVisibleLine attributes:attributes context:nil].size;
    return textSize;
}


- (NSMutableAttributedString *)attributedStringFromStingWithFont:(UIFont *)font                                                withLineSpacing:(CGFloat)lineSpacing {
    
    NSMutableAttributedString *attributedStr = [[NSMutableAttributedString alloc] initWithString:self attributes:@{NSFontAttributeName:font}];
    
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    [paragraphStyle setLineSpacing:lineSpacing];
    
    [attributedStr addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [self length])];
    
    return attributedStr;
}

- (NSString *) NimChineseUrlEncode{
    
    NSString *result = (__bridge_transfer NSString *)CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault, (__bridge CFStringRef)self, CFSTR("."), CFSTR(":/?#[]@!$&'()*+,;="), kCFStringEncodingUTF8);
    return result;
    
}

- (NSString *)NimTrim
{
    return [self stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
}


- (NSAttributedString *)NimChangeText:(NSString *)strChange
                      withChangeColor:(UIColor *)color
                       withChangeFont:(UIFont *)font{
    
    NSMutableAttributedString * aAttributedString = [[NSMutableAttributedString alloc] initWithString:self];
    //寻找子字符串的范围
    NSRange range = [self rangeOfString:strChange];
    //判断是否找到子字符串
    if(range.location == NSNotFound)
        return aAttributedString;
    //子字符串改变颜色
    [aAttributedString addAttribute:NSForegroundColorAttributeName
                              value:color
                              range:range];
    if (font) {
        //子字符串改字体大小
        [aAttributedString addAttribute:NSFontAttributeName
                                  value:font
                                  range:range];
    }
    
    return aAttributedString;
}

- (NSString *)checkToString {
    
    if(self == nil || [self isKindOfClass:[NSNull class]]){
        return  @"";
    }
    return self;
}

- (NSString *)checkToZero {
    if(self == nil || [self isKindOfClass:[NSNull class]] || self == NULL || [self isEqualToString:@"(null)"]){
        return  @"0";
    }
    return self;
}


- (NSString *)NimScrDateFomate:(NSString *)scrFomate andDesDateFomate:(NSString *)desFomate{
    NSDate *date = [NSDate NimDateFromString:self andFormat:scrFomate];
    NSString *str = [date NimStringWithDateFormat:desFomate];
    return str;
}


#pragma mark - 身份证号的处理
-(NSString *)NimBirthdayStrFromIdentityCard{
    
    NSMutableString *result = [NSMutableString stringWithCapacity:0];
    NSString *year = nil;
    NSString *month = nil;
    
    //检查是否适合发身份证
    BOOL bTrue = [NSString NimValidateIDCardNumber:self];
    if (!bTrue) {
        return result;
    }
    
    BOOL isAllNumber = YES;
    NSString *day = nil;
    if([self length]<14)
        return result;
    
    //**截取前14位
    NSString *fontNumer = [self substringWithRange:NSMakeRange(0, 13)];
    
    //**检测前14位否全都是数字;
    const char *str = [fontNumer UTF8String];
    const char *p = str;
    while (*p!='\0') {
        if(!(*p>='0'&&*p<='9'))
            isAllNumber = NO;
        p++;
    }
    if(!isAllNumber)
        return result;
    
    year = [self substringWithRange:NSMakeRange(6, 4)];
    month = [self substringWithRange:NSMakeRange(10, 2)];
    day = [self substringWithRange:NSMakeRange(12,2)];
    
    [result appendString:year];
    [result appendString:@"-"];
    [result appendString:month];
    [result appendString:@"-"];
    [result appendString:day];
    return result;
}

//根据身份证号性别
-(NSString *)NimGetIdentityCardSex{
    
    int sexInt = -1;
    if (self.length==15) {
        sexInt=[[self substringWithRange:NSMakeRange(14,1)] intValue];
    }else if (self.length==18){
        sexInt=[[self substringWithRange:NSMakeRange(16,1)] intValue];
    }else{
        return @"-1";
    }
    
    if(sexInt%2!=0)
    {
        return @"1";
    }
    else
    {
        return @"2";
    }
}
//根据省份证号获取年龄
-(NSString *)NimGetIdentityCardAge{
    
    NSDateFormatter *formatterTow = [[NSDateFormatter alloc]init];
    [formatterTow setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSDate *bsyDate = [formatterTow dateFromString:[self NimBirthdayStrFromIdentityCard]];
    
    NSTimeInterval dateDiff = [bsyDate timeIntervalSinceNow];
    
    int age = trunc(dateDiff/(60*60*24))/365;
    
    return [NSString stringWithFormat:@"%d",-age];
}


//判断身份证是否合法
+ (BOOL)NimValidateIDCardNumber:(NSString *)value {
    value = [value stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    
    int length =0;
    if (!value) {
        return NO;
    }else {
        length = (int)value.length;
        
        if (length !=15 && length !=18) {
            return NO;
        }
    }
    // 省份代码
    NSArray *areasArray =@[@"11",@"12", @"13",@"14", @"15",@"21", @"22",@"23", @"31",@"32", @"33",@"34", @"35",@"36", @"37",@"41", @"42",@"43", @"44",@"45", @"46",@"50", @"51",@"52", @"53",@"54", @"61",@"62", @"63",@"64", @"65",@"71", @"81",@"82", @"91"];
    
    NSString *valueStart2 = [value substringToIndex:2];
    BOOL areaFlag =NO;
    for (NSString *areaCode in areasArray) {
        if ([areaCode isEqualToString:valueStart2]) {
            areaFlag =YES;
            break;
        }
    }
    
    if (!areaFlag) {
        return false;
    }
    
    
    NSRegularExpression *regularExpression;
    NSUInteger numberofMatch;
    
    int year =0;
    switch (length) {
        case 15:{
            year = [value substringWithRange:NSMakeRange(6,2)].intValue +1900;
            
            if (year %4 ==0 || (year %100 ==0 && year %4 ==0)) {
                
                regularExpression = [[NSRegularExpression alloc]initWithPattern:@"^[1-9][0-9]{5}[0-9]{2}((01|03|05|07|08|10|12)(0[1-9]|[1-2][0-9]|3[0-1])|(04|06|09|11)(0[1-9]|[1-2][0-9]|30)|02(0[1-9]|[1-2][0-9]))[0-9]{3}$"
                                                                        options:NSRegularExpressionCaseInsensitive
                                                                          error:nil];//测试出生日期的合法性
            }else {
                regularExpression = [[NSRegularExpression alloc]initWithPattern:@"^[1-9][0-9]{5}[0-9]{2}((01|03|05|07|08|10|12)(0[1-9]|[1-2][0-9]|3[0-1])|(04|06|09|11)(0[1-9]|[1-2][0-9]|30)|02(0[1-9]|1[0-9]|2[0-8]))[0-9]{3}$"
                                                                        options:NSRegularExpressionCaseInsensitive
                                                                          error:nil];//测试出生日期的合法性
            }
            numberofMatch = [regularExpression numberOfMatchesInString:value
                                                               options:NSMatchingReportProgress
                                                                 range:NSMakeRange(0, value.length)];
            
            
            if(numberofMatch >0) {
                return YES;
            }else {
                return NO;
            }
        }
        case 18:{
            
            year = [value substringWithRange:NSMakeRange(6,4)].intValue;
            if (year %4 ==0 || (year %100 ==0 && year %4 ==0)) {
                
                regularExpression = [[NSRegularExpression alloc]initWithPattern:@"^[1-9][0-9]{5}19[0-9]{2}((01|03|05|07|08|10|12)(0[1-9]|[1-2][0-9]|3[0-1])|(04|06|09|11)(0[1-9]|[1-2][0-9]|30)|02(0[1-9]|[1-2][0-9]))[0-9]{3}[0-9Xx]$"
                                                                        options:NSRegularExpressionCaseInsensitive
                                                                          error:nil];//测试出生日期的合法性
            }else {
                regularExpression = [[NSRegularExpression alloc]initWithPattern:@"^[1-9][0-9]{5}19[0-9]{2}((01|03|05|07|08|10|12)(0[1-9]|[1-2][0-9]|3[0-1])|(04|06|09|11)(0[1-9]|[1-2][0-9]|30)|02(0[1-9]|1[0-9]|2[0-8]))[0-9]{3}[0-9Xx]$"
                                                                        options:NSRegularExpressionCaseInsensitive
                                                                          error:nil];//测试出生日期的合法性
            }
            numberofMatch = [regularExpression numberOfMatchesInString:value
                                                               options:NSMatchingReportProgress
                                                                 range:NSMakeRange(0, value.length)];
            
            
            if(numberofMatch >0) {
                int S = ([value substringWithRange:NSMakeRange(0,1)].intValue + [value substringWithRange:NSMakeRange(10,1)].intValue) *7 + ([value substringWithRange:NSMakeRange(1,1)].intValue + [value substringWithRange:NSMakeRange(11,1)].intValue) *9 + ([value substringWithRange:NSMakeRange(2,1)].intValue + [value substringWithRange:NSMakeRange(12,1)].intValue) *10 + ([value substringWithRange:NSMakeRange(3,1)].intValue + [value substringWithRange:NSMakeRange(13,1)].intValue) *5 + ([value substringWithRange:NSMakeRange(4,1)].intValue + [value substringWithRange:NSMakeRange(14,1)].intValue) *8 + ([value substringWithRange:NSMakeRange(5,1)].intValue + [value substringWithRange:NSMakeRange(15,1)].intValue) *4 + ([value substringWithRange:NSMakeRange(6,1)].intValue + [value substringWithRange:NSMakeRange(16,1)].intValue) *2 + [value substringWithRange:NSMakeRange(7,1)].intValue *1 + [value substringWithRange:NSMakeRange(8,1)].intValue *6 + [value substringWithRange:NSMakeRange(9,1)].intValue *3;
                int Y = S %11;
                NSString *M =@"F";
                NSString *JYM =@"10X98765432";
                M = [JYM substringWithRange:NSMakeRange(Y,1)];// 判断校验位
                if ([M isEqualToString:[value substringWithRange:NSMakeRange(17,1)]]) {
                    return YES;// 检测ID的校验位
                }else {
                    return NO;
                }
                
            }else {
                return NO;
            }
        }
        default:
            return NO;
    }
}


+ (NSString *)NimHandleWithSeverTime:(NSString *)time {
    
    NSString *sixStr = @"0";
    if(time.length >= 1){
        sixStr = [time substringWithRange:NSMakeRange(time.length - 1, 1)];
    }
    NSString *fiveStr = @"0";
    if(time.length >= 2){
        fiveStr = [time substringWithRange:NSMakeRange(time.length - 2, 1)];
    }
    NSString *fourStr = @"0";
    if(time.length >= 3){
        fourStr = [time substringWithRange:NSMakeRange(time.length - 3, 1)];
    }
    NSString *thirdStr = @"0";
    if(time.length >= 4){
        thirdStr = [time substringWithRange:NSMakeRange(time.length - 4, 1)];
    }
    NSString *secStr = @"0";
    if(time.length >= 5){
        secStr = [time substringWithRange:NSMakeRange(time.length - 5, 1)];
    }
    NSString *firstStr = @"0";
    if(time.length >= 6){
        firstStr = [time substringWithRange:NSMakeRange(time.length - 6, 1)];
    }
    NSString *newDate = [NSString stringWithFormat:@" %@%@:%@%@:%@%@", firstStr, secStr, thirdStr, fourStr, fiveStr, sixStr];
    
    return newDate;
}

- (NSString *)formatSecuryCode {
    if (self.length >10 ) {
        //银行卡
        NSString *headStr = [self substringToIndex:3];
        NSString *backStr = [self substringFromIndex:self.length - 3];
        return [NSString stringWithFormat:@"%@***%@",headStr,backStr];
    }else {
        NSString *headStr = [self substringToIndex:1];
        NSString *backStr = [self substringFromIndex:self.length - 3];
        return [NSString stringWithFormat:@"%@***%@",headStr,backStr];
    }
}

@end
