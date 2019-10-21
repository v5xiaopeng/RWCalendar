//
//  WZPCalendarDataManager.m
//  WZPCalendar
//
//  Created by Y19092310 on 2019/10/11.
//  Copyright © 2019年 Y19092310. All rights reserved.
//

#import "WZPCalendarDataManager.h"

@interface WZPCalendarDataManager()

@property (nonatomic, strong) NSDateComponents *todayCompontents;
@property (nonatomic, strong) NSCalendar *greCalendar;

@end

@implementation WZPCalendarDataManager

static WZPCalendarDataManager *__manager;
+ (WZPCalendarDataManager *)sharedCalendarDataManager{
    static dispatch_once_t oneToken;
    
    dispatch_once(&oneToken, ^{
        
        __manager = [[WZPCalendarDataManager alloc]init];
        __manager.todayCompontents = [__manager dateToComponents:[NSDate date]];
        __manager.greCalendar = [[NSCalendar alloc]initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
//        __manager.greCalendar.firstWeekday = 1;
    });
    return __manager;
}

//  获取行数
- (NSInteger)getNumberOfLineWithDate:(NSDate *)date{
    NSInteger tatalDay = [self numberOfDaysInCurrentMonth:date];
    NSInteger firstDay = [self startDayOfWeek:date];
    
    //  判断日历有多少行
    NSInteger tempDay = tatalDay + (firstDay - 1);
    NSInteger column = 0;
    if (tempDay % 7 == 0) {
        column = tempDay / 7;
    } else {
        column = tempDay / 7 + 1;
    }
    return column;
}

//  得到每一天的数据源
- (NSArray *)getcalendarModelArrayWithDate:(NSDate *)date{
    NSMutableArray *resultArray = [[NSMutableArray alloc]init];
    NSInteger tatalDay = [self numberOfDaysInCurrentMonth:date];
    NSInteger firstDay = [self startDayOfWeek:date];
    NSDateComponents *components = [self dateToComponents:date];
    
    // 判断日历有多少行
    NSInteger column = [self getNumberOfLineWithDate:date];
    
    NSInteger i = 0;
    NSInteger j = 0;
    components.day = 0;
    for (i = 0;i < column;i++) {
        for (j = 0;j < 7;j++) {
            if (i == 0 && j < firstDay - 1) {
                WZPCalendarModel *calendarModel = [[WZPCalendarModel alloc]init];
                calendarModel.year = 0;
                calendarModel.month = 0;
                calendarModel.day = 0;
                calendarModel.holiday = @"";
                calendarModel.week = -1;
                calendarModel.dateInterval = -1;
                [resultArray addObject:calendarModel];
                continue;
            }
            components.day += 1;
            if (components.day == tatalDay + 1) {
                i = column;// 结束外层循环
                break;
            }
            WZPCalendarModel *calendarModel = [[WZPCalendarModel alloc]init];
            calendarModel.year = components.year;
            calendarModel.month = components.month;
            calendarModel.day = components.day;
            calendarModel.week = j;
            NSDate *date = [self componentsToDate:components];
            // 时间戳
            calendarModel.dateInterval = [self dateToInterval:date];
            [self setChineseCalendarAndHolidayWithDate:components date:date calendarModel:calendarModel];
            
            [resultArray addObject:calendarModel];
        }
    }
    return resultArray;
}

// 一个月有多少天
- (NSUInteger)numberOfDaysInCurrentMonth:(NSDate *)date{
    return [_greCalendar rangeOfUnit:NSCalendarUnitDay inUnit:NSCalendarUnitMonth forDate:date].length;
}

//  确定这个月的第一天是星期几
- (NSUInteger)startDayOfWeek:(NSDate *)date{
    NSDate *startDate = nil;
    BOOL result = [_greCalendar rangeOfUnit:NSCalendarUnitMonth startDate:&startDate interval:NULL forDate:date];
    if (result) {
        return ([_greCalendar ordinalityOfUnit:NSCalendarUnitDay inUnit:NSCalendarUnitWeekOfMonth forDate:startDate]-1) == 0?7:([_greCalendar ordinalityOfUnit:NSCalendarUnitDay inUnit:NSCalendarUnitWeekOfMonth forDate:startDate]-1);
    }
    return 0;
}

//  日期转时间戳
- (NSInteger)dateToInterval:(NSDate *)date{
    return (long)[date timeIntervalSince1970];
}

#pragma mark - 农历和节假日
- (void)setChineseCalendarAndHolidayWithDate:(NSDateComponents *)components date:(NSDate *)date calendarModel:(WZPCalendarModel *)calendarModel{
    if (components.year == _todayCompontents.year && components.month == _todayCompontents.month && components.day == _todayCompontents.day) {
        calendarModel.holiday = @"今天";
    }
    
    if (components.month == 1 && components.day == 1) {
        calendarModel.holiday = @"元旦";
    }
    else if (components.month == 2 && components.day == 14) {
        calendarModel.holiday = @"情人节";
    }
    else if (components.month == 3 && components.day == 8) {
        calendarModel.holiday = @"妇女节";
    }
    else if (components.month == 4 && components.day == 1) {
        calendarModel.holiday = @"愚人节";
    }
    else if (components.month == 4 && (components.day == 4 || components.day == 5 || components.day == 6)) {
        if ([self isQingMingholidayWithYear:components.year month:components.month day:components.day]) {
            calendarModel.holiday = @"清明节";
        }
    }
    else if (components.month == 5 && components.day == 1) {
        calendarModel.holiday = @"劳动节";
    }
    else if (components.month == 5 && components.day == 4) {
        calendarModel.holiday = @"青年节";
    }
    else if (components.month == 6 && components.day == 1) {
        calendarModel.holiday = @"儿童节";
    }
    else if (components.month == 8 && components.day == 1) {
        calendarModel.holiday = @"建军节";
    }
    else if (components.month == 9 && components.day == 10) {
        calendarModel.holiday = @"教师节";
    }
    else if (components.month == 10 && components.day == 1) {
        calendarModel.holiday = @"国庆节";
    }
    else if (components.month == 1 && components.day == 1) {
        calendarModel.holiday = @"元旦";
    }
    else if (components.month == 11 && components.day == 11) {
        calendarModel.holiday = @"光棍节";
    }
    else if (components.month == 12 && components.day == 25) {
        calendarModel.holiday = @"圣诞节";
    }
}
/*
 清明节日期的计算 [Y*D+C]-L
 公式解读：Y=年数后2位，D=0.2422，L=闰年数，21世纪C=4.81，20世纪=5.59。
 */
- (BOOL)isQingMingholidayWithYear:(NSInteger)year month:(NSInteger)month day:(NSInteger)day{
    if (month == 4) {
//        NSInteger pre = year / 100;
        NSArray *coefficient = @[@5.15, @5.37, @5.59, @4.82, @5.02, @5.26, @5.48, @4.70, @4.92, @5.135, @5.36, @4.60, @4.81, @5.04, @5.26];
        
        NSNumber *cNumber = coefficient[year / 100 - 17];
        float c = [cNumber floatValue];
//        float c = 4.81;
//        if (pre == 19) {
//            c = 5.59;
//        }
        
        NSInteger y = year % 100;
        NSInteger qingMingDay = (y * 0.2422 + c) - y / 4;
        if (day == qingMingDay) {
            return YES;
        }
    }
    
    return NO;
}

#pragma mark - NSDate和NSCompontents转换
- (NSDateComponents *)dateToComponents:(NSDate *)date{
    NSDateComponents *components = [_greCalendar components:(NSCalendarUnitEra | NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond) fromDate:date];
    return components;
}

- (NSDate *)componentsToDate:(NSDateComponents *)components{
    // 不区分时分秒
    components.hour = 0;
    components.minute = 0;
    components.second = 0;
    NSDate *date = [_greCalendar dateFromComponents:components];
    return date;
}

@end
