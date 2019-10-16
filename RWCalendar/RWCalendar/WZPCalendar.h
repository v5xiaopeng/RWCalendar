//
//  WZPCalendar.h
//  WZPCalendar
//
//  Created by Y19092310 on 2019/10/9.
//  Copyright © 2019年 Y19092310. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WZPCalendarModel.h"

typedef void(^WZPSelectDate)(id date);

@interface WZPCalendar : UIView

/** 当前年月字体颜色 默认black */
@property (nonatomic, strong) UIColor *currentYearAndMonthFontColor;
/** 星期1-5字体颜色 默认black */
@property (nonatomic, strong) UIColor *weekFontColor;
/** 周末字体颜色 默认green */
@property (nonatomic, strong) UIColor *weekendFontColor;
//-----日期相关设置-----//
/** 字体颜色 默认black */
@property (nonatomic, strong) UIColor *titleColor;
/** 字体背景颜色 默认clear */
@property (nonatomic, strong) UIColor *titleBgColor;
/** 选中日期字体颜色 默认white */
@property (nonatomic, strong) UIColor *selectTitleColor;
/** 选中日期title背景颜色 默认gray */
@property (nonatomic, strong) UIColor *selectTitleBgColor;
/** 今天title颜色 默认white */
@property (nonatomic, strong) UIColor *todayTitleColor;
/** 今天title背景颜色 默认purple */
@property (nonatomic, strong) UIColor *todayTitleBgColor;
/** 背景颜色 默认white */
@property (nonatomic, strong) UIColor *normalBackgroundColor;
/** 特殊日期字体颜色 默认green */
@property (nonatomic, strong) UIColor *specialTitleColor;
/** 特殊日期背景颜色 默认lightGray */
@property (nonatomic, strong) UIColor *specialBackgroundColor;

- (void)setUpView;

@property (nonatomic, copy) WZPSelectDate calendarSelectedDate;
- (void)setCalendarSelectedDate:(WZPSelectDate)calendarSelectedDate;
- (void)WZPCalendarSelectedDate:(WZPSelectDate)calendar;

@end
