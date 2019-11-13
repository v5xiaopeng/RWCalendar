//
//  ViewController.m
//  RWCalendar
//
//  Created by mac on 2019/10/15.
//  Copyright © 2019年 mac. All rights reserved.
//

#import "ViewController.h"
#import "Target_RWCalendar.h"

@interface ViewController (){
    Target_RWCalendar *_targ;
}

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    UIView *calendarView = [[Target_RWCalendar alloc] Action_initCalendar:nil];
    
    [self.view addSubview:calendarView];
}
- (void)setAblock:(void(^)(id date))block{
    
    [_targ Action_setCalendarBlock:@{@"block":block}];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
