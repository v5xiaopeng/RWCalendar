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
    
    __calendar.weekFontColor = [UIColor grayColor];
    __calendar.weekendFontColor = [UIColor orangeColor];
    __calendar.currentYearAndMonthFontColor = [UIColor redColor];
    return __calendar;
}

- (void)Action_setupCalendar:(NSDictionary *)params{
    [__calendar setUpView];
}
    
- (void)Action_setCalendarBlock:(NSDictionary *)params{
    __calendar.calendarSelectedDate = params[@"block"];
}

@end
