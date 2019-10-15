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

+ (WZPCalendarDataManager *)sharedCalendarDataManager;
- (NSInteger)getNumberOfLineWithDate:(NSDate *)date;
// 得到每一天的数据源
- (NSArray *)getcalendarModelArrayWithDate:(NSDate *)date;

- (NSDateComponents *)dateToComponents:(NSDate *)date;
- (NSDate *)componentsToDate:(NSDateComponents *)components;

@end
