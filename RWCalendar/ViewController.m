//
//  ViewController.m
//  RWCalendar
//
//  Created by mac on 2019/10/15.
//  Copyright © 2019年 mac. All rights reserved.
//

#import "ViewController.h"
#import "Target_RWCalendar.h"
#import "WZPCalendar.h"
#import <Masonry/Masonry.h>

@interface ViewController (){
    Target_RWCalendar *_targ;
}

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
//    UIView *calendarView = [[Target_RWCalendar alloc] Action_initCalendar:nil];
//
//    [self.view addSubview:calendarView];
//    UIView *bgView = [[UIView alloc]init];
//    bgView.backgroundColor = [UIColor redColor];
//    [self.view addSubview:bgView];
//    [bgView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.mas_equalTo(50);
//        make.centerX.equalTo(self.view);
//        make.width.mas_equalTo(300);
//        make.height.mas_greaterThanOrEqualTo(50);
//    }];
    WZPCalendar *calendar = [[WZPCalendar alloc]init];//WithFrame:CGRectZero];
    calendar.todayTitleColor = [UIColor cyanColor];
    calendar.todayTitleBgColor = [UIColor orangeColor];
    [self.view addSubview:calendar];
    [calendar mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.left.bottom.right.equalTo(bgView);
        make.top.mas_equalTo(50);
        make.left.right.equalTo(self.view);
        make.height.mas_greaterThanOrEqualTo(300);
//        make.width.mas_greaterThanOrEqualTo(300);
    }];
    calendar.calendarSelectedDate = ^(WZPCalendarModel *date) {
        
        NSLog(@"%ld-%ld-%ld",(long)date.year,(long)date.month,(long)date.day);
    };
}
//- (void)setAblock:(void(^)(id date))block{
//
//    [_targ Action_setCalendarBlock:@{@"block":block}];
//}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
