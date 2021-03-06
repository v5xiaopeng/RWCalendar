//
//  WZPCalendar.m
//  WZPCalendar
//
//  Created by Y19092310 on 2019/10/9.
//  Copyright © 2019年 Y19092310. All rights reserved.
//

#import "WZPCalendar.h"
#import <Masonry/Masonry.h>
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
@property (nonatomic, strong) NSMutableArray *weekLbs;

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

//- (id)initWithFrame:(CGRect)frame{
//    self = [super initWithFrame:frame];
//    if (self) {
//        [self initSomeColor];
//        [self setUpView];
//    }
//    return self;
//}
- (void)drawRect:(CGRect)rect{
    [self initSomeColor];
    [self setUpView];
}
//  初始化一些颜色
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

- (void)setUpView{
    self.weekLbs = [[NSMutableArray alloc]initWithCapacity:0];
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

- (void)reloadCalendarView{
    //  当前年月颜色
    _currentMonthLb.textColor = self.currentYearAndMonthFontColor;
    //  周一到周日颜色
    for (int i = 0; i < self.weekLbs.count; i++) {
        UILabel *weekLb = self.weekLbs[i];
        if (i == 5 || i == 6) {
            weekLb.textColor = self.weekendFontColor;
        } else {
            weekLb.textColor = self.weekFontColor;
        }
    }
    //  每天颜色
    [self.collectionView reloadData];
}

//  切换月份控件
- (void)addTopView{
    _topView = [[UIView alloc]init];//WithFrame:CGRectMake(0, 0, kSCREEN_WIDTH, 64)];
//    _topView.backgroundColor = [UIColor cyanColor];
    [self addSubview:_topView];
    [_topView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(self);
        make.height.mas_equalTo(64);
    }];
    
    self.currentDate = [NSDate date];
    NSString *todayStr = [_dateFormatter stringFromDate:self.currentDate];
    _currentMonthLb = [[UILabel alloc]initWithFrame:CGRectMake(kSCREEN_WIDTH/3, 0, kSCREEN_WIDTH/3, 64)];
    _currentMonthLb.text = todayStr;
    _currentMonthLb.textAlignment = NSTextAlignmentCenter;
    _currentMonthLb.textColor = self.currentYearAndMonthFontColor;
    [_topView addSubview:_currentMonthLb];
    [_currentMonthLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.centerX.equalTo(self->_topView);
        make.width.mas_equalTo(self.bounds.size.width/3.0);
    }];
    
    UIButton *lastBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [lastBtn setTitle:@"上一月" forState:UIControlStateNormal];
    [lastBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [lastBtn addTarget:self action:@selector(lastMonth) forControlEvents:UIControlEventTouchUpInside];
    lastBtn.frame = CGRectMake(0, 0, kSCREEN_WIDTH/3, 64);
    [_topView addSubview:lastBtn];
    [lastBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.bottom.equalTo(self->_topView);
        make.right.mas_equalTo(self->_currentMonthLb.mas_left);
    }];
    UIButton *nextBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [nextBtn setTitle:@"下一月" forState:UIControlStateNormal];
    [nextBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [nextBtn addTarget:self action:@selector(nextMonth) forControlEvents:UIControlEventTouchUpInside];
    nextBtn.frame = CGRectMake(kSCREEN_WIDTH*2/3, 0, kSCREEN_WIDTH/3, 64);
    [_topView addSubview:nextBtn];
    [nextBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.right.bottom.equalTo(self->_topView);
        make.left.mas_equalTo(self->_currentMonthLb.mas_right);
    }];

}
//  切换月份Action
- (void)lastMonth{
    __weak typeof(WZPCalendar) *weakSelf = self;
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [weakSelf.calendarDataArr removeAllObjects];
        [weakSelf.calendarDataArr addObjectsFromArray:[weakSelf getCalendarDataSoruceWithType:WZPCalendarLastType]];
        dispatch_async(dispatch_get_main_queue(), ^{
            NSInteger lineNum = [[WZPCalendarDataManager sharedCalendarDataManager] getNumberOfLineWithDate:weakSelf.currentDate];
            [weakSelf.collectionView mas_updateConstraints:^(MASConstraintMaker *make) {
                make.height.mas_equalTo(kIphone6Scale(60)*lineNum);
            }];
            [weakSelf.collectionView reloadSections:[NSIndexSet indexSetWithIndex:0]];
            self->_currentMonthLb.text = [self->_dateFormatter stringFromDate:weakSelf.currentDate];
        });
    });
}

