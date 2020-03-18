//
//  NSDate+NimCaculate.h
//  NIM
//
//  Created by MiaoYe on 2016/11/25.
//  Copyright © 2016年 Kingwelan. All rights reserved.
//

#import <Foundation/Foundation.h>

//日期类型
typedef  NS_ENUM(NSInteger, NimDateType) {
    NimDate_Second          = 0,    //秒
    NimDate_Minute          ,       //分
    NimDate_Hour            ,       //时
    NimDate_Day             ,       //天
    NimDate_Month           ,       //月
    NimDate_Year            ,       //年
    
};


@interface NSDate (NimCaculate)

/**
 *  根据格式产生日起的字符串表示
 *
 *  @param format 时间格式串，例如 yyyy-MM-dd HH:mm:ss
 *
 *  @return NSString对象
 */
- (NSString *)NimStringWithDateFormat:(NSString *)format;

/**
 *  与当前时间比较，并返回时间表示，比如：昨天，1小时前 等等
 *
 *  @return NSString对象
 */
- (NSString *)NimTimeAgo;

/**
 *  与当前时间比较，并返回时间差的表述，比如 xx年xx月xx日，xx日xx时 等等
 *
 *  @return NSString对象
 */
- (NSString *)NimTimeLeft;

/**
 *  取基于timeIntervalSince1970的时间戳
 *
 *  @return long long
 */
+ (long long)NimTimeStamp;

/**
 *  yyyMMddHHmmss格式的时间转到NSDate，结果为UTC时间，不带时区信息的
 *
 *  @param dateStr 时间串
 *  @format 默认 yyyMMddHHmmss串
 *  @return NSDate对象
 */
+(NSDate*) NimDateFromString:(NSString*)dateStr andFormat:(NSString *)format;

/** 年 */
@property (nonatomic, readonly) NSInteger	nimYear;

/** 月 */
@property (nonatomic, readonly) NSInteger	nimMonth;

/** 日 */
@property (nonatomic, readonly) NSInteger	nimDay;

/** 时 */
@property (nonatomic, readonly) NSInteger	nimHour;

/** 分 */
@property (nonatomic, readonly) NSInteger	nimMinute;

/** 秒 */
@property (nonatomic, readonly) NSInteger	nimSecond;

/** 星期 */
@property (nonatomic, readonly) NSInteger	nimWeekday;



#pragma mark - 时间间隔
/**
 *  获取某个时间段的时间
 *
 *  @param time 时间间隔
 *  @param type 类型：年，月，日，时，分，秒
 *
 *  @return 所需的时间
 */
- (NSDate *)NimDteAfterTime:(NSTimeInterval)time andDateType:(NimDateType)type;

#pragma mark - 两个时间类型的
+ (NSString *)NimDateStr:(NSString *)dateStr andSourceFomate:(NSString *)scrFomate andDestinFomate:(NSString *)desFomate;

@end
