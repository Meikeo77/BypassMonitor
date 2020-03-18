//
//  NSString+NimCaculate.h
//  NIM
//
//  Created by MiaoYe on 2016/11/25.
//  Copyright © 2016年 Kingwelan. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (NimCaculate)

- (NSUInteger)numberOfLines;

/**
 *  使用NSUTF8StringEncoding转到NSData对象
 *
 *  @return NSData对象
 */
- (NSData *)NimToUtf8Data;

/**
 *  将yyyy-MM-dd HH:mm:ss格式的时间转到NSDate对象
 *
 *  @return NSDate对象
 */
- (NSDate *)NimTodate;

/**
 *  json串转换成NSDictionary
 *
 *  @return NSDictionary对象
 */
- (NSDictionary*) NimJsonStrToDictionary;

/**
 *  判断字串是否为空
 *
 *  @return BOOL，""和nil将返回YES
 */
- (BOOL)NimEmpty;

/**
 *  判断字串是否不为空
 *
 *  @return BOOL，""和nil将返回NO
 */
- (BOOL)NimNotEmpty;

/**
 *  判断是否包含串
 *
 *  @param subString 要判断是否包含的子串, 供低于8.0版使用的containsString
 *
 *  @return BOOL
 */
- (BOOL)NimIfContainsString:(NSString*)subString;

/**
 *  判断串占用的尺寸
 *
 *  @param font 串使用的字体
 *  @param rectSize 字串的最大尺寸
 *
 *  @return CGSize
 */
- (CGSize) NimSizeWithFont:(UIFont *)font inSize:(CGSize)rectSize;

- (CGSize) NimSizeWithFontSize:(CGFloat)font inSize:(CGSize)rectSize;

/**
 *  判断串占用的尺寸，带行间距
 *
 *  @param font 串使用的字体
 *  @param rectSize 字串的最大尺寸
 *
 *  @return CGSize
 */
- (CGSize) NimSizeWithFont:(UIFont*)font inSize:(CGSize)rectSize lineSpacing:(CGFloat)lineSpace;

/**
 *  中文转%XX方式，用于在url中嵌入中文，该方法不适用于将整个url进行编码，适用于单独将中文编码
 *
 *  @return 编码后的NSString对象
 */
- (NSString *) NimChineseUrlEncode;

/**
 *  去掉两端的空白字符和换行符
 *
 *  @return NSString对象
 */
- (NSString *)NimTrim;

/**
 *  根据属性来计算串的size
 *
 *  @param attributes boundingRectWithSize接口用到的属性
 *
 *  @return 串的size
 */
- (CGSize)NimTextSizeWithAttributes:(NSDictionary *)attributes;


/**
 *  设置字符串的富文本形式
 *
 *  @param strChange 需要变色的字符串 color变色颜色 font字体
 *
 *  @return NSAttributedString
 */
- (NSAttributedString *)NimChangeText:(NSString *)strChange
                      withChangeColor:(UIColor *)color
                       withChangeFont:(UIFont *)font;

/**
 *  设置竖直间距
 *
 *  @param font        字体
 *  @param lineSpacing 间距
 *
 *  @return NSMutableAttributedString
 */
- (NSMutableAttributedString *)attributedStringFromStingWithFont:(UIFont *)font                                                withLineSpacing:(CGFloat)lineSpacing;


- (NSString *)checkToString;

- (NSString *)checkToZero;


#pragma mark - 两个时间类型的
- (NSString *)NimScrDateFomate:(NSString *)scrFomate andDesDateFomate:(NSString *)desFomate;


#pragma mark - 身份证号的处理
/**
 *  根据身份证返回生日
 *
 *  @return 生日
 */
- (NSString *)NimBirthdayStrFromIdentityCard;

/**
 *  根据身份证返回性别
 *
 *  @return 性别
 */
-(NSString *)NimGetIdentityCardSex;

/**
 *  根据身份证返回年龄
 *
 *  @return 年龄
 */
-(NSString *)NimGetIdentityCardAge;

/**
 *  判断身份证是否合法
 *
 *  @param value 身份证
 *
 *  @return YES:合法，NO:不合法
 */
+ (BOOL)NimValidateIDCardNumber:(NSString *)value;


/**
 *  处理后台返回的时间
 *
 *  @param time －服务器返回的时间132839
 *
 *  @return 返回时间 13:28:39
 */
+ (NSString *)NimHandleWithSeverTime:(NSString *)time;

- (NSString *)formatSecuryCode;

@end
