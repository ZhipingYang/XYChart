//
//  TableViewCell.m
//  UUChartView
//
//  Created by shake on 15/1/4.
//  Copyright (c) 2015年 uyiuyao. All rights reserved.
//

#import "ChartViewCell.h"
#import "XYChart.h"

NSString *const lineChartReuseIdentifier = @"lineChartReuseIdentifier";
NSString *const barChartReuseIdentifier = @"barChartReuseIdentifier";

@interface ChartViewCell ()
{
    XYChart *_chartView;
}
@end

@implementation ChartViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        XYChartType type = [reuseIdentifier isEqualToString:lineChartReuseIdentifier]
                         ? XYChartTypeLine : XYChartTypeBar;
        _chartView = [[XYChart alloc] initWithFrame:CGRectZero chartType:type];
        [self.contentView addSubview:_chartView];
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    _chartView.frame = CGRectMake(0, 30, xy_width(self)-20, xy_height(self)-40);
}

- (void)setGroup:(RandomChartDataSource *)group
{
    _group = group;
    [_chartView setDataSource:group animation:YES];
}

@end
