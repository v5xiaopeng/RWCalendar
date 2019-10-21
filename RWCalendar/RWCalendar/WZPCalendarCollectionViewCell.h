//
//  WZPCalendarCollectionViewCell.h
//  WZPCalendar
//
//  Created by Y19092310 on 2019/10/9.
//  Copyright © 2019年 Y19092310. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WZPCalendarCollectionViewCell : UICollectionViewCell

/** 字体颜色 默认black */
@property (nonatomic, strong) UIColor *titleColor;
/** 特殊日期字体颜色 默认green */
@property (nonatomic, strong) UIColor *specialTitleColor;
/** 选中日期字体颜色 默认white */
@property (nonatomic, strong) UIColor *selectTitleColor;
/** 今天title背景颜色 默认purple */
@property (nonatomic, strong) UIColor *todayTitleBgColor;
/** 选中日期title背景颜色 默认gray */
@property (nonatomic, strong) UIColor *selectTitleBgColor;
/** 背景颜色 默认white */
@property (nonatomic, strong) UIColor *normalBackgroundColor;
/** 特殊日期背景颜色 默认lightGray */
@property (nonatomic, strong) UIColor *specialBackgroundColor;

//  预留
@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, strong) UILabel *dateLabel;
@property (nonatomic, strong) UILabel *subLabel;
@property (nonatomic, assign) BOOL isSelected;

@end
