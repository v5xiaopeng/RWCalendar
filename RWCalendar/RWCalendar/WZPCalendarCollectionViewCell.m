//
//  WZPCalendarCollectionViewCell.m
//  WZPCalendar
//
//  Created by Y19092310 on 2019/10/9.
//  Copyright © 2019年 Y19092310. All rights reserved.
//

#import "WZPCalendarCollectionViewCell.h"
#define kSCREEN_WIDTH       ([UIScreen mainScreen].bounds.size.width)
#define kIphone6Scale(x)    ((x) * kSCREEN_WIDTH / 375.0f)

@implementation WZPCalendarCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    {
        [self createCell];
    }
    return self;
}

- (void)createCell{
    self.backgroundColor = [UIColor whiteColor];
    CGFloat labelX = (self.contentView.frame.size.width - (self.frame.size.height/2 - kIphone6Scale(10)))/2;
    _dateLabel = [[UILabel alloc]initWithFrame:CGRectMake(labelX, kIphone6Scale(10), self.frame.size.height/2 - kIphone6Scale(10), self.frame.size.height/2 - kIphone6Scale(10))];
    _dateLabel.textAlignment = NSTextAlignmentCenter;
    _dateLabel.layer.cornerRadius = (self.frame.size.height/2 - kIphone6Scale(10))/2;
    _dateLabel.clipsToBounds = YES;
    _dateLabel.backgroundColor = [UIColor clearColor];
    _dateLabel.font = [UIFont systemFontOfSize:15.0f];
    [self.contentView addSubview:_dateLabel];
    
    _subLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, self.frame.size.height/2 + kIphone6Scale(10), self.frame.size.width, self.frame.size.height/2 - kIphone6Scale(10))];
    _subLabel.textAlignment = NSTextAlignmentCenter;
    _subLabel.textColor = [UIColor redColor];
    _subLabel.backgroundColor = [UIColor clearColor];
    _subLabel.font = [UIFont systemFontOfSize:11.0f];
    _subLabel.hidden = YES;
    [self.contentView addSubview:_subLabel];
    
//    _imageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, self.frame.size.height/2 + kIphone6Scale(10), self.frame.size.width, self.frame.size.height/2 - kIphone6Scale(10))];
//    [self.contentView addSubview:_imageView];
}

@end
