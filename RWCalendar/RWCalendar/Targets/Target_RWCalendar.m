//
//  Target_RWCalendar.m
//  RWCalendar
//
//  Created by mac on 2019/10/14.
//  Copyright © 2019年 mac. All rights reserved.
//

#import "Target_RWCalendar.h"
#import "WZPCalendar.h"

static WZPCalendar *__calendar;
@interface Target_RWCalendar()

@end

@implementation Target_RWCalendar

- (UIView *)Action_initCalendar:(NSDictionary *)params{
    __calendar = [[WZPCalendar alloc]initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 0)];
    
    return __calendar;
}

- (void)Action_setupCalendar:(NSDictionary *)params{
    [__calendar reloadCalendarView];
}

- (void)Action_reloadCalendarView:(NSDictionary *)params{
    [__calendar reloadCalendarView];
}
    
- (void)Action_setCalendarBlock:(NSDictionary *)params{
    __calendar.calendarSelectedDate = params[@"block"];
}

- (void)Action_setSomeColors:(NSDictionary *)params{
    __calendar.weekFontColor = params[@"weekFontColor"];
    __calendar.weekendFontColor = params[@"weekendFontColor"];
    __calendar.currentYearAndMonthFontColor = params[@"currentYearAndMonthFontColor"];
    __calendar.titleColor = params[@"titleColor"];
    __calendar.titleBgColor = params[@"titleBgColor"];
    __calendar.selectTitleColor = params[@"selectTitleColor"];
    __calendar.selectTitleBgColor = params[@"selectTitleBgColor"];
    __calendar.todayTitleColor = params[@"todayTitleColor"];
    __calendar.todayTitleBgColor = params[@"todayTitleBgColor"];
    __calendar.normalBackgroundColor = params[@"normalBackgroundColor"];
    __calendar.specialTitleColor = params[@"specialTitleColor"];
    __calendar.specialBackgroundColor = params[@"specialBackgroundColor"];
}

@end
