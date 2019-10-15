//
//  WZPCalendarModel.h
//  WZPCalendar
//
//  Created by Y19092310 on 2019/10/9.
//  Copyright © 2019年 Y19092310. All rights reserved.
//

#import <Foundation/Foundation.h>

/** 特殊日期 */
typedef NS_ENUM(NSInteger, WZPCalendarSpecialDayType)
{
    WZPCalendarSpecialDayBirthDayType = 0,  // 生日
    WZPCalendarSpecialDayPayDayType,        // 发薪日
};

@interface WZPCalendarModel : NSObject

@property (nonatomic, assign) NSInteger year;
@property (nonatomic, assign) NSInteger month;
@property (nonatomic, assign) NSInteger day;
@property (nonatomic, assign) NSInteger week;
@property (nonatomic, assign) NSInteger dateInterval;// 日期的时间戳
@property (nonatomic,   copy) NSString *holiday;// 节日

@property (nonatomic, assign) WZPCalendarSpecialDayType specialDayType;

@end
