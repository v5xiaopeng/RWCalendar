//
//  WZPCalendarModel.h
//  WZPCalendar
//
//  Created by Y19092310 on 2019/10/9.
//  Copyright © 2019年 Y19092310. All rights reserved.
//

#import <Foundation/Foundation.h>

/** 预留特殊日期类型 */
typedef NS_ENUM(NSInteger, WZPCalendarSpecialDayType)
{
    WZPCalendarSpecialDayBirthDayType = 0,  // 生日
    WZPCalendarSpecialDayPayDayType,        // 发薪日
};

@interface WZPCalendarModel : NSObject

/** 年 */
@property (nonatomic, assign) NSInteger year;
/** 月 */
@property (nonatomic, assign) NSInteger month;
/** 日 */
@property (nonatomic, assign) NSInteger day;
/** 周几 */
@property (nonatomic, assign) NSInteger week;
/** 日期的时间戳 */
@property (nonatomic, assign) NSInteger dateInterval;
/** 节日 */
@property (nonatomic,   copy) NSString *holiday;
/**
 预留 特殊日期类型
 */
@property (nonatomic, assign) WZPCalendarSpecialDayType specialDayType;

@end