- (void)nextMonth{
    __weak typeof(WZPCalendar) *weakSelf = self;
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [weakSelf.calendarDataArr removeAllObjects];
        [weakSelf.calendarDataArr addObjectsFromArray:[weakSelf getCalendarDataSoruceWithType:WZPCalendarNextType]];
        dispatch_async(dispatch_get_main_queue(), ^{
            NSInteger lineNum = [[WZPCalendarDataManager sharedCalendarDataManager] getNumberOfLineWithDate:weakSelf.currentDate];
            [weakSelf.collectionView mas_updateConstraints:^(MASConstraintMaker *make) {
                make.height.mas_equalTo(kIphone6Scale(60)*lineNum);
            }];
            [weakSelf.collectionView reloadSections:[NSIndexSet indexSetWithIndex:0]];
            self->_currentMonthLb.text = [self->_dateFormatter stringFromDate:weakSelf.currentDate];
        });
    });
}
//  星期显示，周一到周日
- (void)addWeekView{
    UIView *weekView = [[UIView alloc]init];//WithFrame:CGRectMake(0, 64, kSCREEN_WIDTH, kWeekViewHeight)];
    weekView.backgroundColor = [UIColor whiteColor];
    [self addSubview:weekView];
    [weekView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self->_topView.mas_bottom);
        make.left.right.equalTo(self);
        make.height.mas_equalTo(kWeekViewHeight);
    }];
    
    NSArray *weekArray = @[@"一",@"二",@"三",@"四",@"五",@"六",@"日"];
    int i = 0;
    if (self.weekLbs.count > 0) {
        [self.weekLbs removeAllObjects];
    }
    CGFloat perWeekWidth = self.bounds.size.width/7.0;
    for (i = 0; i < 7;i++) {
        UILabel *weekLabel = [[UILabel alloc]initWithFrame:CGRectMake(i * perWeekWidth, 0, perWeekWidth, kWeekViewHeight)];
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
        [weekLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(weekView);
            make.left.mas_equalTo(i * perWeekWidth);
            make.width.mas_equalTo(perWeekWidth);
            make.height.mas_equalTo(kWeekViewHeight);
        }];
        [self.weekLbs addObject:weekLabel];
    }
}

//  加载日历collectionView
- (void)loadCalendarView{
//    NSInteger width = kIphone6Scale(54);
//    NSInteger height = kIphone6Scale(60);
    
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    
    self.currentModel = nil;
    self.collectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(0, 64 + kWeekViewHeight, kSCREEN_WIDTH, self.bounds.size.height - 64 - kWeekViewHeight) collectionViewLayout:flowLayout];
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    self.collectionView.scrollEnabled = NO;
    self.collectionView.showsHorizontalScrollIndicator = NO;
    self.collectionView.showsVerticalScrollIndicator = NO;
    self.collectionView.backgroundColor = [UIColor whiteColor];
    [self addSubview:self.collectionView];
    NSInteger lineNum = [[WZPCalendarDataManager sharedCalendarDataManager] getNumberOfLineWithDate:self.currentDate];
    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(64 + kWeekViewHeight);
        make.left.bottom.right.equalTo(self);
        make.height.mas_equalTo(kIphone6Scale(60)*lineNum);
    }];
    
    [self.collectionView registerClass:[WZPCalendarCollectionViewCell class] forCellWithReuseIdentifier:@"WZPCalendarCollectionViewCell"];
    
    __weak typeof(WZPCalendar) *weakSelf = self;
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        weakSelf.currentIndex = nil;
        [weakSelf.calendarDataArr addObjectsFromArray:[weakSelf getCalendarData]];
        dispatch_async(dispatch_get_main_queue(), ^{
            NSInteger lineNum = [[WZPCalendarDataManager sharedCalendarDataManager] getNumberOfLineWithDate:[NSDate date]];
            [weakSelf.collectionView mas_updateConstraints:^(MASConstraintMaker *make) {
                make.height.mas_equalTo(kIphone6Scale(60)*lineNum);
            }];
            [weakSelf.collectionView reloadSections:[NSIndexSet indexSetWithIndex:0]];
        });
    });
}

//  获取日历数据
- (NSArray *)getCalendarData{
    _todayDate = [NSDate date];
    NSDateComponents *components = [[WZPCalendarDataManager sharedCalendarDataManager] dateToComponents:_todayDate];
    components.day = 1;
    NSDate *date = [[WZPCalendarDataManager sharedCalendarDataManager] componentsToDate:components];
    
    return [[WZPCalendarDataManager sharedCalendarDataManager] getcalendarModelArrayWithDate:date];
}
#pragma mark - UICollectionViewDelegateFlowLayout
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return CGSizeMake(self.bounds.size.width/7.0, kIphone6Scale(60));
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    return 0;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    return 0;
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    return UIEdgeInsetsMake(0, 0, 0, 0);
}
#pragma mark - 日历每一天 collectionView delegate
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

//  选中日期block的set方法
- (void)setCalendarSelectedDate:(WZPSelectDate)calendarSelectedDate{
    _calendarSelectedDate = calendarSelectedDate;
}

//  切换月份
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
