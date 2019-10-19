//
//  WZPCalendar.m
//  WZPCalendar
//
//  Created by Y19092310 on 2019/10/9.
//  Copyright © 2019年 Y19092310. All rights reserved.
//

#import "WZPCalendar.h"
//#import "Masonry.h"
#import "WZPCalendarCollectionViewCell.h"
#import "WZPCalendarDataManager.h"

#define kSCREEN_WIDTH       ([UIScreen mainScreen].bounds.size.width)
#define kSCREEN_HEIGHT      ([UIScreen mainScreen].bounds.size.height)
#define kCOLORRGB(r,g,b)    [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:1]
#define kIphone6Scale(x)    ((x) * kSCREEN_WIDTH / 375.0f)
#define kWeekViewHeight     40
//默认颜色
#define kDEFAULT_YEARANDMONTH_COLOR         [UIColor blackColor]
#define kDEFAULT_WEEK_FONT_COLOR            [UIColor blackColor]
#define kDEFAULT_WEEKEND_FONT_COLOR         [UIColor greenColor]
#define kDEFAULT_TITLE_COLOR                [UIColor blackColor]
#define kDEFAULT_TITLE_BG_COLOR             [UIColor clearColor]
#define kDEFAULT_SELECTED_TITLE_COLOR       [UIColor whiteColor]
#define kDEFAULT_SELECTED_TITLE_BG_COLOR    [UIColor grayColor]
#define kDEFAULT_TODAY_TITLE_COLOR          [UIColor whiteColor]
#define kDEFAULT_TODAY_TITLE_BG_COLOR       [UIColor purpleColor]
#define kDEFAULT_SPECIAL_TITLE_COLOR        [UIColor greenColor]
#define kDEFAULT_SPECIAL_BG_COLOR           [UIColor lightGrayColor]
#define kDEFAULT_NORMAL_BG_COLOR            [UIColor whiteColor]

typedef NS_ENUM(NSInteger, WZPCalendarType)
{
    WZPCalendarLastType = 0,// 上个月
    WZPCalendarNextType     // 下个月
};

@interface WZPCalendar()<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>{
    UIView *_topView;
    UILabel *_currentMonthLb;
}

@property (nonatomic, strong) NSDate *todayDate;
@property (nonatomic, strong) NSDateFormatter *dateFormatter;

@property (nonatomic,   copy) NSString *todayDayStr;
@property (nonatomic,   copy) NSString *todayMonthStr;
@property (nonatomic,   copy) NSString *todayYearStr;

/** 记录当前年月 */
@property (nonatomic, strong) NSDate *currentDate;
@property (nonatomic, strong) NSMutableArray *calendarDataArr;
@property (nonatomic, strong) NSIndexPath *currentIndex;
@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) WZPCalendarModel *currentModel;


@end

@implementation WZPCalendar
@synthesize currentYearAndMonthFontColor    =_currentYearAndMonthFontColor;
@synthesize weekFontColor                   =_weekFontColor;
@synthesize weekendFontColor                =_weekendFontColor;

- (id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self initSomeColor];
        [self setUpView];
    }
    return self;
}
- (void)initSomeColor{
    self.currentYearAndMonthFontColor = self.currentYearAndMonthFontColor != nil ? self.currentYearAndMonthFontColor : kDEFAULT_YEARANDMONTH_COLOR;
    self.weekFontColor = self.weekFontColor != nil ? self.weekFontColor : kDEFAULT_WEEK_FONT_COLOR;
    self.weekendFontColor = self.weekendFontColor != nil ? self.weekendFontColor : kDEFAULT_WEEKEND_FONT_COLOR;
    self.titleColor = self.titleColor != nil ? self.titleColor : kDEFAULT_TITLE_COLOR;
    self.titleBgColor = self.titleBgColor != nil ? self.titleBgColor : kDEFAULT_TITLE_BG_COLOR;
    self.specialTitleColor = self.specialTitleColor != nil ? self.specialTitleColor : kDEFAULT_SELECTED_TITLE_COLOR;
    self.selectTitleColor = self.selectTitleColor != nil ? self.selectTitleColor : kDEFAULT_SELECTED_TITLE_COLOR;
    self.selectTitleBgColor = self.selectTitleBgColor != nil ? self.selectTitleBgColor : kDEFAULT_SELECTED_TITLE_BG_COLOR;
    self.todayTitleColor = self.todayTitleColor != nil ? self.todayTitleColor : kDEFAULT_TODAY_TITLE_COLOR;
    self.todayTitleBgColor = self.todayTitleBgColor != nil ? self.todayTitleBgColor : kDEFAULT_TODAY_TITLE_BG_COLOR;
    self.normalBackgroundColor = self.normalBackgroundColor != nil ? self.normalBackgroundColor : kDEFAULT_NORMAL_BG_COLOR;
    self.specialBackgroundColor = self.specialBackgroundColor != nil ? self.specialBackgroundColor : kDEFAULT_SPECIAL_BG_COLOR;
}
- (void)setCurrentYearAndMonthFontColor:(UIColor *)color{
    _currentYearAndMonthFontColor = color;
    _currentMonthLb.textColor = _currentYearAndMonthFontColor;
}

