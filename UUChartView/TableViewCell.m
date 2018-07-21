//
//  TableViewCell.m
//  UUChartView
//
//  Created by shake on 15/1/4.
//  Copyright (c) 2015年 uyiuyao. All rights reserved.
//

#import "TableViewCell.h"
#import "UUChartView.h"
#import "UUChartGroup.h"

@interface TableViewCell ()
{
    NSIndexPath *path;
    UUChartView *chartView;
}
@end

@implementation TableViewCell

- (void)layoutSubviews
{
    [super layoutSubviews];
    chartView.frame = CGRectMake(10, 30, self.bounds.size.width-20, self.bounds.size.height-40);
}

- (void)configUI:(NSIndexPath *)indexPath
{
    if (chartView) {
        [chartView removeFromSuperview];
        chartView = nil;
    }
    
    chartView = [[UUChartView alloc] initWithFrame:CGRectZero
                                        chartGroup:[[UUChartGroup alloc] initWithTyle:UUChartStyleBar]];
    [self.contentView addSubview:chartView];
}
@end
