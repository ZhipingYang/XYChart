//
//  TableViewCell.m
//  UUChartView
//
//  Created by shake on 15/1/4.
//  Copyright (c) 2015年 uyiuyao. All rights reserved.
//

#import "TableViewCell.h"
#import "XYChart.h"
#import "XYChartGroup.h"

@interface TableViewCell ()
{
    XYChart *_chartView;
}
@end

@implementation TableViewCell

- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super initWithCoder:aDecoder]) {
        _chartView = [[XYChart alloc] init];
        [self.contentView addSubview:_chartView];
    }
    return self;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        _chartView = [[XYChart alloc] init];
        [self.contentView addSubview:_chartView];
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    _chartView.frame = CGRectMake(0, 30, self.bounds.size.width-20, self.bounds.size.height-40);
}

- (void)setGroup:(XYChartGroup *)group
{
    _group = group;
    _chartView.chartGroup = group;
}

@end
