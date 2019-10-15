//
//  Target_RWCalendar.m
//  RWCalendar
//
//  Created by mac on 2019/10/14.
//  Copyright © 2019年 mac. All rights reserved.
//

#import "Target_RWCalendar.h"
#import "WZPCalendar.h"

@interface Target_RWCalendar()

@property (nonatomic, strong) WZPCalendar *calendar;

@end

@implementation Target_RWCalendar

- (UIView *)Action_initCalendar:(NSDictionary *)params{
    _calendar = [[WZPCalendar alloc]initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 0)];
    
    _calendar.weekFontColor = [UIColor grayColor];
    _calendar.weekendFontColor = [UIColor orangeColor];
    _calendar.currentYearAndMonthFontColor = [UIColor redColor];
    return _calendar;
}

- (void)Action_setupCalendar:(NSDictionary *)params{
    [_calendar setUpView];
}
    
- (void)Action_setCalendarBlock:(NSDictionary *)params{
    typedef void (^selectedBlock)(id);
    selectedBlock block = params[@"block"];
    
    [_calendar WZPCalendarSelectedDate:^(id date) {
        if (block) {
            block(date);
        }
//        WZPCalendarModel *model = date;
//        NSLog(@"-%ld年%ld月%ld日 周%ld-",(long)model.year,model.month,model.day,model.week+1);
    }];
}

@end
