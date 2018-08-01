//
//  TableViewCell.m
//  UUChartView
//
//  Created by shake on 15/1/4.
//  Copyright (c) 2015年 uyiuyao. All rights reserved.
//

#import "TableViewCell.h"
#import "XYChart.h"

@interface TableViewCell ()
{
    XYChart *_chartView;
}
@end

@implementation TableViewCell

- (void)layoutSubviews
{
    [super layoutSubviews];
    _chartView.frame = CGRectMake(0, 30, xy_width(self)-20, xy_height(self)-40);
}

- (void)setGroup:(ChartGroup *)group
{
    _group = group;
    if (_chartView) {
        [_chartView removeFromSuperview];
    }
    _chartView = [[XYChart alloc] initWithFrame:CGRectMake(0, 30, xy_width(self)-20, xy_height(self)-40)
                                      chartType:group.type];
    [self.contentView addSubview:_chartView];
    _chartView.dataSource = group;
}

@end
