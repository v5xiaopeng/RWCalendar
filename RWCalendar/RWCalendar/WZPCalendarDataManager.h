//
//  WZPCalendarDataManager.h
//  WZPCalendar
//
//  Created by Y19092310 on 2019/10/11.
//  Copyright © 2019年 Y19092310. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WZPCalendarModel.h"

@interface WZPCalendarDataManager : NSObject


/** 日历数据处理单例 */
+ (WZPCalendarDataManager *)sharedCalendarDataManager;

/**
 获取一个月有多少天

 @param date 要获取的月份
 @return 天数
 */
- (NSInteger)getNumberOfLineWithDate:(NSDate *)date;

/**
 根据date得到当月每一天的数据

 @param date 要获取的月份
 @return 每一天数据，存放WZPCalendarModel对象的数组
 */
- (NSArray *)getcalendarModelArrayWithDate:(NSDate *)date;

//  NSDate和NSCompontents转换
/**
 NSCompontents转NSDate

 @param date 要转化的date
 @return components
 */
- (NSDateComponents *)dateToComponents:(NSDate *)date;

/**
 NSDate转NSCompontents
 
 @param components 要转化的components
 @return date
 */
- (NSDate *)componentsToDate:(NSDateComponents *)components;

@end
