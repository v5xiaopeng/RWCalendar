//
//  ViewController.m
//  RWCalendar
//
//  Created by mac on 2019/10/15.
//  Copyright © 2019年 mac. All rights reserved.
//

#import "ViewController.h"
#import "Target_RWCalendar.h"

typedef void (^selectedBlock)(id);
@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    Target_RWCalendar *targ = [[Target_RWCalendar alloc]init];
    UIView *calendarView = [targ Action_initCalendar:nil];
    
    [self.view addSubview:calendarView];
    [targ Action_setupCalendar:nil];
    selectedBlock block = ^(id date){
        NSLog(@"%@",date);
    };
    [targ Action_setCalendarBlock:@{@"block":block}];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