- (void)setUpView{
    self.calendarDataArr = [[NSMutableArray alloc]initWithCapacity:0];
    _dateFormatter = [[NSDateFormatter alloc]init];
    NSDate *todayDate = [NSDate date];
    [_dateFormatter setDateFormat: @"yyyy"];
    self.todayYearStr = [_dateFormatter stringFromDate:todayDate];
    [_dateFormatter setDateFormat: @"MM"];
    self.todayMonthStr = [_dateFormatter stringFromDate:todayDate];
    [_dateFormatter setDateFormat: @"dd"];
    self.todayDayStr = [_dateFormatter stringFromDate:todayDate];
    [_dateFormatter setDateFormat: @"yyyy年MM月"];
    [self addTopView];
    [self addWeekView];
    [self loadCalendarView];
}
//切换月份
- (void)addTopView{
    _topView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kSCREEN_WIDTH, 64)];
    _topView.backgroundColor = [UIColor cyanColor];
    [self addSubview:_topView];
//    [_topView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.left.right.equalTo(self);
//        make.height.mas_equalTo(64);
//    }];
    self.currentDate = [NSDate date];
    NSString *todayStr = [_dateFormatter stringFromDate:self.currentDate];
    _currentMonthLb = [[UILabel alloc]initWithFrame:CGRectMake(kSCREEN_WIDTH/3, 0, kSCREEN_WIDTH/3, 64)];
    _currentMonthLb.text = todayStr;
    _currentMonthLb.textAlignment = NSTextAlignmentCenter;
    _currentMonthLb.textColor = self.currentYearAndMonthFontColor;
    [_topView addSubview:_currentMonthLb];
    
    UIButton *lastBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [lastBtn setTitle:@"上一月" forState:UIControlStateNormal];
    [lastBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [lastBtn addTarget:self action:@selector(lastMonth) forControlEvents:UIControlEventTouchUpInside];
    lastBtn.frame = CGRectMake(0, 0, kSCREEN_WIDTH/3, 64);
    [_topView addSubview:lastBtn];
    UIButton *nextBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [nextBtn setTitle:@"下一月" forState:UIControlStateNormal];
    [nextBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [nextBtn addTarget:self action:@selector(nextMonth) forControlEvents:UIControlEventTouchUpInside];
    nextBtn.frame = CGRectMake(kSCREEN_WIDTH*2/3, 0, kSCREEN_WIDTH/3, 64);
    [_topView addSubview:nextBtn];
//    [_currentMonthLb mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.bottom.equalTo(self->_topView);
//        make.centerX.equalTo(self->_topView.mas_centerX);
//        make.width.equalTo(lastBtn.mas_width);
//    }];
//    [lastBtn mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.left.bottom.equalTo(self->_topView);
//        make.right.equalTo(self->_currentMonthLb.mas_left);
//        make.width.equalTo(nextBtn.mas_width);
//    }];
//    [nextBtn mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.right.bottom.equalTo(self->_topView);
//        make.left.equalTo(self->_currentMonthLb.mas_right);
//    }];
}
- (void)lastMonth{
    NSLog(@"上一月");
    __weak typeof(WZPCalendar) *weakSelf = self;
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [weakSelf.calendarDataArr removeAllObjects];
        [weakSelf.calendarDataArr addObjectsFromArray:[weakSelf getCalendarDataSoruceWithType:WZPCalendarLastType]];
        dispatch_async(dispatch_get_main_queue(), ^{
            [weakSelf.collectionView reloadSections:[NSIndexSet indexSetWithIndex:0]];
            _currentMonthLb.text = [_dateFormatter stringFromDate:weakSelf.currentDate];
        });
    });
}
- (void)nextMonth{
    NSLog(@"下一月");
    __weak typeof(WZPCalendar) *weakSelf = self;
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [weakSelf.calendarDataArr removeAllObjects];
        [weakSelf.calendarDataArr addObjectsFromArray:[weakSelf getCalendarDataSoruceWithType:WZPCalendarNextType]];
        dispatch_async(dispatch_get_main_queue(), ^{
            [weakSelf.collectionView reloadSections:[NSIndexSet indexSetWithIndex:0]];
            _currentMonthLb.text = [_dateFormatter stringFromDate:weakSelf.currentDate];
        });
    });
}
//星期显示
- (void)addWeekView{
    UIView *weekView = [[UIView alloc]initWithFrame:CGRectMake(0, 64, kSCREEN_WIDTH, kWeekViewHeight)];
    weekView.backgroundColor = [UIColor whiteColor];
    [self addSubview:weekView];
    
    NSArray *weekArray = @[@"一",@"二",@"三",@"四",@"五",@"六",@"日"];
    int i = 0;
    NSInteger width = kIphone6Scale(54);
    for (i = 0; i < 7;i++) {
        UILabel *weekLabel = [[UILabel alloc]initWithFrame:CGRectMake(i * width, 0, width, kWeekViewHeight)];
        weekLabel.backgroundColor = [UIColor whiteColor];
        weekLabel.text = weekArray[i];
        weekLabel.font = [UIFont boldSystemFontOfSize:16.0f];
        weekLabel.textAlignment = NSTextAlignmentCenter;
        if (i == 5 || i == 6) {
            weekLabel.textColor = self.weekendFontColor;
        } else {
            weekLabel.textColor = self.weekFontColor;
        }
        [weekView addSubview:weekLabel];
    }
}
//加载日期
- (void)loadCalendarView{
    NSInteger width = kIphone6Scale(54);
    NSInteger height = kIphone6Scale(60);
    
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc]init];
    flowLayout.itemSize = CGSizeMake(width, height);
    flowLayout.sectionInset = UIEdgeInsetsMake(0, 0, 0, 0);
    flowLayout.minimumInteritemSpacing = 0;
    flowLayout.minimumLineSpacing = 0;
    self.currentModel = nil;
    self.collectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(0, 64 + kWeekViewHeight, width * 7, self.bounds.size.height - 64 - kWeekViewHeight) collectionViewLayout:flowLayout];
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    self.collectionView.scrollEnabled = NO;
    self.collectionView.showsHorizontalScrollIndicator = NO;
    self.collectionView.showsVerticalScrollIndicator = NO;
    self.collectionView.backgroundColor = [UIColor whiteColor];
    [self addSubview:self.collectionView];
    
    [self.collectionView registerClass:[WZPCalendarCollectionViewCell class] forCellWithReuseIdentifier:@"WZPCalendarCollectionViewCell"];
    
    __weak typeof(WZPCalendar) *weakSelf = self;
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        weakSelf.currentIndex = nil;
        [weakSelf.calendarDataArr addObjectsFromArray:[weakSelf getCalendarData]];
        dispatch_async(dispatch_get_main_queue(), ^{
            NSInteger lineNum = [[WZPCalendarDataManager sharedCalendarDataManager] getNumberOfLineWithDate:[NSDate date]];
            weakSelf.frame = CGRectMake(weakSelf.frame.origin.x, weakSelf.frame.origin.y, weakSelf.bounds.size.width, 64+40+kIphone6Scale(60)*lineNum);
            weakSelf.collectionView.frame = CGRectMake(0, 64 + kWeekViewHeight, width * 7, weakSelf.bounds.size.height - 64 - kWeekViewHeight);
            [weakSelf.collectionView reloadSections:[NSIndexSet indexSetWithIndex:0]];
        });
    });
}
//获取日历数据
- (NSArray *)getCalendarData{
    _todayDate = [NSDate date];
    NSDateComponents *components = [[WZPCalendarDataManager sharedCalendarDataManager] dateToComponents:_todayDate];
    components.day = 1;
    NSDate *date = [[WZPCalendarDataManager sharedCalendarDataManager] componentsToDate:components];
    
    return [[WZPCalendarDataManager sharedCalendarDataManager] getcalendarModelArrayWithDate:date];
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.calendarDataArr.count;
}
- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    WZPCalendarModel *calendarModel = self.calendarDataArr[indexPath.row];
    WZPCalendarCollectionViewCell *cell = (WZPCalendarCollectionViewCell *)[collectionView dequeueReusableCellWithReuseIdentifier:@"WZPCalendarCollectionViewCell" forIndexPath:indexPath];
    
    cell.dateLabel.text = @"";
    
    if (self.currentModel != nil) {
        if (calendarModel.day == self.currentModel.day && calendarModel.month == self.currentModel.month && calendarModel.year == self.currentModel.year) {
            if (calendarModel.day == [self.todayDayStr integerValue] && calendarModel.month == [self.todayMonthStr integerValue] && calendarModel.year == [self.todayYearStr integerValue]) {
                cell.dateLabel.textColor = self.todayTitleColor;
                cell.dateLabel.backgroundColor = self.todayTitleBgColor;
            }else{
                cell.dateLabel.textColor = self.selectTitleColor;
                cell.dateLabel.backgroundColor = self.selectTitleBgColor;
            }
            self.currentIndex = indexPath;
        }else{
            cell.dateLabel.backgroundColor = kDEFAULT_TITLE_BG_COLOR;
            if (calendarModel.week == 5 || calendarModel.week == 6) {
                cell.dateLabel.textColor = kDEFAULT_SPECIAL_TITLE_COLOR;
            }else{
                cell.dateLabel.textColor = kDEFAULT_TITLE_COLOR;
            }
        }
    }else{
        if (calendarModel.day == [self.todayDayStr integerValue] && calendarModel.month == [self.todayMonthStr integerValue] && calendarModel.year == [self.todayYearStr integerValue]) {
            cell.dateLabel.textColor = self.todayTitleColor;
            cell.dateLabel.backgroundColor = self.todayTitleBgColor;
            self.currentIndex = indexPath;
        }else{
            cell.dateLabel.backgroundColor = kDEFAULT_TITLE_BG_COLOR;
            if (calendarModel.week == 5 || calendarModel.week == 6) {
                cell.dateLabel.textColor = kDEFAULT_SPECIAL_TITLE_COLOR;
            }else{
                cell.dateLabel.textColor = kDEFAULT_TITLE_COLOR;
            }
        }
    }
    if (calendarModel.week == 5 || calendarModel.week == 6) {
        cell.backgroundColor = self.specialBackgroundColor;
    }else{
        cell.backgroundColor = self.normalBackgroundColor;
    }
    if (calendarModel.day > 0) {
        cell.dateLabel.text = [NSString stringWithFormat:@"%ld",(long)calendarModel.day];
        cell.subLabel.text = calendarModel.holiday;
    }

    return cell;
}
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    WZPCalendarModel *calendarModel = self.calendarDataArr[indexPath.row];
    if (calendarModel.day > 0) {
        if (self.calendarSelectedDate) {
            self.calendarSelectedDate(calendarModel);
        }
        self.currentModel = calendarModel;
        //只刷新更改的两个
        if (self.currentIndex != nil) {
            if (self.currentIndex != indexPath) {
                [self.collectionView reloadItemsAtIndexPaths:@[indexPath,self.currentIndex]];
            }
        }else{
            [self.collectionView reloadItemsAtIndexPaths:@[indexPath]];
        }
        self.currentIndex = indexPath;
//        [self.collectionView reloadSections:[NSIndexSet indexSetWithIndex:0]];
    }
    
}

- (void)setCalendarSelectedDate:(WZPSelectDate)calendarSelectedDate{
    _calendarSelectedDate = calendarSelectedDate;
}
//- (void)WZPCalendarSelectedDate:(WZPSelectDate)calendar{
//    self.calendarSelectedDate = calendar;
//}
//切换月份
- (NSArray *)getCalendarDataSoruceWithType:(WZPCalendarType)type{
    NSDateComponents *components = [[WZPCalendarDataManager sharedCalendarDataManager] dateToComponents:self.currentDate];
    components.day = 1;
    if (type == WZPCalendarNextType) {
        components.month += 1;
    }else if (type == WZPCalendarLastType) {
        components.month -= 1;
    }
    self.currentDate = [[WZPCalendarDataManager sharedCalendarDataManager] componentsToDate:components];
    self.currentIndex = nil;
    return [[WZPCalendarDataManager sharedCalendarDataManager] getcalendarModelArrayWithDate:self.currentDate];
}


@end
