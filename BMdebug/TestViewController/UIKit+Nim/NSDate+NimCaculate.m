//
//  NSDate+NimCaculate.m
//  NIM
//
//  Created by MiaoYe on 2016/11/25.
//  Copyright © 2016年 Kingwelan. All rights reserved.
//

#import "NSDate+NimCaculate.h"

#define SECOND	(1)
#define MINUTE	(60 * SECOND)
#define HOUR	(60 * MINUTE)
#define DAY		(24 * HOUR)
#define MONTH	(30 * DAY)
#define YEAR	(12 * MONTH)
@implementation NSDate (NimCaculate)

@dynamic nimYear;
@dynamic nimMonth;
@dynamic nimDay;
@dynamic nimHour;
@dynamic nimMinute;
@dynamic nimSecond;
@dynamic nimWeekday;

- (NSInteger)NimYear{
    return [[NSCalendar currentCalendar] components:NSCalendarUnitYear
                                           fromDate:self].year;
}

- (NSInteger)NimMonth{
    return [[NSCalendar currentCalendar] components:NSCalendarUnitMonth
                                           fromDate:self].month;
}

- (NSInteger)NimDay{
    return [[NSCalendar currentCalendar] components:NSCalendarUnitDay
                                           fromDate:self].day;
}

- (NSInteger)NimHour{
    return [[NSCalendar currentCalendar] components:NSCalendarUnitHour
                                           fromDate:self].hour;
}

- (NSInteger)NimMinute{
    return [[NSCalendar currentCalendar] components:NSCalendarUnitMinute
                                           fromDate:self].minute;
}

- (NSInteger)NimSecond{
    return [[NSCalendar currentCalendar] components:NSCalendarUnitSecond
                                           fromDate:self].second;
}

- (NSInteger)NimWeekday{
    return [[NSCalendar currentCalendar] components:NSCalendarUnitWeekday
                                           fromDate:self].weekday;
}

- (NSString *)NimStringWithDateFormat:(NSString *)format{
    NSDateFormatter * dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:format];
    return [dateFormatter stringFromDate:self];
}

- (NSString *)NimTimeAgo{
    NSTimeInterval delta = [[NSDate date] timeIntervalSinceDate:self];
    
    if (delta < 1 * MINUTE){
        return @"刚刚";
    }else if (delta < 2 * MINUTE){
        return @"1分钟前";
    }else if (delta < 45 * MINUTE){
        int minutes = floor((double)delta/MINUTE);
        return [NSString stringWithFormat:@"%d分钟前", minutes];
    }else if (delta < 90 * MINUTE){
        return @"1小时前";
    }else if (delta < 24 * HOUR){
        int hours = floor((double)delta/HOUR);
        return [NSString stringWithFormat:@"%d小时前", hours];
    }else if (delta < 48 * HOUR){
        return @"昨天";
    }else if (delta < 30 * DAY){
        int days = floor((double)delta/DAY);
        return [NSString stringWithFormat:@"%d天前", days];
    }else if (delta < 12 * MONTH){
        int months = floor((double)delta/MONTH);
        return months <= 1 ? @"1个月前" : [NSString stringWithFormat:@"%d个月前", months];
    }
    
    int years = floor((double)delta/MONTH/12.0);
    return years <= 1 ? @"1年前" : [NSString stringWithFormat:@"%d年前", years];
}

- (NSString *)NimTimeLeft
{
    long int delta = lround( [self timeIntervalSinceDate:[NSDate date]] );
    
    NSMutableString * result = [NSMutableString string];
    
    if ( delta >= YEAR ){
        NSInteger years = ( delta / YEAR );
        [result appendFormat:@"%d年", (int)years];
        delta -= years * YEAR ;
    }
    
    if ( delta >= MONTH ){
        NSInteger months = ( delta / MONTH );
        [result appendFormat:@"%d月", (int)months];
        delta -= months * MONTH ;
    }
    
    if ( delta >= DAY ){
        NSInteger days = ( delta / DAY );
        [result appendFormat:@"%d天", (int)days];
        delta -= days * DAY ;
    }
    
    if ( delta >= HOUR ){
        NSInteger hours = ( delta / HOUR );
        [result appendFormat:@"%d小时", (int)hours];
        delta -= hours * HOUR ;
    }
    
    if ( delta >= MINUTE ){
        NSInteger minutes = ( delta / MINUTE );
        [result appendFormat:@"%d分钟", (int)minutes];
        delta -= minutes * MINUTE ;
    }
    
    NSInteger seconds = ( delta / SECOND );
    [result appendFormat:@"%d秒", (int)seconds];
    
    return result;
}

+ (long long)NimTimeStamp{
    return (long long)[[NSDate date] timeIntervalSince1970];
}

+(NSDate*) NimDateFromString:(NSString*)dateStr andFormat:(NSString *)format{
    
    if (!format) {
        format = @"yyyyMMddHHmmss";
    }
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init] ;
    [formatter setDateFormat:format];
    NSDate *date=[formatter dateFromString:dateStr];
    return date;
}



#pragma mark - 时间管理
/**
 *  获取某个时间段的时间
 *
 *  @param time 时间间隔
 *  @param type 类型：年，月，日，时，分，秒
 *
 *  @return 所需的时间
 */
- (NSDate *)NimDteAfterTime:(NSTimeInterval)time andDateType:(NimDateType)type{
    
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSDateComponents *comps = nil;
    comps = [calendar components:NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitDay fromDate:self];
    NSDateComponents *adcomps = [[NSDateComponents alloc] init];
    
    NSInteger year = 0;
    NSInteger month = 0;
    NSInteger day = 0;
    NSInteger hour = 0;
    NSInteger minute = 0;
    NSInteger second = 0;
    
    if (NimDate_Year == type) {
        year = time;
    }else if(NimDate_Month == type){
        month = time;
    }else if(NimDate_Day == type){
        day = time;
    }else if(NimDate_Hour == type){
        hour = time;
    }else if(NimDate_Minute == type){
        minute = time;
    }else{
        second = time;
    }
    
    [adcomps setYear:year];
    [adcomps setMonth:month];
    [adcomps setDay:day];
    [adcomps setHour:hour];
    [adcomps setMinute:minute];
    [adcomps setSecond:second];
    
    NSDate *newdate = [calendar dateByAddingComponents:adcomps toDate:self options:0];
    return newdate;
}

#pragma mark - 两个时间类型的
+ (NSString *)NimDateStr:(NSString *)dateStr andSourceFomate:(NSString *)scrFomate andDestinFomate:(NSString *)desFomate{
    NSDate *date = [NSDate NimDateFromString:dateStr andFormat:scrFomate];
    NSString *str = [date NimStringWithDateFormat:desFomate];
    return str;
}


@end
