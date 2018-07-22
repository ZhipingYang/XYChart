//
//  TableViewCell.m
//  UUChartView
//
//  Created by shake on 15/1/4.
//  Copyright (c) 2015年 uyiuyao. All rights reserved.
//

#import "TableViewCell.h"
#import "XYChart.h"
#import "UUChartGroup.h"

@interface TableViewCell ()
{
    NSIndexPath *path;
    XYChart *chartView;
}
@end

@implementation TableViewCell

- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super initWithCoder:aDecoder]) {
        chartView = [[XYChart alloc] init];
        [self.contentView addSubview:chartView];
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    chartView.frame = CGRectMake(10, 30, self.bounds.size.width-20, self.bounds.size.height-40);
}

- (void)setGroup:(UUChartGroup *)group
{
    _group = group;
    chartView.chartGroup = group;
}

@end
